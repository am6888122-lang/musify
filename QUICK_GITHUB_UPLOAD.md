# 🚀 Quick GitHub Upload Guide

## Step-by-Step Commands (Copy & Paste)

### 1️⃣ Initialize Git
```bash
git init
```

### 2️⃣ Configure Git (First Time Only)
Replace with your information:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 3️⃣ Add All Files
```bash
git add .
```

### 4️⃣ Create First Commit
```bash
git commit -m "Initial commit: Complete Musify music streaming app"
```

### 5️⃣ Create GitHub Repository
1. Go to [github.com](https://github.com)
2. Click "+" → "New repository"
3. Name: `musify`
4. Description: "A beautiful music streaming app built with Flutter"
5. Choose Public or Private
6. **DON'T** check any boxes (README, .gitignore, license)
7. Click "Create repository"

### 6️⃣ Connect to GitHub
Replace `YOUR_USERNAME` with your GitHub username:
```bash
git remote add origin https://github.com/YOUR_USERNAME/musify.git
```

### 7️⃣ Push to GitHub
```bash
git branch -M main
git push -u origin main
```

### 8️⃣ Authentication
When prompted for password, use a **Personal Access Token**:

1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. "Generate new token (classic)"
3. Select `repo` scope
4. Copy the token
5. Paste it when asked for password

---

## ✅ Done!
Your project is now on GitHub at:
`https://github.com/YOUR_USERNAME/musify`

## 🔄 Future Updates
After making changes:
```bash
git add .
git commit -m "Description of changes"
git push
```

---

## 📝 Before Uploading - Update README.md

Open `README.md` and replace:
- `YOUR_USERNAME` → Your GitHub username
- `your.email@example.com` → Your email
- Add screenshots of your app

---

## ⚠️ Important Notes

### Protected Files (Already in .gitignore)
These files will NOT be uploaded:
- ✅ `google-services.json`
- ✅ `GoogleService-Info.plist`
- ✅ `firebase_options.dart`
- ✅ `local.properties`
- ✅ Build files
- ✅ User data (*.hive)

### What WILL be uploaded:
- ✅ Source code (lib/, android/, ios/, etc.)
- ✅ Documentation (README.md, LICENSE, etc.)
- ✅ Configuration files (pubspec.yaml, etc.)
- ✅ Assets (images, fonts, etc.)

---

## 🆘 Troubleshooting

### Error: "remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/musify.git
```

### Error: "failed to push"
```bash
git pull origin main --allow-unrelated-histories
git push -u origin main
```

### Error: "Authentication failed"
- Use Personal Access Token, not password
- Make sure token has `repo` permissions

---

## 📱 Quick Commands Reference

```bash
# Check status
git status

# See commit history
git log --oneline

# See remote URL
git remote -v

# Change remote URL
git remote set-url origin https://github.com/YOUR_USERNAME/musify.git

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Discard all local changes
git reset --hard HEAD
```

---

Made with ❤️ for Musify
