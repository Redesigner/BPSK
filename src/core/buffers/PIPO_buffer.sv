module PIPO_buffer#(SIZE = 16, WIDTH = 4)
    (
        input wire clk,
        input wire [SIZE - 1: 0] data_in,
        input wire write,
        input wire read,

        output wire [WIDTH - 1:0] data_out
    );

    reg[SIZE - 1:0] buffer = '0;

    edge_pulse reset_p(
        .clk(clk),
        .I(write),
        .O(write_o)
    );

    always @(posedge clk) begin
        if(write_o) begin
            buffer <= data_in;
        end
        else if(read) begin
            buffer <= (buffer >> WIDTH) | (buffer << SIZE - WIDTH);
        end
    end

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            assign data_out[i] = buffer[i];
        end
    endgenerate
endmodule