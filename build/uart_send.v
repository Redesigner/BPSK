module uart_send
    (
        input [PACKET_SIZE-1:0] packet,
        input wire data_ready,
        input wire data_clear,
        output reg buffer_clear,
        output reg [10:0] tx //UART SPECIFIES 11 BITS
    );
    //outputs the data in parallel
    reg [32:0] index = 0;
    reg buffer_clear = 0;
    bit a,c,d;
    bit [7:0] b;

    //signal recieved to clear our current UART packet and grab the next one!
    always @ (data_clear) begin
       // index <= 0;
    end
    
    always @ (posedge data_ready) begin
        index <= index + 1;
        a = 1'b1;
        b = packet[index*8];
        c = ^b;
        d = 1'b1;
        tx = {>>{a,b,c,d}};
    end
endmodule
    