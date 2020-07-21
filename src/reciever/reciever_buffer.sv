`include "../build/core_params.svh"
`include "../build/network_params.svh"

module reciever_buffer
    (
        input clk,
        input read,                                 //flips when data should be added to the buffer
        input clear,                                //flips when buffer should be emptied
        input data_stream,                          //data coming from the demodulator
        output wire [PACKET_WIDTH_BITS - 16 - 1:0] sys_packet,  //completed packet
        output wire send, //high when packet is ready to send
        output wire valid                           
    );
    localparam WIDTH = PACKET_WIDTH_BITS + SORTING_WIDTH;

    reg [$clog2(WIDTH):0] index = '0;
    wire [WIDTH - 1:0] buffer_out;
    reg [WIDTH - 16 - 1:0] sys_packet_in = '0;
    reg send_in = 0;

    ring_buffer #(WIDTH, WIDTH) buffer(
        .clk(clk),
        .data_in(data_stream),
        .write(read),
        .data_out(buffer_out)
    );

    unsort #(NETWORK_SLICES) unsorter(
        .clk(clk),
        .data_in(sys_packet_in[PACKET_WIDTH_BITS - 16 - 1:0]),
        .index_in(sys_packet_in[WIDTH - 16 - 1:PACKET_WIDTH_BITS - 16]),
        .reset(send_in),
        .data_out(sys_packet),
        .done(send)
    );

    //the demodulator has guessed our most recent bit, add it to the buffer
    always @ (posedge clk) begin
        if(valid) begin
            sys_packet_in <= buffer_out[WIDTH - 8:8];
            send_in <= 1;
        end
        else begin
            send_in <= 0;
        end
    end
    assign valid = (buffer_out[7:0] == START_CHAR) && (buffer_out[WIDTH - 1:WIDTH - 8] == END_CHAR);
endmodule