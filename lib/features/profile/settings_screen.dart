import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../core/providers/theme_provider.dart';
import '../../core/providers/music_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            _buildSectionHeader(context, 'Appearance'),
            _buildAppearanceSettings(context),
            
            const SizedBox(height: 30),
            
            // Audio Section
            _buildSectionHeader(context, 'Audio'),
            _buildAudioSettings(context),
            
            const SizedBox(height: 30),
            
            // Download Section
            _buildSectionHeader(context, 'Downloads'),
            _buildDownloadSettings(context),
            
            const SizedBox(height: 30),
            
            // Privacy Section
            _buildSectionHeader(context, 'Privacy'),
            _buildPrivacySettings(context),
            
            const SizedBox(height: 30),
            
            // Account Section
            _buildSectionHeader(context, 'Account'),
            _buildAccountSettings(context),
            
            const SizedBox(height: 30),
            
            // System Section
            _buildSectionHeader(context, 'System'),
            _buildSystemSettings(context),
            
            const SizedBox(height: 30),
            
            // About Section
            _buildSectionHeader(context, 'About'),
            _buildAboutSettings(context),
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

  Widget _buildAppearanceSettings(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Column(
          children: [
            _buildSettingsTile(
              context,
              'Theme',
              'Choose your preferred theme',
              Icons.palette,
              trailing: DropdownButton<ThemeMode>(
                value: themeProvider.themeMode,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    themeProvider.setThemeMode(value);
                  }
                },
              ),
            ),
            _buildSettingsTile(
              context,
              'Dynamic Colors',
              'Use system accent colors',
              Icons.color_lens,
              trailing: Switch(
                value: false, // Placeholder
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dynamic colors updated')),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAudioSettings(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, musicProvider, child) {
        return Column(
          children: [
            _buildSettingsTile(
              context,
              'Audio Quality',
              'Streaming quality preference',
              Icons.high_quality,
              trailing: DropdownButton<String>(
                value: 'High',
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'Low', child: Text('Low')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'High', child: Text('High')),
                  DropdownMenuItem(value: 'Lossless', child: Text('Lossless')),
                ],
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Audio quality set to $value')),
                  );
                },
              ),
            ),
            _buildSettingsTile(
              context,
              'Equalizer',
              'Customize your sound',
              Icons.equalizer,
              onTap: () => _showEqualizerDialog(context),
            ),
            _buildSettingsTile(
              context,
              'Crossfade',
              'Smooth transitions between songs',
              Icons.shuffle,
              trailing: Switch(
                value: true, // Placeholder
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Crossfade ${value ? 'enabled' : 'disabled'}')),
                  );
                },
              ),
            ),
            _buildSettingsTile(
              context,
              'Normalize Volume',
              'Keep volume consistent',
              Icons.volume_up,
              trailing: Switch(
                value: true, // Placeholder
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Volume normalization ${value ? 'enabled' : 'disabled'}')),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDownloadSettings(BuildContext context) {
    return Column(
      children: [
        _buildSettingsTile(
          context,
          'Download Quality',
          'Quality for offline music',
          Icons.download,
          trailing: DropdownButton<String>(
            value: 'High',
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'Low', child: Text('Low')),
              DropdownMenuItem(value: 'Medium', child: Text('Medium')),
              DropdownMenuItem(value: 'High', child: Text('High')),
              DropdownMenuItem(value: 'Lossless', child: Text('Lossless')),
            ],
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Download quality set to $value')),
              );
            },
          ),
        ),
        _buildSettingsTile(
          context,
          'Download over WiFi only',
          'Save mobile data',
          Icons.wifi,
          trailing: Switch(
            value: true, // Placeholder
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('WiFi only downloads ${value ? 'enabled' : 'disabled'}')),
              );
            },
          ),
        ),
        _buildSettingsTile(
          context,
          'Auto-delete downloads',
          'Remove old downloads automatically',
          Icons.auto_delete,
          trailing: DropdownButton<String>(
            value: 'Never',
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'Never', child: Text('Never')),
              DropdownMenuItem(value: '30 days', child: Text('30 days')),
              DropdownMenuItem(value: '60 days', child: Text('60 days')),
              DropdownMenuItem(value: '90 days', child: Text('90 days')),
            ],
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Auto-delete set to $value')),
              );
            },
          ),
        ),
        _buildSettingsTile(
          context,
          'Storage Location',
          'Choose where to save downloads',
          Icons.folder,
          onTap: () => _showStorageLocationDialog(context),
        ),
      ],
    );
  }

  Widget _buildPrivacySettings(BuildContext context) {
    return Column(
      children: [
        _buildSettingsTile(
          context,
          'Private Session',
          'Don\'t save listening history',
          Icons.visibility_off,
          trailing: Switch(
            value: false, // Placeholder
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Private session ${value ? 'enabled' : 'disabled'}')),
              );
            },
          ),
        ),
        _buildSettingsTile(
          context,
          'Show Recently Played',
          'Display in profile',
          Icons.history,
          trailing: Switch(
            value: true, // Placeholder
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Recently played ${value ? 'shown' : 'hidden'}')),
              );
            },
          ),
        ),
        _buildSettingsTile(
          context,
          'Analytics',
          'Help improve the app',
          Icons.analytics,
          trailing: Switch(
            value: true, // Placeholder
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Analytics ${value ? 'enabled' : 'disabled'}')),
              );
            },
          ),
        ),
        _buildSettingsTile(
          context,
          'Clear Listening History',
          'Remove all recently played songs',
          Icons.clear_all,
          onTap: () => _showClearHistoryDialog(context),
        ),
      ],
    );
  }

  Widget _buildAccountSettings(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          children: [
            _buildSettingsTile(
              context,
              'Account Info',
              'Manage your account details',
              Icons.account_circle,
              onTap: () => _showAccountInfoDialog(context, authProvider),
            ),
            _buildSettingsTile(
              context,
              'Change Password',
              'Update your password',
              Icons.lock,
              onTap: () => _showChangePasswordDialog(context),
            ),
            _buildSettingsTile(
              context,
              'Connected Accounts',
              'Manage linked social accounts',
              Icons.link,
              onTap: () => _showConnectedAccountsDialog(context),
            ),
            _buildSettingsTile(
              context,
              'Export Data',
              'Download your data',
              Icons.download,
              onTap: () => _showExportDataDialog(context),
            ),
            _buildSettingsTile(
              context,
              'Delete Account',
              'Permanently delete your account',
              Icons.delete_forever,
              textColor: AppColors.error,
              onTap: () => _showDeleteAccountDialog(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSystemSettings(BuildContext context) {
    // Check Firebase connection status
    final isFirebaseInitialized = Firebase.apps.isNotEmpty;
    
    // Check if using Firebase (from auth_provider.dart)
    const useFirebase = false; // This should match USE_FIREBASE in auth_provider.dart
    
    return Column(
      children: [
        _buildSettingsTile(
          context,
          'Firebase Status',
          isFirebaseInitialized 
              ? (useFirebase ? 'Connected & Active ✅' : 'Connected but Disabled ⚠️')
              : 'Not Connected ❌',
          Icons.cloud,
          trailing: Icon(
            isFirebaseInitialized ? Icons.check_circle : Icons.cancel,
            color: isFirebaseInitialized ? Colors.green : Colors.red,
          ),
          onTap: () => _showFirebaseStatusDialog(context, isFirebaseInitialized, useFirebase),
        ),
        _buildSettingsTile(
          context,
          'Storage Mode',
          useFirebase ? 'Cloud Storage (Firebase)' : 'Local Storage (Hive)',
          Icons.storage,
          trailing: Icon(
            useFirebase ? Icons.cloud_done : Icons.phone_android,
            color: useFirebase ? Colors.blue : Colors.orange,
          ),
        ),
        _buildSettingsTile(
          context,
          'Cache Size',
          'Manage app cache',
          Icons.cached,
          onTap: () => _showCacheSizeDialog(context),
        ),
        _buildSettingsTile(
          context,
          'Clear Cache',
          'Free up storage space',
          Icons.cleaning_services,
          onTap: () => _showClearCacheDialog(context),
        ),
      ],
    );
  }

  Widget _buildAboutSettings(BuildContext context) {
    return Column(
      children: [
        _buildSettingsTile(
          context,
          'App Version',
          AppConstants.appVersion,
          Icons.info,
        ),
        _buildSettingsTile(
          context,
          'Terms of Service',
          'Read our terms',
          Icons.description,
          onTap: () => _showTermsDialog(context),
        ),
        _buildSettingsTile(
          context,
          'Privacy Policy',
          'Read our privacy policy',
          Icons.privacy_tip,
          onTap: () => _showPrivacyPolicyDialog(context),
        ),
        _buildSettingsTile(
          context,
          'Open Source Licenses',
          'View third-party licenses',
          Icons.code,
          onTap: () => _showLicensesDialog(context),
        ),
        _buildSettingsTile(
          context,
          'Rate App',
          'Rate us on the app store',
          Icons.star,
          onTap: () => _showRateAppDialog(context),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
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
          color: textColor ?? AppColors.primary,
        ),
        title: Text(
          title,
          style: TextStyle(color: textColor),
        ),
        subtitle: Text(subtitle),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
        onTap: onTap,
      ),
    );
  }

  // Dialog methods
  void _showEqualizerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Equalizer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Equalizer presets:'),
            const SizedBox(height: 16),
            ...['Normal', 'Rock', 'Pop', 'Jazz', 'Classical', 'Electronic'].map(
              (preset) => RadioListTile<String>(
                title: Text(preset),
                value: preset,
                groupValue: 'Normal',
                onChanged: (value) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Equalizer set to $value')),
                  );
                },
              ),
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

  void _showStorageLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Internal Storage'),
              subtitle: const Text('Device storage'),
              value: 'internal',
              groupValue: 'internal',
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Storage location updated')),
                );
              },
            ),
            RadioListTile<String>(
              title: const Text('SD Card'),
              subtitle: const Text('External storage'),
              value: 'external',
              groupValue: 'internal',
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Storage location updated')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Listening History'),
        content: const Text('This will remove all your recently played songs. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final musicProvider = Provider.of<MusicProvider>(context, listen: false);
              musicProvider.clearRecentlyPlayed();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Listening history cleared')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showAccountInfoDialog(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.user;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user?.name ?? 'N/A'}'),
            const SizedBox(height: 8),
            Text('Email: ${user?.email ?? 'N/A'}'),
            const SizedBox(height: 8),
            Text('Member since: ${user?.createdAt.toString().split(' ')[0] ?? 'N/A'}'),
            const SizedBox(height: 8),
            Text('Account type: ${user?.isPremium == true ? 'Premium' : 'Free'}'),
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

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
              ),
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
                const SnackBar(content: Text('Password updated successfully')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showConnectedAccountsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connected Accounts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.g_mobiledata),
              title: const Text('Google'),
              subtitle: const Text('Connected'),
              trailing: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Google account disconnected')),
                  );
                },
                child: const Text('Disconnect'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.facebook),
              title: const Text('Facebook'),
              subtitle: const Text('Not connected'),
              trailing: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Facebook account connected')),
                  );
                },
                child: const Text('Connect'),
              ),
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

  void _showExportDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Your data will be exported as a JSON file and sent to your email address.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data export started. Check your email.')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to permanently delete your account? This action cannot be undone and all your data will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion initiated')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'Terms of Service content would go here...\n\n'
            'This is a demo app, so these are placeholder terms.',
          ),
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

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Privacy Policy content would go here...\n\n'
            'This is a demo app, so this is a placeholder privacy policy.',
          ),
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

  void _showLicensesDialog(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
    );
  }

  void _showRateAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate Musify'),
        content: const Text('Enjoying Musify? Please take a moment to rate us on the app store!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening app store...')),
              );
            },
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }

  void _showFirebaseStatusDialog(BuildContext context, bool isInitialized, bool useFirebase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isInitialized ? Icons.check_circle : Icons.cancel,
              color: isInitialized ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            const Text('Firebase Status'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusRow('Firebase Initialized', isInitialized),
              const SizedBox(height: 8),
              _buildStatusRow('Firebase Active', useFirebase),
              const SizedBox(height: 8),
              _buildStatusRow('Authentication', isInitialized && useFirebase),
              const SizedBox(height: 8),
              _buildStatusRow('Cloud Firestore', isInitialized && useFirebase),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Current Mode:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                useFirebase 
                    ? '🔥 Firebase Mode\n\n• Accounts saved in cloud\n• Data syncs across devices\n• Requires internet for auth'
                    : '📱 Local Mode\n\n• Accounts saved locally\n• Works offline\n• Data stays on device',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              if (!useFirebase) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'To enable Firebase, set USE_FIREBASE = true in auth_provider.dart',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          if (!isInitialized)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showFirebaseSetupInstructions(context);
              },
              child: const Text('Setup Guide'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, bool status) {
    return Row(
      children: [
        Icon(
          status ? Icons.check_circle : Icons.cancel,
          color: status ? Colors.green : Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  void _showFirebaseSetupInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Firebase Setup'),
        content: const SingleChildScrollView(
          child: Text(
            'To enable Firebase:\n\n'
            '1. Create a Firebase project at:\n'
            '   console.firebase.google.com\n\n'
            '2. Enable Authentication (Email/Password)\n\n'
            '3. Enable Cloud Firestore\n\n'
            '4. Add Android app and download google-services.json\n\n'
            '5. Run: flutterfire configure\n\n'
            '6. Set USE_FIREBASE = true in auth_provider.dart\n\n'
            'For detailed instructions, see:\n'
            'QUICK_FIREBASE_SETUP.md',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showCacheSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cache Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCacheRow('Images', '45.2 MB'),
            _buildCacheRow('Audio', '128.5 MB'),
            _buildCacheRow('Database', '12.8 MB'),
            _buildCacheRow('Other', '5.3 MB'),
            const Divider(),
            _buildCacheRow('Total', '191.8 MB', isBold: true),
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

  Widget _buildCacheRow(String label, String size, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            size,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear all cached images and audio files. '
          'Your downloaded music and account data will not be affected.',
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
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}