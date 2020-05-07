`include "../built-src/parameters.svh"

module unsort #(parameter SIZE = 4)
    (
        input wire clk,
        input wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_in,
        input wire [SIZE-1:0][INDEX_WIDTH-1:0] index_in,
        output wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_out
    );
    int i = 0;
    reg [SIZE-1:0][NETWORK_WIDTH-1:0] buffer;

    always @(posedge clk) begin
        if(i < SIZE) begin
            buffer[index_in[i]] <= data_in[i];
            i <= i + 1;
        end
    end

    assign data_out = buffer;
    
endmodule