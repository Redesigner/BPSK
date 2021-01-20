`include "../build/core_params.svh"

module unsort #(parameter SIZE = 4)
    (
        input wire clk,
        input wire [SIZE - 1 : 0][SLICE_WIDTH - 1 : 0] data_i,
        input wire [SIZE - 1 : 0][INDEX_WIDTH - 1 : 0] index_i,
        input wire w,

        output reg [SIZE - 1 : 0][SLICE_WIDTH - 1 : 0] data_o ='0,
        output wire send
    );
    logic [$clog2(SIZE) : 0] i = 0;
    reg [SIZE - 1 : 0][SLICE_WIDTH - 1 : 0] data_buf = '0;
    reg [SIZE - 1 : 0][INDEX_WIDTH - 1 : 0] index_buf = '0;

    logic active = 0;

    always @(posedge clk) begin
        if (w) begin
            data_buf <= data_i;
            index_buf <= index_i;
            active <= 1;
            i <= 0;

        end

        if (active) begin
            if(i < SIZE) begin
                data_o[index_buf[i]] <= data_i[i];
                i <= i + 1;
            end
            else if(i >= SIZE) begin
                active <= 0;
            end
        end
    end
    
    assign send = active & (i == SIZE);

endmodule