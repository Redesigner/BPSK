module uart_recieve
    (
        input wire data_in,
        input wire baud_clock,
        output reg [8:0] uart_packet,
        output reg data_ready = 0
    );
    reg [4:0] index = 0;
    reg [7:0] buffer;

    always @ (baud_clock) begin
        case (index) inside
            //default : index <= 0;
            0: begin
                if (data_in == 1) begin //the first bit *must* be 1
                    index <= index + 1;
                end
            end

            [1:8]: begin //these are the actual data bits... record these
                index <= index + 1;
                buffer[index - 1] <= data_in;
            end

            9 : begin
                if (^buffer == data_in) begin //check parity
                    index <= index + 1;
                    uart_packet <= buffer;
                    data_ready <= 1; //tell the packet_buffer to copy this data, we have the whole byte
                end else begin //uart parity failed, dump data
                    index <= 0;
                    buffer <= 8'bXXXXXXXX;
                end
            end

            10 : begin //the last bit doesn't *really* matter here, but it will tell if is something is wrong with the transmission
                data_ready <= 0; //we've cleared the buffer
                buffer <= 8'bXXXXXXXX;
                index <= 0;
            end
        endcase
    end
endmodule