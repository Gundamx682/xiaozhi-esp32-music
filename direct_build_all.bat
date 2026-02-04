@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo 小智 ESP32 固件自动构建脚本（直接模式）
echo ========================================
echo.

:: 设置路径
set ESP_IDF=E:\Espressif
set PROJECT_PATH=F:\3333\py-xiaozhi\xiaozhi-esp32-music
set PYTHON_ENV=%ESP_IDF%\python_env\idf5.5_py3.11_env

echo [步骤 1/6] 验证 ESP-IDF Python 环境...
if not exist "%PYTHON_ENV%\Scripts\python.exe" (
    echo ❌ 错误：找不到 ESP-IDF Python 环境
    pause
    exit /b 1
)
echo ✅ ESP-IDF Python 环境已找到

echo.
echo [步骤 2/6] 验证项目目录...
if not exist "%PROJECT_PATH%" (
    echo ❌ 错误：找不到项目目录
    pause
    exit /b 1
)
echo ✅ 项目目录已找到

echo.
echo [步骤 3/6] 设置环境变量...
set IDF_PATH=%ESP_IDF%
echo ✅ IDF_PATH=%IDF_PATH%

:: 添加工具到 PATH
set PATH=%ESP_IDF%\tools\xtensa-esp-elf\xtensa-esp-elf\bin;%PATH%
set PATH=%ESP_IDF%\tools\xtensa-esp-elf-gdb\xtensa-esp-elf-gdb\bin;%PATH%
set PATH=%ESP_IDF%\tools\esp32ulp-elf\esp32ulp-elf\bin;%PATH%
set PATH=%ESP_IDF%\tools\riscv32-esp-elf\riscv32-elf\bin;%PATH%
set PATH=%ESP_IDF%\tools\riscv32-esp-elf-gdb\riscv32-esp-elf-gdb\bin;%PATH%
set PATH=%ESP_IDF%\tools\openocd-esp32\bin;%PATH%
set PATH=%ESP_IDF%\tools\ninja;%PATH%
set PATH=%ESP_IDF%\tools\cmake\bin;%PATH%
set PATH=%ESP_IDF%\tools\idf-exe;%PATH%
set PATH=%PYTHON_ENV%\Scripts;%PATH%

echo ✅ PATH 已配置

echo.
echo [步骤 4/6] 验证工具链...
xtensa-esp32s3-elf-gcc --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️  警告：无法找到 xtensa-esp32s3-elf-gcc
    echo 但继续尝试构建...
) else (
    echo ✅ 工具链已找到
)

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

:: 使用 ESP-IDF Python 执行构建
"%PYTHON_ENV%\Scripts\python.exe" scripts/release.py all

if errorlevel 1 (
    echo.
    echo ========================================
    echo ❌ 构建失败！
    echo ========================================
    echo 请检查上面的错误信息
    echo.
    echo 常见问题：
    echo 1. 确保已安装 ESP-IDF v5.5
    echo 2. 确保有足够的磁盘空间（至少 10GB）
    echo 3. 确保网络连接正常（用于下载依赖）
    echo.
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