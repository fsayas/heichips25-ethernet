// SPDX-FileCopyrightText: © 2025 XXX Authors
// SPDX-License-Identifier: Apache-2.0

// Adapted from the Tiny Tapeout template

`include "line_driver.v"
`include "mdio.v"

`default_nettype none

module heichips25_ethernet (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n,    // reset_n - low to reset
    output wire       ethernet_dp,
    output wire       ethernet_dn
);

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, ui_in[7:6], uio_in[7:2]};

    assign uio_out[7:2] = '0;
    assign uio_oe[7:2] = '0;

    assign uo_out[7:4] = '0;
    assign uo_out[0] = '0;

    wire bypass_if;
    wire direct_drive;
    wire tx;
    wire in_p;
    wire in_n;

    phy phy_0 (
        .clk(clk),            // 100 MHz system clock
        .rst_n(rst_n),        // Reset signal
        .ref_clk(ui_in[0]),   // 50 MHz ref clock
        .tx_en(ui_in[1]),     // Transmit enable
        .txd(ui_in[3:2]),     // Transmit data
        .rx_dv(uo_out[1]),    // Receive data valid from PHY
        .rxd(uo_out[3:2]),    // Receive data from PHY
        .mdc_i(uio_in[0]),    // MDC input
        .mdc_o(uio_out[0]),   // MDC output
        .mdc_oe(uio_oe[0]),   // MDC output enable
        .mdio_i(uio_in[1]),   // MDIO input
        .mdio_o(uio_out[1]),  // MDIO output
        .mdio_oe(uio_oe[1]),  // MDIO output enable
        .tx(tx)               // TX output line
    );

    assign bypass_if = ui_in[4];
    assign direct_drive = ui_in[5];

    assign in_p = bypass_if ? direct_drive : tx;
    assign in_n = bypass_if ? ~direct_drive : ~tx;

    line_driver line_driver_0 (
      .in_p (in_p),
      .in_n (in_n),
      .ethernet_dp (ethernet_dp),
      .ethernet_dn (ethernet_dn)
    );

endmodule
