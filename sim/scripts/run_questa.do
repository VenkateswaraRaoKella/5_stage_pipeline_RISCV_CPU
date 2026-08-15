# ==========================================================
# RISC-V CPU - Questa/ModelSim Simulation Script
# ==========================================================

if {![file exists work]} {
    vlib work
}

vmap work work

echo "=========================================="
echo "  RISC-V CPU - Questa Simulation"
echo "=========================================="

# Compile Verilog RTL
echo "Compiling RTL files..."

vlog -v2k ../src/*.v

if {$? != 0} {
    echo "ERROR: RTL compilation failed."
    quit -f
}

# Compile Verilog testbench
echo "Compiling Testbench files..."

vlog -v2k ../tb/*.v

if {$? != 0} {
    echo "ERROR: Testbench compilation failed."
    quit -f
}

# Start simulation
echo "Starting simulation..."

# Change this if your actual testbench module
# has a different name.
vsim -voptargs=+acc work.riscv_cpu_tb

# Add all signals
add wave -divider "RISC-V CPU"
add wave -r /*

# Run
echo "Running simulation..."
run -all

echo "=========================================="
echo "  Simulation completed"
echo "=========================================="