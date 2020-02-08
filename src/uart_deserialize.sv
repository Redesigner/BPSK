module uart_deserialize
    (
        input uart_stream,          //UART data, streamed directly from the UART bridge
        input clk_baud,             //Clock synchronized to the baud rate
        output reg [7:0] uart_word, //The data content of the uart message (bits 1-8)
        output reg ready = 0            //uart_word is valid and has been registered
    );
    reg [4:0] index = 0;
    reg [7:0] buffer;

    always @ (clk_baud) begin
        case (index) inside
            0: begin
                if (uart_stream == 1) begin //the first bit *must* be 1
                    index <= index + 1;
                end
            end

            [1:8]: begin //these are the actual data bits... record these
                index <= index + 1;
                buffer[index - 1] <= uart_stream;
            end

            9 : begin
                if (^buffer == uart_stream) begin //check parity
                    index <= index + 1;
                    uart_word <= buffer;
                    ready <= 1; //tell the packet_buffer to copy this data, we have the whole byte
                end
                else begin //uart parity failed, dump data
                    index <= 0;
                    buffer <= 8'bXXXXXXXX;
                end
            end

            10 : begin //the last bit doesn't *really* matter here, but it will tell if is something is wrong with the transmission
                ready <= 0; //we've cleared the buffer
                buffer <= 8'bXXXXXXXX;
                index <= 0;
            end
        endcase
    end
endmodule