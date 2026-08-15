`timescale 1ns / 1ps
// ID/EX Pipeline Register
module id_ex #(
    parameter DATA_WIDTH = 32
)(
    input  wire                     clk,
    input  wire                     rst_n,
    input  wire                     flush,
    // Control Signals
    input  wire                     reg_write,
    input  wire                     mem_read,
    input  wire                     mem_write,
    input  wire                     alu_src,
    input  wire [1:0]               alu_op,
    input  wire [1:0]               wb_sel,
    input  wire                     branch,
    input  wire                     jump,
    input  wire                     load_unsigned,
    input  wire                     use_pc_as_operand_a,
    // Instruction Fields
    input  wire [2:0]               funct3,
    input  wire [6:0]               funct7,
    // Data Signals
    input  wire [DATA_WIDTH-1:0]    pc,
    input  wire [DATA_WIDTH-1:0]    rs1_data,
    input  wire [DATA_WIDTH-1:0]    rs2_data,
    input  wire [DATA_WIDTH-1:0]    immediate,
    input  wire [4:0]               rs1,
    input  wire [4:0]               rs2,
    input  wire [4:0]               rd,
    // Control Outputs
    output reg                      reg_write_out,
    output reg                      mem_read_out,
    output reg                      mem_write_out,
    output reg                      alu_src_out,

    output reg [1:0]                alu_op_out,
    output reg [1:0]                wb_sel_out,

    output reg                      branch_out,
    output reg                      jump_out,
    output reg                      load_unsigned_out,
    output reg                      use_pc_as_operand_a_out,
    // Instruction Outputs
    output reg [2:0]                funct3_out,
    output reg [6:0]                funct7_out,
    // Data Outputs
    output reg [DATA_WIDTH-1:0]     pc_out,
    output reg [DATA_WIDTH-1:0]     rs1_data_out,
    output reg [DATA_WIDTH-1:0]     rs2_data_out,
    output reg [DATA_WIDTH-1:0]     immediate_out,
    output reg [4:0]                rs1_out,
    output reg [4:0]                rs2_out,
    output reg [4:0]                rd_out
);

always @(posedge clk) begin
    if (!rst_n || flush) begin
        // Control
        reg_write_out            <= 1'b0;
        mem_read_out             <= 1'b0;
        mem_write_out            <= 1'b0;
        alu_src_out              <= 1'b0;
        alu_op_out               <= 2'b00;
        wb_sel_out               <= 2'b00;
        branch_out               <= 1'b0;
        jump_out                 <= 1'b0;
        load_unsigned_out        <= 1'b0;
        use_pc_as_operand_a_out  <= 1'b0;
        // Instruction Fields
        funct3_out               <= 3'b000;
        funct7_out               <= 7'b0000000;
        // Data
        pc_out                   <= {DATA_WIDTH{1'b0}};
        rs1_data_out             <= {DATA_WIDTH{1'b0}};
        rs2_data_out             <= {DATA_WIDTH{1'b0}};
        immediate_out            <= {DATA_WIDTH{1'b0}};
        rs1_out                  <= 5'd0;
        rs2_out                  <= 5'd0;
        rd_out                   <= 5'd0;
    end
    else begin
        // Control
        reg_write_out            <= reg_write;
        mem_read_out             <= mem_read;
        mem_write_out            <= mem_write;
        alu_src_out              <= alu_src;
        alu_op_out               <= alu_op;
        wb_sel_out               <= wb_sel;
        branch_out               <= branch;
        jump_out                 <= jump;
        load_unsigned_out        <= load_unsigned;
        use_pc_as_operand_a_out  <= use_pc_as_operand_a;
        // Instruction Fields
        funct3_out               <= funct3;
        funct7_out               <= funct7;
        // Data
        pc_out                   <= pc;
        rs1_data_out             <= rs1_data;
        rs2_data_out             <= rs2_data;
        immediate_out            <= immediate;
        rs1_out                  <= rs1;
        rs2_out                  <= rs2;
        rd_out                   <= rd;
    end
end

endmodule