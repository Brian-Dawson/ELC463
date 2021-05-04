`timescale 1ns / 1ps

module testbench(

    );
    
    reg clk;
    reg reset;
    reg [8:0] KN;
    reg [7:0] K;
    reg [7:0] N;
    wire [31:0] pass_1;
    wire [31:0] pass_2;
    wire [31:0] pass_3;
    wire [31:0] pass_4;
    reg [31:0] HIT;
    reg [31:0] MISS;
    reg [31:0] HIT_2;
    reg [31:0] MISS_2;
    reg [23:0] array_inputs1 [57961:0];
    reg [23:0] array_inputs2 [58596:0];
    
    cache_main cache_main(
    .clk(clk),
    .reset(reset),
    .KN(KN),
    .K(K),
    .N(N),
    .file1(array_inputs1),
    .file2(array_inputs2),
    .pass_1(pass_1),
    .pass_2(pass_2),
    .pass_3(pass_3),
    .pass_4(pass_4)
    );
    
    initial begin
        clk = 0;
        reset = 1;
        KN = 256;
        K = 2;
        N = 128;
    end
    
    always @(posedge clk)
        begin
            MISS = pass_1;
            HIT = pass_2;
            MISS_2 = pass_3;
            HIT_2 = pass_4;
    end
    
    
   integer file_inputs2;
   integer file_inputs1;


   reg [23:0] captured_inputs1;
   reg [23:0] captured_inputs2;
   
   initial begin
            file_inputs1 = $fopen("D:/Verilogprojects/ELC463/lab4.srcs/sim_1/new/TRACE1.DAT", "rb");
        if(file_inputs1 == 0)
            begin
                $display("file not found");
                $finish;
            end
end

    initial begin
        file_inputs2 = $fopen("D:/Verilogprojects/ELC463/lab4.srcs/sim_1/new/TRACE2.DAT", "rb");
        
        if(file_inputs2 == 0)
            begin
                $display("file not found");
                $finish;
            end
   end
   
   integer r;
   integer y;
   
    initial begin
        r = 0;
        while(!$feof(file_inputs1))
            begin
                captured_inputs1 = ($fgetc(file_inputs1)) | ($fgetc(file_inputs1) << 8) | ($fgetc(file_inputs1) << 16);

                array_inputs1[r] = captured_inputs1;
                r = r + 1;
            end  
                $fclose(file_inputs1);
    end
    
    initial begin
    y = 0;
        while(!$feof(file_inputs2))
            begin
                 captured_inputs2 = ($fgetc(file_inputs2)) | ($fgetc(file_inputs2) << 8) | ($fgetc(file_inputs2) << 16);
                 array_inputs2[y] = captured_inputs2;
                 y = y + 1;
            end
                $fclose(file_inputs2);
    end
    
    always begin
        #1;
        clk <= ~clk;
        reset = 1'b0;
    end
    

endmodule



