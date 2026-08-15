@echo off
setlocal

echo ==========================================
echo   RISC-V CPU - Yosys Synthesis
echo ==========================================
echo.

cd /d "%~dp0.."

if not exist netlist mkdir netlist
if not exist reports mkdir reports
if not exist logs mkdir logs

echo Running Yosys synthesis...
echo.

yosys -s scripts\synth.ys > logs\synthesis.log 2>&1

if %errorlevel% neq 0 (
    echo.
    echo ==========================================
    echo   SYNTHESIS FAILED
    echo ==========================================
    echo.
    echo Check:
    echo   logs\synthesis.log
    echo.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo   SYNTHESIS SUCCESSFUL
echo ==========================================
echo.

echo Generated netlist:
echo   netlist\riscv_cpu_synth.v
echo.

echo Synthesis log:
echo   logs\synthesis.log
echo.

pause
endlocal