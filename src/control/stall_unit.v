// Stall Unit
module stall_unit(
    // Hazard Detection Input
    input  wire hazard_detected,
    // Outputs
    output wire pc_write,
    output wire if_id_write
);

// Stall Logic
assign pc_write   = ~hazard_detected;
assign if_id_write = ~hazard_detected;

endmodule