@echo off
chcp 65001 >nul
title Poolyar - Auto Setup

echo.
echo ═══════════════════════════════════════════════════
echo        پول‌یار - نصب خودکار پروژه
echo ═══════════════════════════════════════════════════
echo.

:: دریافت اطلاعات از کاربر
set /p GITHUB_USER=نام کاربری GitHub خود را وارد کنید: 
set /p REPO_NAME=نام ریپازیتوری (پیش‌فرض: poolyar): 
if "%REPO_NAME%"=="" set REPO_NAME=poolyar

echo.
echo [1/7] ساخت ساختار پوشه‌ها...
mkdir src 2>nul
mkdir .github\workflows 2>nul

echo [2/7] ساخت package.json...
(
echo {
echo   "name": "%REPO_NAME%",
echo   "version": "2.5.0",
echo   "description": "پول‌یار — مدیریت مالی شخصی",
echo   "main": "main.js",
echo   "scripts": {
echo     "start": "electron .",
echo     "build": "electron-builder --win"
echo   },
echo   "author": "Poolyar Team",
echo   "license": "MIT",
echo   "devDependencies": {
echo     "electron": "^28.1.0",
echo     "electron-builder": "^24.9.1"
echo   },
echo   "build": {
echo     "appId": "com.poolyar.app",
echo     "productName": "Poolyar",
echo     "directories": {"output": "dist"},
echo     "files": ["main.js", "preload.js", "src/**/*"],
echo     "win": {
echo       "target": [{"target": "nsis", "arch": ["x64"]}, {"target": "portable", "arch": ["x64"]}],
echo       "artifactName": "${productName}-${version}-Setup.${ext}"
echo     },
echo     "nsis": {
echo       "oneClick": false,
echo       "allowToChangeInstallationDirectory": true,
echo       "createDesktopShortcut": true
echo     },
echo     "portable": {"artifactName": "${productName}-${version}-Portable.${ext}"}
echo   }
echo }
) > package.json

echo [3/7] ساخت main.js...
(
echo const { app, BrowserWindow, ipcMain } = require^('electron'^);
echo const path = require^('path'^);
echo let mainWindow;
echo function createWindow^(^) {
echo   mainWindow = new BrowserWindow^({
echo     width: 1150, height: 700, minWidth: 900, minHeight: 600,
echo     frame: false, show: false, backgroundColor: '#f0f0f5',
echo     webPreferences: {
echo       nodeIntegration: false, contextIsolation: true,
echo       preload: path.join^(__dirname, 'preload.js'^)
echo     }
echo   }^);
echo   mainWindow.loadFile^(path.join^(__dirname, 'src', 'index.html'^)^);
echo   mainWindow.once^('ready-to-show', ^(^) =^> mainWindow.show^(^)^);
echo   mainWindow.setMenuBarVisibility^(false^);
echo }
echo ipcMain.on^('window-minimize', ^(^) =^> mainWindow?.minimize^(^)^);
echo ipcMain.on^('window-maximize', ^(^) =^> mainWindow?.isMaximized^(^) ? mainWindow.unmaximize^(^) : mainWindow.maximize^(^)^);
echo ipcMain.on^('window-close', ^(^) =^> mainWindow?.close^(^)^);
echo app.whenReady^(^).then^(createWindow^);
echo app.on^('window-all-closed', ^(^) =^> { if ^(process.platform !== 'darwin'^) app.quit^(^); }^);
) > main.js

echo [4/7] ساخت preload.js...
(
echo const { contextBridge, ipcRenderer } = require^('electron'^);
echo contextBridge.exposeInMainWorld^('electronAPI', {
echo   minimizeWindow: ^(^) =^> ipcRenderer.send^('window-minimize'^),
echo   maximizeWindow: ^(^) =^> ipcRenderer.send^('window-maximize'^),
echo   closeWindow: ^(^) =^> ipcRenderer.send^('window-close'^)
echo }^);
) > preload.js

echo [5/7] ساخت GitHub Actions workflow...
(
echo name: Build Electron App
echo on:
echo   push:
echo     branches: [main]
echo   workflow_dispatch:
echo jobs:
echo   build:
echo     runs-on: windows-latest
echo     steps:
echo       - uses: actions/checkout@v4
echo       - uses: actions/setup-node@v4
echo         with:
echo           node-version: '20'
echo       - run: npm install
echo       - run: npm run build
echo         env:
echo           GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
echo       - uses: actions/upload-artifact@v4
echo         with:
echo           name: Poolyar-Windows
echo           path: dist/*.exe
) > .github\workflows\build.yml

echo [6/7] ساخت .gitignore...
(
echo node_modules/
echo dist/
echo *.log
) > .gitignore

echo [7/7] ساخت فایل HTML نمونه...
(
echo ^<!DOCTYPE html^>
echo ^<html lang="fa" dir="rtl"^>
echo ^<head^>
echo ^<meta charset="UTF-8"^>
echo ^<title^>پول‌یار^</title^>
echo ^<style^>
echo * {margin:0; padding:0; box-sizing:border-box;}
echo body {font-family:Tahoma; background:#f0f0f5; height:100vh; display:flex; flex-direction:column;}
echo .titlebar {height:40px; background:#6366f1; display:flex; justify-content:space-between; align-items:center; padding:0 15px; -webkit-app-region:drag;}
echo .titlebar-dots {display:flex; gap:8px; -webkit-app-region:no-drag;}
echo .dot {width:14px; height:14px; border-radius:50%%; border:none; cursor:pointer;}
echo .close {background:#ff5f57;}
echo .minimize {background:#ffbd2e;}
echo .maximize {background:#28c840;}
echo .title {color:white; font-size:14px;}
echo .content {flex:1; display:flex; justify-content:center; align-items:center;}
echo h1 {color:#6366f1;}
echo ^</style^>
echo ^</head^>
echo ^<body^>
echo ^<div class="titlebar"^>
echo ^<span class="title"^>پول‌یار^</span^>
echo ^<div class="titlebar-dots"^>
echo ^<button class="dot close" onclick="window.electronAPI?.closeWindow()"^>^</button^>
echo ^<button class="dot minimize" onclick="window.electronAPI?.minimizeWindow()"^>^</button^>
echo ^<button class="dot maximize" onclick="window.electronAPI?.maximizeWindow()"^>^</button^>
echo ^</div^>
echo ^</div^>
echo ^<div class="content"^>^<h1^>به پول‌یار خوش آمدید!^</h1^>^</div^>
echo ^</body^>
echo ^</html^>
) > src\index.html

echo.
echo ═══════════════════════════════════════════════════
echo        فایل‌ها ساخته شدند!
echo ═══════════════════════════════════════════════════
echo.
echo حالا فایل index.html خودتان را جایگزین src\index.html کنید
echo سپس دستور زیر را اجرا کنید:
echo.
echo     push.bat
echo.
pause