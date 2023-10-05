module DecodeReg (
    input clock, enable, clear, reset,
    input [31:0] instr_in, PC_in, PC_plus4_in,
    output reg [31:0] instr_out, PC_out, PC_plus4_out
);

    initial begin
        {instr_out, PC_out, PC_plus4_out} = 96'b0;
    end
    
    always @(posedge clock) begin
        if(reset || clear)
            {instr_out, PC_out, PC_plus4_out} = 96'b0;
        else if(enable == 1'b1) begin
            instr_out = instr_out;
            PC_out = PC_out;
            PC_plus4_out = PC_plus4_out;
        end 
        else begin
            instr_out = instr_in;
            PC_out = PC_in;
            PC_plus4_out = PC_plus4_in;
        end
    end
endmodule