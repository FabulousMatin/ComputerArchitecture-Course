module HazardUnit (
    input RegWriteM, RegWriteW, PCSrcE,
    input [1:0] ResultSrcE,
    input [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,

    output StallF, StallD, FlushD, FlushE,
    output reg [1:0] ForwardAE, ForwardBE
);
    wire lwStall;
    assign lwStall = (((Rs1D == RdE) | (Rs2D == RdE)) & (ResultSrcE == 2'b01)) === 1'b1;
    assign StallF = lwStall;
    assign StallD = lwStall;
    assign FlushD = PCSrcE;
    assign FlushE = (lwStall | PCSrcE) === 1'b1;
    
    always @(*) begin
        if((Rs1E == RdM) & (RegWriteM == 1) & (Rs1E != 5'b0))
            ForwardAE = 2'b10;
        else if((Rs1E == RdW) & (RegWriteW == 1) & (Rs1E != 5'b0))
            ForwardAE = 2'b01;
        else
            ForwardAE = 2'b00;

        if((Rs2E == RdM) & (RegWriteM == 1) & (Rs2E != 5'b0))
            ForwardBE = 2'b10;
        else if((Rs2E == RdW) & (RegWriteW == 1) & (Rs2E != 5'b0))
            ForwardBE = 2'b01;
        else
            ForwardBE = 2'b00;

        
    end
endmodule