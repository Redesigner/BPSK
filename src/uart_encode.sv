module uart_encode
    (
        input [PACKET_SIZE-1:0] sys_packet,
        input ready,
        input next,
        output reg done = 0,                //Finished encoding the packet, request a new one
        output reg [10:0] uart_packet       //UART packet, in 11 bit LSB
    );
    //outputs the data in parallel
    reg [32:0] byte_index = 0;
    reg open, parity, close;
    reg [7:0] uart_word;

    //signal recieved to clear our current UART packet and grab the next one!
    always @ (next) begin
        if (ready == 1) begin
            if ((byte_index * 8) >= PACKET_SIZE) begin
                uart_word = 8'b00000000; //zero all bits
                uart_word = sys_packet[(PACKET_SIZE - (byte_index * 8)) +:8]; //copy what we have left
                done = 1;
                byte_index = 0;
            end
            else begin
                byte_index = byte_index + 1;

                open = 1'b1;
                uart_word = sys_packet[(PACKET_SIZE - (byte_index * 8)) +:8];
                parity = ^uart_word;
                close = 1'b1;
                done = 0;
                uart_packet = {>>{close, parity, uart_word, open}}; //LSB first
            end
        end
    end
endmodule
    