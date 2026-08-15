// Program Counter
module program_counter #(
    parameter DATA_WIDTH = 32,
    parameter RESET_PC   = 32'h00000000
)(
    input  wire                     clk,
    input  wire                     rst_n,
    // PC Enable
    input  wire                     pc_en,
    // Next Program Counter
    input  wire [DATA_WIDTH-1:0]    next_pc,
    // Current Program Counter
    output reg  [DATA_WIDTH-1:0]    pc
);

// Program Counter Register
always @(posedge clk) begin
    if (!rst_n)
        pc <= RESET_PC;
    else if (pc_en)
        pc <= next_pc;
    else
        pc <= pc;   // Hold current PC (Pipeline Stall)
end

endmodule