module edge_pulse
///Emits a single pulse on a rising edge of a NON-CLOCK pin
    (
        input wire clk,
        input wire I,
        output wire O
    );
    reg old = '0;
    always @(posedge clk) begin
        old <= I;
    end
    assign O = ~old && I;
endmodule