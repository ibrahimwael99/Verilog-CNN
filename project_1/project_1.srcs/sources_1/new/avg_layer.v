`timescale 1ns / 1ps
module avg_layer(
img_in,
clk,
img_out,
reset
);
parameter EXPONENT_WIDTH = 5;
parameter MANTISSA_WIDTH = 10;
parameter DATA_WIDTH = EXPONENT_WIDTH+MANTISSA_WIDTH+1;
parameter dimension = 10 ; //dimension of input matrix
parameter dimension2 = (dimension/2); //dimension of output matrix
input [(dimension*dimension*DATA_WIDTH)-1:0] img_in;
input clk ;
input reset;
output wire [(dimension2*dimension2*DATA_WIDTH)-1:0] img_out;
genvar i,j;
generate  //generate the parallel processing elements
	for(j=0 ; j<dimension; j=j+2) //loop in columns 
	   begin
	     for(i=0;i<(dimension/2);i=i+1) //loop on rows
	     //Take windows horizontally to the end of the matrix for each two rows I refer to rows         
	     // When reach to end of two rows j increase to go for next to rows
	     begin
	  fp_avg #(.EXPONENT_WIDTH(EXPONENT_WIDTH), .MANTISSA_WIDTH(MANTISSA_WIDTH)) inst1 (
         .fp_input({img_in[((((i+1)*2*DATA_WIDTH)+(DATA_WIDTH*dimension*j))-1):((2*i*DATA_WIDTH)+(DATA_WIDTH*dimension*j))],img_in[((((i+1)*2*DATA_WIDTH)+(DATA_WIDTH*dimension*j))-1)+(DATA_WIDTH*dimension):((2*i*DATA_WIDTH)+(DATA_WIDTH*dimension*j))+(DATA_WIDTH*dimension)]}),
         .clk(clk),
         .fp_output(img_out[((((i+1)*DATA_WIDTH)+(j*(DATA_WIDTH/4)*dimension))-1):((i*DATA_WIDTH)+(j*(DATA_WIDTH/4)*dimension))]),
         .reset(reset)
         );
	     end 
	  end
endgenerate    
endmodule
