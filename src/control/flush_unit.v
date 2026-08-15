`timescale 1ns / 1ps
//============================================================
// Flush Unit
//============================================================
module flush_unit(
    // Branch / Jump Decision
    input  wire branch_taken,
    input  wire jump,
    // Flush Signals
    output reg  if_id_flush,
    output reg  id_ex_flush
);
always @(*) begin
    // Default
    if_id_flush = 1'b0;
    id_ex_flush = 1'b0;
    // Flush on Branch or Jump
    if (branch_taken || jump) begin
        if_id_flush = 1'b1;
        id_ex_flush = 1'b1;
    end
end
endmodule