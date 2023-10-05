module RISC_V_MultiCycle(
    input clock, reset
);

    wire PCWrite, AddressSrc, MemWrite, IRWrite, RegWrite, Zero;
    wire [1:0] ResultSrc, ALUSrcA, ALUSrcB;
    wire [2:0] ImmSrc;
    wire [3:0] ALUControl;
    wire [31:0] PCOut, Address, ReadData, Instr, Data, OldPC, ImmExt, WriteData, SrcA, SrcB, ALUResult, ALUOut, Result, RFOut1, RFOut2, RegOutA;
     

Controller cntrl(
    .clock(clock),
    .reset(reset),
    .zero(Zero),
    .opcode(Instr[6:0]),
    .func3(Instr[14:12]),
    .func7(Instr[31:25]),
    

    .PCWrite(PCWrite),
    .AddressSrc(AddressSrc),
    .MemWrite(MemWrite),
    .IRWrite(IRWrite),
    .ResultSrc(ResultSrc),
    .ALUControl(ALUControl),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .ImmSrc(ImmSrc),
    .RegWrite(RegWrite)
);


       

    Register pc(.clock(clock), .enable(PCWrite), .reset(reset), .data_in(Result), .data_out(PCOut));
    MUX2 adr_sel(.data_in1(PCOut), .data_in2(Result), .select(AddressSrc), .data_out(Address));
    Memory I_D_memory(.clock(clock), .writeEn(MemWrite), .reset(reset), .address(Address), .write_data(WriteData), .read_data(ReadData));
    Register old_pc(.clock(clock), .enable(IRWrite), .reset(reset), .data_in(PCOut), .data_out(OldPC));
    Register ir(.clock(clock), .enable(IRWrite), .reset(reset), .data_in(ReadData), .data_out(Instr));
    Register MDR(.clock(clock), .enable(1'b1), .reset(reset), .data_in(ReadData), .data_out(Data));
    RegisterFile rf(.clock(clock), .reset(reset), .writeEn(RegWrite), .address_rd1(Instr[19:15]), .address_rd2(Instr[24:20]), .address_wr(Instr[11:7]), .write_data(Result), .read_data1(RFOut1), .read_data2(RFOut2));
    Extend ex(.data_in(Instr[31:7]), .select(ImmSrc), .data_out(ImmExt));
    Register A(.clock(clock), .enable(1'b1), .reset(reset), .data_in(RFOut1), .data_out(RegOutA));
    Register B(.clock(clock), .enable(1'b1), .reset(reset), .data_in(RFOut2), .data_out(WriteData));
    MUX4 src_A(.data_in1(PCOut), .data_in2(OldPC), .data_in3(RegOutA), .data_in4(32'bz), .select(ALUSrcA), .data_out(SrcA));
    MUX4 src_B(.data_in1(WriteData), .data_in2(ImmExt), .data_in3(4), .data_in4(32'bz), .select(ALUSrcB), .data_out(SrcB));
    ALU alu(.data_in1(SrcA), .data_in2(SrcB), .select(ALUControl), .data_out(ALUResult), .zero(Zero));
    Register result(.clock(clock), .enable(1'b1), .reset(reset), .data_in(ALUResult), .data_out(ALUOut));
    MUX4 result_src(.data_in1(ALUOut), .data_in2(Data), .data_in3(ALUResult), .data_in4(ImmExt), .select(ResultSrc), .data_out(Result));
    

endmodule