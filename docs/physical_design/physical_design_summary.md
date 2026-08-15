# Physical Design Summary

## Overview

This project implements a 5-stage pipelined RISC-V CPU and takes the design through an ASIC physical-design flow.

The physical-design stages transform the synthesized RTL/netlist into a placed, clocked, routed design and ultimately a GDSII layout suitable for physical verification.

## Physical Design Flow

```text
Synthesized Netlist
        |
        v
   Floorplanning
        |
        v
     Placement
        |
        v
 Clock Tree Synthesis
        |
        v
      Routing
        |
        v
   Final Layout
        |
        v
   GDSII / Signoff
```

## 1. Floorplanning

Floorplanning defines the physical organization of the chip before standard-cell placement.

Key activities include:

- Defining the core and die area
- Setting utilization and aspect ratio
- Placing I/O pins
- Establishing power and ground structures
- Preparing the design for standard-cell placement

**Output:** Initial physical organization of the design.

Relevant project results:

```text
results/floorplan/
```

## 2. Placement

Placement assigns physical locations to the synthesized standard cells within the core area.

The objective is to obtain a legal and efficient placement while considering:

- Cell density
- Timing
- Wirelength
- Congestion
- Physical constraints

**Output:** Placed standard-cell design.

Relevant project results:

```text
results/placement/
```

## 3. Clock Tree Synthesis (CTS)

Clock Tree Synthesis builds a clock distribution network so that the clock reaches sequential elements with controlled skew and delay.

Important considerations include:

- Clock skew
- Clock latency
- Clock buffering
- Setup and hold timing
- Clock-tree routing

**Output:** Clocked and buffered physical design.

Relevant project results:

```text
results/cts/
```

## 4. Routing

Routing connects the placed cells and clock network using the available metal layers.

The routing stage includes:

- Global routing
- Detailed routing
- Signal interconnects
- Power/ground connectivity
- Design-rule-aware routing

The final routed design should be checked for routing congestion, timing, and physical-rule violations.

**Output:** Fully routed physical design.

Relevant project results:

```text
results/routing/
```

## 5. Final Layout

The final stage contains the completed physical implementation after placement, CTS, and routing.

The final layout can be inspected using tools such as OpenROAD and KLayout.

Relevant project results:

```text
results/final/
```

## Physical Design Results

The project keeps generated physical-design data separate from documentation:

```text
results/
├── cts/
├── final/
├── floorplan/
├── placement/
├── reports/
├── routing/
└── screenshots/
    ├── cts.png
    ├── placement.png
    ├── routing.png
    ├── riscv_cpu_chip.jpg
    ├── riscv_cpu_top.jpg
    └── riscv.png
```

The screenshots are generated from the actual physical-design flow and are used for visual documentation and portfolio presentation.

## Tools

The physical-design flow uses:

- **OpenLane** — RTL-to-GDSII automation and flow management
- **OpenROAD** — physical-design implementation and analysis
- **KLayout** — GDSII/layout visualization and inspection

## Documentation Principle

Generated implementation files, reports, and screenshots remain in the `results/` directory. This documentation file is intentionally kept separate so that the repository does not contain unnecessary duplicate files.

## Physical Design Stage Summary

| Stage | Main Purpose | Project Result |
|---|---|---|
| Floorplan | Define chip/core organization | `results/floorplan/` |
| Placement | Place standard cells | `results/placement/` |
| CTS | Build clock distribution | `results/cts/` |
| Routing | Connect the design | `results/routing/` |
| Final | Completed physical implementation | `results/final/` |
| Reports | Timing/area and other analysis | `results/reports/` |

## Final Goal

The physical-design flow demonstrates the transformation:

```text
RISC-V RTL
   ↓
Synthesis
   ↓
Gate-Level Netlist
   ↓
Floorplan
   ↓
Placement
   ↓
CTS
   ↓
Routing
   ↓
Final Layout
   ↓
GDSII
```

This provides evidence that the RISC-V CPU was taken beyond RTL simulation into an ASIC physical-design flow.
