module MemoryReg (
    input clock, reset,

    input RegWrite_in, MemWrite_in,
    input [1:0] ResultSrc_in, 
    input [4:0] RegAdrWrite_in,
    input [31:0] ALUResult_in, WriteData_in, PCPlus4_in, ExtImm_in,


    output reg RegWrite_out, MemWrite_out,
    output reg [1:0] ResultSrc_out, 
    output reg [4:0] RegAdrWrite_out,
    output reg [31:0] ALUResult_out, WriteData_out, PCPlus4_out, ExtImm_out
);
    always @(posedge clock) begin
        if(reset) begin
            RegWrite_out = 1'b0;
            MemWrite_out = 1'b0;
            ResultSrc_out = 2'b0;
            RegAdrWrite_out = 5'b0;
            ALUResult_out = 32'b0;
            WriteData_out = 32'b0;
            PCPlus4_out = 32'b0;
            ExtImm_out = 32'b0;
        end
        else begin
            RegWrite_out = RegWrite_in;
            MemWrite_out = MemWrite_in;
            ResultSrc_out = ResultSrc_in;
            RegAdrWrite_out = RegAdrWrite_in;
            ALUResult_out = ALUResult_in;
            WriteData_out = WriteData_in;
            PCPlus4_out = PCPlus4_in;
            ExtImm_out = ExtImm_in;
        end
    end
endmodule