`timescale 1ns / 1ps


    module CPU(
            input clk,
            input reset,
            input [31:0] instruction_from_testbench,
            input [63:0] datamemreaddata_to_mux3,
            output reg [63:0] pcoutput_to_testbench,
            output reg [63:0] mainalu_to_datamemreaddata,
            output reg [63:0] readdata2_to_datamemwritedata,
            output reg memwrite,memread
                );
            
            //Control lines from beginning to IFID and inbetween stuff
            reg[31:0] ins_mem_31_to_0_from_ins_to_IFID;
            wire [63:0] pc_from_pc_to_IFID;
            wire [63:0] mux4_to_pcinput;
            
            //Control lines from IFID to IDEX and inbetween stuff
            
            wire [63:0] pc_from_IFID_to_IDEX;
            wire [31:0] ins_mem_31_to_0_from_IFID_to_all_things;
            wire [1:0] control_ALU_op_from_IFID;
            wire control_ALU_src_from_IFID;
            wire control_Branch_zero_from_IFID;
            wire control_Memwrite_from_IFID;
            wire control_Memread__from_IFID;
            wire control_MemToReg_from_IFID;
            wire control_RegWrite_from_IFID;
            wire [4:0] mux1_to_read_reg_2;
            wire [63:0] signextend_to_IDEX;
            wire [63:0] reg_out_1_to_IDEX;
            wire [63:0] reg_out_2_to_IDEX;
            
            //Control lines from IDEX to EXMEM and inbetween stuff
            wire [1:0] control_ALU_op_from_IDEX;
            wire control_ALU_src_from_IDEX;
            wire control_Branch_zero_from_IDEX;
            wire control_Memwrite_from_IDEX;
            wire control_Memread__from_IDEX;
            wire control_MemToReg_from_IDEX;
            wire control_RegWrite_from_IDEX;
            wire [3:0] alu_control_to_alu;
            wire [63:0] pc_from_IDEX_to_add;
            wire [63:0] reg_out_1_from_IDEX_to_alu;
            wire [63:0] reg_out_2_from_IDEX_to_mux2_and_EXMEM;
            wire [63:0] signextend_from_IDEX_to_add_and_mux2;
            wire [63:0] mux2_to_alu;
            wire [63:0] add_to_EXMEM;
            wire [63:0] alu_to_EXMEM;
            wire [63:0] write_reg_IDEX_to_EXMEM;
            wire ALUZero_to_EXMEM;
            wire [31:0] IDEX_to_ALUControl;
            wire [31:0] IDEX_to_EXMEM;
            
            //Control lines from EXMEM to MEMWB and inbetween stuff
            wire [63:0] add_from_EXMEM_to_mux4;
            wire [63:0] alu_result_to_data_mem_and_MEMWB;
            wire [63:0] reg_2_from_EXMEM_to_datamem;
            wire [63:0] data_mem_to_MEMWB;
            wire [63:0] ins_from_EXMEM_to_MEMWB;
            wire control_Memwrite_from_EXMEM;
            wire control_Memread_from_EXMEM;
            wire control_branch_zero_from_EXMEM;
            wire ALUZero_from_EXMEM_to_branch;
            
            wire PCSrc;
            assign PCSrc = (ALUZero_from_EXMEM_to_branch & control_branch_zero_from_EXMEM);
            
            wire control_MemToReg_from_EXMEM_to_MEMWB;
            wire control_RegWrite_from_EXMEM_to_MEMWB;
            
            //Control lines from MEMWB to beginning
            wire control_MemToReg_from_MEMWB_to_mux3;
            wire control_RegWrite_from_MEMWB_to_registers;
            wire [63:0] MEMWB_to_write_reg;
            wire [63:0] alu_result_from_MEMWB_to_mux3;
            wire [63:0] datamem_from_MEMWB_to_mux3;
            wire [63:0] mux3_to_write_data;
            
            //Hazard
            wire Hazard_pc;
            wire Hazard_IFID;
            wire Hazard_control;
            
            //Forwarding
            wire [1:0] A_Forward;
            wire [1:0] B_Forward;
            wire [4:0] IDEX_forward_RN;
            wire [4:0] IDEX_forward_RM;
            
            //Control Mux wiring
            wire [1:0] control_ALU_op_from_mux;
            wire control_ALU_src_from_mux;
            wire control_Branch_zero_from_mux;
            wire control_Memwrite_from_mux;
            wire control_Memread__from_mux;
            wire control_MemToReg_from_mux;
            wire control_RegWrite_from_mux;
            
            //Alu Muxes
            wire [63:0] alu_mux_1_to_alu_1;
            wire [63:0] alu_mux_2_to_alu_2;
            

              always @ (*) begin
              ins_mem_31_to_0_from_ins_to_IFID = instruction_from_testbench;
              end
            
            //Add Instantiation
            add add_inst(.clk(clk), .signextend_in(signextend_from_IDEX_to_add_and_mux2), .pc_in(pc_from_IDEX_to_add), .add_out(add_to_EXMEM));
            //IFID Instantiation
            IFID IFID_inst(.clk(clk), .instruction31_0_in(ins_mem_31_to_0_from_ins_to_IFID), .Hazard_in(Hazard_IFID), .pc_in(pc_from_pc_to_IFID), .instruction31_0_out(ins_mem_31_to_0_from_IFID_to_all_things), .pc_out(pc_from_IFID_to_IDEX));
            
            //IDEX Instantiation
            IDEX IDEX_inst(.clk(clk), .pc_in(pc_from_IFID_to_IDEX), .read_data_1_in(reg_out_1_to_IDEX), .read_data_2_in(reg_out_2_to_IDEX), .sign_extend_in(signextend_to_IDEX), 
            .instruction_31_to_21_in(ins_mem_31_to_0_from_IFID_to_all_things[31:21]), .forwardRN_in(ins_mem_31_to_0_from_IFID_to_all_things[9:5]),
             .forwardRM_in(ins_mem_31_to_0_from_IFID_to_all_things[20:16]), .instruction_4_to_0_in(ins_mem_31_to_0_from_IFID_to_all_things[4:0]), .alu_op_in(control_ALU_op_from_mux),
             .ALUSrc_in(control_ALU_src_from_mux), .Branch_zero_in(control_Branch_zero_from_mux), .Memwrite_in(control_Memwrite_from_mux),
              .Memread_in(control_Memread__from_mux), .MemToReg_in(control_MemToReg_from_mux), .RegWrite_in(control_RegWrite_from_mux), .pc_out(pc_from_IDEX_to_add), .read_data_1_out(reg_out_1_from_IDEX_to_alu),
              .read_data_2_out(reg_out_2_from_IDEX_to_mux2_and_EXMEM), .sign_extend_out(signextend_from_IDEX_to_add_and_mux2), .instruction_31_to_21_out(IDEX_to_ALUControl[31:21]), 
              .instruction_4_to_0_out(IDEX_to_EXMEM[4:0]), .alu_op_out(control_ALU_op_from_IDEX), .ALUSrc_out(control_ALU_src_from_IDEX), .Branch_zero_out(control_Branch_zero_from_IDEX),
               .Memwrite_out(control_Memwrite_from_IDEX), .forwardRN_out(IDEX_forward_RN), .forwardRM_out(IDEX_forward_RM),  .Memread_out(control_Memread__from_IDEX), .MemToReg_out(control_MemToReg_from_IDEX), .RegWrite_out(control_RegWrite_from_IDEX));
           
            //EXMEM Instantiation
            
            EXMEM EXMEM_inst(.clk(clk), .add_result_in(add_to_EXMEM), .read_data_2_in(alu_mux_2_to_alu_2),
             .instruction_4_to_0_in(IDEX_to_EXMEM[4:0]), .ALU_result_in(alu_to_EXMEM), .ALU_zero_in(ALUZero_to_EXMEM),
            .Branch_zero_in(control_Branch_zero_from_IDEX), .Memwrite_in(control_Memwrite_from_IDEX), .Memread_in(control_Memread__from_IDEX),
            .MemToReg_in(control_MemToReg_from_IDEX), .RegWrite_in(control_RegWrite_from_IDEX), .add_result_out(add_from_EXMEM_to_mux4),
            .read_data_2_out(reg_2_from_EXMEM_to_datamem), .instruction_4_to_0_out(ins_from_EXMEM_to_MEMWB[4:0]), .ALU_result_out(alu_result_to_data_mem_and_MEMWB),
            .ALU_zero_out(ALUZero_from_EXMEM_to_branch), .Branch_zero_out(control_branch_zero_from_EXMEM), .Memwrite_out(control_Memwrite_from_EXMEM),
            .Memread_out(control_Memread_from_EXMEM), .MemToReg_out(control_MemToReg_from_EXMEM_to_MEMWB), .RegWrite_out(control_RegWrite_from_EXMEM_to_MEMWB));
            
            //MEMWB Instantiation
            
            MEMWB MEMWB_inst(.clk(clk), .RegWrite_in(control_RegWrite_from_EXMEM_to_MEMWB), .MemToReg_in(control_MemToReg_from_EXMEM_to_MEMWB),
            .data_memory_in(datamemreaddata_to_mux3), .alu_result_in(alu_result_to_data_mem_and_MEMWB), .instruction_4_to_0_in(ins_from_EXMEM_to_MEMWB[4:0]),
            .RegWrite_out(control_RegWrite_from_MEMWB_to_registers), .MemToReg_out(control_MemToReg_from_MEMWB_to_mux3), .data_memory_out(datamem_from_MEMWB_to_mux3),
            .alu_result_out(alu_result_from_MEMWB_to_mux3), .instruction_4_to_0_out(MEMWB_to_write_reg[4:0]));
            
            
            //ALU Instantiation
            Alu alu_inst (.clk(clk), .readdata1(alu_mux_1_to_alu_1), .main_aluinput2(mux2_to_alu), .ALU(alu_control_to_alu), .y(alu_to_EXMEM), .z(ALUZero_to_EXMEM));
            
            always @ (*) begin
            mainalu_to_datamemreaddata = alu_result_to_data_mem_and_MEMWB;
            readdata2_to_datamemwritedata = reg_2_from_EXMEM_to_datamem;
            memwrite = control_Memwrite_from_EXMEM;
            memread = control_Memread_from_EXMEM;
            end
            
            //Control instantiation 
            Control control_inst
            (.clk(clk), .opcode(ins_mem_31_to_0_from_IFID_to_all_things[31:21]), .branch(control_Branch_zero_from_IFID), .memread(control_Memread__from_IFID), .memtoreg(control_MemToReg_from_IFID),
            .aluop(control_ALU_op_from_IFID), .memwrite(control_Memwrite_from_IFID), .alusrc(control_ALU_src_from_IFID), .regwrite(control_RegWrite_from_IFID));
           
           //Mux1 instantiation 
            mux1 mux1_inst
            (.clk(clk), .instruction20_16(ins_mem_31_to_0_from_IFID_to_all_things[20:16]), 
            .instruction4_0(ins_mem_31_to_0_from_IFID_to_all_things[4:0]), 
            .reg2loc(ins_mem_31_to_0_from_IFID_to_all_things[28]), 
            .readregaddr2(mux1_to_read_reg_2));
            
            //Mux2 instantiation 
            mux2 mux2_inst
            (.clk(clk), .readdata2(alu_mux_2_to_alu_2), .extended(signextend_from_IDEX_to_add_and_mux2), .alusrc(control_ALU_src_from_IDEX), .main_aluinput2(mux2_to_alu));
            
            //Mux3 instantiation 
            mux3 mux3_inst
            (.clk(clk), .datamem_readdata(datamem_from_MEMWB_to_mux3), .y(alu_result_from_MEMWB_to_mux3), .memtoreg(control_MemToReg_from_MEMWB_to_mux3), .writedata(mux3_to_write_data));
            
            //Mux4 instantiation 
            mux4 mux4_inst
            (.clk(clk), .reset(reset), .pc_output(pc_from_pc_to_IFID),.extended(add_from_EXMEM_to_mux4),.cbz(PCSrc),.pc(mux4_to_pcinput));
           
           //Program counter instantiation 
            always@(posedge clk)begin
            pcoutput_to_testbench=mux4_to_pcinput;
            end
            
            //Program counter instantiation 
            pc pc_inst (.clk(clk), .reset(reset), .pc_input(mux4_to_pcinput), .hazard(Hazard_pc), .pc_output(pc_from_pc_to_IFID));
            
            //Register instantiation 
            registerfile reg_inst
            (.readregaddr1(ins_mem_31_to_0_from_IFID_to_all_things[9:5]),.readregaddr2(mux1_to_read_reg_2),.writeregaddr(MEMWB_to_write_reg[4:0]),
            .writedata(mux3_to_write_data),.readdata1(reg_out_1_to_IDEX),.readdata2(reg_out_2_to_IDEX),.reset(reset),.clk(clk),.regwrite(control_RegWrite_from_MEMWB_to_registers));
            
            //Signextend instantiation 
            signextend extend_inst (.unextended(ins_mem_31_to_0_from_IFID_to_all_things), .extended(signextend_to_IDEX));
            
            //ALU control instantiation 
            alu_control alucontrol_inst (.clk(clk), .aluop(control_ALU_op_from_IDEX), .instruction31_21(IDEX_to_ALUControl[31:21]), .alu_controlline(alu_control_to_alu));
            
            //Forwarding instantiation
            ForwardingUnit ForwardingUnit_inst (.EXRN_in(IDEX_forward_RN), .EXRM_in(IDEX_forward_RM), .MEMRD_in(ins_from_EXMEM_to_MEMWB[4:0]),
             .WBRD_in(MEMWB_to_write_reg[4:0]), .MEM_regwrite_in(control_RegWrite_from_EXMEM_to_MEMWB),
              .WB_regwrite_in(control_RegWrite_from_MEMWB_to_registers), .ForwardA(A_Forward), .ForwardB(B_Forward));
            
            
            //Hazard instantiation
            Hazard Hazard_inst(.EXMEMREAD_in(control_Memread__from_IDEX), .EXRD_in(IDEX_to_EXMEM[4:0]), .ID_PC_in(pc_from_IFID_to_IDEX),
             .ID_INS_in(ins_mem_31_to_0_from_IFID_to_all_things), .IFID_write_out(Hazard_IFID), .PC_write_out(Hazard_pc), .CONTROLMUX_out(Hazard_control));
            
            //Control Mux instantiation
            ControlMux ControlMux_inst(.Control_Mux_aluop_in(control_ALU_op_from_IFID),
        .Control_Mux_alusrc_in(control_ALU_src_from_IFID),
        .Control_Mux_memtoreg_in(control_MemToReg_from_IFID),
        .Control_Mux_regwrite_in(control_RegWrite_from_IFID),
        .Control_Mux_memread_in(control_Memread__from_IFID),
        .Control_Mux_memwrite_in(control_Memwrite_from_IFID),
        .Control_Mux_branch_in(control_Branch_zero_from_IFID),
        .Control_Mux_in(Hazard_control),
        .Control_Mux_aluop_out(control_ALU_op_from_mux),
        .Control_Mux_alusrc_out(control_ALU_src_from_mux),
        .Control_Mux_memtoreg_out(control_MemToReg_from_mux),
        .Control_Mux_regwrite_out(control_RegWrite_from_mux),
        .Control_Mux_memread_out(control_Memread__from_mux),
        .Control_Mux_memwrite_out(control_Memwrite_from_mux),
        .Control_Mux_branch_out(control_Branch_zero_from_mux));
        
        
        ForwardALUMux ForwardALUMUX_inst1(.reg_ex_in(reg_out_1_from_IDEX_to_alu), .reg_wb_in(mux3_to_write_data),
         .reg_mem_in(reg_2_from_EXMEM_to_datamem), .forward_control_in(A_Forward), .ForwardALU_Mux_out(alu_mux_1_to_alu_1));
        
        ForwardALUMux ForwardALUMUX_inst2(.reg_ex_in(reg_out_2_from_IDEX_to_mux2_and_EXMEM), .reg_wb_in(mux3_to_write_data),
         .reg_mem_in(reg_2_from_EXMEM_to_datamem), .forward_control_in(B_Forward), .ForwardALU_Mux_out(alu_mux_2_to_alu_2));
        
    endmodule
    
    module ForwardingUnit(
    input [4:0] EXRN_in,
    input [4:0] EXRM_in,
    input [4:0] MEMRD_in,
    input [4:0] WBRD_in,
    input MEM_regwrite_in,
    input WB_regwrite_in,
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
    );
    
    always@(*)begin
    
    if((WB_regwrite_in == 1'b1) && (WBRD_in !== 31) && (WBRD_in === EXRN_in))
        begin
            ForwardA <= 2'b01;
        end
    else if ((MEM_regwrite_in == 1'b1) && (MEMRD_in !== 31) && (MEMRD_in === EXRN_in))
        begin
            ForwardA <= 2'b10;
        end
    else
        begin
            ForwardA <= 2'b00;
        end
    
    
    if((WB_regwrite_in == 1'b1) && (WBRD_in !== 31) && (WBRD_in === EXRM_in))
        begin
            ForwardB <= 2'b01;
        end
    else if ((MEM_regwrite_in == 1'b1) && (MEMRD_in !== 31) && (MEMRD_in === EXRM_in))
        begin
            ForwardB <= 2'b10;
        end
    else
        begin
            ForwardB <= 2'b00;
        end
    
    end
    
    endmodule
    
    module Hazard(
        input EXMEMREAD_in,
        input [4:0] EXRD_in,
        input [63:0] ID_PC_in,
        input [31:0] ID_INS_in,
        output reg IFID_write_out,
        output reg PC_write_out,
        output reg CONTROLMUX_out
    
    );
    
    always@(*)begin
        if(EXMEMREAD_in == 1'b1 && ((EXRD_in === ID_INS_in[9:5]) || (EXRD_in === ID_INS_in[20:16])))
            begin
                IFID_write_out <= 1'b1;
                PC_write_out <= 1'b1;
                CONTROLMUX_out <= 1'b1;
            end
        else
            begin
                IFID_write_out <= 1'b0;
                PC_write_out <= 1'b0;
                CONTROLMUX_out <= 1'b0;            
            end
    
    end
    
    
    endmodule
    
    
    
    module IFID(
        input clk, 
        input [31:0] instruction31_0_in, //Coming from Instruction memory
        input [63:0] pc_in, //Program counter
        input Hazard_in,
        output reg [31:0] instruction31_0_out, 
        output reg [63:0] pc_out
    );
    
    always@(posedge clk) begin
    if(Hazard_in !== 1'b1)
        begin
            instruction31_0_out <= instruction31_0_in;
            pc_out <= pc_in;
        end
    end
    
    endmodule
    
    module IDEX(
        input clk,
        input [63:0] pc_in,
        input [63:0] read_data_1_in,
        input [63:0] read_data_2_in,
        input [63:0] sign_extend_in,
        input [10:0] instruction_31_to_21_in,
        input [4:0] instruction_4_to_0_in,
        input [1:0] alu_op_in,
        input ALUSrc_in,
        input Branch_zero_in,
        input Memwrite_in,
        input Memread_in,
        input MemToReg_in,
        input RegWrite_in,
        input [4:0] forwardRN_in,
        input [4:0] forwardRM_in,
        output reg [63:0] pc_out,
        output reg [63:0] read_data_1_out,
        output reg [63:0] read_data_2_out,
        output reg [63:0] sign_extend_out,
        output reg [10:0] instruction_31_to_21_out,
        output reg [4:0] instruction_4_to_0_out,
        output reg [1:0] alu_op_out,
        output reg ALUSrc_out,
        output reg Branch_zero_out,
        output reg Memwrite_out,
        output reg Memread_out,
        output reg MemToReg_out,
        output reg RegWrite_out,
        output reg [4:0] forwardRN_out,
        output reg [4:0] forwardRM_out
    );
    
    always@(posedge clk) begin
    //Control Parts for between ID/EX and EX/MEM
    alu_op_out <= alu_op_in;
    ALUSrc_out <= ALUSrc_in;
    //Control Parts for between EX/MEM and MEM/WB
    Branch_zero_out <= Branch_zero_in;
    Memwrite_out <= Memwrite_in;
    Memread_out <= Memread_in;
    //Control Parts for between MEM/WB and end
    MemToReg_out <= MemToReg_in;
    RegWrite_out <= RegWrite_in;
    //Other parts
    pc_out <= pc_in;
    read_data_1_out <= read_data_1_in;
    read_data_2_out <= read_data_2_in;
    sign_extend_out <= sign_extend_in;
    instruction_31_to_21_out <= instruction_31_to_21_in;
    instruction_4_to_0_out <= instruction_4_to_0_in;
    
    forwardRN_out <= forwardRN_in;
    forwardRM_out <= forwardRM_in;
    
    end
    endmodule
    
    module EXMEM(
    input clk,
    input [63:0] add_result_in,
    input [63:0] read_data_2_in,
    input [4:0] instruction_4_to_0_in,
    input [63:0] ALU_result_in,
    input ALU_zero_in,
    input Branch_zero_in,
    input Memwrite_in,
    input Memread_in,
    input MemToReg_in,
    input RegWrite_in,
    output reg [63:0] add_result_out,
    output reg [63:0] read_data_2_out,
    output reg [4:0] instruction_4_to_0_out,
    output reg [63:0] ALU_result_out,
    output reg ALU_zero_out,
    output reg Branch_zero_out,
    output reg Memwrite_out,
    output reg Memread_out,
    output reg MemToReg_out,
    output reg RegWrite_out
    );
    
    always@(posedge clk) begin
    //Control Parts for between EX/MEM and MEM/WB
    Branch_zero_out <= Branch_zero_in;
    Memwrite_out <= Memwrite_in;
    Memread_out <= Memread_in;
    //Control Parts for between MEM/WB and end
    MemToReg_out <= MemToReg_in;
    RegWrite_out <= RegWrite_in;
    //Other parts
    add_result_out <= add_result_in;
    read_data_2_out <= read_data_2_in;
    instruction_4_to_0_out <= instruction_4_to_0_in;
    ALU_result_out <= ALU_result_in;
    ALU_zero_out <= ALU_zero_in;
    
    end
    
    endmodule
    
    module MEMWB(
    input clk,
    input RegWrite_in,
    input MemToReg_in,
    input [63:0] data_memory_in,
    input [63:0] alu_result_in,
    input [4:0] instruction_4_to_0_in,
    output reg RegWrite_out,
    output reg MemToReg_out,
    output reg [63:0] data_memory_out,
    output reg [63:0] alu_result_out,
    output reg [4:0] instruction_4_to_0_out
    );
    
    always@(posedge clk) begin
    //Control Parts
    RegWrite_out <= RegWrite_in;
    MemToReg_out <= MemToReg_in;
    //Other parts
    data_memory_out <= data_memory_in;
    alu_result_out <= alu_result_in;
    instruction_4_to_0_out <= instruction_4_to_0_in;
    end
    
    endmodule
    
    module Alu(
            input clk,
            input [63:0] readdata1,
            input [63:0] main_aluinput2,
            input [3:0] ALU,
            output reg [63:0] y,
            output reg z
            );
                always@(*)
                begin
                    case(ALU)
                    4'b0000: assign y = readdata1 & main_aluinput2;
                    4'b0001: assign y = readdata1 | main_aluinput2;
                    4'b0010: assign y = readdata1 + main_aluinput2;
                    4'b0110: assign y = readdata1 - main_aluinput2;
                    4'b0111: assign y = main_aluinput2 ;
                    4'b1100: assign y = ~(readdata1 | main_aluinput2);
                    default: assign y = 64'bxxxxxxxx;
                    endcase
                    
                if (y == 0)
                    begin
                     z = 1'b1;
                     end              
                else 
                    begin
                     z = 1'b0;
                    end
                end
    endmodule
    
    
    module Control(
        input clk,
        input [10:0] opcode,
        output reg [1:0] aluop,
        output reg alusrc,
        output reg memtoreg,
        output reg regwrite,
        output reg memread,
        output reg memwrite,
        output reg branch
                    );
                        always@(opcode) begin
                        if (opcode[10:3]==8'b10110100) begin //B
                        alusrc<=1'b0;
                        regwrite<=1'b0;
                        memread<=1'b0;
                        memwrite<=1'b0;
                        branch<=1'b1;
                        aluop<=2'b01;
                        
                        end
        
                        else
                            case(opcode)
                            
                            11'b10001011000: begin //ADD
                            alusrc<=1'b0;
                            memtoreg<=1'b0;
                            regwrite<=1'b1;
                            memread<=1'b0;
                            memwrite<=1'b0;
                            branch<=1'b0;
                            aluop<=2'b10;
                            end
                        
                            11'b11001011000: begin //SUB
                            alusrc<=1'b0;
                            memtoreg<=1'b0;
                            regwrite<=1'b1;
                            memread<=1'b0;
                            memwrite<=1'b0;
                            branch<=1'b0;
                            aluop<=2'b10;
                            end
                        
                            11'b10001010000: begin//AND
                            alusrc<=1'b0;
                            memtoreg<=1'b0;
                            regwrite<=1'b1;
                            memread<=1'b0;
                            memwrite<=1'b0;
                            branch<=1'b0;
                            aluop<=2'b10;
                            end
                        
                            11'b10101010000: begin //ORR
                            alusrc<=1'b0;
                            memtoreg<=1'b0;
                            regwrite<=1'b1;
                            memread<=1'b0;
                            memwrite<=1'b0;
                            branch<=1'b0;
                            aluop<=2'b10;
                            end
                        
                            11'b11111000010: begin //LDUR
                            alusrc<=1'b1;
                            memtoreg<=1'b1;
                            regwrite<=1'b1;
                            memread<=1'b1;
                            memwrite<=1'b0;
                            branch<=1'b0;
                            aluop<=2'b00;
                            end
                        
                            11'b11111000000:begin //STUR
                            alusrc<=1'b1;
                            regwrite<=1'b0;
                            memread<=1'b0;
                            memwrite<=1'b1;
                            branch<=1'b0;
                            aluop<=2'b00;
                            end
                        endcase
                    end
    endmodule
    
    module ControlMux
    (
        input [1:0] Control_Mux_aluop_in,
        input Control_Mux_alusrc_in,
        input Control_Mux_memtoreg_in,
        input Control_Mux_regwrite_in,
        input Control_Mux_memread_in,
        input Control_Mux_memwrite_in,
        input Control_Mux_branch_in,
        input Control_Mux_in,
        output reg [1:0] Control_Mux_aluop_out,
        output reg Control_Mux_alusrc_out,
        output reg Control_Mux_memtoreg_out,
        output reg Control_Mux_regwrite_out,
        output reg Control_Mux_memread_out,
        output reg Control_Mux_memwrite_out,
        output reg Control_Mux_branch_out
    );
    
    always@(*) begin
    
        if(Control_Mux_in === 1'b1)
            begin
                Control_Mux_aluop_out <= 2'b00;
                Control_Mux_alusrc_out <= 1'b0;
                Control_Mux_memtoreg_out <= 1'b0;
                Control_Mux_regwrite_out <= 1'b0;
                Control_Mux_memread_out <= 1'b0;
                Control_Mux_memwrite_out <= 1'b0;
                Control_Mux_branch_out <= 1'b0;
            end
            
         else
            begin
                Control_Mux_aluop_out <= Control_Mux_aluop_in;
                Control_Mux_alusrc_out <= Control_Mux_alusrc_in;
                Control_Mux_memtoreg_out <= Control_Mux_memtoreg_in;
                Control_Mux_regwrite_out <= Control_Mux_regwrite_in;
                Control_Mux_memread_out <= Control_Mux_memread_in;
                Control_Mux_memwrite_out <= Control_Mux_memwrite_in;
                Control_Mux_branch_out <= Control_Mux_branch_in;
            end
    
    
    end
    
    endmodule
    
    module ForwardALUMux
    (
        input [63:0] reg_ex_in,
        input [63:0] reg_wb_in,
        input [63:0] reg_mem_in,
        input [1:0] forward_control_in,
        output reg [63:0]  ForwardALU_Mux_out
    );
    
    
    always@(*) begin
        if(forward_control_in == 2'b01)
            begin
                ForwardALU_Mux_out <= reg_wb_in;
            end
        else if(forward_control_in == 2'b10)
            begin
                ForwardALU_Mux_out <= reg_mem_in;
            end
        else
            begin
                ForwardALU_Mux_out <= reg_ex_in;
            end
    end
    
    
    endmodule
    
    module mux1(
        input clk,
        input [4:0] instruction20_16,
        input [4:0] instruction4_0,
        input reg2loc, //In this its instruction[28]
        output reg [4:0] readregaddr2
        );
        always @(instruction20_16, instruction4_0, reg2loc) begin
                case(reg2loc)
                    1'b0:readregaddr2=instruction20_16;
                    1'b1:readregaddr2=instruction4_0;
                endcase
        end
    endmodule
    
    module mux2(
        input clk,
        input [63:0] readdata2,
        input [63:0] extended,
        input alusrc,
        output reg [63:0] main_aluinput2
        );
            always @(readdata2, extended, alusrc) begin
                case(alusrc)
                    1'b0:main_aluinput2= readdata2;
                    1'b1:main_aluinput2= extended;
                endcase
            end
    endmodule
    
    module mux3(
        input clk,
        input memtoreg,
        input [63:0] y,
        input [63:0] datamem_readdata,
        output reg [63:0] writedata
                );
        always @(*) begin
            case(memtoreg)
                1'b1: writedata=datamem_readdata;
                1'b0: writedata=y;
            endcase
        end
    endmodule
    
    module mux4(
        input clk,
        input reset,
        input cbz,
        input [63:0] pc_output,
        input [63:0] extended,
        output reg [63:0] pc
            );
            always @(posedge reset) begin
            pc=0;
            end
            
            always @(pc_output,extended) begin
                case(cbz)
                    1'b1: pc = (extended<<2)+pc_output;
                    1'b0: pc = pc_output;
            endcase
            
        end
    endmodule

    
    module add(
    input clk,
    input [63:0] signextend_in,
    input [63:0] pc_in,
    output reg [63:0] add_out
    );
    
     always @(signextend_in,pc_in) begin
        add_out = (signextend_in<<2) + pc_in;
    end
    
    endmodule
    

    
module pc(
            input clk,
            input reset,
            input [63:0] pc_input,
            input hazard,
            output reg [63:0] pc_output
                );
                
                always @(posedge reset)begin
                    if(hazard !== 1'b1)
                    begin
                    pc_output <= 0;
                    end
                end
                
                always @(posedge clk)begin
                    if(hazard !== 1'b1)
                    begin
                    pc_output=pc_input+4;
                    end
                end
                
                
        endmodule
        
module registerfile (
            input reset,
            input clk,
            input regwrite,
            input [4:0] readregaddr1,readregaddr2,
            input [63:0] writedata,
            input [4:0] writeregaddr,
            output reg [63:0] readdata1,readdata2
                            );
        reg [63:0] regs[31:0];//Creates the 32,64-bit registers
        integer i;
        
        initial begin
            for(i=0;i<64;i=i+1) begin
            regs[i] <= i;
        end
    end
        always@(readregaddr1, readregaddr2) begin //for read
            readdata1= regs[readregaddr1];
            readdata2= regs[readregaddr2];
        
        if(regwrite == 1'b1)begin
                   regs[writeregaddr] = writedata;
            end
        end
    endmodule
    
    module signextend(
        input [31:0] unextended,
        output reg [63:0] extended
                    );
                    reg signed [51:0] temp;
            always@(unextended) begin
                if (unextended[31:24]==8'b10110100) begin
                        extended [63:19]= {45{unextended[23]}};
                        extended [18:0]= unextended[23:5];
                        
                        end
                                      
                else begin
                
                        extended[63:9]={55{unextended[20]}};
                        extended[8:0]=unextended[20:12];
                        
                    end
                end
            endmodule
            
    module alu_control(
            input clk,
            input[1:0] aluop,
            input [10:0] instruction31_21,
            output reg [3:0] alu_controlline
                        );
                        
            always@(aluop, instruction31_21)begin
                case(aluop)
                    2'b00 : alu_controlline=4'b0010;
                    2'b01 : alu_controlline=4'b0111;
                    2'b10 : begin
                        if(instruction31_21==11'b10001011000)
                                alu_controlline=4'b0010;
                        else if(instruction31_21==11'b11001011000)
                                alu_controlline=4'b0110;
                        else if(instruction31_21==11'b10001010000)
                                alu_controlline=4'b0000;
                        else if(instruction31_21==11'b10101010000)
                                alu_controlline=4'b0001;
                        end
                   default : alu_controlline = 4'bxxxx;
                endcase
            end
    endmodule
    
    module datamemory(
        input clk,
        input [63:0] main_aluresult,
        input [63:0] datamem_writedata,
        input memwrite,
        input memread,
        output reg [63:0] datamem_readdata
                    );
                    
        integer i=0;
        reg [63:0] storage[31:0];
        
            initial begin
                for(i=0;i<64;i=i+1) begin
                    storage[i]<=2*i;
            end
        end
        
        always@(*) begin
            if(memwrite==1'b1)begin
                storage[main_aluresult]=datamem_writedata;
            end
            
            if(memread==1'b1) begin
                datamem_readdata= storage[main_aluresult];
            end
        end
        
endmodule

module instructionmemory(
    input clk,
    input [63:0] pc,
    output reg [31:0] instruction31_0
    );
    reg [31:0] instructions[63:0];
    always@(pc) begin
    //Instructions
      instructions[0]  = 32'b00000000000000000000000000000000;
      instructions[4]  = 32'b10001011000001000000000010100011; // ADD      x3, x5, x4
      instructions[8]  = 32'b10001011000001010000000001101001; // ADD      x9, x3, x2 Look at this again
      instructions[12] = 32'b11001011000001100000000000100001; // SUB      x1, x1, x6
      instructions[16] = 32'b10001010000010100000001111000110; // AND      x6, x30, x10
      instructions[20] = 32'b11001011000001110000000011001110; // SUB      x14, x6, x7
      instructions[24] = 32'b10101010000001100000000010101000; // ORR      x8, x5, x6
      instructions[28] = 32'b11111000010000000100000100001010; // LDUR     x10, [x8, #4]
      instructions[32] = 32'b10001010000000010000000101001111; // AND      x15, x10, x1
      instructions[36] = 32'b11111000000000001000000101101100; // STUR     x12, [ x11, #8]
      instructions[40] = 32'b10110100000000000000000000000000; // CBZ      x0, #0
      
        end
            always@(pc) begin
                instruction31_0 = instructions[pc];
            end
endmodule