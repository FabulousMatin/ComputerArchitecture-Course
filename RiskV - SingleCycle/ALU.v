module ALU (
    input signed [31:0] data_in1, data_in2,
    input [3:0] select,
    output reg signed [31:0] data_out,
    output reg zero
);

parameter [3:0] ADD = 0, SUB = 1, AND = 2, OR = 3, XOR = 4, SLT = 5, beq = 6, bne = 7, blt = 8, bge = 9;
initial begin
    zero = 1'b0;
end
always @(*) begin
    case (select)
        ADD: data_out = data_in1 + data_in2;
        SUB: data_out = data_in1 - data_in2;
        AND: data_out = data_in1 & data_in2;
        OR: data_out = data_in1 | data_in2;
        XOR: data_out = data_in1 ^ data_in2;
        SLT: data_out = (data_in1 < data_in2) ? 32'b1 : 32'b0;

        beq: zero = (data_in1 == data_in2) ? 1'b1 : 1'b0; 
        bne: zero = (data_in1 != data_in2) ? 1'b1 : 1'b0;
        blt: zero = (data_in1 < data_in2) ? 1'b1 : 1'b0; 
        bge: zero = (data_in1 >= data_in2) ? 1'b1 : 1'b0; 

        default: begin
            zero = 1'b0;
            data_out = 32'b0;
        end
    endcase
end
    
endmodule