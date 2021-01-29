typedef enum logic[2:0] {BREAK, START, PARITY, STOP} uart_mode;
module uart_fast_read
///HIGH SPEED VARIANT of uart-byte-read, more vulnerable to clock misalignment
    (
        input wire clk, //clk should be 16 times the baud rate
        input wire uart_stream,

        output wire [7:0] word,
        output logic write = 0
    );
    reg [7:0] uart_data = 8'b00000000;
    logic [3:0] edge_counter = 0;
    logic [2:0] bit_counter = 0;
    logic uart_stream_reg = uart_stream;
    uart_mode status = BREAK;

    always @(posedge clk) begin
        uart_stream_reg <= uart_stream;

        case (status)
            BREAK : begin
                if (uart_delta && uart_stream == 1'b0) begin
                    status <= START;
                end
            end

            START : begin
                if (edge_counter < 15) begin
                    edge_counter <= edge_counter + 1;
                end
                else begin
                    uart_data <= {uart_data[7:0], uart_stream};
                    if(bit_counter < 7) begin
                        bit_counter <= bit_counter + 1;
                    end
                    else begin
                        status <= PARITY;
                        bit_counter <= 0;
                    end
                    edge_counter <= 0;
                end
            end

            PARITY : begin
                if(edge_counter < 15) begin
                    edge_counter <= edge_counter + 1;
                end
                else begin
                    edge_counter <= 0;
                    if (uart_stream == ^uart_data) begin
                        status <= STOP;
                        write <= 1;
                    end
                    else begin
                        status <= BREAK;
                    end
                end
            end

            STOP : begin
                if (edge_counter < 15) begin
                    edge_counter <= edge_counter + 1;
                end
                else begin
                    edge_counter <= 0;
                    write <= 0;
                    status <= BREAK;
                end
            end
        endcase
    end
    assign uart_delta = uart_stream_reg != uart_stream;
    assign word = uart_data;
endmodule