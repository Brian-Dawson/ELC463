`timescale 1ns / 1ps



module testbench(

    );
    
    reg clk;
    reg reset;
    reg [6:0] KN;
    reg [6:0] K;
reg [6:0] N;
reg [6:0] file [0:6];
reg trace1;
reg trace2;
wire [6:0] pass_1;
wire [6:0] pass_2;
reg [6:0] HIT;
reg [6:0] MISS;
    
    cache_main cache_main(
    .clk(clk),
    .reset(reset),
    .KN(KN),
    .K(K),
    .N(N),
    .file(file),
    .trace1(trace1),
    .trace2(trace2),
    .pass_1(pass_1),
    .pass_2(pass_2)
    );
    
    initial begin
        clk = 0;
        reset = 1;
    end
    
    always @(*)
        begin
            MISS = pass_1;
            HIT = pass_2;
    end
    

    
   integer file_inputs2;
   integer scan_inputs2_num;
   integer file_inputs1;
   integer scan_inputs1_num;
   
   
   reg [23:0] captured_inputs2 [0:59999];
   reg [23:0] captured_inputs1 [59999:0];
   
   initial begin
   
        file_inputs1 = $fopen("D:/Verilogprojects/ELC463/lab4.srcs/sim_1/new/TRACE1.DAT", "r");
        
        if(file_inputs1 == 0)
            begin
                $display("file not found");
                $finish;
            end
            
        file_inputs2 = $fopen("D:/Verilogprojects/ELC463/lab4.srcs/sim_1/new/TRACE2.DAT", "r");
        
        if(file_inputs2 == 0)
            begin
                $display("file not found");
                $finish;
            end
   end
   
   
    initial begin
        while(!$feof(file_inputs1))
            begin
                //scan_inputs1 = ($fgetc(file_inputs1)) | ($fgetc(file_inputs1) << 8) | ($fgetc(file_inputs1) << 16);
                scan_inputs1_num =  $fgets(captured_inputs1, file_inputs1);
            end  
                $fclose(file_inputs1);
    end
    
    initial begin
        while(!$feof(file_inputs2))
            begin
                 //scan_inputs2 = ($fgetc(file_inputs2)) | ($fgetc(file_inputs2) << 8) | ($fgetc(file_inputs2) << 16);
                 scan_inputs2_num = $fgets(captured_inputs2, file_inputs2);
            end
                $fclose(file_inputs2);
    end
    
     always begin
        #1;
        clk <= ~clk;
        reset = 1'b0;
    end

endmodule



