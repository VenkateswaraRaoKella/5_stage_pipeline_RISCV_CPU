`include "../include/defines.vh"
// `include "defines.vh"
module riscv_cpu(
    input wire clk,
    input wire rst_n,
    output wire [31:0] debug_pc,
    output wire [31:0] debug_instruction,
    output wire [31:0] debug_writeback_data
);
// Program Counter
wire [31:0] pc;
wire [31:0] next_pc;
wire [31:0] pc_plus4;
// Instruction Memory
wire [31:0] instruction;
// Instruction Fields
wire [6:0] opcode;
wire [4:0] rd;
wire [2:0] funct3;
wire [4:0] rs1;
wire [4:0] rs2;
wire [6:0] funct7;
// Control Signals
wire reg_write;
wire mem_read;
wire mem_write;
wire alu_src;
wire branch;
wire jump;
wire load_unsigned;
wire [1:0] alu_op;
// Register File
wire [31:0] rs1_data;
wire [31:0] rs2_data;
// Immediate
wire [31:0] immediate;
// ALU
wire [31:0] alu_result;
wire zero;
wire less;
wire overflow;
wire [3:0] alu_control_signal;
// Data Memory
wire [31:0] mem_read_data;
// Branch
wire [31:0] branch_target;
wire branch_taken;
//Sel
wire [1:0] wb_sel;
// Comparator
wire eq;
wire neq;
wire lt;
wire ge;
wire ltu;
wire geu;
wire use_pc_as_operand_a;
// Writeback
wire [31:0] writeback_data;
// IF/ID Pipeline Register Wires
wire [31:0] if_id_pc;
wire [31:0] if_id_instruction;
wire        pc_write;
wire        if_id_write;
wire        if_id_flush;
// ID/EX Pipeline Register Wires
// Data
wire [31:0] id_ex_pc;
wire [31:0] id_ex_rs1_data;
wire [31:0] id_ex_rs2_data;
wire [31:0] id_ex_immediate;
wire [1:0] id_ex_alu_op;
//wire [3:0] id_ex_alu_control;
// Instruction Fields
wire [4:0]  id_ex_rs1;
wire [4:0]  id_ex_rs2;
wire [4:0]  id_ex_rd;
wire [2:0]  id_ex_funct3;
wire [6:0]  id_ex_funct7;
// Control Signals
wire        id_ex_reg_write;
wire        id_ex_mem_read;
wire        id_ex_mem_write;
wire        id_ex_alu_src;
wire        id_ex_branch;
wire        id_ex_jump;
wire        id_ex_load_unsigned;
wire [1:0]  id_ex_wb_sel;
wire        id_ex_use_pc_as_operand_a;
wire        id_ex_flush;
// EX/MEM Pipeline Register
wire        ex_mem_reg_write;
wire        ex_mem_mem_read;
wire        ex_mem_mem_write;
wire [1:0]  ex_mem_wb_sel;
wire [31:0] ex_mem_alu_result;
wire [31:0] ex_mem_rs2_data;
wire [31:0] ex_mem_pc_plus4;
wire [31:0] ex_mem_immediate;
wire [4:0]  ex_mem_rd;
// MEM/WB Pipeline Register
wire        mem_wb_reg_write;
wire [1:0]  mem_wb_wb_sel;
wire [31:0] mem_wb_mem_data;
wire [31:0] mem_wb_alu_result;
wire [31:0] mem_wb_pc_plus4;
wire [31:0] mem_wb_immediate;
wire [4:0]  mem_wb_rd;
// Forwarding Wires
wire [1:0] forward_a;
wire [1:0] forward_b;
wire [31:0] forward_rs1;
wire [31:0] forward_rs2;
// Program Counter
program_counter PC (
    .clk(clk),
    .rst_n(rst_n),
    .pc_en(pc_write),
    .next_pc(next_pc),
    .pc(pc)
);
// Instruction Memory
instruction_memory IMEM (
    .pc(pc),
    .instruction(instruction)
);
// Decoder
decoder DECODER(
    .instruction(if_id_instruction),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)
);
// Control Unit
control_unit CONTROL (
    .opcode(opcode),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .branch(branch),
    .jump(jump),
    .alu_op(alu_op),
    .load_unsigned(load_unsigned),
    .wb_sel(wb_sel),
    .use_pc_as_operand_a(use_pc_as_operand_a)
);
// Comparator
comparator CMP(
    .a(forward_rs1),
    .b(forward_rs2),
    .equal(eq),
    .not_equal(neq),
    .less_than_signed(lt),
    .greater_equal_signed(ge),
    .less_than_unsigned(ltu),
    .greater_equal_unsigned(geu)
);
// Register File
register_file RF (
    .clk(clk),
    .rst_n(rst_n),
    .reg_write(mem_wb_reg_write),
    .rd_addr(mem_wb_rd),
    .rd_data(writeback_data),
    .rs1_addr(rs1),
    .rs2_addr(rs2),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);
