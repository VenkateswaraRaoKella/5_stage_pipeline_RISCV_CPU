`timescale 1ns / 1ps
// MEM/WB Pipeline Register
module mem_wb #(
    parameter DATA_WIDTH = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  flush,
    // Control Signals
    input  wire                  reg_write,
    input  wire [1:0]            wb_sel,
    // Data Signals
    input  wire [DATA_WIDTH-1:0] mem_data,
    input  wire [DATA_WIDTH-1:0] alu_result,
    input  wire [DATA_WIDTH-1:0] pc_plus4,
    input  wire [DATA_WIDTH-1:0] immediate,
    input  wire [4:0]            rd,
    // Outputs
    output reg                   reg_write_out,
    output reg [1:0]             wb_sel_out,
    output reg [DATA_WIDTH-1:0]  mem_data_out,
    output reg [DATA_WIDTH-1:0]  alu_result_out,
    output reg [DATA_WIDTH-1:0]  pc_plus4_out,
    output reg [DATA_WIDTH-1:0]  immediate_out,
    output reg [4:0]             rd_out
);

always @(posedge clk)
begin
    if(!rst_n || flush)
    begin
        reg_write_out <= 1'b0;
        wb_sel_out    <= 2'b00;
        mem_data_out   <= {DATA_WIDTH{1'b0}};
        alu_result_out <= {DATA_WIDTH{1'b0}};
        pc_plus4_out   <= {DATA_WIDTH{1'b0}};
        immediate_out  <= {DATA_WIDTH{1'b0}};
        rd_out         <= 5'd0;
    end
    else
    begin
        reg_write_out <= reg_write;
        wb_sel_out    <= wb_sel;
        mem_data_out   <= mem_data;
        alu_result_out <= alu_result;
        pc_plus4_out   <= pc_plus4;
        immediate_out  <= immediate;
        rd_out         <= rd;
    end
end

endmodule