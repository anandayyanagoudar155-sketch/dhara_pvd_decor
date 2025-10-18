@echo off
:: Ask for repository path
set /p repo_path="Enter the full path to your repo folder: "
cd "%repo_path%"

:: Ask for Git user name and email
set /p username="Enter your Git user name: "
set /p useremail="Enter your Git email: "

git config user.name "%username%"
git config user.email "%useremail%"

:: Ask for branch name (existing or new)
set /p branchname="Enter the branch name you want to push to: "

:: Check if branch exists locally, if not create it
git show-ref --verify --quiet refs/heads/%branchname%
if %errorlevel% neq 0 (
    git checkout -b %branchname%
) else (
    git checkout %branchname%
)

:: Pull latest changes from remote branch
git pull origin %branchname%

:: Add, commit, and push changes to the specified branch
git add .
git commit -m "auto update"
git push origin %branchname%

pause