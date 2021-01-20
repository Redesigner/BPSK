`include "../build/core_params.svh"

module reciever
    (
        input wire sysclk,
        input signal wave,
        output wire uart_rxd_out,
        output wire clk_out,
        output wire debug
    );
    signal signal;
    logic [PAYLOAD_WIDTH - 1 : 0] sys_payload_a;
    logic [PAYLOAD_WIDTH - 1 : 0] sys_payload_b;

    clock_divider #(16) usb_clk (sysclk, clk_baud);
    
    assign signal = wave;
    assign clk_out = clk_carrier;
    
    signal_demodulator demod
    (
        //IN
        .clk(clk_carrier),
        .init(cb_done),
        .stp(cb_reset),
        .sig(signal),
        //OUT
        .guess(guess),
        .write(write)
    );

    wire signal_MSB = signal[SIGNAL_WIDTH - 1];
    cross_correlation_binary cross_binary
    (
        .clk(clk_carrier),
        .signal(signal_MSB),
        .clr(cb_reset),
        .done(cb_done)
    );
    edge_pulse cb_edge
    (
        .clk(clk_carrier),
        .I(done),
        .O(cb_reset)
    );

    reciever_buffer buffer
    (
        //IN
        .clk(clk_carrier),
        .write(write),
        .clr(cb_done),
        .data_stream(guess),
        //OUT
        .payload(sys_payload_a),
        .send(done),
        .debug(debug)
    );
    sync #(PAYLOAD_WIDTH) sync
    (
        .clk_a(clk_carrier),
        .clk_b(clk_baud),
        .r(done),
        .w(w),

        .I(sys_payload_a),
        .O(sys_payload_b)
    );

    UART_Rx #(PAYLOAD_WIDTH) usb_interface
    (
        .clk(clk_baud),
        .w(w),
        .p({<<{sys_payload_b}}),
        .Rx(uart_rxd_out)
    );

    MMCM reciever_clk
    (
    // Clock out ports
    .clk_carrier(clk_carrier),
    // Clock in ports
    .clk_in_sys(sysclk));
endmodule
