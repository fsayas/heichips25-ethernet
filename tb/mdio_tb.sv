`timescale 1ns/1ps

module mdio_tb;

    reg clk, rst_n;
    reg mdc_gen;
    reg mac_mdio_o, mac_mdio_oe;
    wire mdio_bus;
    
    assign mdio_bus = mac_mdio_oe ? mac_mdio_o : 1'bz;

    wire mdio_phy_o, mdio_phy_oe;
    assign mdio_bus = mdio_phy_oe ? mdio_phy_o : 1'bz;

    wire [4:0] reg_addr;
    wire [15:0] reg_wdata;
    wire reg_write_en;
    reg [15:0] reg_rdata;

    mdio #(.PHY_ADDR(5'h01)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .mdc_i(mdc_gen),
        .mdio_i(mdio_bus),
        .mdio_o(mdio_phy_o),
        .mdio_oe(mdio_phy_oe),
        .reg_addr(reg_addr),
        .reg_wdata(reg_wdata),
        .reg_write_en(reg_write_en),
        .reg_rdata(reg_rdata)
    );

    always #5 clk = ~clk;
    always #200 mdc_gen = ~mdc_gen;

    task send_bit(input b);
    begin
        @(negedge mdc_gen);
        mac_mdio_oe = 1;
        mac_mdio_o = b;
    end
    endtask

    task send_z();
    begin
        @(negedge mdc_gen);
        mac_mdio_oe = 0;
    end
    endtask

    initial begin
        $dumpfile("mdio_tb.vcd");
        $dumpvars(0, mdio_tb);
        
        clk = 0; rst_n = 0; mdc_gen = 0; mac_mdio_oe = 0; mac_mdio_o = 1;
        #100 rst_n = 1;
        reg_rdata = 16'hABCD;
        
        // Preamble
        repeat(33) send_bit(1);
        
        // READ FRAME: ST=01, OP=10, PHY=00001, REG=00110
        send_bit(0); send_bit(1); // ST
        send_bit(1); send_bit(0); // OP Read
        send_bit(0); send_bit(0); send_bit(0); send_bit(0); send_bit(1); // PHY
        send_bit(0); send_bit(0); send_bit(1); send_bit(1); send_bit(0); // REG 6
        send_z(); send_z(); // TA
        repeat(16) send_z(); // Data
        
        // Preamble
        repeat(33) send_bit(1);
        
        // WRITE FRAME: ST=01, OP=01, PHY=00001, REG=00011, DATA=4321
        send_bit(0); send_bit(1); // ST
        send_bit(0); send_bit(1); // OP Write
        send_bit(0); send_bit(0); send_bit(0); send_bit(0); send_bit(1); // PHY
        send_bit(0); send_bit(0); send_bit(0); send_bit(1); send_bit(1); // REG 3
        send_bit(1); send_bit(0); // TA
        
        // DATA (0100 0011 0010 0001)
        send_bit(0); send_bit(1); send_bit(0); send_bit(0);
        send_bit(0); send_bit(0); send_bit(1); send_bit(1);
        send_bit(0); send_bit(0); send_bit(1); send_bit(0);
        send_bit(0); send_bit(0); send_bit(0); send_bit(1);
        send_z();

        #1000 $finish;
    end
endmodule
