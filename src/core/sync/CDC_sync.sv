module CDC_sync #(WIDTH = 16)
/**
* Simple triple-buffered clock domain crossing module
**/
    (
        input wire slow_clk,
        input wire fast_clk,
        input wire [WIDTH - 1:0] I,
        output wire [WIDTH - 1:0] O
    );

    reg [WIDTH - 1:0] meta_stable = '0;
    reg [WIDTH - 1:0] stable_0 = '0;
    reg [WIDTH - 1:0] stable_1 = '0;

    always @(posedge slow_clk) begin
        meta_stable <= I;
    end

    always @(posedge fast_clk) begin
        stable_0 <= meta_stable;
        stable_1 <= stable_0;
    end
    assign O = stable_1;

endmodule