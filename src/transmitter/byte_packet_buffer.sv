`include "../build/core_params.svh"

localparam PACKET_WIDTH_RAW = PACKET_WIDTH - 2;

module byte_packet_buffer
    (
        input wire clk,
        input wire reset,
        input wire [7:0] word,                           //the data frame from the uart_signal
        input wire write,                                //copies word when set high

        output wire [PACKET_WIDTH_RAW - 1:0][7:0] sys_packet,//PACKET_WIDTH in bits
        output wire send                                 //the sys_packet is ready to be sent
    );
    //We need two bytes reserved for the start and end signal

    reg [$clog2(PACKET_WIDTH_RAW):0] index = '0;
    reg [PACKET_WIDTH_RAW-1:0][7:0] buffer = '0;
    reg [PACKET_WIDTH_RAW-1:0][7:0] buffer_stable_0 = '0;
    reg send_r = '0;


    always @ (posedge clk) begin
        if(reset) begin
        end
        else begin
            if (index >= PACKET_WIDTH_RAW) begin
                index <= 0;
                send_r <= 1;
                buffer_stable_0 <= buffer;
            end
            else if (index <= PACKET_WIDTH_RAW - 1) begin
                if (write) begin
                    buffer[index] <= word;
                    index <= index + 1;
                    send_r <= 0;
                end
            end
        end
    end

    assign sys_packet = buffer_stable_0;

    edge_pulse buffer_edge(.clk(clk), .I(send_r), .O(send));
endmodule