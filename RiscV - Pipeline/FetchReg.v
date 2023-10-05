module FetchReg (
    input clock, reset, enable,
    input [31:0] PC_in,
    output reg [31:0] PC_out
);
    initial begin
        PC_out = 32'b0;
    end
    
    always @(posedge clock) begin
        if(reset)
            PC_out = 32'b0;
        else if(enable == 1'b1)
            PC_out = PC_out;
        else
            PC_out = PC_in;
    end


endmodule