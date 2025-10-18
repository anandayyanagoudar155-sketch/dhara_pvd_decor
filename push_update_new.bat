@echo off
cd "C:\Anand_files\dhara_pvd_decor"

:: Ask for name and email
set /p username="Enter your Git user name: "
set /p useremail="Enter your Git email: "

git config user.name "%username%"
git config user.email "%useremail%"

git add .
git commit -m "auto update"
git push

pause