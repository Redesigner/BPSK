`include "../built-src/parameters.svh"

module transmitter
    (
        input wire clk,
        input wire uart_txd_in,

        output pio1,
        output pio2,
        output pio3,
        output pio4,
        output pio5,
        output pio6,
        output pio7,
        output pio8,
        output pio9,
        output pio10,
        output pio11,
        output pio12,

        output pio40,

        output led0,

        output led1,
        
        output uart_rxd_out
    );
    //ALLOCATIONS
    reg [DATA_WIDTH-1:0] signal_analog;
    reg [7:0] uart_word;
    reg [PACKET_WIDTH-1:0][7:0] sys_packet;
    reg [(PACKET_WIDTH * 8)-1:0] sorted_packet;

    clock_divider # (5, 12) clock2(clk, clk_baud);
    //Base clock is 12MHz, we want to be at about 19200 Baud for now
    clock_divider # (10, WAVELENGTH) clock3(clk, clk_wave);

    uart_byte_read uart_rx
    (
        //IN
        clk_baud, uart_txd_in,
        //OUT
        uart_word, uart_write
    );

    byte_packet_buffer buffer
    (   
        //IN
        clk_baud, uart_word, uart_write, done,
        //OUT
        sys_packet, data_send
    );
	
    sorter packet_sorter
    (
        //IN
        clk_1, sys_packet, data_send,
        //OUT
        sorted_packet, modulator_ready
    );

    parallel_serial # (PACKET_WIDTH * 8, 32) serial1_out 
    (
        //IN
        clk_wave, sorted_packet, ser_next || modulator_ready, data_send,
        //OUT
        signal, active, done
    );

	signal_modulator modulator
    (
        //IN
        clk_1, signal, active,
        //OUT
        signal_analog, ser_next
    );


    //DEBUG
    uart_encode debug_out_encoder
    (
        clk_baud, sys_packet, modulator_ready,
        uart_stream2, done2
    );

    //SIMULATION INPUT DATA
    /*reg [175:0] test_data = 176'b10001000010100010000101000100001010011011110100110110001001101100010011001010110110100001000100001010001000010100010000101001101111010011011000100110110001001100101011011010000;
    parallel_serial #((176), 32) debug_serial
    (
        //IN
        clk_baud, test_data, 1 ^ done2, 0,
        //OUT
        uart_txd_in, active2, done2
    );*/

    //PIN ASSIGNMENTS
        //DAC
    assign  pio1 =  signal_analog[0];
    assign  pio2 =  signal_analog[1];
    assign  pio3 =  signal_analog[2];
    assign  pio4 =  signal_analog[3];
    assign  pio5 =  signal_analog[4];
    assign  pio6 =  signal_analog[5];
    assign  pio7 =  signal_analog[6];
    assign  pio8 =  signal_analog[7];
    assign  pio9 =  signal_analog[8];
    assign  pio10 = signal_analog[9];
    assign  pio11 = signal_analog[10];
    assign  pio12 = signal_analog[11];

    assign  led0 =  data_send;
    assign  led1 =  data_send;
    assign  pio39 = uart_txd_in;
    assign  pio40 = uart_stream2;
    assign  uart_rxd_out = uart_stream2;


//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
    
    clk_base instance_name
    (
        // Clock out ports
        .clk_1(clk_1),     // output clk_1
        // Status and control signals
        // Clock in ports
        .clk(clk)
    );      // input clk

endmodule