module PIPO_buffer#(SIZE = 16, WIDTH = 4)
/**
* Parallel In; Parallel Out buffer
* synchronized with clk
*
* Barrel shifts by WIDTH if read is high
*
* SIZE = width of data_in
* WIDTH = width of data_out
* Until the buffer is full, data_out will be 0
**/
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