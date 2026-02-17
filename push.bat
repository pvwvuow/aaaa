@echo off
chcp 65001 >nul
title Poolyar - Push to GitHub

echo.
echo ═══════════════════════════════════════════════════
echo        ارسال به GitHub
echo ═══════════════════════════════════════════════════
echo.

set /p GITHUB_USER=نام کاربری GitHub: 
set /p REPO_NAME=نام ریپازیتوری (پیش‌فرض: poolyar): 
if "%REPO_NAME%"=="" set REPO_NAME=poolyar

echo.
echo [1/4] شروع Git...
git init

echo [2/4] اضافه کردن فایل‌ها...
git add .

echo [3/4] کامیت...
git commit -m "Initial commit - Poolyar v2.5.0"

echo [4/4] ارسال به GitHub...
git branch -M main
git remote add origin https://github.com/%GITHUB_USER%/%REPO_NAME%.git 2>nul
git remote set-url origin https://github.com/%GITHUB_USER%/%REPO_NAME%.git
git push -u origin main

echo.
echo ═══════════════════════════════════════════════════
echo        تمام شد!
echo ═══════════════════════════════════════════════════
echo.
echo حالا به این آدرس بروید:
echo https://github.com/%GITHUB_USER%/%REPO_NAME%/actions
echo.
echo صبر کنید build تمام شود، سپس فایل exe را از Artifacts دانلود کنید.
echo.
pause