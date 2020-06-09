`include "../built-src/parameters.svh"
`timescale 1ns/10ps
module transmitter
    (
        input wire sysclk,
        (* IO_BUFFER_TYPE = "IBUF" *) input wire uart_txd_in,

        output wire [DATA_WIDTH:1] pio,
        output wire led0,
        output wire led1,
      
        output wire uart_rxd_out
    );
    //WIRE DECLARATIONS
    wire UART;
    wire [7:0] uart_word, uart_word_slow;
    wire [PACKET_WIDTH * 8 - 1:0] sys_packet;
    wire [(PACKET_WIDTH * (8 + INDEX_WIDTH)) + PREAMBLE_LENGTH - 1:0] sorted_packet;
    wire [DATA_WIDTH - 1:0] ANALOGWAVE;



    //BUFFERS
    //IBUF instantiation
    IBUF UART_IBUF (.I(uart_txd_in), .O(UART));

    /*genvar i;
    generate
        for (i = 0; i < DATA_WIDTH; i++ ) begin
            assign pio[i + 1] = ANALOGWAVE[i];      
        end
    endgenerate
    */
    
    assign pio[DATA_WIDTH:1] = ANALOGWAVE;
    (*IOB="TRUE"*)reg led_data = 0;
    (*IOB="TRUE"*)reg led_data_2 = 0;

//~~~~~~~~~~~~~~~~MODULES~~~~~~~~~~~~~~~~~~~
    uart_fast_read uart_rx
    (
        .clk(clk_baud),
        .uart_stream(UART),
        .word(uart_word_slow), .write(uart_write_slow)
    );

    CDC_sync#(8) buffer_sync
    (
        .slow_clk(clk_baud),
        .fast_clk(clk_out_base),
        .I(uart_word_slow),
        .O(uart_word)
    );

    CDC_sync#(1) write_sync
    (
        .slow_clk(clk_baud),
        .fast_clk(clk_out_base),
        .I(uart_write_slow),
        .O(uart_write)
    );

    (* keep_hierarchy = "yes" *)
    byte_packet_buffer buffer
    (   
        //IN
        .clk(clk_out_base),
        .reset(reset),
        .word(uart_word), .write(uart_write),
        //OUT
        .sys_packet(sys_packet), .send(data_send)
    );

    (* keep_hierarchy = "yes" *)
    sorter packet_sorter
    (
        //IN
        .clk(clk_out_base),
        .reset(reset),
        .ready(data_send),
        .sys_packet(sys_packet),
        //OUT
        .sorted_packet_out(sorted_packet),
        .done(data_sorted)
    );

    (* keep_hierarchy = "yes" *)
    PISO_buffer # (PACKET_WIDTH * (8 + INDEX_WIDTH) + PREAMBLE_LENGTH) modulator_stream 
    (
        //IN
        .clk(clk_out_base),
        .active(ser_next), .reset(data_sorted),
        .parallel(sorted_packet),
        //OUT
        .serial_signal(signal)
    );

    (* keep_hierarchy = "yes" *)
	signal_modulator modulator
    (
        //IN
       .clk(clk_out_base),
       .data_stream(signal), .enable(data_sorted),
        //OUT
        .signal_out(ANALOGWAVE), .next(ser_next), .done(reset)
    );
always @(posedge clk_out_base) begin
    if(reset) begin
        led_data <= 1;
    end
    if(uart_write) begin
        led_data_2 <= 1;
    end
end


//~~~~~~~~~~~~~~~~~CLOCKS~~~~~~~~~~~~~~~~~~~~~~
  clk_base clk_MCMM
   (
    // Clock out ports
    .clk_out_base(clk_out_base),     // output clk_out_base
    .clk_baud(clk_baud_in),     // output clk_baud
   // Clock in ports
    .clk_in1(sysclk)
   );      // input clk_in1
    //OUR UART CHIP ONLY SUPPORTS 12MBPS in standard mode, so the system clock works here
    clock_divider#(27) clk_divider(clk_baud_in, clk_baud);
    
    
//~~~~~~~~~~~~~~~~DEBUG~~~~~~~~~~~~~~~~~~~~
    uart_fast_write uart_tx
    (
        .clk(clk_baud),
        .ready(data_sorted),
        .word(sys_packet[15:8]),
        .rxd(uart_rxd_out)
    );
    
    //SIMULATION INPUT DATA
    /*
    reg [176:0] test_data = 177'b100010000101000100001010011011110100010000101001101100010011011000100110010101101101000010001000010100010000101000100001010011011110100110110001001101100010011001010110110100001;
    parallel_serial #(177) debug_serial
    (
        //IN
        clk_baud, test_data, 1'b1 ^ done2,
        //OUT
        UART, done2
    );
    */
endmodule