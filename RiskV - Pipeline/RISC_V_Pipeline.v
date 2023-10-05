module RISC_V_Pipeline (
    input clock, reset
);
    wire PCSrcE;
    wire [1:0] PCSrc;
// controller
    wire RegWriteD,MemWriteD,JumpD,BranchD,ALUSrcD,RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE,RegWriteM,MemWriteM,RegWriteW;
    wire [1:0] ResultSrcD, ResultSrcE, ResultSrcM, ResultSrcW;
    wire [2:0] ImmSrcD;
    wire [3:0] ALUControlD, ALUControlE;
// Hazard Unit 
    wire StallF, StallD, FlushD, FlushE;
    wire [1:0] ForwardAE, ForwardBE;
//fetch
    wire [31:0] PCNext, PCF, PCPlus4F, InstrF;
//Decode
    wire [31:0] PCD, PCPlus4D, InstrD, RD1D, RD2D, ExtImmD;
//execute 
    wire ZeroE;
    wire [4:0] Rs1E, Rs2E, RdE;
    wire [31:0] PCE, PCPlus4E, RD1E, RD2E, PCTargetE, SrcAE, SrcBE, WriteDataE, ALUResultE, ExtImmE;
//Memory
    wire [4:0] RdM;
    wire [31:0] PCPlus4M, ALUResultM, WriteDataM, ReadDataM, ExtImmM;
// Writeback
    wire [4:0] RdW;
    wire [31:0] PCPlus4W, ReadDataW, ResultW, ExtImmW, ALUResultW;

 


