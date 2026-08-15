# 5-Stage Pipelined RISC-V CPU — RTL to ASIC

A **5-stage pipelined RISC-V processor** designed in Verilog/SystemVerilog and taken through an **RTL-to-ASIC physical design flow** using open-source EDA tools.

The project covers CPU architecture, RTL design, simulation and verification, synthesis, timing/power analysis, physical design, DRC/LVS, and final layout visualization.

---

## 📌 Project Overview

This project implements a classic 5-stage RISC-V pipeline:

```text
        ┌─────┐
        │ IF  │  Instruction Fetch
        └──┬──┘
           │
        ┌──▼──┐
        │ ID  │  Instruction Decode
        └──┬──┘
           │
        ┌──▼──┐
        │ EX  │  Execute
        └──┬──┘
           │
        ┌──▼──┐
        │ MEM │  Memory Access
        └──┬──┘
           │
        ┌──▼──┐
        │ WB  │  Write Back
        └─────┘
```

### Pipeline stages

| Stage | Function                                                  |
| ----- | --------------------------------------------------------- |
| IF    | Fetch instruction and update PC                           |
| ID    | Decode instruction and read registers                     |
| EX    | ALU operations, branch comparison and address calculation |
| MEM   | Load/store memory operations                              |
| WB    | Write results back to the register file                   |

---

## 🚀 Features

### Processor

* 5-stage pipelined architecture
* RISC-V based instruction execution
* Program Counter
* Register File
* ALU
* Instruction memory interface
* Data memory interface
* Pipeline registers
* Control logic

### Supported instruction categories

The current verification includes:

* R-type instructions
* I-type instructions
* `LW`
* `SW`
* `BEQ`

Additional instructions can be added as the processor is extended.

### Pipeline hazard handling

The processor includes logic for:

* Load-use hazard detection
* Pipeline stalling
* EX/MEM forwarding
* MEM/WB forwarding
* Branch handling
* Pipeline flushing

Important control modules include:

```text
hazard_unit
forwarding_unit
stall_unit
flush_unit
```

### Branch handling

For a taken branch, instructions fetched from the wrong path are removed from the pipeline using the **flush logic**.

Both cases are verified:

```text
BEQ taken
BEQ not taken
```

---

# 🏗️ Architecture

The main datapath can be summarized as:

```text
                  ┌──────────────┐
                  │ Instruction  │
                  │   Memory     │
                  └──────┬───────┘
                         │
                         ▼
                    ┌─────────┐
                    │   IF    │
                    └────┬────┘
                         │
                    IF/ID Register
                         │
                         ▼
                    ┌─────────┐
                    │   ID    │
                    │ Decoder │
                    │ RegFile │
                    └────┬────┘
                         │
                    ID/EX Register
                         │
                         ▼
                    ┌─────────┐
                    │   EX    │
                    │   ALU   │
                    └────┬────┘
                         │
                   EX/MEM Register
                         │
                         ▼
                    ┌─────────┐
                    │   MEM   │
                    │  Data   │
                    │ Memory  │
                    └────┬────┘
                         │
                   MEM/WB Register
                         │
                         ▼
                    ┌─────────┐
                    │   WB    │
                    └─────────┘
                         │
                         ▼
                    Register File
```

Hazard and forwarding logic operates alongside the datapath to maintain correct execution when instructions depend on previous instructions.

---

# 🔧 Repository Structure

```text
5_stage_pipeline_CPU/
│
├── constraints/
│   └── timing and physical-design constraints
│
├── docs/
│   ├── architecture/
│   ├── physical_design/
│   ├── synthesis/
│   └── waveforms/
│
├── include/
│   └── shared definitions / headers
│
├── netlist/
│   └── synthesized netlists
│
├── openlane/
│   └── OpenLane configuration and flow files
│
├── results/
│   └── generated implementation results
│
├── sim/
│   └── simulation and verification files
│
├── src/
│   └── source/design files
│
├── synthesis/
│   └── synthesis-related files and reports
│
├── .gitignore
├── LICENSE
└── README.md
```

---

# 🧩 Important RTL Modules

The design is divided into functional modules rather than placing the complete processor into a single RTL file.

Typical major blocks include:

```text
RISC-V CPU
│
├── PC / Instruction Fetch
├── Instruction Decode
├── Register File
├── Control Unit
├── ALU
├── Data Memory Interface
│
├── IF/ID Pipeline Register
├── ID/EX Pipeline Register
├── EX/MEM Pipeline Register
├── MEM/WB Pipeline Register
│
├── Forwarding Unit
├── Hazard Unit
├── Stall Unit
└── Flush Unit
```

