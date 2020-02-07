module phase_clock
    (
        input wire clock,
        input wire data,
        input wire send_enable,
        output reg [DATA_WIDTH-1:0] phase,
        output reg next
    );
    integer internal_phase = 0;
    
    /*initial begin
        next <= ~next;
    end*/
       
    always @ (posedge clock) begin
    //replace modulos eventually, fine for testing
        if (send_enable == 1) begin
            if (internal_phase + 2 > WAVELENGTH) begin
                internal_phase <= 0;
                //we've finished transmitting the current bit, request the next one
                next <= ~next;
            end else begin
                internal_phase <= (internal_phase + 1);
            end
            phase <= ((internal_phase + (SHIFT * data)) % WAVELENGTH);
        end
    end
endmodule