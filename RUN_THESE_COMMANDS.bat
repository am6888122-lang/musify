@echo off
echo ========================================
echo MUSIFY - GitHub Upload Script
echo ========================================
echo.

REM Check if Git is installed
git --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git is not installed!
    echo Please install Git from: https://git-scm.com/download/win
    pause
    exit /b 1
)

echo Git is installed. Proceeding...
echo.

REM Check if Git is configured
git config user.name >nul 2>&1
if errorlevel 1 (
    echo.
    echo ========================================
    echo Git Configuration Required
    echo ========================================
    echo.
    set /p USERNAME="Enter your name: "
    set /p EMAIL="Enter your email: "
    
    git config --global user.name "%USERNAME%"
    git config --global user.email "%EMAIL%"
    
    echo.
    echo Git configured successfully!
    echo.
)

echo ========================================
echo Step 1: Adding all files...
echo ========================================
git add .
if errorlevel 1 (
    echo ERROR: Failed to add files
    pause
    exit /b 1
)
echo Files added successfully!
echo.

echo ========================================
echo Step 2: Creating first commit...
echo ========================================
git commit -m "Initial commit: Complete Musify music streaming app with user management and audio playback"
if errorlevel 1 (
    echo ERROR: Failed to create commit
    pause
    exit /b 1
)
echo Commit created successfully!
echo.

echo ========================================
echo Step 3: GitHub Repository Setup
echo ========================================
echo.
echo Please follow these steps:
echo 1. Open your browser and go to: https://github.com
echo 2. Click "+" and select "New repository"
echo 3. Name: musify
echo 4. Description: A beautiful music streaming app built with Flutter
echo 5. Choose Public or Private
echo 6. DON'T check any boxes (README, .gitignore, license)
echo 7. Click "Create repository"
echo.
set /p GITHUB_USERNAME="Enter your GitHub username: "
echo.

echo ========================================
echo Step 4: Connecting to GitHub...
echo ========================================
git remote add origin https://github.com/%GITHUB_USERNAME%/musify.git
if errorlevel 1 (
    echo.
    echo Remote already exists. Removing and re-adding...
    git remote remove origin
    git remote add origin https://github.com/%GITHUB_USERNAME%/musify.git
)
echo Connected to GitHub successfully!
echo.

echo ========================================
echo Step 5: Pushing to GitHub...
echo ========================================
echo.
echo IMPORTANT: When asked for password, use Personal Access Token!
echo.
echo How to get Personal Access Token:
echo 1. Go to: https://github.com/settings/tokens
echo 2. Click "Generate new token" - "Generate new token (classic)"
echo 3. Select "repo" scope
echo 4. Copy the token
echo 5. Paste it when asked for password below
echo.
pause

git branch -M main
git push -u origin main

if errorlevel 1 (
    echo.
    echo ========================================
    echo ERROR: Failed to push to GitHub
    echo ========================================
    echo.
    echo Possible solutions:
    echo 1. Make sure you created the repository on GitHub
    echo 2. Make sure you used Personal Access Token, not password
    echo 3. Make sure the token has "repo" permissions
    echo.
    echo Try running this command manually:
    echo git push -u origin main
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo SUCCESS! Project uploaded to GitHub!
echo ========================================
echo.
echo Your project is now available at:
echo https://github.com/%GITHUB_USERNAME%/musify
echo.
echo Next steps:
echo 1. Update README.md with your information
echo 2. Add screenshots of your app
echo 3. Add topics to your repository
echo.
pause
