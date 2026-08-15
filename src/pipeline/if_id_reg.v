`timescale 1ns / 1ps
// IF/ID Pipeline Register
module if_id #(parameter DATA_WIDTH = 32)
(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  stall,
    input  wire                  flush,
    input  wire [DATA_WIDTH-1:0] pc,
    input  wire [DATA_WIDTH-1:0] instruction,
    output reg  [DATA_WIDTH-1:0] pc_out,
    output reg  [DATA_WIDTH-1:0] instruction_out
);

always @(posedge clk) begin
    if (!rst_n) begin
        pc_out          <= 0;
        instruction_out <= 32'h00000013;   // NOP
    end
    else if (flush) begin
        pc_out          <= 0;
        instruction_out <= 32'h00000013;
    end
    else if (!stall) begin
        pc_out          <= pc;
        instruction_out <= instruction;
    end
end

endmodule