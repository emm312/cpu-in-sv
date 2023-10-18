module main_tb (
    input clk,
    input clk_en,
    input sync_rst
);
    wire clk_n = clk & clk_en;
    risccpu risccpu(
        .clk(clk_n),
        .sync_rst(sync_rst)
    );
endmodule
