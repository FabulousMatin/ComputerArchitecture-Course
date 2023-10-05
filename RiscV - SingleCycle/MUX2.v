module MUX2 (
    input [31:0] data_in1, data_in2,
    input select,
    output reg [31:0] data_out
);

    always @(data_in1, data_in2, select) begin
        case (select)
            0: data_out = data_in1;
            1: data_out = data_in2;
            default: data_out = 32'b0;
        endcase
    end
endmodule

