`timescale 1ns / 1ps
// EX/MEM Pipeline Register
module ex_mem #(
    parameter DATA_WIDTH = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  flush,
    // Control Signals
    input  wire                  reg_write,
    input  wire                  mem_read,
    input  wire                  mem_write,
    input  wire [1:0]            wb_sel,
    // Data Signals
    input  wire [DATA_WIDTH-1:0] alu_result,
    input  wire [DATA_WIDTH-1:0] rs2_data,
    input  wire [DATA_WIDTH-1:0] pc_plus4,
    input  wire [DATA_WIDTH-1:0] immediate,
    input  wire [4:0]            rd,
    // Outputs
    output reg                   reg_write_out,
    output reg                   mem_read_out,
    output reg                   mem_write_out,
    output reg [1:0]             wb_sel_out,
    output reg [DATA_WIDTH-1:0]  alu_result_out,
    output reg [DATA_WIDTH-1:0]  rs2_data_out,
    output reg [DATA_WIDTH-1:0]  pc_plus4_out,
    output reg [DATA_WIDTH-1:0]  immediate_out,
    output reg [4:0]             rd_out
);

always @(posedge clk)
begin

    if(!rst_n || flush)
    begin
        reg_write_out  <= 1'b0;
        mem_read_out   <= 1'b0;
        mem_write_out  <= 1'b0;
        wb_sel_out     <= 2'b00;

        alu_result_out <= 32'd0;
        rs2_data_out   <= 32'd0;
        pc_plus4_out   <= 32'd0;
        immediate_out  <= 32'd0;
        rd_out         <= 5'd0;
    end
    else
    begin
        reg_write_out  <= reg_write;
        mem_read_out   <= mem_read;
        mem_write_out  <= mem_write;
        wb_sel_out     <= wb_sel;
        alu_result_out <= alu_result;
        rs2_data_out   <= rs2_data;
        pc_plus4_out   <= pc_plus4;
        immediate_out  <= immediate;
        rd_out         <= rd;
    end
end

endmodule