module InstructionMem (
    input [31:0] address,
    output [31:0] instruction
);
    reg [31:0] inst_mem [1023:0];
    
    initial begin
        $readmemh("Instructions.txt", inst_mem);
    end
    
    assign instruction = inst_mem[address >> 2];
endmodule   