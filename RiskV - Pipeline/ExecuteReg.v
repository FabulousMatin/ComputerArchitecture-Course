module ExecuteReg (
    input clock, reset, clear,

    input RegWrite_in, MemWrite_in, Jump_in, Branch_in, ALUSrc_in, 
    input [1:0] ResultSrc_in, 
    input [3:0] ALUControl_in,
    input [4:0] RegAdrRead1_in, RegAdrRead2_in, RegAdrWrite_in,
    input [31:0] RegRead1_in, RegRead2_in, PC_in, ExtImm_in, PCPlus4_in,

    output reg RegWrite_out, MemWrite_out, Jump_out, Branch_out, ALUSrc_out, 
    output reg [1:0] ResultSrc_out, 
    output reg [3:0] ALUControl_out,
    output reg [4:0] RegAdrRead1_out, RegAdrRead2_out, RegAdrWrite_out,
    output reg [31:0] RegRead1_out, RegRead2_out, PC_out, ExtImm_out, PCPlus4_out
);
    always @(posedge clock) begin
        if(reset || clear) begin

            RegWrite_out = 1'b0;
            MemWrite_out = 1'b0;
            Jump_out = 1'b0;
            Branch_out = 1'b0;
            ALUSrc_out = 1'b0;

            ResultSrc_out = 2'b0;

            ALUControl_out = 4'b0;

            RegAdrRead1_out = 5'b0;
            RegAdrRead2_out = 5'b0;
            RegAdrWrite_out = 5'b0;

            RegRead1_out = 32'b0;
            RegRead2_out = 32'b0;
            PC_out = 32'b0;
            ExtImm_out = 32'b0;
            PCPlus4_out = 32'b0;
        end

        else begin
            RegWrite_out = RegWrite_in;
            MemWrite_out = MemWrite_in;
            Jump_out = Jump_in;
            Branch_out = Branch_in;
            ALUSrc_out = ALUSrc_in;
            ResultSrc_out = ResultSrc_in;
            ALUControl_out = ALUControl_in;
            RegAdrRead1_out = RegAdrRead1_in;
            RegAdrRead2_out = RegAdrRead2_in;
            RegAdrWrite_out = RegAdrWrite_in;
            RegRead1_out = RegRead1_in;
            RegRead2_out = RegRead2_in;
            PC_out = PC_in;
            ExtImm_out = ExtImm_in;
            PCPlus4_out = PCPlus4_in;
        end
            
    end
endmodule
