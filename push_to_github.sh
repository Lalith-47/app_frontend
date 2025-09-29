#!/bin/bash

# Navigate to the project directory
cd /home/lalith/praniti/app/praniti_mobile_app

# Check git status
echo "Git status:"
git status

# Add all changes
echo "Adding all changes..."
git add .

# Commit changes
echo "Committing changes..."
git commit -m "Push Praniti Mobile App to GitHub

- Complete Flutter app with student and mentor portals
- Removed admin functionality as requested
- Fixed all build issues and compilation errors
- Modern UI with Material Design 3
- Authentication system with JWT tokens
- Real-time chat functionality
- Career assessment and quiz system
- Responsive design with dark/light theme support
- Clean architecture with Riverpod state management"

# Push to GitHub
echo "Pushing to GitHub..."
git push origin main --force

echo "Done!"



