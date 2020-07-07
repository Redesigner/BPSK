`include "../../build/core_params.svh"
`include "../../build/network_params.svh"

module reciever_buffer
    (
        input clk,
        input read,                                 //flips when data should be added to the buffer
        input clear,                                //flips when buffer should be emptied
        input data_stream,                          //data coming from the demodulator
        output wire [PACKET_WIDTH_BITS - 1:0] sys_packet,  //completed packet
        output wire send                            //high when packet is ready to send
    );
    localparam WIDTH = PACKET_WIDTH * 8 + SORTING_WIDTH;

    reg [$clog2(WIDTH):0] index = '0;
    reg [WIDTH - 1:0] buffer = '0;
    reg [WIDTH - 1:0] sys_packet_in = '0;
    reg send_in = 0;

    unsort #(NETWORK_SLICES) unsorter(
        .clk(clk),
        .data_in(buffer[PACKET_WIDTH_BITS - 1:0]),
        .index_in(buffer[SORTING_WIDTH - 1:PACKET_WIDTH_BITS]),
        .reset(send_in),
        .data_out(sys_packet),
        .done(send)
    );

    //the demodulator has guessed our most recent bit, add it to the buffer
    always @ (posedge clk) begin
        if (clear == 1) begin
            index <= 0;
            send_in <= 0;
        end
        else if (read == 1) begin
            if (index < ) begin
                buffer[index] <= data_stream;
                index <= index + 1;
                send_in <= 0;
            end else begin
                //the buffer is full, so copy the buffer to a new packet
                //add our last bit though
                buffer[index] <= data_stream;
                sys_packet_in <= buffer;
                send_in <= 1;
                //tell the uart modules to begin sending the full packet
            end
        end
    end
endmodule