`include "../build/core_params.svh"

module sorting_test
    (

    );
    reg data_set [0:159];
    genvar i;
    generate
        for (i = 0; i < 160; i ++) begin
            initial begin
                data_set[i] = 1'b1;
            end
        end
    endgenerate
    
    tree_adder #(160, 1) adder
    (
        .clk(clk),
        .data_in(data_set),
        .sum(sum)
    ); 

endmodule