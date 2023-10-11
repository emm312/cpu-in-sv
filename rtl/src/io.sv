module io(
    input [15:0] addr,
    input [15:0] data,
    input write,
    output reg[15:0] data_out,
    input clk
);
    always_ff @(posedge clk) begin
        case (addr)
            16'h0000: begin // printascii
                if (write) begin 
                    $display("%c", data[7:0]); 
                end
            end
            default: assign data_out = 0;
        endcase
    end
endmodule