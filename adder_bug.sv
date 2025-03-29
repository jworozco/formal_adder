// address generator/counter
module adder
#(  parameter DATA_WIDTH=8
) (
    input [DATA_WIDTH-1:0] a, b,
    output logic [DATA_WIDTH-1:0] sum
);
    assign sum = a + b;

`ifdef FORMAL
    int a_val, b_val, sum_val;
    assign a_val = a;
    assign b_val = b;
    assign sum_val = a_val + b_val;
    always_comb begin
        // check result
        a_sum:  assert (sum_val == sum);
    end
`endif // FORMAL

endmodule




