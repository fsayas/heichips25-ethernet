`timescale 1ns/1ps

module phy_tb;

    // Registers for inputs
    reg clk;
    reg rst_n;
    reg ref_clk;
    reg tx_en;
    reg [1:0] txd;
    reg mdc_i;
    reg mdio_i;

    // Wires for outputs
    wire rx_dv;
    wire [1:0] rxd;
    wire mdc_o;
    wire mdc_oe;
    wire mdio_o;
    wire mdio_oe;
    wire tx;

    // Instantiate the PHY module
    phy dut (
        .clk(clk),
        .rst_n(rst_n),
        .ref_clk(ref_clk),
        .tx_en(tx_en),
        .txd(txd),
        .rx_dv(rx_dv),
        .rxd(rxd),
        .mdc_i(mdc_i),
        .mdc_o(mdc_o),
        .mdc_oe(mdc_oe),
        .mdio_i(mdio_i),
        .mdio_o(mdio_o),
        .mdio_oe(mdio_oe),
        .tx(tx)
    );

    // 100 MHz System Clock (10ns period)
    always #5 clk = ~clk;

    // 50 MHz RMII Reference Clock derived from 100 MHz clock
    always @(posedge clk) begin
        if (!rst_n) ref_clk <= 0;
        else ref_clk <= ~ref_clk;
    end

    // Test sequence
    initial begin
        // Setup tracing for GTKWave
        $dumpfile("phy_tb.vcd");
        $dumpvars(0, phy_tb);

        // Initialize inputs
        clk = 0;
        rst_n = 0;
        tx_en = 0;
        txd = 0;
        mdc_i = 0;
        mdio_i = 0;

        // Apply reset
        #25;
        rst_n = 1;

        // Wait to observe NLP (Link Integrity Test) pulses
        $display("Observing idle state (NLP pulses should occur)...");
        #200; // Small wait just to see the beginning

        // Send a frame at 10 Mbps over 50 MHz RMII
        // Each bit of data (2 bits at a time) must be held for 10 cycles (50 MHz / 10 = 5 MHz nibble rate = 10 Mbps)
        $display("Transmitting Data...");
        
        @(negedge ref_clk);
        tx_en = 1;
        txd = 2'b01; // Data = 1
        repeat(10) @(negedge ref_clk); // Hold for 10 total cycles
        
        txd = 2'b10; // Data = 2
        repeat(10) @(negedge ref_clk);
        
        txd = 2'b11; // Data = 3
        repeat(10) @(negedge ref_clk);
        
        txd = 2'b00; // Data = 0
        repeat(10) @(negedge ref_clk);
        
        // Stop transmitting
        tx_en = 0;
        txd = 2'b00;

        // Wait a little more to see it settle back to idle
        #200;

        $display("Testbench finished.");
        $finish;
    end

endmodule
