`include "../built-src/parameters.svh"

module unsort #(parameter SIZE = 4)
    (
        input wire clk,
        input wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_in,
        input wire [SIZE-1:0][INDEX_WIDTH-1:0] index_in,
        input wire reset,
        output wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_out,
        output reg done = 0
    );
    int i = 0;
    reg [SIZE-1:0][NETWORK_WIDTH-1:0] buffer = '0;
    reg started = 0;

    edge_pulse reset_edge(
        .clk(clk),
        .I(reset),
        .O(reset_o)
    );

    always @(posedge clk) begin
        if(reset_o) begin
            i <= 0;
            started <= 1;
        end
        else if(i < SIZE && started) begin
            buffer[index_in[i]] <= data_in[i];
            i <= i + 1;
        end
        else begin
            done <= 1;
        end
    end

    assign data_out = buffer;
    
endmodule