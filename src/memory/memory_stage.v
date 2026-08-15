module memory_stage #(
    parameter DATA_WIDTH = 32,
    parameter MEM_DEPTH  = 256
)(
    // Clock
    input  wire                     clk,
    // Control Signals
    input  wire                     mem_read,
    input  wire                     mem_write,
    // Address
    input  wire [DATA_WIDTH-1:0]    address,
    // Store Data
    input  wire [DATA_WIDTH-1:0]    write_data,
    // Load Data
    output wire [DATA_WIDTH-1:0]    read_data
);
// Data Memory
data_memory #(
    .DATA_WIDTH(DATA_WIDTH),
    .MEM_DEPTH(MEM_DEPTH)
) DMEM (
    .clk        (clk),
    .mem_read   (mem_read),
    .mem_write  (mem_write),
    .address    (address),
    .write_data (write_data),
    .read_data  (read_data)
);

endmodule