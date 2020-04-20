`timescale 1ns / 1ps
module Pipeline_tb;
parameter DATA_WIDTH = 32 ; 
parameter INPUT_SIZE= 100; //Number of inputs
parameter OUTPUT_SIZE_1 = 32 ; //Number of outputs layer 1|| inputs for layer 2
parameter OUTPUT_SIZE_2 = 10 ; //Number of outputs layer 2|| inputs for layer 3
parameter OUTPUT_SIZE_3 = 4 ; //Number of outputs layer 3
parameter ADDR_WIDTH = 9 ; 
parameter file1 = "C:/Users/DELL/Desktop/Logic-2/Assign/Verilog-CNN/txts/Weights_FC_0_ones.txt";
parameter file2 = "C:/Users/DELL/Desktop/Logic-2/Assign/Verilog-CNN/txts/Weights_FC_1_ones.txt";
parameter file3 = "C:/Users/DELL/Desktop/Logic-2/Assign/Verilog-CNN/txts/Weights_FC_2_ones.txt";
parameter inputs_file_0 = "C:/Users/DELL/Desktop/Logic-2/Assign/Verilog-CNN/txts/Inputs_FC_0.txt";

reg  [DATA_WIDTH*INPUT_SIZE-1:0] input_fc;
reg clk, start_fc_1,start_fc_2,start_fc_3 , reset, done_1, done_2, done_3;
reg [DATA_WIDTH*OUTPUT_SIZE_1-1:0] output_fc_buffer_1;
reg [DATA_WIDTH*OUTPUT_SIZE_2-1:0] output_fc_buffer_2;
reg [DATA_WIDTH-1:0] inputs_mem [0:INPUT_SIZE-1] ;

wire [DATA_WIDTH*OUTPUT_SIZE_1-1:0] output_fc_layer_1;
wire [DATA_WIDTH*OUTPUT_SIZE_2-1:0] output_fc_layer_2;
wire [DATA_WIDTH*OUTPUT_SIZE_3-1:0] output_fc_layer_3;
wire [(DATA_WIDTH*OUTPUT_SIZE_1)-1:0] test_multi;
wire [(DATA_WIDTH*OUTPUT_SIZE_1)-1:0] test_weights;
wire [(DATA_WIDTH*OUTPUT_SIZE_1)-1:0] test_output;
/*
always@ (posedge done_1)
begin
output_fc_buffer_1=output_fc_layer_1;
end
*/
/*always@ (posedge done_2)
output_fc_buffer_2=output_fc_layer_2;
*/
integer i;
initial //apply input vectors
    begin
    $readmemh(inputs_file_0, inputs_mem);
    for( i = 0;i <INPUT_SIZE;i=i+1)
        input_fc[i*DATA_WIDTH+:DATA_WIDTH] = inputs_mem[i];
    reset=1; 
    start_fc_1=1;
    start_fc_2=1;
    start_fc_3=1;
    clk = 0;
    done_1 =0;
    done_2 =0;
    done_3 =0; 
    #20; //16 works 15 doesn't
    reset =0;
    start_fc_1=0;
    #1000 done_1 = 1;
    assign output_fc_buffer_1=output_fc_layer_1;
    
    #10;
     reset=1; 
     start_fc_2=1;
     #20; //16 works 15 doesn't
     reset =0;
     start_fc_2=0;
     
     #1000 done_2 = 1;
     $stop;
     assign output_fc_buffer_2=output_fc_layer_2;
    #1000 $stop;
    
    end
    
    always begin
        #5  clk = ~clk; // Toggle clock every 5 ticks 
     end
SingleLayer #(.INPUT_SIZE(INPUT_SIZE), .file(file1), .OUTPUT_SIZE(OUTPUT_SIZE_1))//instantiate the module                                                     
SL1( .input_fc(input_fc),
    .clk(clk),
    .start_fc(start_fc_1),
    .reset(reset),
    .output_fc_final(output_fc_layer_1),
    .test_multi(test_multi),.test_weights(test_weights),.test_output(test_output),.done(done_1));
    
SingleLayer #(.INPUT_SIZE(OUTPUT_SIZE_1), .file(file2), .OUTPUT_SIZE(OUTPUT_SIZE_2))//instantiate the module                                                     
SL2( .input_fc(output_fc_buffer_1),
    .clk(clk),
    .start_fc(start_fc_2),
    .reset(reset),
    .output_fc_final(output_fc_layer_2),
    .test_multi(test_multi),.test_weights(test_weights),.test_output(test_output),.done(done_2));
    
SingleLayer #(.INPUT_SIZE(OUTPUT_SIZE_2), .file(file3), .OUTPUT_SIZE(OUTPUT_SIZE_3))//instantiate the module                                                     
SL3( .input_fc(output_fc_buffer_2),
    .clk(clk),
    .start_fc(start_fc_3),
    .reset(reset),
    .output_fc_final(output_fc_layer_3),
    .test_multi(test_multi),.test_weights(test_weights),.test_output(test_output),.done(done_3));               
endmodule
