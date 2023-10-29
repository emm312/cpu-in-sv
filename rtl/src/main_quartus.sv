module risccpu(
    input clk,
    input sync_rst,
	output [7:0] led,
	input [3:0] SWITCHES,
	input PSWITCH
);
	wire clk_uen;
	wire clk_en;
	wire clk_proper = clk_uen & clk_en;
	wire sys_sync_rst;
	wire rst = ~sync_rst;
	SystemClockDomainManager clk_manager(
		.ref_clk_50(clk),
		.user_async_rst(rst),
		.sys_clk(clk_uen),
		.sys_clk_en(clk_en),
		.sys_sync_rst(sys_sync_rst)
	);
		
	cpu cpu(
		.clk(clk_proper),
		.sync_rst(rst),
		
		.led(led),
		.SWITCHES(SWITCHES),
		.PSWITCH(PSWITCH)
	);
endmodule