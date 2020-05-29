`include "../built-src/parameters.svh"
`timescale 1ns/10ps
module transmitter
    (
        input wire sysclk,
        (* IO_BUFFER_TYPE = "IBUF" *) input wire uart_txd_in,

        output wire [DATA_WIDTH:1] pio,
        output wire led1
      
        //output uart_rxd_out
    );
    //WIRE DECLARATIONS
    wire UART;
    wire [7:0] uart_word;
    wire [PACKET_WIDTH * 8 - 1:0] sys_packet;
    wire [(PACKET_WIDTH * (8 + INDEX_WIDTH)) + PREAMBLE_LENGTH - 1:0] sorted_packet;
    wire [DATA_WIDTH - 1:0] ANALOGWAVE;



    //BUFFERS
    //IBUF instantiation
    IBUF UART_IBUF (.I(uart_txd_in), .O(UART));

    //OBUF instantiation
    wire [DATA_WIDTH-1:0] ANALOGWAVE_PO;
    genvar i;
    generate
        for (i = 0; i < DATA_WIDTH; i++ ) begin
            OBUF ANALOGWAVE_OBUF (.I(ANALOGWAVE[i]), .O(ANALOGWAVE_PO[i]));
            defparam ANALOGWAVE_OBUF.SLEW = "FAST";
            assign pio[i + 1] = ANALOGWAVE_PO[i];      
        end
    endgenerate
    OBUF LED_OBUF (.I(data_sorted), .O(led1));    

//~~~~~~~~~~~~~~~~MODULES~~~~~~~~~~~~~~~~~~~
    //(* keep_hierarchy = "yes" *)
    uart_fast_read uart_rx
    (
        .clk(clk_baud),
        .uart_stream(UART),
        .word(uart_word), .write(uart_write)
    );

    //(* keep_hierarchy = "yes" *)
    byte_packet_buffer buffer
    (   
        //IN
        .clk(clk_out_base),
        .word(uart_word), .write(uart_write),
        //OUT
        .sys_packet(sys_packet), .send(data_send)
    );
	
    //(* keep_hierarchy = "yes" *)
    sorter packet_sorter
    (
        //IN
        .clk(clk_out_base),
        .ready(data_send),
        .sys_packet(sys_packet),
        //OUT
        .sorted_packet_out(sorted_packet),
        .done(data_sorted)
    );
    
    /*
    (* keep_hierarchy = "yes" *)
    sorter_async packet_sorter_async
    (
        //IN
        .sys_packet(sys_packet),
        //OUT
        .sorted_packet_out(sorted_packet)
    );*/

    //(* keep_hierarchy = "yes" *)
    PISO_buffer # (PACKET_WIDTH * (8 + INDEX_WIDTH) + PREAMBLE_LENGTH) modulator_stream 
    (
        //IN
        .clk(clk_out_base),
        .active(ser_next), .reset(data_sorted),
        .parallel(sorted_packet),
        //OUT
        .serial_signal(signal)
    );

	signal_modulator modulator
    (
        //IN
       .clk(clk_out_base),
       .data_stream(signal), .enable(data_sorted),
        //OUT
        .signal_out(ANALOGWAVE), .next(ser_next)
    );

//~~~~~~~~~~~~~~~~~CLOCKS~~~~~~~~~~~~~~~~~~~~~~
  clk_base clk_MCMM
   (
    // Clock out ports
    .clk_out_base(clk_out_base),     // output clk_out_base
   // Clock in ports
    .clk_in1(sysclk));
    
    
    //OUR UART CHIP ONLY SUPPORTS 12MBPS in standard mode, so the system clock works here
    assign clk_baud = sysclk;
    
    
    
//~~~~~~~~~~~~~~~~DEBUG~~~~~~~~~~~~~~~~~~~~
    /*
    uart_encode debug_out_encoder
    (
        clk_baud, sys_packet, modulator_ready,
        uart_stream2, done2
    );*/
    
    //SIMULATION INPUT DATA
    /*
    reg [176:0] test_data = 177'b100010000101000100001010001000010100110111101001101100010011011000100110010101101101000010001000010100010000101000100001010011011110100110110001001101100010011001010110110100001;
    parallel_serial #(177) debug_serial
    (
        //IN
        clk_baud, test_data, 1'b1 ^ done2,
        //OUT
        UART, done2
    );
    */
endmodule