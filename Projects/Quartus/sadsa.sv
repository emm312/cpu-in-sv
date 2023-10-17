module riscjnjjcpu(
    input clk,
    input sync_rst,
	 output reg [7:0] led
);
reg [31:0] ctr = 0;
reg [7:0] inner_ctr = 0;

always_ff @(posedge clk) begin
	ctr <= ctr + 1;
	if (ctr > 50000000) begin
		ctr <= 0;
		inner_ctr <= inner_ctr + 1;
		led <= inner_ctr;
	end
	end
endmodule
	