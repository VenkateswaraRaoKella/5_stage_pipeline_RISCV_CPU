# OpenLane Flow

This directory contains the OpenLane configuration used to harden the
5-stage pipelined RISC-V CPU.

## Design

- **Design:** RISC-V 5-Stage Pipelined CPU
- **Top Module:** `riscv_cpu`
- **HDL:** Verilog
- **Clock:** `clk`
- **Clock Period:** 10 ns
- **Target Frequency:** 100 MHz

## Configuration

The main OpenLane configuration is:

```text
config.json