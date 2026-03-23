module phy(
    input        clk,       // 100 MHz system clock
    input        rst_n,     // Reset

    input        ref_clk,   // 50 MHz RMII clock
    input        tx_en,     // Transmit Enable
    input  [1:0] txd,       // Transmit Data
    output       rx_dv,     // Receive Data Valid
    output [1:0] rxd,       // Receive Data

    input        mdc_i,     // MDC input
    output       mdc_o,     // MDC output
    output       mdc_oe,    // MDC output enable
    input        mdio_i,    // MDIO input
    output       mdio_o,    // MDIO output
    output       mdio_oe,   // MDIO output enable

    output       tx         // TX output line

);

    // Sync inputs
    reg ref_clk_d;
    reg ref_clk_dd;
    reg tx_en_d;
    reg tx_en_dd;
    reg [1:0] txd_d;
    reg [1:0] txd_dd;

    always @(posedge clk or negedge rst_n) begin // 100 MHz
        if (!rst_n) begin
            ref_clk_d <= 0;
            ref_clk_dd <= 0;
            tx_en_d <= 0;
            tx_en_dd <= 0;
            txd_d <= 2'b00;
            txd_dd <= 2'b00;
        end else begin
            ref_clk_dd <= ref_clk_d;
            ref_clk_d <= ref_clk;
            tx_en_dd <= tx_en_d;
            tx_en_d <= tx_en;
            txd_dd <= txd_d;
            txd_d <= txd;
        end
    end

    // TX logic
    reg [3:0] cycle_count;
    reg [2:0] enc_count;
    reg [3:0] enc_buf;

    always @(posedge clk or negedge rst_n) begin // 100 MHz
        if (!rst_n) begin
            cycle_count <= 9;
            enc_count <= 0;
            enc_buf <= 4'b0000;
        end else begin
            
            if (!ref_clk_dd && ref_clk_d) begin // 50 MHz rising edge
                if (tx_en_dd) begin
                    if (cycle_count >= 9) cycle_count <= 0;
                    else cycle_count <= cycle_count + 1;
                end else begin
                    cycle_count <= 9;
                end
            end

            if (!ref_clk_dd && ref_clk_d && tx_en_dd && (cycle_count >= 9)) begin
                enc_buf <= {txd_dd[1] ? 2'b10 : 2'b01, 
                            txd_dd[0] ? 2'b10 : 2'b01}; 
                enc_count <= 0;
            end else if (enc_count >= 4) begin
                enc_buf <= {enc_buf[3], enc_buf[3:1]};
                enc_count <= 0;
            end else begin
                enc_count <= enc_count + 1;
            end

        end
    end

    assign tx = enc_buf[0];



    // MDIO Submodule Instantiation
    wire [4:0]  reg_addr;
    wire [15:0] reg_wdata;
    wire        reg_write_en;
    reg  [15:0] reg_rdata;

    wire _unused_wdata = &{1'b0, reg_wdata[13:0]};

    mdio #(.PHY_ADDR(5'b00001)) mdio_inst (
        .clk(clk),
        .rst_n(rst_n),
        .mdc_i(mdc_i),
        .mdio_i(mdio_i),
        .mdio_o(mdio_o),
        .mdio_oe(mdio_oe),
        .reg_addr(reg_addr),
        .reg_wdata(reg_wdata),
        .reg_write_en(reg_write_en),
        .reg_rdata(reg_rdata)
    );

    // Register Read Multiplexer
    reg reg_loopback;
    reg [15:0] tx_packet_count;

    always @(*) begin
        case (reg_addr)
            5'd0:  reg_rdata = {1'b0, reg_loopback, 5'b00000, 1'b1, 8'b00000000}; // BMCR
            5'd1:  reg_rdata = 16'h1804; // BMSR
            5'd2:  reg_rdata = 16'h4843; // PHYID1 ("HC")
            5'd3:  reg_rdata = 16'h2025; // PHYID2 ("25")
            5'd16: reg_rdata = tx_packet_count; // Vendor Specific TX Packet Count
            default: reg_rdata = 16'h0000;
        endcase
    end

    // Register Write & Statistics Logic
    always @(posedge clk or negedge rst_n) begin // 100 MHz
        if (!rst_n) begin
            reg_loopback <= 1'b0;
            tx_packet_count <= 16'd0;
        end else begin
            if (reg_write_en && reg_addr == 5'd0) begin
                reg_loopback <= reg_wdata[14];
                if (reg_wdata[15]) begin
                    tx_packet_count <= 16'd0; // Use soft-reset to clear stats
                end
            end
            
            if (!tx_en_dd && tx_en_d) begin
                tx_packet_count <= tx_packet_count + 1;
            end
        end
    end

    // Loopback Management
    assign rx_dv = reg_loopback ? tx_en : 1'b0;
    assign rxd   = reg_loopback ? txd   : 2'b00;

    // MDC tri-state pins remain inputs
    assign mdc_o = 1'b0;
    assign mdc_oe = 1'b0;

endmodule
