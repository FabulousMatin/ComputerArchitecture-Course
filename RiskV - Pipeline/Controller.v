module Controller (
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,

    output reg RegWrite,
    output reg [1:0] ResultSrc,
    output reg MemWrite,
    output reg Jump,
    output reg Branch,
    output reg [3:0] ALUControl, 
    output reg ALUSrc,
    output reg [2:0] ImmSrc
);
    parameter [6:0]
    R_TYPE = 7'b0110011, // add, sub, and, or, slt
    I_TYPE = 7'b0010011, // addi, xori, ori, slti,
    LW = 7'b0000011,     // lw
    JALR = 7'b1100111,   // jalr
    SW = 7'b0100011,     // sw
    JAL = 7'b1101111,    // jal
    B_TYPE = 7'b1100011, // beq, bne, blt, bge
    LUI = 7'b0110111;    // lui

    parameter [3:0] ADD = 0, SUB = 1, AND = 2, OR = 3, XOR = 4, SLT = 5, beq = 6, bne = 7, blt = 8, bge = 9;
    parameter [2:0] EXTEND_I_TYPE = 0, EXTEND_S_TYPE = 1, EXTEND_B_TYPE = 2, EXTEND_U_TYPE = 3, EXTEND_J_TYPE = 4;

    always @(opcode, func3, func7) begin
        {Jump,Branch,ResultSrc,MemWrite,ALUControl,ALUSrc,ImmSrc,RegWrite} = 14'b0;

        case (opcode)
            R_TYPE: begin
                RegWrite = 1;
                if(func7 == 7'b0 & func3 == 3'b0)
                    ALUControl = ADD;
                else if(func7 == 7'b0100000 & func3 == 3'b0)
                    ALUControl = SUB;
                else if(func7 == 7'b0 & func3 == 3'b111)
                    ALUControl = AND;
                else if(func7 == 7'b0 & func3 == 3'b010)
                    ALUControl = SLT;
                else if(func7 == 7'b0 & func3 == 3'b110)
                    ALUControl = OR;
            end
            I_TYPE: begin
                ALUSrc = 1;
                RegWrite = 1;
                ImmSrc = EXTEND_I_TYPE;
                if(func3 == 3'b0)
                    ALUControl = ADD;
                else if(func3 == 3'b100)
                    ALUControl = XOR;
                else if(func3 == 3'b010)
                    ALUControl = SLT;
                else if(func3 == 3'b110)
                    ALUControl = OR;
            end
            LW: begin
                ResultSrc = 2'b01;
                ALUControl = ADD;
                ALUSrc = 1;
                ImmSrc = EXTEND_I_TYPE;
                RegWrite = 1;
            end
            JALR: begin
                Jump = 1;
                ResultSrc = 2'b10;
                ALUControl = ADD;
                ALUSrc = 1;
                ImmSrc = EXTEND_I_TYPE;
                RegWrite = 1;
            end
            SW: begin
                MemWrite = 1;
                ALUControl = ADD;
                ALUSrc = 1;
                ImmSrc = EXTEND_S_TYPE;
            end
            JAL: begin
                Jump = 1;
                ResultSrc = 2'b10;
                ImmSrc = EXTEND_J_TYPE;
                ALU_control = ADD;
                RegWrite = 1;
            end
            B_TYPE: begin
                if(func3 == 3'b0) 
                    ALUControl = beq;
                else if(func3 == 3'b001)
                    ALUControl = bne;
                else if(func3 == 3'b101)
                    ALUControl = bge;
                else if(func3 == 3'b100)
                    ALUControl = blt;
                
                
                Branch = 1;

                ImmSrc = EXTEND_B_TYPE;
            end
            LUI: begin
                ResultSrc = 2'b11;
                ImmSrc = EXTEND_U_TYPE;
                RegWrite = 1;
            end
            default: {Jump,Branch,ResultSrc,MemWrite,ALUControl,ALUSrc,ImmSrc,RegWrite} = 14'b0;
        endcase
    end


endmodule