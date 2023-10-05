module Controller (
    input clock, reset, zero,
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    

    output reg PCWrite,
    output reg AddressSrc,
    output reg MemWrite,
    output reg IRWrite,
    output reg [1:0] ResultSrc,
    output reg [3:0] ALUControl,
    output reg [1:0] ALUSrcA,
    output reg [1:0] ALUSrcB,
    output reg [2:0] ImmSrc,
    output reg RegWrite
);
    reg PC_update, branch;

    parameter [6:0]
    R_TYPE = 7'b0110011, //add, sub, and, or, slt
    I_TYPE = 7'b0010011, //addi, xori, ori, slti,
    LW = 7'b0000011,
    JALR = 7'b1100111,
    SW = 7'b0100011,
    JAL = 7'b1101111,
    B_TYPE = 7'b1100011, // beq, bne, blt, bge
    LUI = 7'b0110111;

    parameter [3:0] ADD = 0, SUB = 1, AND = 2, OR = 3, XOR = 4, SLT = 5, beq = 6, bne = 7, blt = 8, bge = 9;
    parameter [2:0] EXTEND_I_TYPE = 0, EXTEND_S_TYPE = 1, EXTEND_B_TYPE = 2, EXTEND_U_TYPE = 3, EXTEND_J_TYPE = 4;



    parameter [4:0]
    InstructionFetch = 0,
    InstructionDecode = 1,
    A_R_TYPE = 2,  B_R_TYPE  = 3,  
    A_I_TYPE = 4,  B_I_TYPE  = 5, 
    A_LW     = 6,  B_LW      = 7, C_LW = 8,
    A_JALR   = 9,  B_JALR    = 10, 
    A_SW     = 11, B_SW     = 12, 
    A_JAL    = 13, B_JAL    = 14, 
    A_B_TYPE = 15, B_B_TYPE = 16;

    reg [4:0] pstate, nstate;

    always @(pstate) begin
        case (pstate)
            InstructionFetch: nstate = InstructionDecode;

            InstructionDecode: begin
                case (opcode)
                    R_TYPE: nstate = A_R_TYPE;
                    I_TYPE: nstate = A_I_TYPE;
                    LW: nstate = A_LW;
                    JALR: nstate = A_JALR;
                    SW: nstate = A_SW;
                    JAL: nstate = A_JAL;
                    B_TYPE: nstate = A_B_TYPE;
                    LUI: nstate = InstructionFetch;
                    default: nstate = InstructionFetch;
                endcase
            end

            A_R_TYPE: nstate = B_R_TYPE;
            A_I_TYPE: nstate = B_I_TYPE;
            A_LW    : nstate = B_LW    ;
            A_JALR  : nstate = B_JALR  ;
            A_SW    : nstate = B_SW    ;
            A_JAL   : nstate = B_JAL   ;
            A_B_TYPE: nstate = InstructionFetch;

            B_R_TYPE: nstate = InstructionFetch;
            B_I_TYPE: nstate = InstructionFetch;
            B_LW    : nstate = C_LW;
            B_JALR  : nstate = InstructionFetch;
            B_SW    : nstate = InstructionFetch;
            B_JAL   : nstate = InstructionFetch;

         
            C_LW    : nstate = InstructionFetch    ;
         
            default: nstate = InstructionFetch;
        endcase
    end


    always @(pstate, opcode, func3, func7, zero) begin

        {AddressSrc,MemWrite,IRWrite,ResultSrc,ALUControl,ALUSrcA,ALUSrcB,ImmSrc,RegWrite,PC_update,branch} = 20'b0;

        case (pstate)
            InstructionFetch:begin
                PC_update = 1;
                AddressSrc = 0;
                IRWrite = 1;
                ALUSrcA = 2'b00;
                ALUSrcB = 2'b10;
                ALUControl = ADD;
                ResultSrc = 2'b10;
            end

            InstructionDecode:begin
                if(opcode == B_TYPE) begin
                    ALUSrcA = 2'b01;
                    ALUSrcB = 2'b01;
                    ImmSrc = EXTEND_B_TYPE;
                    ALUControl = ADD;
                end
                else if(opcode == LUI) begin
                    ImmSrc = EXTEND_U_TYPE;
                    RegWrite = 1;
                    ResultSrc = 2'b11;
                end
                else if(opcode == JAL | opcode == JALR) begin
                    ResultSrc = 2'b00;
                    RegWrite = 1;
                end
            end

            A_R_TYPE: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b00;

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

            B_R_TYPE: begin
                ResultSrc = 2'b00;
                RegWrite = 1;
            end

            A_I_TYPE: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
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

            B_I_TYPE: begin
                ResultSrc = 2'b00;
                RegWrite = 1;
            end

            A_LW: begin
                ImmSrc = EXTEND_I_TYPE;
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                ALUControl = ADD;
            end

            B_LW: begin
                ResultSrc = 2'b00;
                AddressSrc = 1;
            end

            C_LW: begin
                ResultSrc = 2'b01;
                RegWrite = 1;
            end

            A_SW: begin
                ImmSrc = EXTEND_S_TYPE;
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                ALUControl = ADD;
            end

            B_SW: begin
                ResultSrc = 2'b00;
                AddressSrc = 1;
                MemWrite = 1;
            end

            A_B_TYPE: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b00;
                ResultSrc = 2'b00;
                branch = 1;

                if(func3 == 3'b0) 
                    ALUControl = beq;
                else if(func3 == 3'b001)
                    ALUControl = bne;
                else if(func3 == 3'b101)
                    ALUControl = bge;
                else if(func3 == 3'b100)
                    ALUControl = blt;
            end

            A_JALR: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                ImmSrc = EXTEND_I_TYPE;
                ALUControl = ADD;
            end

            B_JALR: begin
                ResultSrc = 2'b00;
                PC_update = 1;
            end

            A_JAL: begin
                ALUSrcA = 2'b01;
                ALUSrcB = 2'b01;
                ImmSrc = EXTEND_J_TYPE;
                ALUControl = ADD;
            end

            B_JAL: begin
                ResultSrc = 2'b00;
                PC_update = 1;
            end
            default: {AddressSrc,MemWrite,IRWrite,ResultSrc,ALUControl,ALUSrcA,ALUSrcB,ImmSrc,RegWrite,PC_update,branch} = 20'b0;
        endcase
    end


    always @(posedge clock, posedge reset) begin
        if(reset)
            pstate = InstructionFetch;
        else
            pstate = nstate;
    end

    
    assign PCWrite = ((zero & branch) | PC_update);
endmodule