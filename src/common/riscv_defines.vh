`ifndef RISCV_DEFINES_VH
`define RISCV_DEFINES_VH
// ==========================================================
// RV32I BASE OPCODE DEFINITIONS
// ==========================================================

// R-type register-register instructions
`define OPCODE_RTYPE   7'b0110011

// I-type immediate arithmetic/logical instructions
`define OPCODE_ITYPE   7'b0010011

// Load instructions
`define OPCODE_LOAD    7'b0000011

// Store instructions
`define OPCODE_STORE   7'b0100011

// Branch instructions
`define OPCODE_BRANCH  7'b1100011

// JAL
`define OPCODE_JAL     7'b1101111

// JALR
`define OPCODE_JALR    7'b1100111

// LUI
`define OPCODE_LUI     7'b0110111

// AUIPC
`define OPCODE_AUIPC   7'b0010111

`endif