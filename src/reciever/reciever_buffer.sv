`include "../build/core_params.svh"

//localparam WIDTH = PAYLOAD_WIDTH + REFERENCE_WIDTH;
typedef enum logic[1:0] {HEAD, DATA, END} mode;
module reciever_buffer
    (
        input clk,
        input write,                                //flips when data should be added to the buffer
        input clr,                                  //flips when buffer should be emptied
        input data_stream,                          //data coming from the demodulator
        output wire [PAYLOAD_WIDTH - 1 : 0] payload,//completed packet
        output wire send,                           //high when packet is ready to send
        output reg debug = 0
    );

    mode mode = END;

    logic sort = 0;
    logic [PAYLOAD_WIDTH - 1 : 0] data_buf = '0;
    logic [REFERENCE_WIDTH - 1 : 0] index_buf = '0; 
    wire [7:0] byte_buf;
    wire [7:0] byte_buf_r;
    
    wire write_edge;
    reg write_b = 0;

    SP_reg #(8) SP_buffer(
        .clk(clk),
        .cs(write),
        .s(data_stream),
        .clr(byte_full),

        .full(byte_full),
        .p(byte_buf)
    );

    always@(posedge clk) begin
        write_b <= write;
        
        if(write_edge) begin
            if(byte_buf == FRAME_END) begin
                debug <= ~debug;
            end
            if(byte_full) begin
                case (byte_buf)
                    FRAME_HEADSTART : begin
                        mode <= HEAD;
                    end
                    FRAME_START : begin
                        mode <= DATA;
                    end
                    FRAME_END : begin
                        mode <= END;
                        sort <= 1;
                    end
                    default : begin //is not a control bit, start writing
                        if(mode == HEAD) begin
                            index_buf <= {{index_buf[REFERENCE_WIDTH - 9 : 0], byte_buf}};
                        end
                        if(mode == DATA) begin
                            data_buf <= {{data_buf[PAYLOAD_WIDTH - 9 : 0], byte_buf}};
                        end
                        if(mode == END) begin
                            sort <= 0;
                        end
                    end
                endcase
            end
            else begin
                sort <= 0;
            end
        end
    end

    unsort #(SORTING_SLICES) unsorter(
        .clk(clk),
        .data_i(data_buf),
        .index_i(index_buf),
        .w(sort),
        .data_o(payload),
        .send(send)
    );

    assign write_edge = (~write_b) & write;
    assign byte_buf_r = {<<{byte_buf}};
endmodule