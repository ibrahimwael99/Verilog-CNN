//test bench for floating-point multiplication
module mul_flp_tb;
reg [31:0] flp_a, flp_b;
wire sign;
wire [7:0] exponent;
wire [8:0] exp_sum;
wire [22:0] prod;
reg clock;
//display variables
//initial
//$monitor ("sign = %b, exp_biased = %b,prod = %b",sign, exp_sum, prod);
//apply input vectors
initial
begin
clock=1;
//+5 x +3 = +15
// s ----e---- --------------f-------------
#0 flp_a = 32'b01000000101000000000000000000000;
flp_b = 32'b01000000010000000000000000000000;
//+6 x +4 = +24
// s ----e---- --------------f-------------
#10 flp_a = 32'b01000000110000000000000000000000;
flp_b = 32'b01000000100000000000000000000000;
//-5 x +5 = -25
// s ----e---- --------------f-------------
#10 flp_a = 32'b11000000101000000000000000000000;
flp_b = 32'b01000000101000000000000000000000;
//+7 x -5 = -35
// s ----e---- --------------f-------------
#10 flp_a = 32'b01000000111000000000000000000000;
flp_b = 32'b11000000101000000000000000000000;
//+25 x +25 = +625
// s ----e---- --------------f-------------
#10 flp_a = 32'b01000001110010000000000000000000;
flp_b = 32'b01000001110010000000000000000000;
//continued on next page

//+76 x +55 = +4180
// s ----e---- --------------f-------------
#10 flp_a = 32'b01000010100110000000000000000000;
flp_b = 32'b01000010010111000000000000000000;
//-48 x -17 = +816
// s ----e---- --------------f-------------
#10 flp_a = 32'b11000010010000000000000000000000;
flp_b = 32'b11000001100010000000000000000000;
//+3724 x +853 = +3,176,572
// s ----e---- --------------f-------------
#10 flp_a = 32'b01000101011010001100000000000000;
flp_b = 32'b01000100010101010100000000000000;
#10 $stop;
end

always begin
    #5  clock = ~clock; // Toggle clock every 5 ticks
end
//instantiate the module into the test bench
fpMul inst1 (
.flp_a(flp_a),
.flp_b(flp_b),
.sign(sign),
.exponent(exponent),
.exp_sum(exp_sum),
.prod(prod)
);
endmodule