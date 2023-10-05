module MUX4 (
    input [31:0] data_in1, data_in2, data_in3, data_in4,
    input [1:0] select,
    output reg [31:0] data_out
);
    always @(*) begin
        case (select)
            0: data_out = data_in1;
            1: data_out = data_in2;
            2: data_out = data_in3;
            3: data_out = data_in4;
            default: data_out = 32'bz;
        endcase
    end
endmodule