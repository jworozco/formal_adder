// A signed 32x32 Multiplier utilizing SPM
//
// Copyright 2016, mshalan@aucegypt.edu

`timescale    1ns/1ps
`default_nettype    none
// verilator lint_off TIMESCALEMOD


module pm32 (
    input wire          clk,
    input wire          rst,
    input wire          start,
    input wire  [31:0]  mc,
    input wire  [31:0]  mp,
    output reg  [63:0]  p,
    output wire         done,
    input wire          op // not use for in design, but added for compatibility with tb
);
    wire        pw;
    reg [31:0]  Y;
    reg [7:0]   cnt, ncnt;
    reg [1:0]   state, nstate;

    localparam  IDLE=0, RUNNING=1, DONE=2;

    always @(posedge clk or posedge rst)
        if(rst)
            state  <= IDLE;
        else
            state <= nstate;

    always_comb
        case(state)
            IDLE    :   if(start) nstate = RUNNING; else nstate = IDLE;
            RUNNING :   if(cnt == 64) nstate = DONE; else nstate = RUNNING;
            DONE    :   if(start) nstate = RUNNING; else nstate = DONE;
            default :   nstate = IDLE;
        endcase

    always @(posedge clk)
        cnt <= ncnt;

    always_comb
        case(state)
            IDLE    :   ncnt = 0;
            RUNNING :   ncnt = cnt + 1;
            DONE    :   ncnt = 0;
            default :   ncnt = 0;
        endcase

    always @(posedge clk or posedge rst)
        if(rst)
            Y <= 32'b0;
        else if((start == 1'b1))
            Y <= mp;
        else if(state==RUNNING)
            Y <= (Y >> 1);

    always @(posedge clk or posedge rst)
        if(rst)
            p <= 64'b0;
        else if(start)
            p <= 64'b0;
        else if(state==RUNNING)
            p <= {pw, p[63:1]};

    wire y = (state==RUNNING) ? Y[0] : 1'b0;

    spm #(.SIZE(32)) spm32(
        .clk(clk),
        .rst(rst),
        .x(mc),
        .y(y),
        .p(pw)
    );

    assign done = (state == DONE);

`ifdef FORMAL

    initial rst <= 1'b1;

    always @(posedge clk) begin
        if (rst) begin
            assume(start == 1'b0);
        end else begin
            if (start) begin
                //the start signal should be high only once per multiplication, and the inputs need to be stable
                //for the duration of the multiplication
                assume(mc == $past(mc));
                assume(mp == $past(mp));
            end
        end

    end

    always @(posedge clk) begin
        if (rst) begin
            assert(state == IDLE);
        end else begin
            if (done) begin
                assert(p == (mc * mp));
            end
        end

    end

    // Ensure state transitions follow the defined state machine
    always @(posedge clk) begin
        if (rst) begin

        end else begin
            unique case (state)
                IDLE:    assert(nstate == IDLE || nstate == RUNNING);
                RUNNING: assert(nstate == RUNNING || nstate == DONE);
                DONE:    assert(nstate == DONE || nstate == RUNNING);
            endcase
        end
    end
    // Ensure `done` is asserted only in the DONE state
    always @(posedge clk or posedge rst)
        if(rst)
            p <= 64'b0;
        else if(start)
            p <= 64'b0;
        else if(state==RUNNING)
            p <= {pw, p[63:1]};
    // Ensure `done` is asserted only in the DONE state
    always @(posedge clk) begin
        if (rst) begin
            assert(done == 1'b0);
        end else begin
            assert(done == (state == DONE));
        end
    end


`endif // FORMAL

endmodule
