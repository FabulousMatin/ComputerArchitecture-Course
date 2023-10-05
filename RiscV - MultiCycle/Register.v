module Register (
    input clock, enable, reset,
    input [31:0] data_in,
    output reg [31:0] data_out
);
    initial data_out = 32'b0;
    
    always @(posedge clock) begin
        if(reset)
            data_out = 32'b0;
        else if(enable)
            data_out = data_in;
    end


endmodule