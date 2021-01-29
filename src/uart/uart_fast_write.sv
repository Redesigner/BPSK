`include "../build/core_params.svh"

module uart_fast_write
    (
        input wire cs,      //positive edge triggers rw action
        input wire rw,      //latches data when high, if no data to transmit
        input byte word,    //individual byte to be sent

        output wire empty,  //high when no data to send
        output wire rxd     //UART protocol message, connect to USB Rx
    );


    uart frame;
    logic rw_dly;
    logic empty_dly;

    always @(posedge cs) begin
        rw_dly <= rw;
        empty_dly <= empty;
    end

    PS_reg #(11) encoder
    (
        .cs(cs),
        .rw(rw_dly & empty),
        .p({1'b0, word, ^word, 1'b1}),

        .empty(empty),
        .s(s)
    );
    assign rxd = empty & empty_dly ? 1 : s;
endmodule
