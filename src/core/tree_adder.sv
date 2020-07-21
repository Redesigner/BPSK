///*DO NOT* MODIFY THIS CODE UNLESS YOU KNOW WHAT YOU'RE DOING!!!!
///RECURSIVE MODULES ARE SUSCEPTIBLE TO MEMORY LEAKS

//WIDTH should be the input width
module tree_adder #(N = 8, WIDTH_IN = 1)
    (
        input wire clk,
        input wire [N - 1 : 0][WIDTH_IN - 1:0] data_in,
        output wire [(WIDTH_IN + $clog2(N + 1) - 1) - 1:0] sum
    );
    /*localparam branch_width = (ROOT == 0) ? WIDTH + $clog2(N) :
        WIDTH - 1;*/
    localparam WIDTH_OUT = WIDTH_IN + $clog2(N + 1) - 1;
    generate
        //CASE: base
        if(N == 2) begin
            /*reg [WIDTH_IN + 1:0] sum_reg = '0;
            assign sum = sum_reg;
            always @(posedge clk) begin
                sum_reg <= data_in[0] + data_in[1];
            end*/
            assign sum = data_in[0] + data_in[1];
        end
        else if (N == 3) begin
            /*reg [WIDTH_IN + 1:0] sum_reg = '0;
            assign sum = sum_reg;
            always @(posedge clk) begin
                sum_reg <= data_in[0] + data_in[1] + data_in[2];
            end*/
            assign sum = data_in[0] + data_in[1] + data_in[2];
        end

        //CASE: base_exception
        else if (N == 1) begin
            //this module should be optimized out
            assign sum = data_in[0];
        end

        //CASE: even
        else if(N % 2 == 0) begin
            wire [WIDTH_OUT - 2:0] left_sum;
            wire [WIDTH_OUT - 2:0] right_sum;

            /*reg [WIDTH_OUT:0] sum_reg = '0;
            assign sum = sum_reg;
            always @(posedge clk) begin
                sum_reg <= left_sum + right_sum;
            end*/
            assign sum = left_sum + right_sum;

            tree_adder #(N / 2, WIDTH_IN) left
            (
                .clk(clk),
                .data_in(data_in[0:N / 2 - 1]),
                .sum(left_sum)
            );
            tree_adder #(N / 2, WIDTH_IN) right
            (
                .clk(clk),
                .data_in(data_in[N / 2:N - 1]),
                .sum(right_sum)
            );

        end

        //CASE: odd
        else if(N % 2 == 1) begin
            wire [WIDTH_OUT - 2:0] left_sum;
            wire [WIDTH_OUT - 2:0] right_sum;

            /*reg [WIDTH_OUT:0] sum_reg = '0;
            assign sum = sum_reg;
            always @(posedge clk) begin
                sum_reg <= left_sum + right_sum + data_in[N - 1];
            end*/
            assign sum = left_sum + right_sum + data_in[N - 1];

            tree_adder #((N - 1) / 2, WIDTH_IN) left
            (
                .clk(clk),
                .data_in(data_in[(N - 1) / 2 - 1 : 0]),
                .sum(left_sum)
            );
            tree_adder #((N - 1) / 2, WIDTH_IN) right
            (
                .clk(clk),
                .data_in(data_in[N - 2 : (N - 1) / 2]),
                .sum(right_sum)
            );

        end
    endgenerate
endmodule