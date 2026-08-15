//============================================================
// Data Memory
// RV32I Data Memory
//============================================================
module data_memory #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10,
    parameter MEM_DEPTH  = (1 << ADDR_WIDTH),
    parameter MEM_FILE   = "data_mem.hex"
)(
    input  wire                     clk,
    input  wire                     rst_n,
    // Memory Control
    input  wire                     mem_read,
    input  wire                     mem_write,
    // Address
    input  wire [31:0]              address,
    // Write Data
    input  wire [DATA_WIDTH-1:0]    write_data,
    // Read Data
    output wire [DATA_WIDTH-1:0]    read_data
);
// Memory Array
reg [DATA_WIDTH-1:0] memory [0:MEM_DEPTH-1];
integer i;
// Memory Initialization
initial begin
    // Initialize memory to zero
    for(i = 0; i < MEM_DEPTH; i = i + 1)
        memory[i] = {DATA_WIDTH{1'b0}};
    `ifndef SYNTHESIS
    // Load memory file
    $readmemh(MEM_FILE, memory);
    `endif
end
// Word Address
wire [ADDR_WIDTH-1:0] word_addr;
assign word_addr = address[ADDR_WIDTH+1:2];
// Write Logic
always @(posedge clk)
begin
    if(!rst_n)
    begin
        for(i = 0; i < MEM_DEPTH; i = i + 1)
            memory[i] <= {DATA_WIDTH{1'b0}};
    end
    else if(mem_write)
    begin
        memory[word_addr] <= write_data;
    end
end
// Read Logic
assign read_data =
        (mem_read) ?
        memory[word_addr] :
        {DATA_WIDTH{1'b0}};
// Debug Task (Simulation Only)
task display_memory;
    integer j;
begin
    $display("\n========== DATA MEMORY ==========");
    for(j = 0; j < 32; j = j + 1)
        $display("MEM[%0d] = 0x%08h", j, memory[j]);
    $display("=================================\n");
end
endtask

endmodule