module rom (
    input [15:0] read_pos,
    output [7:0] data
);
    wire [7:0] rom [0:65535];
    reg [7:0] data_inner;
    initial begin
        $display("Initializing ROM");
        $readmemh("image.mem", rom);
    end

    assign data = rom[read_pos];
endmodule
