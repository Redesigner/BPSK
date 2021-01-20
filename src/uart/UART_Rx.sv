module UART_Rx #(WIDTH)
    (
        input wire clk,
        input wire w,
        input wire [WIDTH - 1 : 0] p,
        output wire Rx
    );
    byte word;
    PP_reg #(WIDTH, 8) p_to_byte
    (
        //IN
        .clk(clk),
        .cs(w | u_empty_e),
        .rw(w),
        .p_i(p),
        //OUT
        .flow(p_empty),
        .p_o(word)
    );

    uart_fast_write uart_out
    (
        //IN
        .cs(clk),
        .rw(~p_empty),
        .word(word),
        //OUT
        .empty(u_empty),
        .rxd(rxd)
    );

    //we only care if the uart has recently become empty
    edge_pulse empty_e
    (
        .clk(clk),
        .I(u_empty),
        .O(u_empty_e)
    );
    assign Rx = (u_empty) ? 1'b1 : rxd;
endmodule