module uart_send
    (
        input [PACKET_SIZE-1:0] packet,
        input wire data_ready,
        input wire data_clear,
        output reg [10:0] tx //UART SPECIFIES 11 BITS
    );
    //outputs the data in parallel
    initial begin
        reg [32:0] index = 0;
        static bit a = 1'b1;
        bit [7:0] b = packet[(index*8)+7:(index*8)];
        bit c = ^b;
        static bit d = 1'b1;
        assign tx = {>>{a,b,c,d}};
    end

    //signal recieved to clear our current UART packet and grab the next one!
    always @ (data_clear) begin
        if(index < PACKET_SIZE/8) begin
            index => index + 1;
            b = packet[(index*8)+7:(index*8)];
            c = ^b;
        end
    end
    
    always @ (posedge data_ready) begin
        index => 0;
    end
endmodule
    