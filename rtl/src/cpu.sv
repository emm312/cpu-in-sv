typedef enum {
    ReadingOpWord,
    ReadingRegWord,
    ReadingImm1,
    ReadingImm2,
    ExecutingInstr
} State;

module cpu(
    input clk
);
    State state;
    wire [7:0] word;
    reg [4:0] opcode;
    reg [2:0] dst;
    reg [15:0] pc;
    reg hasimm1;
    reg hasimm2;
    reg [7:0] imm1;
    reg [7:0] imm2;
    reg [2:0] src1;
    reg [2:0] src2;

    reg [15:0] regs [0:7];
    assign regs[7] = 65535;
    reg [15:0] src1val;
    reg [15:0] src2val;

    reg [15:0] ram [0:65535];

    rom therom(
        .read_pos(pc),
        .data(word)
    );

    reg gr_flag;
    reg eq_flag;
    reg gte_flag;

    reg write_io;
    reg [15:0] io_addr;
    reg [15:0] io_data;
    reg [15:0] io_data_out;
    io theio(
        .addr(io_addr),
        .data(io_data),
        .data_out(io_data_out),
        .write(write_io),
        .clk(clk)
    );


    initial begin
        state = ReadingOpWord;
    end
    always_ff @(posedge clk) begin
        case (state)
            ReadingOpWord: begin
                opcode <= word[4:0];
                dst <= word[7:5];
                state <= ReadingRegWord;
            end
            ReadingRegWord: begin
                hasimm1 <= word[7];
                hasimm2 <= word[6];
                src1 <= word[5:3];
                src2 <= word[2:0];
                if (word[7]) begin
                    state <= ReadingImm1;
                end else if (word[6]) begin
                    state <= ReadingImm2;
                end else begin
                    state <= ExecutingInstr;
                end
            end
            ReadingImm1: begin
                imm1 <= word;
                if (hasimm2) begin
                    state <= ReadingImm2;
                end else begin
                    state <= ExecutingInstr;
                end
            end
            ReadingImm2: begin
                imm2 <= word;
                state <= ExecutingInstr;
            end
            ExecutingInstr: begin
                if (hasimm1)
                    src1val = { 8'b0, imm1 };
                else begin
                    if (src1 == 0)
                        src1val = 0;
                    else
                        src1val = regs[src1];
                end

                if (hasimm2)
                    src2val = { 8'b0, imm2 };
                else begin
                    if (src2 == 0)
                        src2val = 0;
                    else
                        src2val = regs[src2];
                end
                
                case (opcode)
                    5'b11111: $finish;
                    5'b01000: begin
                        gr_flag <= src1val > src2val;
                        eq_flag <= src1val == src2val;
                        gte_flag <= src1val >= src2val;
                    end // cmp
                    5'b01001: begin
                        if (gr_flag)
                            pc <= src1val;
                    end // jgr
                    5'b01010: begin
                        if (~gr_flag)
                            pc <= src1val;
                    end // jlt
                    5'b01011: begin
                        if (gte_flag)
                            pc <= src1val;
                    end // jge
                    5'b01100: begin
                        if (~gte_flag)
                            pc <= src1val;
                    end // jle
                    5'b01101: begin
                        if (eq_flag)
                            pc <= src1val;
                    end // jeq
                    5'b01110: begin
                        if (~eq_flag)
                            pc <= src1val;
                    end // jnq
                    5'b01111: begin
                        pc <= src1val;
                    end // jmp
                    5'b10000: begin // cal
                        ram[regs[7]] <= pc;
                        regs[7] <= regs[7] - 1;
                        pc <= src1val;
                    end
                    5'b10001: begin // ret
                        regs[7] <= regs[7] + 1;
                        pc <= ram[regs[7]];
                    end
                    5'b10010: begin // psh
                        ram[regs[7]] <= src1val;
                        regs[7] <= regs[7] - 1;
                    end
                    5'b10011: begin // pop
                        regs[7] <= regs[7] + 1;
                        regs[src1] <= ram[regs[7]];
                    end
                    5'b10100: begin // lod
                        regs[dst] <= ram[src1val];
                    end
                    5'b10101: begin // str
                        ram[src1val] <= regs[dst];
                    end
                    5'b10110: begin // rsh
                        regs[dst] <= regs[dst] >> 1;
                    end
                    5'b10111: begin // lsh
                        regs[dst] <= regs[dst] << 1;
                    end
                    5'b11000: begin // pst
                        io_addr <= regs[dst];
                        io_data <= regs[src1];
                        write_io <= 1;
                    end
                    5'b11001: begin // pld
                        io_addr <= src1val;
                        write_io <= 0;
                        regs[dst] <= io_data_out;
                    end
                    default: begin
                        if ((opcode & 5'b00111) == opcode) begin
                                case (opcode[2:0])
                                    3'b000: regs[dst] = src1val;
                                    3'b001: regs[dst] = src1val + src2val;
                                    3'b010: regs[dst] = src1val - src2val;
                                    3'b011: regs[dst] = src1val * src2val;
                                    3'b100: regs[dst] = src1val & src2val;
                                    3'b101: regs[dst] = src1val | src2val;
                                    3'b110: regs[dst] = src1val ^ src2val;
                                    3'b111: regs[dst] = ~src1val;
                                endcase
                        
                        end else
                            $finish;
                    end
                endcase
                state <= ReadingOpWord;
            end
        endcase
        if (state != ExecutingInstr) begin
            pc <= pc + 1;
        end
    end
endmodule