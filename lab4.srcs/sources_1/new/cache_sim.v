`timescale 1ns / 1ps

//KN = 256
//K = 2
//N = 128

/*
function set_counter(
input index_loc, //H
input [7:0] N,  //N always = 128
input [23:0] cache [57961:0] //Whole cache
);

integer inter_set_cntr;
inter_set_cntr = cache[index_loc][N+1];

    if(inter_set_cntr == N)
        begin
            inter_set_cntr = 1;
        end
    else
        begin
            inter_set_cntr += 1;
        end

endfunction
*/

function set_counter_2(
input index_loc,
input [7:0] N,
input [23:0] cache [58596:0]
);

integer inter_set_cntr;
inter_set_cntr = cache[index_loc][N+1];

    if(inter_set_cntr == N)
        begin
            inter_set_cntr = 1;
        end
    else
        begin
            inter_set_cntr += 1;
        end

endfunction

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
output reg [31:0] pass_2
    );
    reg [23:0] data_1 [57961:0];
    reg [23:0] data_2 [58596:0];
    reg [23:0] cache[128:0][1:0];
    
    reg temp_data;
    reg [7:0] data1_temp;
    integer i = 0;
    integer k = 0;
    integer g = 0;
    integer h = 0;
    integer j = 0;
    integer a = 0;
    integer b = 0;
    integer k_inner = 0;
    reg [7:0] set_cntr = 0;
    integer hit_flag = 0;
    
    integer top_cntr = 0;
    integer test_cntr1 = 0;
    integer test_cntr2 = 0;
    integer test_cntr3 = 0;
    reg test_reg = 0;
    
    integer inter_set_cntr;
    reg [31:0] internal_1 = 0; //MISS
    reg [31:0] internal_2 = 0; //HIT
    
    always@(*)begin
    for(int q = 0; q < (57962); q = q + 1)
    begin
    data_1[q] = file1[q];
    end
    for(int o = 0; o < (58597); o = o + 1)
    begin
    data_2[o] = file2[o];
    end
    end
 

    always @(reset) begin
//    for(a = 0; a < 57962; a = a + 1)
//    begin
   
//    data1_temp = data_1[a][23:16];
//    data_1[a][23:16] = data_1[a][7:0];
//    data_1[a][7:0] = data1_temp;
    
    
//    end

    for(i = 0; i < 129; i = i + 1) //pre-populating cache with 0s
    begin
        for(h = 0; h < 2; h = h + 1)
        begin
            cache[i][h] = 0;
        end
    
    end
    
    for(i = 0; i < 28981; i = i + 1)
        begin
            for(h = 0; h < 2; h = h + 1)
                begin
                top_cntr +=1;
                    if(cache[0][h][20] == data_1[i][20]) //if idx of trace data == index of cache
                        begin
                            
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
                        end 
                end
        end
    end
  /*  
    always @(*) begin
        for(k = 0; k < 58597; k = i + 1)
            for(h = 0; h < K; h = h + 1)
                begin
                    if(reordered_data_2[h][0] == entry[21:20])
                        begin
                            k_inner = 1;
                            hit_flag = 0;
                            for(j = 0; j < N+1; j = j + 1)
                                begin
                                    if(reordered_data_2[h][k] == entry[20:0])
                                        begin
                                            hit_flag = 1;
                                        end
                                end
                            if(reordered_data_2[h][set_cntr] == 0)
                                begin
                                    reordered_data_2[h][set_cntr] = entry[20:0];
                                    internal_1 += 1;
                                    set_cntr = set_counter_2(h, N, reordered_data_2);
                                    reordered_data_2[h][N+1] = set_cntr;
                                end
                             else if(reordered_data_2[h][set_cntr] != 0 && hit_flag == 1)
                                begin
                                    internal_2 += 1;
                                    set_cntr = set_counter_2(h, N, reordered_data_2);
                                    reordered_data_2[h][N+1] = set_cntr;
                                end
                             else
                                begin
                                    reordered_data_2[h][set_cntr] = entry[20:0];
                                    internal_1 += 1;
                                    set_cntr = set_counter_2(h, N, reordered_data_2);
                                    reordered_data_2[h][N+1] = set_cntr;
                                end   
                        end 
                end
     end*/
     always @(posedge clk)begin
    pass_1 = internal_1;
    pass_2 = internal_2;
    end
endmodule