This modular structure makes the design easier to verify, synthesize, debug, and extend.

---

# ⚠️ Hazard Handling

## Load-Use Hazard

A load instruction followed immediately by an instruction that uses the loaded value creates a data hazard.

The processor detects the dependency and inserts a pipeline stall when forwarding alone cannot resolve the hazard.

```text
LW   x1, 0(x2)
ADD  x3, x1, x4
         ↑
     dependency
```

---

## Data Forwarding

The processor supports forwarding from later pipeline stages to the EX stage.

```text
EX/MEM ───────────────┐
                      ├──► Forwarding MUX ──► ALU
MEM/WB ───────────────┘
```

This reduces unnecessary pipeline stalls.

---

# 🔄 Branch Flush

For a taken `BEQ`, instructions following the incorrectly predicted/sequential PC path must be removed.

```text
BEQ taken
    │
    ▼
Branch target selected
    │
    ▼
flush_unit
    │
    ├──► Flush wrong-path instruction
    └──► Continue from branch target
```

The `flush_unit` is therefore part of the pipeline control/hazard-handling logic.

---

# 🧪 Verification

The testbench verifies both normal instruction execution and pipeline-specific behavior.

### Current test scenarios

```text
✓ R-type instruction
✓ I-type instruction
✓ LW
✓ SW
✓ Load-use hazard
✓ EX/MEM forwarding
✓ MEM/WB forwarding
✓ BEQ taken
✓ BEQ not taken
✓ Pipeline stall
✓ Pipeline flush
```

Waveforms can be inspected using tools such as:

* Icarus Verilog
* Verilator
* GTKWave

---

# 🛠️ Tools Used

## RTL / Simulation

* Verilog/SystemVerilog
* Icarus Verilog
* Verilator
* GTKWave

## Synthesis

* Yosys

## Physical Design

* OpenLane
* OpenROAD

## Layout / Verification

* KLayout
* Magic
* Netgen

## Technology

* SkyWater SKY130
* `sky130_fd_sc_hd` standard-cell library

---

# 🔨 ASIC Flow

The project follows an open-source RTL-to-ASIC flow:

```text
RTL
 │
 ▼
Lint / RTL Verification
 │
 ▼
Yosys Synthesis
 │
 ▼
Gate-Level Netlist
 │
 ▼
Floorplanning
 │
 ▼
I/O Placement
 │
 ▼
Global Placement
 │
 ▼
Detailed Placement
 │
 ▼
Clock Tree Synthesis
 │
 ▼
Global Routing
 │
 ▼
Detailed Routing
 │
 ▼
DRC / LVS / Timing / Power
 │
 ▼
GDSII
 │
 ▼
KLayout
```

---

# 📐 Synthesis

Yosys is used to convert the RTL design into a technology-mapped gate-level netlist.

The synthesis stage provides information such as:

* Number of wires
* Number of wire bits
* Number of ports
* Number of cells
* Standard-cell usage
* Sequential-cell usage
* Estimated/chip area

Example synthesis statistics are generated for the top module:

```text
=== riscv_cpu ===

Number of wires: ...
Number of wire bits: ...
Number of ports: ...
Number of cells: ...
Chip area for module 'riscv_cpu': ...
```

The exact values depend on the RTL version, synthesis configuration, constraints, and technology library.

---

# 📊 Physical Design

OpenROAD is used for the backend physical-design stages.

Important stages include:

```text
Floorplan
    ↓
Global Placement
    ↓
Detailed Placement
    ↓
CTS
    ↓
Global Routing
    ↓
Detailed Routing
```

Intermediate OpenROAD databases can be inspected using `.odb` files.

For example:

```text
floorplan → .odb
placement → .odb
CTS       → .odb
routing   → .odb
```

These databases can be opened with OpenROAD GUI for physical-design inspection.

---

# 🖥️ Layout Visualization

The final physical implementation can be inspected using **KLayout**.

The final GDSII represents the physical implementation of the top-level CPU after synthesis, placement, clock-tree synthesis, and routing.

Typical flow:

```text
OpenLane
   │
   ▼
Final GDSII
   │
   ▼
KLayout
   │
   ▼
Physical Layout Inspection
```

OpenROAD is useful for inspecting the physical-design stages, while KLayout is useful for inspecting the final GDSII layout.

---

# ✅ Physical Verification

The ASIC flow includes physical verification steps such as:

### DRC

Design Rule Checking verifies whether the layout satisfies the manufacturing design rules.

Tools include:

* Magic
* KLayout

### LVS

Layout Versus Schematic verifies consistency between the extracted layout and the intended circuit/netlist.

Tool:

* Netgen

### Timing

