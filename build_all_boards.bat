@echo off
chcp 65001 >nul
echo ========================================
echo 小智 ESP32 固件批量构建脚本
echo ========================================
echo.

echo [1/3] 激活 ESP-IDF 环境...
call E:\Espressif\idf-env.exe
if errorlevel 1 (
    echo 错误：无法激活 ESP-IDF 环境
    pause
    exit /b 1
)

echo.
echo [2/3] 进入项目目录...
cd /d F:\3333\py-xiaozhi\xiaozhi-esp32-music
if errorlevel 1 (
    echo 错误：无法进入项目目录
    pause
    exit /b 1
)

echo.
echo [3/3] 开始构建所有变体...
echo 注意：构建 100 个变体可能需要 2-4 小时
echo 请保持电脑开启并连接电源
echo.
python scripts/release.py all

if errorlevel 1 (
    echo.
    echo ========================================
    echo 构建失败！
    echo ========================================
    pause
    exit /b 1
) else (
    echo.
    echo ========================================
    echo 构建成功！
    echo ========================================
    echo 固件位置: F:\3333\py-xiaozhi\xiaozhi-esp32-music\releases\
    echo.
    dir releases\*.zip
    pause
)