// Immediate Generator
immediate_generator IMM_GEN (
    .instruction(if_id_instruction),
    .immediate(immediate)
);
// ALU Control
alu_control ALU_CTRL (
    .alu_op(alu_op),
    .funct3(funct3),
    .funct7(funct7),
    .alu_control(alu_control_signal)
);
// Execute
execute_stage EX_STAGE(
    .pc(id_ex_pc),
    .rs1_data(forward_rs1),
    .rs2_data(forward_rs2),
    .immediate(id_ex_immediate),
    .alu_src(id_ex_alu_src),
    .use_pc_as_operand_a(id_ex_use_pc_as_operand_a),
    .alu_control(alu_control_signal),
    .alu_result(alu_result),
    .zero(zero),
    .less(less),
    .overflow(overflow)
);
wire [31:0] id_ex_pc_plus4;
adder ID_EX_PC4(
    .a(id_ex_pc),
    .b(32'd4),
    .sum(id_ex_pc_plus4)
);
// EX/MEM
wire ex_mem_flush;
assign ex_mem_flush = 1'b0;
ex_mem EX_MEM(
    .clk(clk),
    .rst_n(rst_n),
    .flush(ex_mem_flush),
    // Control
    .reg_write(id_ex_reg_write),
    .mem_read(id_ex_mem_read),
    .mem_write(id_ex_mem_write),
    .wb_sel(id_ex_wb_sel),
    // Data
    .alu_result(alu_result),
    .rs2_data(forward_rs2),
    .rd(id_ex_rd),
    .pc_plus4(id_ex_pc_plus4),
    .immediate(id_ex_immediate),
    .reg_write_out(ex_mem_reg_write),
    .mem_read_out(ex_mem_mem_read),
    .mem_write_out(ex_mem_mem_write),
    .wb_sel_out(ex_mem_wb_sel),
    .alu_result_out(ex_mem_alu_result),
    .rs2_data_out(ex_mem_rs2_data),
    .rd_out(ex_mem_rd),
    .pc_plus4_out(ex_mem_pc_plus4),
    .immediate_out(ex_mem_immediate)
);
// PC + 4
adder PC_ADDER (
    .a(pc),
    .b(32'd4),
    .sum(pc_plus4)
);
// Branch Adder
adder BRANCH_ADDER (
    .a(id_ex_pc),
    .b(id_ex_immediate),
    .sum(branch_target)
);
// Branch Unit
branch_unit BRANCH(
    .branch(id_ex_branch),
    .funct3(id_ex_funct3),
    .equal(eq),
    .not_equal(neq),
    .less_than_signed(lt),
    .greater_equal_signed(ge),
    .less_than_unsigned(ltu),
    .greater_equal_unsigned(geu),
    .branch_taken(branch_taken)
);
// Memory Stage
memory_stage MEM_STAGE(
    .clk(clk),
    .mem_read(ex_mem_mem_read),
    .mem_write(ex_mem_mem_write),
    .address(ex_mem_alu_result),
    .write_data(ex_mem_rs2_data),
    .read_data(mem_read_data)
);
// MEM/WB
wire mem_wb_flush;
assign mem_wb_flush = 1'b0;
mem_wb MEM_WB(
    .clk(clk),
    .rst_n(rst_n),
    .flush(mem_wb_flush),
    .reg_write(ex_mem_reg_write),
    .wb_sel(ex_mem_wb_sel),
    .mem_data(mem_read_data),
    .alu_result(ex_mem_alu_result),
    .pc_plus4(ex_mem_pc_plus4),
    .immediate(ex_mem_immediate),
    .rd(ex_mem_rd),
    .reg_write_out(mem_wb_reg_write),
    .wb_sel_out(mem_wb_wb_sel),
    .mem_data_out(mem_wb_mem_data),
    .alu_result_out(mem_wb_alu_result),
    .pc_plus4_out(mem_wb_pc_plus4),
    .immediate_out(mem_wb_immediate),
    .rd_out(mem_wb_rd)
);
// Writeback_stage
writeback_stage WB_STAGE (
    .alu_result(mem_wb_alu_result),
    .mem_data(mem_wb_mem_data),
    .pc_plus4(mem_wb_pc_plus4),
    .immediate(mem_wb_immediate),
    .wb_sel(mem_wb_wb_sel),
    .writeback_data(writeback_data)
);
// IF/ID Pipeline Register
if_id IF_ID (
    .clk            (clk),
    .rst_n          (rst_n),
    .stall          (~if_id_write),
    .flush          (if_id_flush),
    .pc             (pc),
    .instruction    (instruction),
    .pc_out         (if_id_pc),
    .instruction_out(if_id_instruction)
);
// ID/EX Pipeline Register
id_ex ID_EX(
    .clk(clk),
    .rst_n(rst_n),
    .flush(id_ex_flush),
    // Control
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .wb_sel(wb_sel),
    .alu_src(alu_src),
    //.alu_control(alu_control_signal),
    // Data
    .pc(if_id_pc),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .immediate(immediate),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    // Outputs
    .reg_write_out(id_ex_reg_write),
    .mem_read_out(id_ex_mem_read),
    .mem_write_out(id_ex_mem_write),
    .wb_sel_out(id_ex_wb_sel),
    .alu_src_out(id_ex_alu_src),
    //.alu_control_out(id_ex_alu_control),
    .pc_out(id_ex_pc),
    .rs1_data_out(id_ex_rs1_data),
    .rs2_data_out(id_ex_rs2_data),
    .immediate_out(id_ex_immediate),
    .rs1_out(id_ex_rs1),
    .rs2_out(id_ex_rs2),
    .rd_out(id_ex_rd),
    // Additional Control
    .alu_op               (alu_op),
    .branch               (branch),
    .jump                 (jump),
    .load_unsigned        (load_unsigned),
    .use_pc_as_operand_a  (use_pc_as_operand_a),
    // Instruction Fields
    .funct3               (funct3),
    .funct7               (funct7),
    // Outputs
    .alu_op_out               (id_ex_alu_op),
    .branch_out               (id_ex_branch),
    .jump_out                 (id_ex_jump),
    .load_unsigned_out        (id_ex_load_unsigned),
    .use_pc_as_operand_a_out  (id_ex_use_pc_as_operand_a),
    .funct3_out(id_ex_funct3),
    .funct7_out(id_ex_funct7)
);
// Forwarding Unit
forwarding_unit FORWARD(
    .ex_mem_reg_write(ex_mem_reg_write),
    .ex_mem_rd(ex_mem_rd),
    .mem_wb_reg_write(mem_wb_reg_write),
    .mem_wb_rd(mem_wb_rd),
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .forward_a(forward_a),
    .forward_b(forward_b)
);
mux4 #(32) FORWARD_A(
    .in0(id_ex_rs1_data),
    .in1(writeback_data),
    .in2(ex_mem_alu_result),
    .in3(32'd0),
    .sel(forward_a),
    .out(forward_rs1)
);
mux4 #(32) FORWARD_B(
    .in0(id_ex_rs2_data),
    .in1(writeback_data),
    .in2(ex_mem_alu_result),
    .in3(32'd0),
    .sel(forward_b),
    .out(forward_rs2)
);
wire id_ex_flush_hazard;
wire id_ex_flush_branch;
assign id_ex_flush =
        id_ex_flush_hazard |
        id_ex_flush_branch;
// Hazard Detection Unit
hazard_detection_unit HAZARD(
    .id_ex_mem_read(id_ex_mem_read),
    .id_ex_rd(id_ex_rd),
    .if_id_rs1(rs1),
    .if_id_rs2(rs2),
    .pc_write(pc_write),
    .if_id_write(if_id_write),
    .id_ex_flush(id_ex_flush_hazard)
);
// Flush Unit
flush_unit FLUSH(
    .branch_taken(branch_taken),
    .jump(id_ex_jump),
    .if_id_flush(if_id_flush),
    .id_ex_flush(id_ex_flush_branch)
);
// Next PC
assign next_pc =
id_ex_jump ?
alu_result :
branch_taken ?
branch_target :
pc_plus4;
assign debug_pc              = pc;
assign debug_instruction     = instruction;
assign debug_writeback_data  = writeback_data;
endmodule