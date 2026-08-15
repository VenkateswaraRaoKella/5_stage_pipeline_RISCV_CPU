//============================================================
// Testbench : five_cycle_cpu
// RV32I 5-Stage Pipelined CPU
//
// Tests through the loaded instruction_mem.hex:
//
// 1.  R-Type
// 2.  I-Type
// 3.  LW
// 4.  SW
// 5.  Load-use hazard
// 6.  EX/MEM forwarding
// 7.  MEM/WB forwarding
// 8.  BEQ taken
// 9.  BEQ not taken
// 10. BNE
// 11. BLT
// 12. BGE
// 13. BLTU
// 14. BGEU
// 15. LUI
// 16. AUIPC
// 17. JAL
// 18. JALR
// 19. Negative immediate
// 20. x0 protection
//============================================================

module five_cycle_cpu_tb;
    //--------------------------------------------------------
    // Clock / Reset
    //--------------------------------------------------------
    reg clk;
    reg rst_n;
    reg [31:0] debug_pc;
    reg [31:0] debug_instruction;
    reg [31:0] debug_writeback_data;
    //--------------------------------------------------------
    // DUT
    //--------------------------------------------------------
    five_cycle_cpu DUT (
        .clk   (clk),
        .rst_n (rst_n),
        .debug_pc (debug_pc),
        .debug_instruction(debug_instruction),
        .debug_writeback_data(debug_writeback_data)
    );
    //--------------------------------------------------------
    // Clock
    //--------------------------------------------------------
    initial begin
        clk = 1'b0;
    end
    always #5 clk = ~clk;
    //--------------------------------------------------------
    // VCD Dump
    //--------------------------------------------------------
    initial begin
        $dumpfile("five_cycle_cpu.vcd");
        $dumpvars(0, five_cycle_cpu_tb);
    end
    //--------------------------------------------------------
    // Reset
    //--------------------------------------------------------
    initial begin
        rst_n = 1'b0;
        // Hold reset for two clock cycles
        #20;
        rst_n = 1'b1;
    end
    //--------------------------------------------------------
    // Monitor
    //--------------------------------------------------------
    initial begin
        $monitor(
            "T=%0t | PC=%08h | INST=%08h | ",
            "ALU=%08h | WB=%08h | ",
            "x1=%08h x2=%08h x3=%08h",
            $time,
            DUT.pc,
            DUT.instruction,
            DUT.alu_result,
            DUT.writeback_data,
            DUT.RF.registers[1],
            DUT.RF.registers[2],
            DUT.RF.registers[3]
        );
    end
    //========================================================
    // PASS / FAIL Counters
    //========================================================
    integer pass_count;
    integer fail_count;
    initial begin
        pass_count = 0;
        fail_count = 0;
    end
    //========================================================
    // Register Check Task
    //========================================================
    task check_register;
        input integer reg_num;
        input [31:0] expected;
        begin
            if (DUT.RF.registers[reg_num] === expected) begin
                $display(
                    "PASS: x%0d = 0x%08h",
                    reg_num,
                    DUT.RF.registers[reg_num]
                );
                pass_count = pass_count + 1;
            end
            else begin
                $display(
                    "FAIL: x%0d = 0x%08h | EXPECTED = 0x%08h",
                    reg_num,
                    DUT.RF.registers[reg_num],
                    expected
                );
                fail_count = fail_count + 1;
            end
        end
    endtask
    //========================================================
    // x0 Protection Test
    //========================================================
    task check_x0;
        begin
            if (DUT.RF.registers[0] === 32'h00000000) begin
                $display(
                    "PASS: x0 protection | x0 = 0x%08h",
                    DUT.RF.registers[0]
                );
                pass_count = pass_count + 1;
            end
            else begin
                $display(
                    "FAIL: x0 protection | x0 = 0x%08h",
                    DUT.RF.registers[0]
                );
                fail_count = fail_count + 1;
            end
        end
    endtask
    //========================================================
    // Display Register File
    //========================================================
    task display_results;
        integer j;
        begin
            $display("");
            $display("================================================");
            $display("             REGISTER FILE RESULT");
            $display("================================================");
            for (j = 0; j < 32; j = j + 1) begin
                $display(
                    "x%0d = 0x%08h",
                    j,
                    DUT.RF.registers[j]
                );
            end
            $display("================================================");
            $display("");
        end
    endtask
    //========================================================
    // Expected Register Results
    //========================================================
    task run_register_tests;
        begin
            $display("");
            $display("================================================");
            $display("             AUTOMATIC VERIFICATION");
            $display("================================================");
            $display("");
            //------------------------------------------------
            // x0 protection
            //------------------------------------------------
            check_x0;
            //------------------------------------------------
            // Basic R / I / Memory / Forwarding tests
            //------------------------------------------------
            check_register(1,  32'h00000005);
            check_register(2,  32'h0000000A);
            check_register(3,  32'h0000000F);
            check_register(4,  32'h0000000F);
            check_register(5,  32'h00000014);
            check_register(6,  32'h0000001E);
            check_register(7,  32'h00000032);
            check_register(8,  32'h00000033);
            check_register(9,  32'h0000000F);
            check_register(10, 32'h00000041);
            //------------------------------------------------
            // Branch / signed / negative immediate
            //------------------------------------------------
            check_register(11, 32'hFFFFFF22);
            //------------------------------------------------
            // LUI
            //------------------------------------------------
            check_register(12, 32'h12345000);
            //------------------------------------------------
            // AUIPC
            //------------------------------------------------
            check_register(13, 32'h00001060);
            //------------------------------------------------
            // JAL / JALR
            //------------------------------------------------
            check_register(14, 32'h00000068);
            check_register(15, 32'h00000042);
            check_register(16, 32'h00000070);
            check_register(17, 32'h00000078);
            check_register(18, 32'h0000007C);
            check_register(19, 32'h00000063);
        end
    endtask
    //========================================================
    // Main Simulation
    //========================================================
    initial begin
        //----------------------------------------------------
        // Wait until reset is released
        //----------------------------------------------------
        wait (rst_n == 1'b1);
        //----------------------------------------------------
        // Allow pipeline to execute program
        //----------------------------------------------------
        #500;
        //----------------------------------------------------
        // Display final register state
        //----------------------------------------------------
        display_results;
        //----------------------------------------------------
        // Run checks
        //----------------------------------------------------
        run_register_tests;
        //----------------------------------------------------
        // Summary
        //----------------------------------------------------
        $display("");
        $display("================================================");
        $display("              TEST SUMMARY");
        $display("================================================");
        $display(
            "PASS COUNT = %0d",
            pass_count
        );
        $display(
            "FAIL COUNT = %0d",
            fail_count
        );
        $display("================================================");
        if (fail_count == 0) begin
            $display("");
            $display("****************************************");
            $display("*       ALL TESTS PASSED              *");
            $display("*       CPU VERIFICATION SUCCESS      *");
            $display("****************************************");
            $display("");
        end
        else begin
            $display("");
            $display("****************************************");
            $display("*       CPU VERIFICATION FAILED       *");
            $display("*       CHECK FAILURES ABOVE           *");
            $display("****************************************");
            $display("");
        end
        //----------------------------------------------------
        // Finish
        //----------------------------------------------------
        $finish;
    end
    
endmodule