//============================================================
// Register File
// RV32I - 32 Registers x 32-bit
//============================================================
module register_file #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 5,
    parameter NUM_REGS   = 32
)(
    input  wire                     clk,
    input  wire                     rst_n,
    // Write Port
    input  wire                     reg_write,
    input  wire [ADDR_WIDTH-1:0]    rd_addr,
    input  wire [DATA_WIDTH-1:0]    rd_data,
    // Read Port 1
    input  wire [ADDR_WIDTH-1:0]    rs1_addr,
    output wire [DATA_WIDTH-1:0]    rs1_data,
    // Read Port 2
    input  wire [ADDR_WIDTH-1:0]    rs2_addr,
    output wire [DATA_WIDTH-1:0]    rs2_data
);

// Register Array
reg [DATA_WIDTH-1:0] registers [0:NUM_REGS-1];
integer i;
// Optional Simulation Initialization
initial begin
    for(i=0;i<NUM_REGS;i=i+1)
        registers[i] = {DATA_WIDTH{1'b0}};
end
// Reset & Write Logic
always @(posedge clk) begin
    if(!rst_n) begin
        for(i=0;i<NUM_REGS;i=i+1)
            registers[i] <= {DATA_WIDTH{1'b0}};
    end
    else begin
        // x0 is always zero
        registers[0] <= {DATA_WIDTH{1'b0}};

        // Write destination register
        if(reg_write && (rd_addr != 5'd0))
            registers[rd_addr] <= rd_data;
    end
end
// Asynchronous Read Port 1
assign rs1_data =
    (rs1_addr == 5'd0) ?
    {DATA_WIDTH{1'b0}} :
    registers[rs1_addr];
// Asynchronous Read Port 2
assign rs2_data =
    (rs2_addr == 5'd0) ?
    {DATA_WIDTH{1'b0}} :
    registers[rs2_addr];
// Debug Task (Simulation Only)
task display_registers;
    integer j;
begin
    $display("\n========== Register File ==========");
    for(j=0;j<NUM_REGS;j=j+1)
        $display("x%0d = 0x%08h", j, registers[j]);
    $display("===================================\n");
end
endtask

endmodule