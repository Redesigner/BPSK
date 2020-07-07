module clock_divider #(N = 10)
    (    
        input wire I,
        output reg O = 0
    );
    parameter WIDTH = $clog2(N);
    reg [WIDTH-1:0] index = '0;

    always @(posedge I) begin
        if (index >= ((N / 2) - 1)) begin
            O <= ~O;
            index <= 0;
        end
        else begin
            index <= index + 1;
        end
    end
endmodule