`ifndef DEFINES_VH
`define DEFINES_VH
//============================================================
// General Parameters
//============================================================
`define DATA_WIDTH     32
`define ADDR_WIDTH     32
`define REG_ADDR_WIDTH 5
`define REG_COUNT      32
//============================================================
// ALU Operation (From Control Unit)
//============================================================
`define ALUOP_ADD      2'b00
`define ALUOP_BRANCH   2'b01
`define ALUOP_RTYPE    2'b10
`define ALUOP_ITYPE    2'b11
//============================================================
// ALU Control Signals
//============================================================
`define ALU_ADD        4'b0000
`define ALU_SUB        4'b0001
`define ALU_AND        4'b0010
`define ALU_OR         4'b0011
`define ALU_XOR        4'b0100
`define ALU_SLL        4'b0101
`define ALU_SRL        4'b0110
`define ALU_SRA        4'b0111
`define ALU_SLT        4'b1000
`define ALU_SLTU       4'b1001
//============================================================
// Write Back Select
//============================================================
`define WB_ALU         2'b00
`define WB_MEM         2'b01
`define WB_PC4         2'b10
`define WB_IMM         2'b11
//============================================================
// RISC-V Opcodes
//============================================================
`define OPCODE_RTYPE   7'b0110011
`define OPCODE_ITYPE   7'b0010011
`define OPCODE_LOAD    7'b0000011
`define OPCODE_STORE   7'b0100011
`define OPCODE_BRANCH  7'b1100011
`define OPCODE_JALR    7'b1100111
`define OPCODE_JAL     7'b1101111
`define OPCODE_LUI     7'b0110111
`define OPCODE_AUIPC   7'b0010111
//============================================================
// Branch funct3
//============================================================
`define BEQ            3'b000
`define BNE            3'b001
`define BLT            3'b100
`define BGE            3'b101
`define BLTU           3'b110
`define BGEU           3'b111
//============================================================
// Load funct3
//============================================================
`define LB             3'b000
`define LH             3'b001
`define LW             3'b010
`define LBU            3'b100
`define LHU            3'b101
//============================================================
// Store funct3
//============================================================
`define SB             3'b000
`define SH             3'b001
`define SW             3'b010
//============================================================
// Reset Address
//============================================================
`define RESET_PC       32'h00000000
`endif