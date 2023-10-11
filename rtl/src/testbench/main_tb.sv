module main_tb (
    input clk,
    input clk_en,
    input sync_rst
);
    cpu the_cpu(
        .clk(clk),
        .clk_en(clk_en),
        .sync_rst(sync_rst)
    );
endmodule
