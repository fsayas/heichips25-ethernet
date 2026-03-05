module phy(
    input        clk,       // 100 MHz system clock
    input        rst_n,     // Reset

    input        ref_clk,   // 50 MHz RMII clock
    input        tx_en,     // Transmit Enable
    input  [1:0] txd,       // Transmit Data
    output       rx_dv,     // Receive Data Valid
    output [1:0] rxd,       // Receive Data

    input        mdc,       // MDC
    input        mdio_i,    // MDIO
    output       mdio_o,    // MDIO
    output       mdio_oe,   // MDIO

    output reg   tx_p,
    output reg   tx_n

);

    // Sync inputs
    reg ref_clk_d;
    reg ref_clk_dd;
    reg tx_en_d;
    reg tx_en_dd;
    reg [1:0] txd_d;
    reg [1:0] txd_dd;
    reg mdc_d;
    reg mdc_dd;
    reg mdio_i_d;
    reg mdio_i_dd;

    always @(posedge clk or negedge rst_n) begin // 100 MHz
        if (!rst_n) begin
            ref_clk_d <= 0;
            ref_clk_dd <= 0;
            tx_en_d <= 0;
            tx_en_dd <= 0;
            txd_d <= 2'b00;
            txd_dd <= 2'b00;
            mdc_d <= 0;
            mdc_dd <= 0;
            mdio_i_d <= 0;
            mdio_i_dd <= 0;
        end else begin
            ref_clk_dd <= ref_clk_d;
            ref_clk_d <= ref_clk;
            tx_en_dd <= tx_en_d;
            tx_en_d <= tx_en;
            txd_dd <= txd_d;
            txd_d <= txd;
            mdc_dd <= mdc_d;
            mdc_d <= mdc;
            mdio_i_dd <= mdio_i_d;
            mdio_i_d <= mdio_i;
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

                    if (cycle_count >= 9) begin
                        enc_buf <= {txd_dd[1] ? 2'b01 : 2'b10,  // Manchester encoding
                                    txd_dd[0] ? 2'b01 : 2'b10}; // 0 --> 01, 1 --> 10
                        cycle_count <= 0;
                    end else
                        cycle_count <= cycle_count + 1;

                end else begin
                    cycle_count <= 9;
                end

            end

            if (enc_count >= 4) begin // 20 MHz (50 ns)                
                enc_buf <= enc_buf >>> 1; // Arithmetic shift right preserves MSB
                enc_count <= 0;
            end else begin
                if (!tx_en_dd && tx_en_d) // TX_EN assertion resets count
                    enc_count <= 0;
                else
                    enc_count <= enc_count + 1;
            end

        end
    end


    // Link Integrity Test. Send NLP (100 ns each 16 ms of inactivity)
    reg [20:0] lit_count;
    reg do_nlp;

    always @(posedge clk or negedge rst_n) begin // 100 MHz
        if (!rst_n) begin
            lit_count <= 0;
            do_nlp <= 0;
        end else begin
            if (!tx_en_dd) begin
                if (lit_count < 1600000) begin // 16 ms interval
                    lit_count <= lit_count + 1;  
                end else if (lit_count < 1600010) begin // 100 ns NLP
                    lit_count <= lit_count + 1; 
                    do_nlp <= 1;
                end else begin
                    lit_count <= 0;
                    do_nlp <= 0;
                end
            end else begin
                lit_count <= 0;
                do_nlp <= 0;
            end
        end
    end

    // Manage outputs
    always @(posedge clk) begin
        tx_p <= do_nlp ? ~enc_buf[0] : enc_buf[0];
        tx_n <= do_nlp ? enc_buf[0] : ~enc_buf[0];
    end

    // TODO: MDIO. Dumb connection to use signals.
    assign mdio_o = mdio_i_dd;
    assign mdio_oe = mdc_dd;

    // TODO: manage loopback
    assign rx_dv = tx_en;
    assign rxd = txd;

endmodule
