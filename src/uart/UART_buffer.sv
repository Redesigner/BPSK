module UART_buffer#(OUTPUT_SIZE = 16, INPUT_SIZE = 4)
    (
        input wire clk,
        input wire [INPUT_SIZE - 1: 0] data_in,
        input wire write,

        output reg [OUTPUT_SIZE - 1:0] data_out = '0,
        output reg output_ready = 1'b0
    );
    reg [$clog2(OUTPUT_SIZE) : 0] output_counter = 0;
    reg[OUTPUT_SIZE - 1:0] buffer = '0;

    always @(posedge clk) begin
        if(write) begin
            buffer <= (data_in | buffer << INPUT_SIZE);
            if(output_counter < (OUTPUT_SIZE / INPUT_SIZE) - 1) begin
                output_ready <= 1'b0;
                output_counter <= output_counter + 1;
            end
            else begin
                output_ready <= 1'b1;
                data_out <= (data_in | buffer << INPUT_SIZE);
                output_counter <= 0;
            end
        end
    end

    
endmodule