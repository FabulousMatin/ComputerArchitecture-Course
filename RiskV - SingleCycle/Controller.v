module Controller (
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    input zero,

    output reg [1:0] PC_src,
    output reg [1:0] result_src,
    output reg mem_write,
    output reg [3:0] ALU_control,
    output reg ALU_src,
    output reg [2:0] extend_src,
    output reg reg_write
);
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

    always @(opcode, func3, func7, zero) begin
        {PC_src,result_src,mem_write,ALU_control,ALU_src,extend_src,reg_write} = 14'b0;

        case (opcode)
            R_TYPE: begin
                reg_write = 1;
                if(func7 == 7'b0 & func3 == 3'b0) // add
                    ALU_control = ADD;
                else if(func7 == 7'b0100000 & func3 == 3'b0)
                    ALU_control = SUB;
                else if(func7 == 7'b0 & func3 == 3'b111)
                    ALU_control = AND;
                else if(func7 == 7'b0 & func3 == 3'b010)
                    ALU_control = SLT;
                else if(func7 == 7'b0 & func3 == 3'b110)
                    ALU_control = OR;
            end
            I_TYPE: begin
                ALU_src = 1;
                reg_write = 1;
                extend_src = EXTEND_I_TYPE;
                if(func3 == 3'b0)
                    ALU_control = ADD;
                else if(func3 == 3'b100)
                    ALU_control = XOR;
                else if(func3 == 3'b010)
                    ALU_control = SLT;
                else if(func3 == 3'b110)
                    ALU_control = OR;
            end
            LW: begin
                result_src = 2'b01;
                ALU_control = ADD;
                ALU_src = 1;
                extend_src = EXTEND_I_TYPE;
                reg_write = 1;
            end
            JALR: begin
                PC_src = 2'b10;
                result_src = 2'b10;
                ALU_control = ADD;
                ALU_src = 1;
                extend_src = EXTEND_I_TYPE;
                reg_write = 1;
            end
            SW: begin
                mem_write = 1;
                ALU_control = ADD;
                ALU_src = 1;
                extend_src = EXTEND_S_TYPE;
            end
            JAL: begin
                PC_src = 2'b01;
                result_src = 2'b10;
                ALU_control = ADD;
                extend_src = EXTEND_J_TYPE;
                reg_write = 1;
            end
            B_TYPE: begin
                if(func3 == 3'b0) 
                    ALU_control = beq;
                else if(func3 == 3'b001)
                    ALU_control = bne;
                else if(func3 == 3'b101)
                    ALU_control = bge;
                else if(func3 == 3'b100)
                    ALU_control = blt;
                
                if(zero)
                    PC_src = 2'b01;

                extend_src = EXTEND_B_TYPE;
            end
            LUI: begin
                result_src = 2'b11;
                extend_src = EXTEND_U_TYPE;
                reg_write = 1;
            end
            default: {PC_src,result_src,mem_write,ALU_control,ALU_src,extend_src,reg_write} = 14'b0;
        endcase
    end
endmodule