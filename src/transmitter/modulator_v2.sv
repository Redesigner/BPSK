`include "core_params.svh"
`include "sine_table.svh"

module modulator_v2 #(BITS = 32)
    (
        input wire clk,
        input wire reset,
        input wire [BITS - 1 : 0] data,

        output signal signal,
        output wire sleep
    );
    reg active = 1'b0;
    reg [$clog2(WAVELENGTH) : 0] counter = 0;
    reg [$clog2(BITS) : 0] bit_counter = 0;
    reg data_reg = 0;
    reg reset_old = 1'b0;

    (* keep_hierarchy = "yes" *)
    PISO_buffer #(BITS) data_stream
    (
        .clk(clk),
        .active(counter == (WAVELENGTH - 2)),
        .reset(reset_local),
        .parallel(data),
        .serial_signal(data_serial)
    );

    wire [SIGNAL_WIDTH - 1 : 0] sine;
    (* keep_hierarchy = "yes" *)
    PIPO_buffer #(SINE_RESOLUTION * SIGNAL_WIDTH, SIGNAL_WIDTH) sine_table
    (
        .clk(clk),
        .read(active),
        .write(reset_local),
        .data_in({>>{SINE_TABLE}}),
        .data_out(sine)
    );

    wire [SIGNAL_WIDTH - 1 : 0] sine_shift;
    (* keep_hierarchy = "yes" *)
    PIPO_buffer #(SINE_RESOLUTION * SIGNAL_WIDTH, SIGNAL_WIDTH) shift_sine_table
    (
        .clk(clk),
        .read(active),
        .write(reset_local),
        .data_in({>>{SHIFTED_SINE_TABLE}}),
        .data_out(sine_shift)
    );

    always @(posedge clk) begin
        reset_old <= reset;
        if(reset_local) begin
            counter <= 0;
            data_reg <= data;
            active <= 1'b1;
        end
        else if(active) begin
            if(counter < WAVELENGTH - 1) begin
                counter <= counter + 1;
            end
            else begin
                counter <= 0;
            end

            if(counter == (WAVELENGTH - 2)) begin
                if(bit_counter < BITS) begin
                    bit_counter <= bit_counter + 1;
                end
                else begin
                    bit_counter <= 0;
                    active <= 1'b0;
                end
            end
        end
    end

    assign signal = active ? 
        (data_serial ? sine : sine_shift) :
        1'b0;
    assign reset_local = reset && ~reset_old;
    
    assign sleep = data_serial;

endmodule