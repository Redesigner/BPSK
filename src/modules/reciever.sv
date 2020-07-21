`include "../build/core_params.svh"

module reciever
    (
        input wire sysclk,
        input wire [DATA_WIDTH:1] pio,
        output wire uart_rxd_out,
        output wire led0,
        output wire led1,
        output wire pio2
    );

    wire [PACKET_WIDTH * 8 - 1: 0] sys_packet;
    wire [PACKET_WIDTH * 8 - 1: 0] sys_packet_o;
    wire [7:0] uart_word;
    wire [DATA_WIDTH - 1:0] wave;
    wire valid_out;
    assign wave = pio[DATA_WIDTH:1];
    clock_divider #(12) clock2(sysclk, clk_baud);
    reg led0_reg = 1'b0;
    reg led1_reg = 1'b0;
    reg pio_reg = 1'b0;
    signal_demodulator demod
    (
        //IN
        .clk(clk_carrier),
        .reset(done_out_cross),
        .signal(wave),
        //OUT
        .guess(data_guess),
        .write(write)
    );

    cross_correlation_binary cross_binary
    (
        .clk(clk_carrier),
        .signal(wave >> (DATA_WIDTH - 1)),
        .done(done_out_cross)
    );

    reciever_buffer buffer
    (
        //IN
        .clk(clk_carrier),
        .read(write),
        .clear('b0),
        .data_stream(data_guess),
        //OUT
        .sys_packet(sys_packet),
        .send(done),
        .valid(valid_out)
    );

    CDC_sync #(PACKET_WIDTH * 8) sync
    (
        //IN
        .slow_clk(clk_carrier),
        .fast_clk(clk_baud),
        .I(sys_packet),
        //OUT
        .O(sys_packet_o)
    );

    PIPO_buffer #(PACKET_WIDTH * 8, 8) PIPO
    (
        //IN
        .clk(clk_baud),
        .data_in(sys_packet),
        .write(done),
        .read(read),
        //OUT
        .data_out(uart_word)
    );

    uart_fast_write uart_out
    (
        //IN
        .clk(clk_baud),
        .ready(done),
        .word(uart_word),
        //OUT
        .next(read),
        .rxd(uart_rxd_out)
    );
    always @(posedge clk_carrier) begin
        if(write) begin
            pio_reg <= data_guess;
        end
        if(done_out_cross) begin
            led0_reg <= 1'b1;
        end
        if(valid_out) begin
            led1_reg <= 1'b1;
        end
    end
    
    assign led0 = led0_reg;
    assign led1 = led1_reg;
    assign pio2 = pio_reg;
    MMCM reciever_MMCM
    (
    // Clock out ports
    .clk_carrier(clk_carrier),     // output clk_carrier
    // Clock in ports
    .clk_in_sys(sysclk));
endmodule
