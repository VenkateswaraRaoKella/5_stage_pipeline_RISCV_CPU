@echo off
setlocal

echo ==========================================
echo   RISC-V CPU - Run Icarus Simulation
echo ==========================================
echo.

cd /d "%~dp0.."

if not exist sim\sim.out (
    echo ERROR: sim\sim.out was not found.
    echo.
    echo Run:
    echo   scripts\compile_iverilog.bat
    echo.
    pause
    exit /b 1
)

echo Running simulation...
echo.

cd sim
vvp sim.out

if %errorlevel% neq 0 (
    echo.
    echo ==========================================
    echo   SIMULATION FAILED
    echo ==========================================
    echo.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo   SIMULATION COMPLETED
echo ==========================================
echo.

if exist waveform.vcd (
    echo Waveform generated:
    echo   sim\waveform.vcd
    echo.
    echo Open using:
    echo   gtkwave sim\waveform.vcd
) else (
    echo NOTE: waveform.vcd was not generated.
    echo.
    echo Your testbench should contain:
    echo   $dumpfile("waveform.vcd");
    echo   $dumpvars(0, tb);
)

echo.
pause
endlocal