module uart_fast_write
    (
        input wire clk,
        input wire ready,
        input wire [7:0] word,
        output wire rxd
    );
    //reg [7:0] buffer = '0;
    reg [3:0] counter = 0;
    reg sleep = 1;
    always @(posedge clk) begin
    //only run 11 cycles per tranmission
        if(ready && sleep) begin
            //buffer <= word;
            sleep <= 0;
        end
        if(counter < 9 && ~sleep) begin
            counter <= counter + 1;
        end
        if(counter >= 9 && ~sleep) begin
            counter <= 0;
            sleep <= 1;
        end
    end
    wire [10:0] data = {<<{1'b1, ^word, word, 1'b0}};
    wire [10:0] reversed = {<<{data}};
    PISO_buffer #(11) PISO
    (
        .clk(clk),
        .active(~sleep),
        .reset(ready),
        .parallel(reversed),
        .serial_signal(rxd)
    );
endmodule