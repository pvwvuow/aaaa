@echo off
chcp 65001 >nul
cd /d "D:\پروژه ها\پول یار\aaaa\pooli"

set /p msg="توضیح تغییرات: "
git add .
git commit -m "%msg%"
git push

echo.
echo آپدیت شد! برو Actions رو چک کن.
pause