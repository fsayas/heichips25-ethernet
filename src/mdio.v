module mdio #(
    parameter PHY_ADDR = 5'b00001
)(
    input  wire        clk,
    input  wire        rst_n,
    
    input  wire        mdc_i,
    input  wire        mdio_i,
    output reg         mdio_o,
    output reg         mdio_oe,
    
    output reg  [4:0]  reg_addr,
    output reg  [15:0] reg_wdata,
    output reg         reg_write_en,
    input  wire [15:0] reg_rdata
);

    reg mdc_d, mdc_dd;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mdc_d <= 1'b0;
            mdc_dd <= 1'b0;
        end else begin
            mdc_dd <= mdc_d;
            mdc_d <= mdc_i;
        end
    end
    wire mdc_rise = !mdc_dd && mdc_d;
    wire mdc_fall = mdc_dd && !mdc_d;

    reg [1:0] state;
    localparam IDLE = 2'd0;
    localparam RUN = 2'd1;

    reg [5:0] bit_cnt;
    reg [5:0] ones_cnt;
    reg [13:0] header_buf; // ST(2), OP(2), PHY(5), REG(5) -> 14 bits
    reg [15:0] data_buf;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            bit_cnt <= 0;
            ones_cnt <= 0;
            header_buf <= 0;
            data_buf <= 0;
            reg_addr <= 0;
            reg_wdata <= 0;
            reg_write_en <= 0;
            mdio_oe <= 0;
            mdio_o <= 0;
        end else begin
            reg_write_en <= 1'b0;

            if (mdc_rise) begin
                if (state == IDLE) begin
                    if (mdio_i == 1'b1) begin
                        if (ones_cnt < 63) ones_cnt <= ones_cnt + 1;
                    end else begin
                        if (ones_cnt >= 32) begin
                            state <= RUN;
                            bit_cnt <= 1;
                            header_buf <= 14'b0;
                        end
                        ones_cnt <= 0;
                    end
                end else if (state == RUN) begin
                    bit_cnt <= bit_cnt + 1;
                    
                    if (bit_cnt < 14) begin
                        header_buf <= {header_buf[12:0], mdio_i};
                        if (bit_cnt == 13) begin
                            reg_addr <= {header_buf[3:0], mdio_i};
                        end
                    end else if (bit_cnt >= 16) begin
                        if (header_buf[11:10] == 2'b01) begin
                            data_buf <= {data_buf[14:0], mdio_i};
                        end
                        if (bit_cnt == 31) begin
                            state <= IDLE;
                            bit_cnt <= 0;
                            if (header_buf[13:12] == 2'b01 && header_buf[11:10] == 2'b01 && header_buf[9:5] == PHY_ADDR) begin
                                reg_wdata <= {data_buf[14:0], mdio_i};
                                reg_write_en <= 1'b1;
                            end
                        end
                    end
                end
            end

            // Drive MDIO output on MDC FALLING EDGE to provide setup time for MAC
            if (mdc_fall) begin
                if (state == RUN) begin
                    if (header_buf[13:12] == 2'b01 && header_buf[11:10] == 2'b10 && header_buf[9:5] == PHY_ADDR) begin
                        if (bit_cnt == 15) begin
                            mdio_oe <= 1'b1;
                            mdio_o  <= 1'b0;
                            data_buf <= reg_rdata;
                        end else if (bit_cnt >= 16 && bit_cnt <= 31) begin
                            mdio_oe <= 1'b1;
                            mdio_o  <= data_buf[15];
                            data_buf <= {data_buf[14:0], 1'b0};
                        end else begin
                            mdio_oe <= 1'b0;
                        end
                    end else begin
                        mdio_oe <= 1'b0;
                    end
                end else begin
                    mdio_oe <= 1'b0;
                end
            end
            
        end
    end
endmodule