The implementation flow provides setup and hold timing reports.

Important metrics include:

```text
Setup WNS
Setup TNS
Hold WNS
Hold TNS
```

### Power

Power analysis provides estimates based on the implemented design and selected operating conditions.

---

# 📁 Important Generated Outputs

The OpenLane run generates several important artifacts.

### Netlist

```text
netlist/
```

Contains synthesized gate-level representations where retained.

### DEF

DEF files describe physical design information such as placement and routing.

### ODB

ODB files are OpenDB databases used by OpenROAD to represent the physical design.

### GDSII

The final GDSII is the physical layout database used for final layout inspection.

### Reports

Important reports include:

```text
Area
Timing
Power
DRC
LVS
```

Generated OpenLane run directories should generally be treated as generated artifacts rather than manually duplicated into `docs/`.

---

# 📈 Results

The project evaluates the implementation using:

| Category        | Metric          |
| --------------- | --------------- |
| Synthesis       | Cell count      |
| Synthesis       | Area            |
| Timing          | Setup WNS       |
| Timing          | Setup TNS       |
| Timing          | Hold WNS        |
| Timing          | Hold TNS        |
| Power           | Power estimate  |
| Physical Design | Core/chip area  |
| DRC             | Violation count |
| LVS             | Pass/Fail       |
| Layout          | Final GDSII     |

> Exact results should be taken from the latest successful OpenLane run rather than hard-coded here.

---

# 📚 Documentation

Additional project documentation is organized under:

```text
docs/
├── architecture/
│   └── CPU architecture and pipeline documentation
│
├── rtl/
│   └── RTL module and verification documentation
│
├── synthesis/
│   └── synthesis results and analysis
│
└── physical_design/
    └── floorplan, placement, CTS, routing,
        DRC, LVS and layout documentation
```

---

# 🚦 How to Run RTL Simulation

The exact command depends on the testbench and simulator configuration.

For Icarus Verilog, a typical flow is:

```bash
iverilog -g2012 -o sim.out <RTL_FILES> <TESTBENCH>
vvp sim.out
```

To generate a VCD waveform, ensure the testbench contains the required waveform dump statements and then open the generated waveform with:

```bash
gtkwave <waveform>.vcd
```

For Verilator, use the project's configured Verilator command/build flow.

---

# 🔬 Synthesis and ASIC Flow

The OpenLane configuration is located under:

```text
openlane/
```

The project uses the configured SkyWater SKY130 technology and standard-cell library.

A typical flow is:

```text
RTL
 ↓
OpenLane
 ↓
Synthesis
 ↓
Floorplan
 ↓
Placement
 ↓
CTS
 ↓
Routing
 ↓
Signoff
 ↓
GDSII
```

The generated run directory contains individual OpenLane stages and their corresponding outputs.

---

# 🎯 Project Goals

This project is intended to demonstrate practical understanding of:

* Computer architecture
* RISC-V processor design
* Pipeline architecture
* RTL design
* Hazard detection
* Data forwarding
* Pipeline stalling
* Pipeline flushing
* RTL verification
* Logic synthesis
* Static timing analysis
* Physical design
* Clock-tree synthesis
* Routing
* DRC
* LVS
* GDSII generation
* Open-source ASIC design tools

---

# 🔮 Future Improvements

Potential extensions include:

* Expand the supported RISC-V instruction set
* Add additional branch instructions
* Improve branch handling
* Add more comprehensive automated verification
* Add assertions and coverage
* Add caches
* Add memory hierarchy
* Improve timing performance
* Perform power optimization
* Explore clock gating
* Add more detailed ASIC signoff analysis
* Generate and document a complete final GDSII flow

---

# 👤 Author

**K Venkateswara Rao**

This project is developed as a learning and portfolio project focused on:

**RISC-V + Computer Architecture + RTL Design + ASIC/VLSI Design**

---

# 📄 License

This project is released under the **MIT License**.

See the [`LICENSE`](LICENSE) file for details.

---

## ⭐ Project Summary

```text
5-Stage RISC-V CPU
        │
        ├── RTL Design
        ├── Hazard Detection
        ├── Forwarding
        ├── Stall / Flush Control
        ├── Simulation & Verification
        │
        ▼
      Yosys
        │
        ▼
   Gate-Level Netlist
        │
        ▼
     OpenLane
        │
        ├── Floorplan
        ├── Placement
        ├── CTS
        ├── Routing
        ├── DRC
        └── LVS
        │
        ▼
      GDSII
        │
        ▼
     KLayout
```

**End-to-end implementation of a pipelined RISC-V CPU from RTL to physical layout using an open-source ASIC design flow.**