module instruction_memory #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10,              // 2^10 = 1024 words
    parameter MEM_DEPTH  = (1 << ADDR_WIDTH),
    parameter MEM_FILE   = "instruction_mem.hex"
)(
    input  wire [31:0]              pc,
    output wire [DATA_WIDTH-1:0]    instruction
);
// Instruction Memory
reg [DATA_WIDTH-1:0] memory [0:MEM_DEPTH-1];
// Initialize Memory
integer i;
initial begin
    for (i = 0; i < MEM_DEPTH; i = i + 1)
        memory[i] = 32'h00000013;   // NOP

    `ifndef SYNTHESIS // For synthesis only, if got error any error.. Remove this line
        $readmemh(MEM_FILE, memory);
    `endif// And this line also..
end
// Word-Aligned Address
wire [ADDR_WIDTH-1:0] word_addr;
assign word_addr = pc[ADDR_WIDTH+1:2];
// Instruction Fetch
assign instruction = memory[word_addr];

endmodule