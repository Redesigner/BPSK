module clock_divider #(N = 10)
/**
* Uses a register to divide a clock's frequency by N
**/
    (    
        input wire I,
        output wire O
    );
    localparam WIDTH = $clog2(N);
    reg [WIDTH-1:0] index = '0;
    reg O_reg = 0;

    always @(posedge I) begin
        if (index >= ((N / 2) - 1)) begin
            O_reg <= ~O_reg;
            index <= 0;
        end
        else begin
            index <= index + 1;
        end
    end
    BUFG buffer
    (
        .I(O_reg),
        .O(O)
    );
endmodule