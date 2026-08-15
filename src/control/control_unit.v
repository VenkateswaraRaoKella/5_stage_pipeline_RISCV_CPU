`include "../include/defines.vh" // For test only, remove while simulating the CPU
// RV32I Control Unit
module control_unit(
    input  wire [6:0] opcode,
    // Register File
    output reg        reg_write,
    // Memory
    output reg        mem_read,
    output reg        mem_write,
    // ALU
    output reg        alu_src,
    output reg [1:0]  alu_op,
    // Branch / Jump
    output reg        branch,
    output reg        jump,
    // Load Type
    output reg        load_unsigned,
    // Writeback Select
    // 00 : ALU Result
    // 01 : Memory Data
    // 10 : PC + 4
    // 11 : Immediate
    output reg [1:0]  wb_sel,
    // ALU Operand A Select
    // 0 : rs1
    // 1 : PC
    output reg        use_pc_as_operand_a
);

always @(*) begin

    // Default Values
    reg_write            = 1'b0;
    mem_read             = 1'b0;
    mem_write            = 1'b0;
    alu_src              = 1'b0;
    alu_op               = 2'b00;
    branch               = 1'b0;
    jump                 = 1'b0;
    load_unsigned        = 1'b0;
    wb_sel               = 2'b00;
    use_pc_as_operand_a  = 1'b0;
    // Opcode Decode
    case(opcode)

    // R-Type
    `OPCODE_RTYPE:
    begin
        reg_write = 1'b1;
        alu_src   = 1'b0;
        alu_op    = 2'b10;
        wb_sel    = 2'b00;
    end

    // I-Type Arithmetic
    `OPCODE_ITYPE:
    begin
        reg_write = 1'b1;
        alu_src   = 1'b1;
        alu_op    = 2'b10;
        wb_sel    = 2'b00;
    end

    // Load
    `OPCODE_LOAD:
    begin
        reg_write = 1'b1;
        mem_read  = 1'b1;
        alu_src   = 1'b1;
        alu_op    = 2'b00;
        wb_sel    = 2'b01;
    end

    // Store
    `OPCODE_STORE:
    begin
        mem_write = 1'b1;
        alu_src   = 1'b1;
        alu_op    = 2'b00;
    end

    // Branch
    `OPCODE_BRANCH:
    begin
        branch = 1'b1;
        alu_op = 2'b01;
    end

    // JAL
    `OPCODE_JAL:
    begin
        reg_write           = 1'b1;
        jump                = 1'b1;
        wb_sel              = 2'b10;
        use_pc_as_operand_a = 1'b1;
        alu_src             = 1'b1;
        alu_op              = 2'b00;
    end

    // JALR
    `OPCODE_JALR:
    begin
        reg_write = 1'b1;
        jump      = 1'b1;
        wb_sel    = 2'b10;
        alu_src   = 1'b1;
        alu_op    = 2'b00;
    end

    // LUI
    `OPCODE_LUI:
    begin
        reg_write = 1'b1;
        wb_sel    = 2'b11;
    end

    // AUIPC
    `OPCODE_AUIPC:
    begin
        reg_write           = 1'b1;
        wb_sel              = 2'b00;
        use_pc_as_operand_a = 1'b1;
        alu_src             = 1'b1;
        alu_op              = 2'b00;
    end

    // Default
    default:
    begin
    end

    endcase

end

endmodule