module uart_fast_read
///HIGH SPEED VARIANT of uart-byte-read, more vulnerable to clock misalignment
    (
        input wire clk,
        input wire uart_stream,

        output wire [7:0] word,
        output wire write
    );
    reg [11:0] base = 12'b10000000001;
    reg data_started = 0;
    reg counter_start = 0;
    reg [3:0] counter = 11;
    wire [11:0] uart_data;
    ring_buffer #(12, 12) buffer (
    .clk(clk),
    .data_in(uart_stream), .write(1'b1),
    .data_out(uart_data));

    always @(posedge clk) begin

        //sleep for 11 cycles once we recieve a valid word
        if(write) begin
            counter <= 0;
        end
        else if(counter < 11) begin
            counter <= counter + 1;
        end
    end

    assign valid = ((^uart_data[9:2] == uart_data[10]) && (uart_data[0] == 1) && (uart_data[11] == 1) && (uart_data[1] == 0));
    assign write = valid && counter >= 10;
    assign word = uart_data[9:2];
endmodule