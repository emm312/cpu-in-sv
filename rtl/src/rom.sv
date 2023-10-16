module rom (
    input [15:0] read_pos,
    output [7:0] data
);
    reg [7:0] data_inner;
    `include "../../image.mem"

    assign data = data_inner;
endmodule
