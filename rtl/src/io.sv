module io(
    input [15:0] addr,
    input [15:0] data,
    input write,
    output reg [15:0] data_out,
    input clk,
	 output reg [7:0] LED,
	 input button_1
);
		always_ff @(posedge clk) begin
        case (addr)
				0: begin
					if (write) begin
						LED <= data;
					end else begin
						data_out <= button_1;
					end
				end
		  endcase
		 end
endmodule