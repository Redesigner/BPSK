`include "../build/core_params.svh"

module uart_test
(
    input wire uart_txd_in,
    input wire sysclk,
    output wire uart_rxd_out,
    output wire debug,
    output wire led0
);
    wire [7:0] word;

    clock_divider #(16) clk_div
    (
        sysclk,
        baudclk_o
    );

    uart_fast_read UART_Tx
    (
        .clk(sysclk),
        .uart_stream(uart_txd_in),
        .word(word),
        .write(w)
    );

    uart_fast_write UART_Rx
    (
        .cs(baudclk_o),
        .rw(w),
        .word(word),
        .rxd(uart_rxd_out)
    );
    assign led0 = w;
    assign debug = uart_rxd_out;
endmodule