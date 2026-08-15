@echo off
setlocal

echo ==========================================
echo   RISC-V CPU - Icarus Verilog Compile
echo ==========================================
echo.

cd /d "%~dp0.."

if not exist sim mkdir sim

echo Compiling Verilog RTL and Testbench...
echo.

iverilog -g2012 -Wall ^
-o sim\sim.out ^
rtl\*.v ^
tb\*.v

if %errorlevel% neq 0 (
    echo.
    echo ==========================================
    echo   COMPILATION FAILED
    echo ==========================================
    echo.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo   COMPILATION SUCCESSFUL
echo ==========================================
echo.
echo Output: sim\sim.out
echo.

pause
endlocal