module io(
    input [15:0] addr,
    input [15:0] data,
	input sync_rst,
    input write,
    output reg [15:0] data_out,
    input clk,
	output reg [7:0] LED,
	input button_1,
	input [3:0] switches
);
		always_ff @(posedge clk) begin
        	case (addr)
				0: begin
					if (write) begin
						LED <= data[7:0];
					end else begin
						data_out <= { button_1, 15'b0 };
					end
				end
				1: begin
					if (write) begin
						// TODO
					end else begin
						data_out <= { switches, 12'b0 };
					end
				end
			endcase
			if (~sync_rst) begin
				LED <= 8'b0;
			end
		end
endmodule