//Fetch
    MUX4 pc_select(.data_in1(PCPlus4F), .data_in2(PCTargetE), .data_in3(ALUResultE), .data_in4(32'bz), .select(PCSrc), .data_out(PCNext));
    FetchReg pc(.clock(clock), .reset(reset), .enable(StallF), .PC_in(PCNext), .PC_out(PCF));
    InstructionMem im(.address(PCF), .instruction(InstrF));
    Adder pc4(.data_in1(PCF), .data_in2(4), .data_out(PCPlus4F));

    DecodeReg dreg(
        .clock(clock), .enable(StallD), .clear(FlushD), .reset(reset),
        .instr_in(InstrF), .PC_in(PCF), .PC_plus4_in(PCPlus4F), 
        .instr_out(InstrD), .PC_out(PCD), .PC_plus4_out(PCPlus4D)
    );

//Decode
    
    Controller cntrl(
        .opcode(InstrD[6:0]),
        .func3(InstrD[14:12]),
        .func7(InstrD[31:25]),

        .RegWrite(RegWriteD),
        .ResultSrc(ResultSrcD),
        .MemWrite(MemWriteD),
        .Jump(JumpD),
        .Branch(BranchD),
        .ALUControl(ALUControlD), 
        .ALUSrc(ALUSrcD),
        .ImmSrc(ImmSrcD)
    );

    RegisterFile rf(.clock(clock), .reset(reset), .writeEn(RegWriteW), .address_rd1(InstrD[19:15]), .address_rd2(InstrD[24:20]), .address_wr(RdW), .write_data(ResultW), .read_data1(RD1D), .read_data2(RD2D));
    Extend ex(.data_in(InstrD[31:7]), .select(ImmSrcD), .data_out(ExtImmD));


    ExecuteReg exreg(
        .clock(clock), .reset(reset), .clear(FlushE),

        .RegWrite_in(RegWriteD), .MemWrite_in(MemWriteD), .Jump_in(JumpD), .Branch_in(BranchD), .ALUSrc_in(ALUSrcD), 
        .ResultSrc_in(ResultSrcD), 
        .ALUControl_in(ALUControlD),
        .RegAdrRead1_in(InstrD[19:15]), .RegAdrRead2_in(InstrD[24:20]), .RegAdrWrite_in(InstrD[11:7]),
        .RegRead1_in(RD1D), .RegRead2_in(RD2D), .PC_in(PCD), .ExtImm_in(ExtImmD), .PCPlus4_in(PCPlus4D),

        .RegWrite_out(RegWriteE), .MemWrite_out(MemWriteE), .Jump_out(JumpE), .Branch_out(BranchE), .ALUSrc_out(ALUSrcE), 
        .ResultSrc_out(ResultSrcE), 
        .ALUControl_out(ALUControlE),
        .RegAdrRead1_out(Rs1E), .RegAdrRead2_out(Rs2E), .RegAdrWrite_out(RdE),
        .RegRead1_out(RD1E), .RegRead2_out(RD2E), .PC_out(PCE), .ExtImm_out(ExtImmE), .PCPlus4_out(PCPlus4E)
    );

//Execution 
    
    MUX4 src_a(.data_in1(RD1E), .data_in2(ResultW), .data_in3(ALUResultM), .data_in4(32'bz), .select(ForwardAE), .data_out(SrcAE));
    MUX4 src_b(.data_in1(RD2E), .data_in2(ResultW), .data_in3(ALUResultM), .data_in4(32'bz), .select(ForwardBE), .data_out(WriteDataE));
    MUX2 src_be(.data_in1(WriteDataE), .data_in2(ExtImmE), .select(ALUSrcE), .data_out(SrcBE));
    Adder pc_imm(.data_in1(PCE), .data_in2(ExtImmE), .data_out(PCTargetE));
    ALU alu(.data_in1(SrcAE), .data_in2(SrcBE), .select(ALUControlE), .data_out(ALUResultE), .zero(ZeroE));

    MemoryReg memreg(
        .clock(clock), .reset(reset),

        .RegWrite_in(RegWriteE), .MemWrite_in(MemWriteE),
        .ResultSrc_in(ResultSrcE), 
        .RegAdrWrite_in(RdE),
        .ALUResult_in(ALUResultE), .WriteData_in(WriteDataE), .PCPlus4_in(PCPlus4E), .ExtImm_in(ExtImmE),

        .RegWrite_out(RegWriteM), .MemWrite_out(MemWriteM),
        .ResultSrc_out(ResultSrcM), 
        .RegAdrWrite_out(RdM),
        .ALUResult_out(ALUResultM), .WriteData_out(WriteDataM), .PCPlus4_out(PCPlus4M), .ExtImm_out(ExtImmM)
    );

//Memory
    DataMemory dm(.clock(clock), .reset(reset), .writeEn(MemWriteM), .address(ALUResultM), .write_data(WriteDataM), .read_data(ReadDataM));

    WritebackReg wreg(
        .clock(clock), .reset(reset),

        .RegWrite_in(RegWriteM),
        .ResultSrc_in(ResultSrcM), 
        .RegAdrWrite_in(RdM),
        .ALUResult_in(ALUResultM), .ReadData_in(ReadDataM), .PCPlus4_in(PCPlus4M), .ExtImm_in(ExtImmM),

        .RegWrite_out(RegWriteW),
        .ResultSrc_out(ResultSrcW), 
        .RegAdrWrite_out(RdW),
        .ALUResult_out(ALUResultW), .ReadData_out(ReadDataW), .PCPlus4_out(PCPlus4W), .ExtImm_out(ExtImmW)
    );

//Writeback
    MUX4 wres(.data_in1(ALUResultW), .data_in2(ReadDataW), .data_in3(PCPlus4W), .data_in4(ExtImmW), .select(ResultSrcW), .data_out(ResultW));


//
    HazardUnit hu(
        .RegWriteM(RegWriteM), .RegWriteW(RegWriteW), .PCSrcE(PCSrcE),
        .ResultSrcE(ResultSrcE),
        .Rs1D(InstrD[19:15]), .Rs2D(InstrD[24:20]), .Rs1E(Rs1E), .Rs2E(Rs2E), .RdE(RdE), .RdM(RdM), .RdW(RdW),

        .StallF(StallF), .StallD(StallD), .FlushD(FlushD), .FlushE(FlushE),
        .ForwardAE(ForwardAE), .ForwardBE(ForwardBE)
    );

    assign PCSrcE = ((ZeroE & BranchE) | JumpE) === 1'b1;
    assign PCSrc = (PCSrcE & ALUSrcE) ? 2'b10 : (PCSrcE) ? 2'b01 : 2'b00;





endmodule