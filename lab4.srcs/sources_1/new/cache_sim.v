`timescale 1ns / 1ps

//KN = 256
//K = 2
//N = 128


module cache_main(
input clk,
input reset,
input [8:0] KN,
input [7:0] K,
input [7:0] N,
input [23:0] file1 [57961:0],
input [23:0] file2 [58596:0],
input trace1,
input trace2,
output reg [31:0] pass_1,
output reg [31:0] pass_2,
output reg [31:0] pass_3, 
output reg [31:0] pass_4
    );
    reg [23:0] data_1 [57961:0];
    reg [23:0] data_2 [58596:0];
    reg [23:0] cache[128:0][1:0];
    reg [23:0] cache_2[128:0][1:0];
    integer i = 0;
    integer k = 0; 
    integer g = 0;
    integer h = 0;
    integer j = 0;
    integer a = 0;
    integer b = 0;
    integer k_inner = 0;
    reg [7:0] set_cntr = 0;
    reg [7:0] set_cntr2 = 0;
    integer hit_flag = 0;
    integer hit_flag_2 = 0;
    integer temp = 0;
    integer temp_2 = 0;
    
    integer top_cntr = 0;
    integer test_cntr1 = 0;
    integer test_cntr2 = 0;
    integer test_cntr3 = 0;
    reg test_reg = 0;
    
    integer inter_set_cntr;
    reg [31:0] internal_1 = 0; //MISS TRACE 1
    reg [31:0] internal_2 = 0; //HIT TRACE 1
    reg [31:0] internal_3 = 0;
    reg [31:0] internal_4 = 0;
    


    always @(posedge reset) begin
    for(int q = 0; q < (57962); q = q + 1)
    begin
    data_1[q] = file1[q];
    end
    for(int o = 0; o < (58597); o = o + 1)
    begin
    data_2[o] = file2[o];
    end
    for(i = 0; i < 129; i = i + 1) //pre-populating cache with 0s
    begin
        for(h = 0; h < 2; h = h + 1)
        begin
            cache[i][h] = 0;
            cache_2[i][h] = 0;
        end
    
    end
    
    for(int i = 0; i < 57961; i = i + 1)
        begin
        //top_cntr +=1;
            for(int h = 0; h < 2; h = h + 1)
                begin
                //top_cntr +=1;  
                    if((cache[0][h][3] == data_1[i][3]) && temp < 57961) //if idx of trace data == index of cache
                        begin
                            top_cntr +=1;
                            //k_inner = 1;
                            hit_flag = 0;
                            for(j = 0; j < N; j = j + 1)//setting hit flag
                                begin
                                    if(cache[j][h][20:0] == data_1[i][20:0])
                                        begin
                                            hit_flag = 1;
                                        end
                                end
                            if(cache[set_cntr][h] == 0) //if space is empty
                                begin
                                    test_cntr1 += 1;
                                    cache[set_cntr][h][20:0] = data_1[i][20:0]; //fill empty space with tag
                                    internal_1 += 1; //miss 
                                    //set_cntr = set_counter(h, N, (data_1)); 
                                    set_cntr = cache[N][h]; 
                                        if(set_cntr == N-1)
                                            begin
                                                set_cntr = 0;
                                            end
                                        else
                                            begin
                                                set_cntr += 1;
                                            end
                                    
                                    cache[N][h] = set_cntr;
                                end
                             else if((cache[set_cntr][h] != 0) && (hit_flag == 1))//not empty and tag is same
                                begin
                                    test_cntr2 += 1;
                                    internal_2 += 1; //hit
                                    set_cntr = cache[N][h];
                                        if(set_cntr == N-1)
                                            begin
                                                set_cntr = 0;
                                            end
                                        else
                                            begin
                                                set_cntr += 1;
                                            end
                                    cache[N][h] = set_cntr;
                                end
                             else //not empty and not same tag
                                begin
                                    test_cntr3 += 1;
                                    cache[set_cntr][h][20:0] = data_1[i][20:0];
                                    internal_1 += 1; //miss
                                    set_cntr = cache[N][h];
                                        if(set_cntr == N-1)
                                            begin
                                                set_cntr = 0;
                                            end
                                        else
                                            begin
                                                set_cntr += 1;
                                            end
                                    cache[N][h] = set_cntr;
                                end   
                                temp = temp + 1;
                        end 
                end
        end
        
         for(int i = 0; i < 58597; i = i + 1)
        begin
        //top_cntr +=1;
            for(int h = 0; h < 2; h = h + 1)
                begin
                //top_cntr +=1;  
                    if((cache_2[0][h][3] == data_2[i][3]) && temp_2 < 58597) //if idx of trace data == index of cache
                        begin
                            top_cntr +=1;
                            //k_inner = 1;
                            hit_flag_2 = 0;
                            for(j = 0; j < N; j = j + 1)//setting hit flag
                                begin
                                    if(cache_2[j][h][20:0] == data_2[i][20:0])
                                        begin
                                            hit_flag_2 = 1;
                                        end
                                end
                            if(cache_2[set_cntr2][h] == 0) //if space is empty
                                begin
                                    test_cntr1 += 1;
                                    cache_2[set_cntr2][h][20:0] = data_2[i][20:0]; //fill empty space with tag
                                    internal_3 += 1; //miss 
                                    //set_cntr = set_counter(h, N, (data_1)); 
                                    set_cntr2 = cache_2[N][h]; 
                                        if(set_cntr2 == N-1)
                                            begin
                                                set_cntr2 = 0;
                                            end
                                        else
                                            begin
                                                set_cntr2 += 1;
                                            end
                                    
                                    cache_2[N][h] = set_cntr2;
                                end
                             else if((cache_2[set_cntr2][h] != 0) && (hit_flag_2 == 1))//not empty and tag is same
                                begin
                                    test_cntr2 += 1;
                                    internal_4 += 1; //hit
                                    set_cntr2 = cache_2[N][h];
                                        if(set_cntr2 == N-1)
                                            begin
                                                set_cntr2 = 0;
                                            end
                                        else
                                            begin
                                                set_cntr2 += 1;
                                            end
                                    cache_2[N][h] = set_cntr2;
                                end
                             else //not empty and not same tag
                                begin
                                    test_cntr3 += 1;
                                    cache_2[set_cntr2][h][20:0] = data_2[i][20:0];
                                    internal_3 += 1; //miss
                                    set_cntr2 = cache_2[N][h];
                                        if(set_cntr == N-1)
                                            begin
                                                set_cntr2 = 0;
                                            end
                                        else
                                            begin
                                                set_cntr2 += 1;
                                            end
                                    cache[N][h] = set_cntr2;
                                end   
                                temp_2 = temp_2 + 1;
                        end 
                end
        end
    end
    
    
    
    
     always @(posedge clk)begin
    pass_1 = internal_1;
    pass_2 = internal_2;
    pass_3 = internal_3;
    pass_4 = internal_4;
    end
endmodule
