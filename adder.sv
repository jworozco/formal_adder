// address generator/counter
module adder 
#(  parameter DATA_WIDTH=8
) ( input clk, rst,
    input [DATA_WIDTH-1:0] a, b,
    output logic [DATA_WIDTH:0] sum
);
    assign sum = a + b;

`ifdef FORMAL
    always @(posedge clk) begin
        if (~rst) begin
            // tests
            c_a: cover (a);
            c_b: cover (b);
            c_sum: cover (sum);
            // check result
            a_sum:  assert property (sum == a + b);
        end
    end
`endif // FORMAL

endmodule




