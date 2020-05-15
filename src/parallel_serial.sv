module parallel_serial
    (
        input wire clk,
        input wire [WIDTH-1:0] parallel_data,
        input wire next,

        output wire serial_signal,
        output wire done
    );
    parameter WIDTH = 16;
    parameter N = 4;
    reg [N-1:0] counter = 0;

    always @(posedge clk) begin
        if(next == 1) begin
            if (counter < (WIDTH - 1)) begin
                counter <= counter + 1;
            end
            if (counter == (WIDTH - 1)) begin
                counter <= 0;
            end
        end
    end

    //assign active = next && ~done;

    assign serial_signal = counter >= WIDTH - 1 ?
    parallel_data[WIDTH-1] :
    parallel_data[counter];

    assign done = (counter >= (WIDTH - 1));

endmodule