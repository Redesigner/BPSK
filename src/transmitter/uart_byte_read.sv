module uart_byte_read
    (
        //DATA is valid for about 1 cycle
        input wire clk_baud,
        input wire uart_stream,
        
        output reg [7:0] word = 0,
        output reg write = 0 //Driven high when full UART message is recieved
    );
    reg [4:0] counter = 0;
    reg [7:0] buffer = 8'b00000000;

    always @(posedge clk_baud) begin
            case (counter) inside
            0: begin
                write <= 0; //make sure we aren't sending old data
                buffer <= 8'b00000000; //Buffer_clear
                if (uart_stream == 0) begin //START BIT
                    counter <= counter + 1;
                end
            end

            [1:8]: begin //WORD
                counter <= counter + 1;
                buffer[counter - 1] <= uart_stream;
            end

            9 : begin
                if (^buffer == uart_stream) begin //EVEN PARITY
                    counter <= counter + 1;
                    word <= buffer;
                end
                else begin //uart parity failed, dump data
                    counter <= 0;
                    buffer <= 8'b00000000;
                end
            end

            10 : begin //STOP BIT
                if (uart_stream == 1) begin
                    write <= 1; //data is valid
                end
                else begin
                    buffer <= 8'b00000000;
                end
                counter <= 0;
            end
        endcase
    end
endmodule