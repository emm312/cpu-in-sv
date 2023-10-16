module io(
    input [15:0] addr,
    input [15:0] data,
    input write,
    output reg[15:0] data_out,
    input clk
);
    always_ff @(posedge clk) begin
        case (addr)
				// 0: LED <= data[7:0];
				default: ;
		  endcase
    end
endmodule