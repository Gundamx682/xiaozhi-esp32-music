@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo 小智 ESP32 固件自动构建脚本
echo ========================================
echo.

:: 设置 ESP-IDF 路径
set IDF_PATH=E:\Espressif

:: 设置项目路径
set PROJECT_PATH=F:\3333\py-xiaozhi\xiaozhi-esp32-music

echo [步骤 1/6] 验证 ESP-IDF 安装...
if not exist "%IDF_PATH%\idf-env.exe" (
    echo ❌ 错误：找不到 ESP-IDF，路径: %IDF_PATH%
    pause
    exit /b 1
)
echo ✅ ESP-IDF 已找到

echo.
echo [步骤 2/6] 验证项目目录...
if not exist "%PROJECT_PATH%" (
    echo ❌ 错误：找不到项目目录，路径: %PROJECT_PATH%
    pause
    exit /b 1
)
echo ✅ 项目目录已找到

echo.
echo [步骤 3/6] 验证 Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 错误：找不到 Python
    pause
    exit /b 1
)
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo ✅ Python 版本: %PYTHON_VERSION%

echo.
echo [步骤 4/6] 激活 ESP-IDF 环境...
call "%IDF_PATH%\idf-env.exe"
if errorlevel 1 (
    echo ❌ 错误：无法激活 ESP-IDF 环境
    pause
    exit /b 1
)

:: 验证 idf.py 是否可用
idf.py --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 错误：idf.py 命令不可用
    echo 请检查 ESP-IDF 是否正确安装
    pause
    exit /b 1
)
for /f "tokens=3" %%i in ('idf.py --version 2^>^&1') do set IDF_VERSION=%%i
echo ✅ ESP-IDF 版本: %IDF_VERSION%

echo.
echo [步骤 5/6] 进入项目目录...
cd /d "%PROJECT_PATH%"
if errorlevel 1 (
    echo ❌ 错误：无法进入项目目录
    pause
    exit /b 1
)
echo ✅ 当前目录: %CD%

echo.
echo [步骤 6/6] 开始构建所有变体...
echo ========================================
echo ⚠️  重要提示：
echo - 将构建 100 个变体固件
echo - 预计需要 2-4 小时
echo - 请保持电脑开启并连接电源
echo - 构建完成后固件将保存在 releases\ 目录
echo ========================================
echo.

:: 确认是否继续
echo 请确认是否开始构建？(Y/N)
set /p CONFIRM=
if /i not "%CONFIRM%"=="Y" (
    echo 用户取消构建
    pause
    exit /b 0
)

echo.
echo 开始构建...
echo ----------------------------------------

:: 执行构建
python scripts/release.py all

if errorlevel 1 (
    echo.
    echo ========================================
    echo ❌ 构建失败！
    echo ========================================
    echo 请检查上面的错误信息
    pause
    exit /b 1
)

echo.
echo ========================================
echo ✅ 构建成功！
echo ========================================
echo.
echo 固件位置: %PROJECT_PATH%\releases\
echo.

:: 统计生成的文件
set COUNT=0
for %%f in ("%PROJECT_PATH%\releases\*.zip") do set /a COUNT+=1

echo 已生成的固件数量: %COUNT%
echo.
echo 固件列表：
dir "%PROJECT_PATH%\releases\*.zip" /b

echo.
echo ========================================
echo 完成！所有固件已成功构建
echo ========================================
pause