import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Actions
            _buildQuickActions(context),
            
            const SizedBox(height: 30),
            
            // FAQ Section
            _buildSectionHeader(context, 'Frequently Asked Questions'),
            _buildFAQSection(context),
            
            const SizedBox(height: 30),
            
            // Contact Section
            _buildSectionHeader(context, 'Contact Us'),
            _buildContactSection(context),
            
            const SizedBox(height: 30),
            
            // Troubleshooting
            _buildSectionHeader(context, 'Troubleshooting'),
            _buildTroubleshootingSection(context),
            
            const SizedBox(height: 30),
            
            // App Info
            _buildSectionHeader(context, 'App Information'),
            _buildAppInfoSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.support_agent,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            'How can we help you?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get quick answers or contact our support team',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showContactDialog(context),
                  icon: const Icon(Icons.chat),
                  label: const Text('Live Chat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showEmailDialog(context),
                  icon: const Icon(Icons.email),
                  label: const Text('Email Us'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    final faqs = [
      {
        'question': 'How do I download music for offline listening?',
        'answer': 'Tap the download button next to any song, album, or playlist. Downloaded music will be available in the "Downloaded Music" section of your profile.',
      },
      {
        'question': 'Why can\'t I play some songs?',
        'answer': 'Some songs may not be available in your region due to licensing restrictions. Try using a VPN or check if the song is available in your country.',
      },
      {
        'question': 'How do I create a playlist?',
        'answer': 'Go to the Home screen, tap the "+" button, select "Create Playlist", give it a name, and start adding songs by tapping the "+" button next to any song.',
      },
      {
        'question': 'How do I change the audio quality?',
        'answer': 'Go to Settings > Audio > Audio Quality and select your preferred quality. Higher quality uses more data and storage.',
      },
      {
        'question': 'Can I use Musify without an internet connection?',
        'answer': 'Yes! You can listen to downloaded music offline. Make sure to download your favorite songs and playlists when you have internet access.',
      },
      {
        'question': 'How do I cancel my premium subscription?',
        'answer': 'Go to Settings > Account > Subscription and tap "Cancel Subscription". You can also manage subscriptions through your device\'s app store.',
      },
      {
        'question': 'Why is the app using so much storage?',
        'answer': 'Downloaded music and cached data use storage. You can manage this in Settings > Downloads > Storage Management or clear cache in Settings > Storage.',
      },
      {
        'question': 'How do I report inappropriate content?',
        'answer': 'Tap the three dots menu next to any song or playlist and select "Report". Our team will review the content within 24 hours.',
      },
    ];

    return Column(
      children: faqs.map((faq) => _buildFAQItem(
        context,
        faq['question']!,
        faq['answer']!,
      )).toList(),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      children: [
        _buildContactTile(
          context,
          'Live Chat',
          'Chat with our support team',
          Icons.chat,
          () => _showContactDialog(context),
        ),
        _buildContactTile(
          context,
          'Email Support',
          'support@musify.com',
          Icons.email,
          () => _showEmailDialog(context),
        ),
        _buildContactTile(
          context,
          'Phone Support',
          '+1 (555) 123-4567',
          Icons.phone,
          () => _showPhoneDialog(context),
        ),
        _buildContactTile(
          context,
          'Community Forum',
          'Join our community discussions',
          Icons.forum,
          () => _showForumDialog(context),
        ),
        _buildContactTile(
          context,
          'Social Media',
          'Follow us for updates',
          Icons.share,
          () => _showSocialMediaDialog(context),
        ),
      ],
    );
  }

  Widget _buildContactTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTroubleshootingSection(BuildContext context) {
    return Column(
      children: [
        _buildTroubleshootingTile(
          context,
          'App Crashes',
          'Force close and restart the app. If the problem persists, try restarting your device.',
          Icons.bug_report,
        ),
        _buildTroubleshootingTile(
          context,
          'Songs Won\'t Play',
          'Check your internet connection. Clear app cache in Settings > Storage > Clear Cache.',
          Icons.play_disabled,
        ),
        _buildTroubleshootingTile(
          context,
          'Slow Performance',
          'Close other apps, restart your device, or clear app cache to improve performance.',
          Icons.speed,
        ),
        _buildTroubleshootingTile(
          context,
          'Login Issues',
          'Reset your password or try logging in with a different method (Google, Facebook).',
          Icons.login,
        ),
        _buildTroubleshootingTile(
          context,
          'Download Problems',
          'Check storage space and internet connection. Try downloading one song at a time.',
          Icons.download_outlined,
        ),
      ],
    );
  }

  Widget _buildTroubleshootingTile(
    BuildContext context,
    String title,
    String solution,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: ExpansionTile(
        leading: Icon(
          icon,
          color: AppColors.secondary,
        ),
        title: Text(title),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              solution,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    return Column(
      children: [
        _buildInfoTile(
          context,
          'App Version',
          AppConstants.appVersion,
          Icons.info,
        ),
        _buildInfoTile(
          context,
          'Build Number',
          '1.0.0+1',
          Icons.build,
        ),
        _buildInfoTile(
          context,
          'Last Updated',
          'December 2024',
          Icons.update,
        ),
        _buildInfoTile(
          context,
          'Device Info',
          'Tap to copy device information',
          Icons.phone_android,
          onTap: () => _copyDeviceInfo(context),
        ),
        _buildInfoTile(
          context,
          'Send Feedback',
          'Help us improve the app',
          Icons.feedback,
          onTap: () => _showFeedbackDialog(context),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
        onTap: onTap,
      ),
    );
  }

  // Dialog methods
  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Live Chat'),
        content: const Text('Live chat is currently available Monday-Friday, 9 AM - 6 PM EST. Would you like to start a chat session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Starting live chat session...')),
              );
            },
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  void _showEmailDialog(BuildContext context) {
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Email Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'Brief description of your issue',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Describe your issue in detail',
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email sent! We\'ll respond within 24 hours.')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showPhoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Phone Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone support is available:'),
            SizedBox(height: 8),
            Text('• Monday-Friday: 9 AM - 6 PM EST'),
            Text('• Saturday: 10 AM - 4 PM EST'),
            Text('• Sunday: Closed'),
            SizedBox(height: 16),
            Text('Phone: +1 (555) 123-4567'),
            SizedBox(height: 8),
            Text('International: +1 (555) 123-4568'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening phone dialer...')),
              );
            },
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  void _showForumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Community Forum'),
        content: const Text('Join thousands of Musify users in our community forum. Get help, share tips, and connect with other music lovers!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening community forum...')),
              );
            },
            child: const Text('Visit Forum'),
          ),
        ],
      ),
    );
  }

  void _showSocialMediaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Follow Us'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.facebook),
              title: const Text('Facebook'),
              subtitle: const Text('@MusifyApp'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Facebook...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.alternate_email),
              title: const Text('Twitter'),
              subtitle: const Text('@MusifyApp'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Twitter...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Instagram'),
              subtitle: const Text('@MusifyApp'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Instagram...')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _copyDeviceInfo(BuildContext context) {
    const deviceInfo = '''
Device Information:
- App Version: ${AppConstants.appVersion}
- Platform: Flutter
- Build: 1.0.0+1
- OS: Android/iOS
- Device: Mobile Device
''';

    Clipboard.setData(const ClipboardData(text: deviceInfo));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Device information copied to clipboard')),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final feedbackController = TextEditingController();
    int rating = 5;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Send Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Rate your experience:'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () => setState(() => rating = index + 1),
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: AppColors.secondary,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: feedbackController,
                decoration: const InputDecoration(
                  labelText: 'Your feedback',
                  hintText: 'Tell us what you think...',
                ),
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thank you for your feedback!')),
                );
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}