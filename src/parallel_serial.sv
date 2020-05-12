module parallel_serial
    (
        input wire clk,
        input wire [WIDTH-1:0] parallel_data,
        input wire start,
        input wire clear,

        output wire serial_signal,
        output wire active,
        output wire done
    );
    parameter WIDTH = 16;
    parameter N = 4;
    reg [N-1:0] counter = 0;

    always @(posedge clk) begin
        if(clear == 1) begin
            counter <= 0;
        end
        else if(start == 1) begin
            if (counter < (WIDTH - 1)) begin
                counter <= counter + 1;
            end
        end
    end

    assign active = start && ~done;
    assign serial_signal = counter >= WIDTH - 1 ?
    parallel_data[WIDTH-1] :
    start && parallel_data[counter];
    assign done = (counter >= (WIDTH - 1));

endmodule