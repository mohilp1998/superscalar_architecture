library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pkg is
  type slv8_array_t is array (natural range <>) of std_logic_vector(7 downto 0);
  type slv4_array_t is array (natural range <>) of std_logic_vector(3 downto 0);
  type slv6_array_t is array (natural range <>) of std_logic_vector(5 downto 0);
  type slv16_array_t is array (natural range <>) of std_logic_vector(15 downto 0);
  type slv_array_t is array (natural range <>) of std_logic;
  type slv3_array_t is array (natural range <>) of std_logic_vector(2 downto 0);
  type slv2_array_t is array (natural range <>) of std_logic_vector(1 downto 0);
  type slv6_int_array_t is array (natural range <>) of integer range 0 to 9;
end package;

package body pkg is
end package body;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.pkg.all;




entity top_level is 

port (

   top_clock:in std_logic;
   system_reset:in std_logic;-----------------------------------active high system reset
   r0_out: out std_logic_vector(15 downto 0);
   r1_out: out std_logic_vector(15 downto 0);
   r2_out: out std_logic_vector(15 downto 0);
   r3_out: out std_logic_vector(15 downto 0);
   r4_out: out std_logic_vector(15 downto 0);
   r5_out: out std_logic_vector(15 downto 0);
   r6_out: out std_logic_vector(15 downto 0);
   r7_out: out std_logic_vector(15 downto 0);
   curr_pc: out std_logic_vector(15 downto 0)
   );

end entity;


architecture struct of top_level is

component memory_code is

port  (clk : in std_logic;  
        we  : in std_logic;   
        a   : in std_logic_vector(15 downto 0);   
        di  : in std_logic_vector(15 downto 0);   
        do  : out std_logic_vector(31 downto 0)); 
 end component memory_code;

component fetch is

port (
	clk: in std_logic;
	Mem_in: in std_logic_vector(31 downto 0);
	PC_in: in std_logic_vector(15 downto 0);

	stall_in: in std_logic;
	instr_invalidate_in: in std_logic;
	------------------------------------------------------------
	inst_1_valid: out std_logic;
	inst_2_valid: out std_logic;
	Instr1: out std_logic_vector(15 downto 0);
	Instr2: out std_logic_vector(15 downto 0);
	PC: out std_logic_vector(15 downto 0)
  ) ;

  end component fetch;

component add_pc is
  	port (
  		PC_in:in std_logic_vector(15 downto 0);
  		PC_out:out std_logic_vector(15 downto 0)
  		
  	);
  end component add_pc;  

  component decode is

   port (
	clk: in std_logic;
	reset:in std_logic;
	inst_1_valid_in: in std_logic;
	inst_2_valid_in: in std_logic;
	Instr1_in: in std_logic_vector(15 downto 0);
	Instr2_in: in std_logic_vector(15 downto 0);
	PC_in: in std_logic_vector(15 downto 0);
	Nxt_PC_in: in std_logic_vector(15 downto 0);


	br_inst_valid_in: in std_logic;
	br_btag_in: in std_logic_vector(2 downto 0);
	br_self_tag_in: in std_logic_vector(2 downto 0);

	stall_in: in std_logic;
	instr_invalidate_in: in std_logic;
	------------------------------------------------------------
	--Instruction 1
	I1_valid: out std_logic;
	I1_op_code: out std_logic_vector(3 downto 0);
	I1_op_cz: out std_logic_vector(1 downto 0);
	I1_dest_code: out std_logic_vector(2 downto 0);
	I1_operand_1_code: out std_logic_vector(2 downto 0);
	I1_operand_2_code: out std_logic_vector(2 downto 0);
	I1_Imm: out std_logic_vector(15 downto 0);
	I1_PC: out std_logic_vector(15 downto 0);
	I1_Nxt_PC: out std_logic_vector(15 downto 0);
	I1_BTAG: out std_logic_vector(2 downto 0);
	I1_self_tag: out std_logic_vector(2 downto 0);

	--Instruction 2
	I2_valid: out std_logic;
	I2_op_code: out std_logic_vector(3 downto 0);
	I2_op_cz: out std_logic_vector(1 downto 0);
	I2_dest_code: out std_logic_vector(2 downto 0);
	I2_operand_1_code: out std_logic_vector(2 downto 0);
	I2_operand_2_code: out std_logic_vector(2 downto 0);
	I2_Imm: out std_logic_vector(15 downto 0);
	I2_PC: out std_logic_vector(15 downto 0);
	I2_Nxt_PC: out std_logic_vector(15 downto 0);
	I2_BTAG: out std_logic_vector(2 downto 0);
	I2_self_tag: out std_logic_vector(2 downto 0);

	-----------------------------------
	stall_out: out std_logic
  );

   end component decode;


   component bit16_2x1 is 

    port ( c_0 : in  STD_LOGIC;
           d_0   : in  std_logic_vector(15 downto 0);
           d_1   : in  std_logic_vector(15 downto 0);
           o   : out std_logic_vector(15 downto 0));
    end component bit16_2x1;
    

    component bit1_2x1 is 

     port ( c_0 : in  STD_LOGIC;
           d_0   : in  std_logic;
           d_1   : in  std_logic;
           o   : out std_logic);


    end component bit1_2x1;


    component reservation_state is

     port (instr1_valid_in:in std_logic;
 	   op_code1_in:in std_logic_vector(3 downto 0);
 	   op_cz1_in: in std_logic_vector(1 downto 0);
 	   destn_code1_in:in std_logic_vector(2 downto 0);
 	   opr1_code1_in:in std_logic_vector(2 downto 0);
 	   opr2_code1_in:in std_logic_vector(2 downto 0);
		opr3_code1_in:in std_logic_vector(2 downto 0);
 	   curr_pc1_in: in std_logic_vector(15 downto 0);
 	   next_pc1_in:in std_logic_vector(15 downto 0);
 	   imm1_in:in std_logic_vector(15 downto 0);
 	   btag1_in:in std_logic_vector(2 downto 0);
 	   self1_tag_in:in std_logic_vector(2 downto 0);

       instr2_valid_in:in std_logic;
 	   op_code2_in:in std_logic_vector(3 downto 0);
 	   op_cz2_in: in std_logic_vector(1 downto 0);
 	   destn_code2_in:in std_logic_vector(2 downto 0);
 	   opr1_code2_in:in std_logic_vector(2 downto 0);
 	   opr2_code2_in:in std_logic_vector(2 downto 0);
		opr3_code2_in:in std_logic_vector(2 downto 0);
 	   curr_pc2_in: in std_logic_vector(15 downto 0);
 	   next_pc2_in:in std_logic_vector(15 downto 0);
 	   imm2_in:in std_logic_vector(15 downto 0);
 	   btag2_in:in std_logic_vector(2 downto 0);
 	   self2_tag_in:in std_logic_vector(2 downto 0);

       alu_valid_done1_in:in std_logic;
       alu_done_number1:in std_logic_vector(3 downto 0);

       alu_valid_done2_in:in std_logic;
       alu_done_number2:in std_logic_vector(3 downto 0);

       ls_valid_done_in:in std_logic;
       ls_done_number:in std_logic_vector(3 downto 0);

       jmp_valid_done_in:in std_logic;
       jmp_done_number:in std_logic_vector(3 downto 0);

         

 	   reset_system:in std_logic;--to be done at start of cycle general reset which assigns all registers its original values
 	   --reset_system_mapping:in std_logic;--to be used to clear all assigned ARF and RRF's 
       clk_input:in std_logic;
       stall_reservation_update:in std_logic;--no data comes to reservation station if becomes 1


       broadcast1_rename_in:in std_logic_vector(5 downto 0);--refers to rename register broadcasted
       broadcast1_orig_destn_in:in std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast1_data_in:in std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
       broadcast1_valid_in: in std_logic;--refers whether broadcasted data is valid or not

       broadcast1_c_flag_in:in std_logic;
       broadcast1_c_flag_rename_in:in std_logic_vector(2 downto 0);
       broadcast1_c_flag_valid_in:in std_logic;

       broadcast1_z_flag_in:in std_logic;
       broadcast1_z_flag_rename_in:in std_logic_vector(2 downto 0);
       broadcast1_z_flag_valid_in:in std_logic;

       broadcast1_btag_in: in std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies
       


       broadcast2_rename_in:in std_logic_vector(5 downto 0);--refers to rename register broadcasted
       broadcast2_orig_destn_in:in std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast2_data_in:in std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
       broadcast2_valid_in: in std_logic;--refers whether broadcasted data is valid or not 
       

       broadcast2_c_flag_in:in std_logic;
       broadcast2_c_flag_rename_in:in std_logic_vector(2 downto 0);
       broadcast2_c_flag_valid_in:in std_logic;

       broadcast2_z_flag_in:in std_logic;
       broadcast2_z_flag_rename_in:in std_logic_vector(2 downto 0);
       broadcast2_z_flag_valid_in:in std_logic;

       broadcast2_btag_in:in std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies


       broadcast3_rename_in:in std_logic_vector(5 downto 0);--refers to rename register broadcasted
       broadcast3_orig_destn_in:in std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast3_data_in:in std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
       broadcast3_valid_in: in std_logic;--refers whether broadcasted data is valid or not 
       -- 
       broadcast3_btag_in:in std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies
       
       
       broadcast4_rename_in:in std_logic_vector(5 downto 0);--refers to rename register broadcasted
       broadcast4_orig_destn_in:in std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast4_data_in:in std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
       broadcast4_valid_in: in std_logic;--refers whether broadcasted data is valid or not 
       
       
       broadcast4_c_flag_in:in std_logic;
       broadcast4_c_flag_rename_in:in std_logic_vector(2 downto 0);
       broadcast4_c_flag_valid_in:in std_logic;

       broadcast4_z_flag_in:in std_logic;
       broadcast4_z_flag_rename_in:in std_logic_vector(2 downto 0);
       broadcast4_z_flag_valid_in:in std_logic;

       broadcast4_btag_in:in std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies

       branch_mispredict_broadcast_in:in std_logic_vector(1 downto 0); --00 implies no misprediction 01 implies first branch mispredicted 10 implies second branch mispredicted


       broadcast5_rename_in:in std_logic_vector(5 downto 0);
       broadcast5_orig_destn_in:in std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register 
       broadcast5_data_in:in std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
       broadcast5_valid_in: in std_logic;--refers whether broadcasted data is valid or not \
       broadcast5_btag_in:in std_logic_vector(2 downto 0);
       

       --entry in ROB output

       curr_pc1_rob_out:out std_logic_vector(15 downto 0);
       destn_code1_rob_out:out std_logic_vector(2 downto 0);
       op_code1_rob_out:out std_logic_vector(3 downto 0);
       destn_rename1_rob_out:out std_logic_vector(5 downto 0);
       destn_rename_c1_rob_out:out std_logic_vector(2 downto 0);
       destn_rename_z1_rob_out:out std_logic_vector(2 downto 0);

       curr_pc2_rob_out:out std_logic_vector(15 downto 0);
       destn_code2_rob_out:out std_logic_vector(2 downto 0);
       op_code2_rob_out:out std_logic_vector(3 downto 0);
       destn_rename2_rob_out:out std_logic_vector(5 downto 0);
       destn_rename_c2_rob_out:out std_logic_vector(2 downto 0);
       destn_rename_z2_rob_out:out std_logic_vector(2 downto 0);



       alu_instr_valid_out:out slv_array_t(0 to 9);
       alu_op_code_out:out slv4_array_t(0 to 9);
       alu_op_code_cz_out:out slv2_array_t(0 to 9);
       alu_destn_rename_code_out:out slv6_array_t(0 to 9);
       alu_operand1_out:out slv16_array_t(0 to 9);
       alu_valid1_out:out slv_array_t(0 to 9);

       alu_operand2_out:out slv16_array_t(0 to 9);
       alu_valid2_out:out slv_array_t(0 to 9);

       alu_operand3_out:out slv16_array_t(0 to 9);
       alu_valid3_out:out slv_array_t(0 to 9);

       alu_c_flag_out:out slv_array_t(0 to 9);
       alu_c_flag_rename_out:out slv3_array_t(0 to 9);
       alu_c_flag_valid_out:out slv_array_t(0 to 9);

       alu_z_flag_out:out slv_array_t(0 to 9);
       alu_z_flag_rename_out:out slv3_array_t(0 to 9);
       alu_z_flag_valid_out:out slv_array_t(0 to 9);

       alu_btag_out:out slv3_array_t(0 to 9);

       alu_orign_destn_out:out slv3_array_t(0 to 9);

       alu_curr_pc_out:out slv16_array_t(0 to 9);

       alu_scheduler_valid_out:out slv_array_t(0 to 9);       


       ls_instr_valid_out:out slv_array_t(0 to 9);
       ls_op_code_out:out slv4_array_t(0 to 9);
       --_op_code_cz_out:out slv2_array_t(0 to 9);
       ls_destn_rename_code_out:out slv6_array_t(0 to 9);
       ls_operand1_out:out slv16_array_t(0 to 9);
       ls_valid1_out:out slv_array_t(0 to 9);

       ls_operand2_out:out slv16_array_t(0 to 9);
       ls_valid2_out:out slv_array_t(0 to 9);


       ls_operand3_out:out slv16_array_t(0 to 9);--denotes which register to load onto or store from
       ls_valid3_out:out slv_array_t(0 to 9);

       
       ls_btag_out:out slv3_array_t(0 to 9);

       ls_orign_destn_out:out slv3_array_t(0 to 9);

       ls_curr_pc_out:out slv16_array_t(0 to 9);
       --ls_imm_out:out slv16_array_t(0 to 9);


       ls_scheduler_valid_out:out slv_array_t(0 to 9);



       jmp_instr_valid_out:out slv_array_t(0 to 9);
       jmp_op_code_out:out slv4_array_t(0 to 9);
       --_op_code_cz_out:out slv2_array_t(0 to 9);
       jmp_destn_rename_code_out:out slv6_array_t(0 to 9);
       jmp_operand1_out:out slv16_array_t(0 to 9);
       jmp_valid1_out:out slv_array_t(0 to 9);

       jmp_operand2_out:out slv16_array_t(0 to 9);
       jmp_valid2_out:out slv_array_t(0 to 9);


       jmp_operand3_out:out slv16_array_t(0 to 9);--denotes which register to load onto or store from
       jmp_valid3_out:out slv_array_t(0 to 9);

       
       jmp_btag_out:out slv3_array_t(0 to 9);

       jmp_orign_destn_out:out slv3_array_t(0 to 9);

       jmp_curr_pc_out:out slv16_array_t(0 to 9);
       --ls_imm_out:out slv16_array_t(0 to 9);


       jmp_scheduler_valid_out:out slv_array_t(0 to 9);
       jmp_next_pc_out:out slv16_array_t(0 to 9);

       jmp_self_tag_out:out slv3_array_t(0 to 9);



       halt_out:out std_logic--instr could not be written onto RS 
       -- 
       );

      end component;

-------------------------------------------------------------------------------------------------------------------------------------------------
component lw_sw_sch is
  port (  clk: in std_logic;
          reset: in std_logic;

          ls_instr_valid_in: in slv_array_t(0 to 9);
          ls_op_code_in: in slv4_array_t(0 to 9);
          ls_original_dest_in: in slv3_array_t(0 to 9);
          ls_rename_dest_in: in slv6_array_t(0 to 9);
          ls_operand_1_in: in slv16_array_t(0 to 9);
          ls_operand_1_valid_in: in slv_array_t(0 to 9);

          ls_operand_2_in: in slv16_array_t(0 to 9);
          ls_operand_2_valid_in: in slv_array_t(0 to 9);

          ls_operand_3_in: in slv16_array_t(0 to 9);
          ls_operand_3_valid_in: in slv_array_t(0 to 9);

          ls_pc_in: in slv16_array_t(0 to 9);
          ls_sch_valid_in: in slv_array_t(0 to 9);

          ls_btag_in: in slv3_array_t(0 to 9);

          ls_stall_in: in std_logic;
          --------------------------------------------------------------------------------
          -- Execute Pipepline output
          ls_instr_valid_out: out std_logic;
          ls_op_code_out: out std_logic_vector(3 downto 0);
          ls_original_dest_out: out std_logic_vector(2 downto 0);
          ls_rename_dest_out: out std_logic_vector(5 downto 0);
          ls_operand_1_out: out std_logic_vector(15 downto 0);
          ls_operand_2_out: out std_logic_vector(15 downto 0);
          ls_operand_3_out: out std_logic_vector(15 downto 0);
          ls_pc_out: out std_logic_vector(15 downto 0);
          ls_btag_out: out std_logic_vector(2 downto 0);

          --------------------------------------------------------------------------------
          -- Data going back to RS
          rs_ls_index_out: out std_logic_vector(3 downto 0);
          rs_ls_valid_out: out std_logic
          );
end component ; -- lw_sw_sch
-------------------------------------------------------------------------------------------------------------------------------------------------

component branch_sch is
  port (
    clk: in std_logic;
    reset: in std_logic;
    br_instr_valid_in: in slv_array_t(0 to 9);
    br_op_code_in: in slv4_array_t(0 to 9);
    br_original_dest_in: in slv3_array_t(0 to 9);
    br_rename_dest_in: in slv6_array_t(0 to 9);
    br_operand_1_in: in slv16_array_t(0 to 9);
    br_operand_1_valid_in: in slv_array_t(0 to 9);

    br_operand_2_in: in slv16_array_t(0 to 9);
    br_operand_2_valid_in: in slv_array_t(0 to 9);

    br_operand_3_in: in slv16_array_t(0 to 9);
    br_operand_3_valid_in: in slv_array_t(0 to 9);

    br_pc_in: in slv16_array_t(0 to 9);
    br_nxt_pc_in: in slv16_array_t(0 to 9);
    br_sch_valid_in: in slv_array_t(0 to 9);

    br_btag_in: in slv3_array_t(0 to 9);
    br_self_tag_in: in slv3_array_t(0 to 9);

    br_stall_in: in std_logic;
    -----------------------------------------------------------------------------------
    --Execute pipeline branch input
    br_instr_valid_out: out std_logic;
    br_op_code_out: out std_logic_vector(3 downto 0);
    br_original_dest_out: out std_logic_vector(2 downto 0);
    br_rename_dest_out: out std_logic_vector(5 downto 0);
    br_operand_1_out: out std_logic_vector(15 downto 0);--refers to Ra
    
    br_operand_2_out: out std_logic_vector(15 downto 0);--refers to Rb
    
    br_operand_3_out: out std_logic_vector(15 downto 0);--refers to immediate
    
    br_pc_out: out std_logic_vector(15 downto 0);
    br_nxt_pc_out: out std_logic_vector(15 downto 0);
    
    br_btag_out: out std_logic_vector(2 downto 0);
    br_self_tag_out: out std_logic_vector(2 downto 0);
    --------------------------------------------------------------------------------
    -- Data going back to RS
    rs_br_index_out: out std_logic_vector(3 downto 0);
    rs_br_valid_out: out std_logic
    );
end component ; -- branch_sch

-------------------------------------------------------------------------------------------------------------------------------------------------

component alu_sch is
  port (
    clk: in std_logic;
    reset: in std_logic;
    alu_instr_valid_in: in slv_array_t(0 to 9);
    alu_op_code_in: in slv4_array_t(0 to 9);
    alu_op_code_cz_in: in slv2_array_t(0 to 9);
    
    alu_original_dest_in: in slv3_array_t(0 to 9);
    alu_rename_dest_in: in slv6_array_t(0 to 9);
    
    alu_operand_1_in: in slv16_array_t(0 to 9);
    alu_operand_1_valid_in: in slv_array_t(0 to 9);

    alu_operand_2_in: in slv16_array_t(0 to 9);
    alu_operand_2_valid_in: in slv_array_t(0 to 9);

    alu_operand_3_in: in slv16_array_t(0 to 9);
    alu_operand_3_valid_in: in slv_array_t(0 to 9);

    alu_c_flag_in: in slv_array_t(0 to 9);
    alu_c_flag_rename_in: in slv3_array_t(0 to 9);

    alu_z_flag_in: in slv_array_t(0 to 9);
    alu_z_flag_rename_in: in slv3_array_t(0 to 9);

    alu_pc_in: in slv16_array_t(0 to 9);
    alu_sch_valid_in: in slv_array_t(0 to 9);

    alu_btag_in: in slv3_array_t(0 to 9);

    alu_stall_in: in std_logic;
    --------------------------------------------------------------------------------
    -- Execute Pipepline output
    alu_instr_valid_out_1: out std_logic;
    alu_op_code_out_1: out std_logic_vector(3 downto 0);
    alu_op_code_cz_out_1: out std_logic_vector(1 downto 0);
    
    alu_original_dest_out_1: out std_logic_vector(2 downto 0);
    alu_rename_dest_out_1: out std_logic_vector(5 downto 0);
    
    alu_operand_1_out_1: out std_logic_vector(15 downto 0);
    
    alu_operand_2_out_1: out std_logic_vector(15 downto 0);
    
    alu_operand_3_out_1: out std_logic_vector(15 downto 0);
    
    alu_c_flag_out_1: out std_logic;
    alu_c_flag_rename_out_1: out std_logic_vector(2 downto 0);

    alu_z_flag_out_1: out std_logic;
    alu_z_flag_rename_out_1: out std_logic_vector(2 downto 0);

    alu_pc_out_1: out std_logic_vector(15 downto 0);
    
    alu_btag_out_1: out std_logic_vector(2 downto 0);
    -------------------------------------------------------------------------------------------
    --2 copies as 2 pipelines
    alu_instr_valid_out_2: out std_logic;
    alu_op_code_out_2: out std_logic_vector(3 downto 0);
    alu_op_code_cz_out_2: out std_logic_vector(1 downto 0);
    
    alu_original_dest_out_2: out std_logic_vector(2 downto 0);
    alu_rename_dest_out_2: out std_logic_vector(5 downto 0);
    
    alu_operand_1_out_2: out std_logic_vector(15 downto 0);
    
    alu_operand_2_out_2: out std_logic_vector(15 downto 0);
    
    alu_operand_3_out_2: out std_logic_vector(15 downto 0);
    
    alu_c_flag_out_2: out std_logic;
    alu_c_flag_rename_out_2: out std_logic_vector(2 downto 0);

    alu_z_flag_out_2: out std_logic;
    alu_z_flag_rename_out_2: out std_logic_vector(2 downto 0);

    alu_pc_out_2: out std_logic_vector(15 downto 0);
    
    alu_btag_out_2: out std_logic_vector(2 downto 0);
    --------------------------------------------------------------------------------
    -- Data going back to RS
    rs_alu_index_1_out: out std_logic_vector(3 downto 0);
    rs_alu_valid_1_out: out std_logic;
    rs_alu_index_2_out: out std_logic_vector(3 downto 0);
    rs_alu_valid_2_out: out std_logic 
  );
end component ; -- alu_sch

-------------------------------------------------------------------------------------------------------------------------------------------------



  signal addr_to_mem:std_logic_vector(15 downto 0);
  signal code_mem:std_logic_vector(31 downto 0);
  --signal curr_pc_mem:std_logic_vector(15 downto 0);
  signal fetch_PC_plus_two:std_logic_vector(15 downto 0);--refers to fetch_pc_mem +2
  signal control_to_jmp:std_logic; --tells whether instr is jmp or not
  signal branch_predicted:std_logic_vector(15 downto 0);--tells us predicted branch from fetch
  signal next_pc_fetch_in:std_logic_vector(15 downto 0);--tells us whether to use pc+2 or predicted branch--to be written onto fetch register
  signal next_branch_fetch:std_logic_vector(15 downto 0);--tells us whether to use predicted or pc +2 
  --signal next_pc_mem:std_logic_vector(15 downto 0);--instr feteched next
  signal branch_mis_predicted:std_logic;--tells us to fetch branch instr from exec pipeline
  signal addr_exec:std_logic_vector(15 downto 0); --tells us the addr from exec pipeline

  signal stall_fetch_in:std_logic;--controlling the stopping of writing onto fetch state
  signal invalidate_fetch_in:std_logic;--invalidating the fetch register data
  signal instr1_fetch_valid:std_logic;--output of fetch state 1
  signal instr2_fetch_valid:std_logic;--output of fetch state 2
  signal instr1_fetch_out:std_logic_vector(15 downto 0);--output instr2 from fetch
  signal instr2_fetch_out:std_logic_vector(15 downto 0);--output instr2 from fetch

  signal fetch_pc_out: std_logic_vector(15 downto 0);--output pc from fetch
  

  signal stall_decode_in: std_logic; --stalls the deode stage fetch
  --signal
  signal decode_invalidate_in:std_logic;--invalidating all instr in decode state
  signal instr1_decode_valid:std_logic;
  
  signal instr1_decode_op_code:std_logic_vector(3 downto 0);
  signal instr1_decode_op_cz:std_logic_vector(1 downto 0);
  signal instr1_decode_destn_code:std_logic_vector(2 downto 0);
  signal instr1_decode_op1_code:std_logic_vector(2 downto 0);
  signal instr1_decode_op2_code:std_logic_vector(2 downto 0);
  signal instr1_decode_imm:std_logic_vector(15 downto 0);
  signal instr1_decode_PC:std_logic_vector(15 downto 0);
  signal instr1_decode_next_PC:std_logic_vector(15 downto 0);
  signal instr1_decode_btag:std_logic_vector(2 downto 0);
  signal instr1_decode_self_tag:std_logic_vector(2 downto 0);
  
  signal instr1_RS_valid_in:std_logic;


  signal instr2_decode_valid:std_logic;
  
  signal instr2_decode_op_code:std_logic_vector(3 downto 0);
  signal instr2_decode_op_cz:std_logic_vector(1 downto 0);
  signal instr2_decode_destn_code:std_logic_vector(2 downto 0);
  signal instr2_decode_op1_code:std_logic_vector(2 downto 0);
  signal instr2_decode_op2_code:std_logic_vector(2 downto 0);
  signal instr2_decode_imm:std_logic_vector(15 downto 0);
  signal instr2_decode_PC:std_logic_vector(15 downto 0);
  signal instr2_decode_next_PC:std_logic_vector(15 downto 0);
  signal instr2_decode_btag:std_logic_vector(2 downto 0);
  signal instr2_decode_self_tag:std_logic_vector(2 downto 0);
  
  signal instr2_RS_valid_in:std_logic;

  signal decode_stall_out:std_logic;


  signal broadcast_branch_decode_valid: std_logic; -----------------------------

  signal broadcast_branch_btag_in: std_logic_vector(2 downto 0);
  signal broadcast_branch_self_tag_in:std_logic_vector(2 downto 0);


--output signals from scheduler
 
  signal alu_valid_done1_RS:std_logic;
  signal alu_done_number1_RS:std_logic_vector(3 downto 0);
  
  signal alu_valid_done2_RS:std_logic;
  signal alu_done_number2_RS:std_logic_vector(3 downto 0);

  signal ls_valid_done_RS:std_logic;
  signal ls_done_number_RS:std_logic_vector(3 downto 0);

  signal jmp_valid_done_RS:std_logic;
  signal jmp_done_number_RS:std_logic_vector(3 downto 0);


  signal stall_reservation_center:std_logic; --signal used to control reservation center update



 --input signals from execution pipeline and after mem state
 
  
  signal broadcast1_rename: std_logic_vector(5 downto 0);--refers to rename register broadcasted
  signal broadcast1_orig_destn: std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
  signal broadcast1_data: std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
  signal broadcast1_valid: std_logic;--refers whether broadcasted data is valid or not

  signal broadcast1_c_flag: std_logic;
  signal broadcast1_c_flag_rename:std_logic_vector(2 downto 0);
  signal broadcast1_c_flag_valid: std_logic;

  signal broadcast1_z_flag: std_logic;
  signal broadcast1_z_flag_rename:std_logic_vector(2 downto 0);
  signal broadcast1_z_flag_valid: std_logic;

  signal broadcast1_btag: std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies
       


  signal broadcast2_rename: std_logic_vector(5 downto 0);--refers to rename register broadcasted
  signal broadcast2_orig_destn: std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
  signal broadcast2_data: std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
  signal broadcast2_valid: std_logic;--refers whether broadcasted data is valid or not 
       

  signal broadcast2_c_flag:std_logic;
  signal broadcast2_c_flag_rename:std_logic_vector(2 downto 0);
  signal broadcast2_c_flag_valid: std_logic;

  signal broadcast2_z_flag: std_logic;
  signal broadcast2_z_flag_rename: std_logic_vector(2 downto 0);
  signal broadcast2_z_flag_valid: std_logic;

  signal broadcast2_btag: std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies


  signal broadcast3_rename: std_logic_vector(5 downto 0);--refers to rename register broadcasted
  signal broadcast3_orig_destn: std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
  signal broadcast3_data: std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
  signal broadcast3_valid:  std_logic;--refers whether broadcasted data is valid or not 
       -- 
  signal broadcast3_btag: std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies
       
       
  signal broadcast4_rename: std_logic_vector(5 downto 0);--refers to rename register broadcasted
  signal broadcast4_orig_destn: std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
  signal broadcast4_data: std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
  signal broadcast4_valid: std_logic;--refers whether broadcasted data is valid or not 
       
       
  signal broadcast4_c_flag: std_logic;
  signal broadcast4_c_flag_rename: std_logic_vector(2 downto 0);
  signal broadcast4_c_flag_valid: std_logic;

  signal broadcast4_z_flag: std_logic;
  signal broadcast4_z_flag_rename: std_logic_vector(2 downto 0);
  signal broadcast4_z_flag_valid: std_logic;

  signal broadcast4_btag:std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies

  signal branch_mispredict_broadcast: std_logic_vector(1 downto 0); --00 implies no misprediction 01 implies first branch mispredicted 10 implies second branch mispredicted

  --if 

  signal broadcast5_rename: std_logic_vector(5 downto 0);
  signal broadcast5_orig_destn: std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register 
  signal broadcast5_data: std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
  signal broadcast5_valid: std_logic;--refers whether broadcasted data is valid or not \
  signal broadcast5_btag :std_logic_vector(2 downto 0);


  --output signals from Reservation center to ROB
  
  signal curr_pc1_rob: std_logic_vector(15 downto 0);
  signal destn_code1_rob: std_logic_vector(2 downto 0);
  signal op_code1_rob: std_logic_vector(3 downto 0);
  signal destn_rename1_rob: std_logic_vector(5 downto 0);
  signal destn_rename_c1_rob: std_logic_vector(2 downto 0);
  signal destn_rename_z1_rob: std_logic_vector(2 downto 0);

  signal curr_pc2_rob: std_logic_vector(15 downto 0);
  signal destn_code2_rob: std_logic_vector(2 downto 0);
  signal op_code2_rob: std_logic_vector(3 downto 0);
  signal destn_rename2_rob: std_logic_vector(5 downto 0);
  signal destn_rename_c2_rob: std_logic_vector(2 downto 0);
  signal destn_rename_z2_rob: std_logic_vector(2 downto 0);


  ---output signals to scheduler



  signal alu_instr_valid: slv_array_t(0 to 9);
  signal alu_op_code: slv4_array_t(0 to 9);
  signal alu_op_code_cz: slv2_array_t(0 to 9);
  signal alu_destn_rename_code: slv6_array_t(0 to 9);
  signal alu_operand1: slv16_array_t(0 to 9);
  signal alu_valid1: slv_array_t(0 to 9);

  signal alu_operand2: slv16_array_t(0 to 9);
  signal alu_valid2: slv_array_t(0 to 9);

  signal alu_operand3: slv16_array_t(0 to 9);
  signal alu_valid3: slv_array_t(0 to 9);

  signal alu_c_flag: slv_array_t(0 to 9);
  signal alu_c_flag_rename: slv3_array_t(0 to 9);
  signal alu_c_flag_valid: slv_array_t(0 to 9);

  signal alu_z_flag: slv_array_t(0 to 9);
  signal alu_z_flag_rename: slv3_array_t(0 to 9);
  signal alu_z_flag_valid: slv_array_t(0 to 9);

  signal alu_btag: slv3_array_t(0 to 9);

  signal alu_orign_destn: slv3_array_t(0 to 9);

  signal alu_curr_pc: slv16_array_t(0 to 9);

  signal alu_scheduler_valid: slv_array_t(0 to 9);       


  signal ls_instr_valid: slv_array_t(0 to 9);
  signal ls_op_code: slv4_array_t(0 to 9);
       --_op_code_cz_out:out slv2_array_t(0 to 9);
  signal ls_destn_rename_code: slv6_array_t(0 to 9);
  signal ls_operand1: slv16_array_t(0 to 9);
  signal ls_valid1: slv_array_t(0 to 9);

  signal ls_operand2: slv16_array_t(0 to 9);
  signal ls_valid2: slv_array_t(0 to 9);


  signal ls_operand3: slv16_array_t(0 to 9);--denotes which register to load onto or store from
  signal ls_valid3: slv_array_t(0 to 9);

       
  signal ls_btag: slv3_array_t(0 to 9);

  signal ls_orign_destn: slv3_array_t(0 to 9);

  signal ls_curr_pc: slv16_array_t(0 to 9);
       --ls_imm_out:out slv16_array_t(0 to 9);


  signal ls_scheduler_valid: slv_array_t(0 to 9);


   --instr of jump to jump scheduler
       


   signal jmp_instr_valid: slv_array_t(0 to 9);
   signal jmp_op_code: slv4_array_t(0 to 9);
       --_op_code_cz_out:out slv2_array_t(0 to 9);
   signal jmp_destn_rename_code: slv6_array_t(0 to 9);
   signal jmp_operand1: slv16_array_t(0 to 9);
   signal jmp_valid1: slv_array_t(0 to 9);

   signal jmp_operand2: slv16_array_t(0 to 9);
   signal jmp_valid2: slv_array_t(0 to 9);


   signal jmp_operand3:slv16_array_t(0 to 9);--denotes which register to load onto or store from
   signal jmp_valid3: slv_array_t(0 to 9);

       
   signal jmp_btag: slv3_array_t(0 to 9);

   signal jmp_orign_destn:slv3_array_t(0 to 9);

   signal jmp_curr_pc: slv16_array_t(0 to 9);
       --ls_imm_out:out slv16_array_t(0 to 9);


   signal jmp_scheduler_valid: slv_array_t(0 to 9);
   signal jmp_next_pc: slv16_array_t(0 to 9);

   signal jmp_self_tag: slv3_array_t(0 to 9);



   signal  halt_out_RS: std_logic;--instr could not be written onto RS


     ----added a reset stage after addr to memory  
--------------------------------------------------------------------------------------------------------------------------------------------
--Scheduler left output signals(RS valid and number is already an=bove not repeated)  
  signal alu_sch_stall_in: std_logic;
  
  signal alu_sch_instr_valid_out_1: std_logic;
  signal alu_sch_op_code_out_1: std_logic_vector(3 downto 0);
  signal alu_sch_op_code_cz_out_1: std_logic_vector(1 downto 0);
  
  signal alu_sch_original_dest_out_1: std_logic_vector(2 downto 0);
  signal alu_sch_rename_dest_out_1: std_logic_vector(5 downto 0);
  
  signal alu_sch_operand_1_out_1: std_logic_vector(15 downto 0);
  
  signal alu_sch_operand_2_out_1: std_logic_vector(15 downto 0);
  
  signal alu_sch_operand_3_out_1: std_logic_vector(15 downto 0);
  
  signal alu_sch_c_flag_out_1: std_logic;
  signal alu_sch_c_flag_rename_out_1: std_logic_vector(2 downto 0);

  signal alu_sch_z_flag_out_1: std_logic;
  signal alu_sch_z_flag_rename_out_1: std_logic_vector(2 downto 0);

  signal alu_sch_pc_out_1: std_logic_vector(15 downto 0);
  
  signal alu_sch_btag_out_1: std_logic_vector(2 downto 0);
  -------------------------------------------------------------------------------------------
  --2 copies as 2 pipelines
  signal alu_sch_instr_valid_out_2: std_logic;
  signal alu_sch_op_code_out_2: std_logic_vector(3 downto 0);
  signal alu_sch_op_code_cz_out_2: std_logic_vector(1 downto 0);
  
  signal alu_sch_original_dest_out_2: std_logic_vector(2 downto 0);
  signal alu_sch_rename_dest_out_2: std_logic_vector(5 downto 0);
  
  signal alu_sch_operand_1_out_2: std_logic_vector(15 downto 0);
  
  signal alu_sch_operand_2_out_2: std_logic_vector(15 downto 0);
  
  signal alu_sch_operand_3_out_2: std_logic_vector(15 downto 0);
  
  signal alu_sch_c_flag_out_2: std_logic;
  signal alu_sch_c_flag_rename_out_2: std_logic_vector(2 downto 0);

  signal alu_sch_z_flag_out_2: std_logic;
  signal alu_sch_z_flag_rename_out_2: std_logic_vector(2 downto 0);

  signal alu_sch_pc_out_2: std_logic_vector(15 downto 0);
  
  signal alu_sch_btag_out_2: std_logic_vector(2 downto 0);
  
  ----------------------------------------------------------------------------------
  signal ls_sch_stall_in: std_logic;

  -- Execute Pipepline output
  signal ls_sch_instr_valid_out: std_logic;
  signal ls_sch_op_code_out: std_logic_vector(3 downto 0);
  signal ls_sch_original_dest_out: std_logic_vector(2 downto 0);
  signal ls_sch_rename_dest_out: std_logic_vector(5 downto 0);
  signal ls_sch_operand_1_out: std_logic_vector(15 downto 0);
  signal ls_sch_operand_2_out: std_logic_vector(15 downto 0);
  signal ls_sch_operand_3_out: std_logic_vector(15 downto 0);
  signal ls_sch_pc_out: std_logic_vector(15 downto 0);
  signal ls_sch_btag_out: std_logic_vector(2 downto 0);
  ----------------------------------------------------------------------------------
  signal br_sch_stall_in: std_logic;

  --Execute pipeline branch input
  signal br_sch_instr_valid_out: std_logic;
  signal br_sch_op_code_out: std_logic_vector(3 downto 0);
  signal br_sch_original_dest_out: std_logic_vector(2 downto 0);
  signal br_sch_rename_dest_out: std_logic_vector(5 downto 0);
  signal br_sch_operand_1_out: std_logic_vector(15 downto 0);
  
  signal br_sch_operand_2_out: std_logic_vector(15 downto 0);
  
  signal br_sch_operand_3_out: std_logic_vector(15 downto 0);
  
  signal br_sch_pc_out: std_logic_vector(15 downto 0);
  signal br_sch_nxt_pc_out: std_logic_vector(15 downto 0);
  
  signal br_sch_btag_out: std_logic_vector(2 downto 0);
  signal br_sch_self_tag_out: std_logic_vector(2 downto 0);



 begin
 
 memory_instance: memory_code port map

                        (
                          clk=>top_clock,
                          we=>'0',
                          a=>addr_to_mem,
                          do=>code_mem,
                          di=>(others=>'0'));

 mux_instance3: bit16_2x1 port map(  --used for reset
              
               c_0=>system_reset,
               d_0=>next_pc_fetch_in,
               d_1=>(others=>'0'),
               o=>addr_to_mem

 	           );


 mux_instance4: bit1_2x1 port map(  --used for invalidating decode
              
               c_0=>decode_invalidate_in,
               d_0=>instr1_decode_valid,
               d_1=>'0',
               o=>instr1_RS_valid_in

 	           );

 mux_instance5: bit1_2x1 port map(  --used for invalidating decode
              
               c_0=>decode_invalidate_in,
               d_0=>instr2_decode_valid,
               d_1=>'0',
               o=>instr2_RS_valid_in

 	           );

                         


 add_instance1:add_pc port map(

 	PC_in=>fetch_pc_out,
 	PC_out=>fetch_PC_plus_two
 	
 );

 mux_instance1: bit16_2x1 port map( --used to choose between predicted reisters and branch address
              
               c_0=>control_to_jmp,
               d_0=>fetch_PC_plus_two,
               d_1=>branch_predicted,
               o=>next_branch_fetch

 	           );

 mux_instance2: bit16_2x1 port map( --used for misprediction correction
              
               c_0=>branch_mis_predicted,
               d_0=>next_branch_fetch,
               d_1=>addr_exec,
               o=>next_pc_fetch_in
);

  fetch_instance:fetch port map(
       
    clk=>top_clock,
	Mem_in=>code_mem,
	PC_in=>addr_to_mem,

	stall_in=>stall_fetch_in,
	instr_invalidate_in=> '0',
	------------------------------------------------------------
	inst_1_valid=>instr1_fetch_valid,
	inst_2_valid=>instr2_fetch_valid,
	Instr1=>instr1_fetch_out,
	Instr2=>instr2_fetch_out,
	PC=>fetch_pc_out

 );


  decode_instance:decode port map(
   

	clk=>top_clock,
	reset=>system_reset,
	inst_1_valid_in=>instr1_fetch_valid,
	inst_2_valid_in=>instr2_fetch_valid,
	Instr1_in=>instr1_fetch_out,
	Instr2_in=>instr2_fetch_out,
	PC_in=>fetch_pc_out,
	Nxt_PC_in=> next_pc_fetch_in,

    br_inst_valid_in=>broadcast_branch_decode_valid,
	br_btag_in=>broadcast_branch_btag_in,
	br_self_tag_in=>broadcast_branch_self_tag_in,


	stall_in=>stall_decode_in,
	instr_invalidate_in=>invalidate_fetch_in, --as invalidation happens of it on next pipeline register
	------------------------------------------------------------
	--Instruction 1
	I1_valid=>instr1_decode_valid,
	I1_op_code=>instr1_decode_op_code,
	I1_op_cz=>instr1_decode_op_cz,
	I1_dest_code=>instr1_decode_destn_code,
	I1_operand_1_code=>instr1_decode_op1_code,
	I1_operand_2_code=>instr1_decode_op2_code,
	I1_Imm=>instr1_decode_imm,
	I1_PC=>instr1_decode_PC,
	I1_Nxt_PC=>instr1_decode_next_PC,
	I1_BTAG=>instr1_decode_btag,
	I1_self_tag=>instr1_decode_self_tag,

	--Instruction 2
	I2_valid=>instr2_decode_valid,
	I2_op_code=>instr2_decode_op_code,
	I2_op_cz=>instr2_decode_op_cz,
	I2_dest_code=>instr2_decode_destn_code,
	I2_operand_1_code=>instr2_decode_op1_code,
	I2_operand_2_code=>instr2_decode_op2_code,
	I2_Imm=>instr2_decode_imm,
	I2_PC=>instr2_decode_PC,
	I2_Nxt_PC=>instr2_decode_next_PC,
	I2_BTAG=>instr2_decode_btag,
	I2_self_tag=>instr2_decode_self_tag,

	-----------------------------------
	stall_out=>decode_stall_out
  );

  

      RS :reservation_state port map(

       instr1_valid_in=>instr1_RS_valid_in,
 	   op_code1_in=>instr1_decode_op_code,
 	   op_cz1_in=>instr1_decode_op_cz,
 	   destn_code1_in=>instr1_decode_destn_code,
 	   opr1_code1_in=>instr1_decode_op1_code,
 	   opr2_code1_in=>instr1_decode_op2_code,
	   opr3_code1_in=>instr1_decode_destn_code,
 	   curr_pc1_in=>instr1_decode_PC,
 	   next_pc1_in=>instr1_decode_next_PC,
 	   imm1_in=>instr1_decode_imm,
 	   btag1_in=>instr1_decode_btag,
 	   self1_tag_in=>instr1_decode_self_tag,

       instr2_valid_in=>instr2_RS_valid_in,
 	   op_code2_in=>instr2_decode_op_code,
 	   op_cz2_in=>instr2_decode_op_cz,
 	   destn_code2_in=>instr2_decode_destn_code,
 	   opr1_code2_in=>instr2_decode_op1_code,
 	   opr2_code2_in=>instr2_decode_op2_code,
	   opr3_code2_in=>instr2_decode_destn_code,
 	   curr_pc2_in=>instr2_decode_PC,
 	   next_pc2_in=>instr2_decode_next_PC,
 	   imm2_in=>instr2_decode_imm,
 	   btag2_in=>instr2_decode_btag,
 	   self2_tag_in=>instr2_decode_self_tag,

       alu_valid_done1_in=>alu_valid_done1_RS,
       alu_done_number1=>alu_done_number1_RS,

       alu_valid_done2_in=>alu_valid_done2_RS,
       alu_done_number2=>alu_done_number2_RS,

       ls_valid_done_in=>ls_valid_done_RS,
       ls_done_number=>ls_done_number_RS,

       jmp_valid_done_in=>jmp_valid_done_RS,
       jmp_done_number=>jmp_done_number_RS,

         

 	   reset_system=>system_reset,--to be done at start of cycle general reset which assigns all registers its original values
 	   --reset_system_mapping:in std_logic;--to be used to clear all assigned ARF and RRF's 
       clk_input=>top_clock,
       stall_reservation_update=>stall_reservation_center,--no data comes to reservation station if becomes 1


       broadcast1_rename_in=>broadcast1_rename,--refers to rename register broadcasted
       broadcast1_orig_destn_in=>broadcast1_orig_destn,--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast1_data_in=>broadcast1_data, --refers to data of rename register broadcasted
       broadcast1_valid_in=>broadcast1_valid,--refers whether broadcasted data is valid or not

       broadcast1_c_flag_in=>broadcast1_c_flag,
       broadcast1_c_flag_rename_in=>broadcast1_c_flag_rename,
       broadcast1_c_flag_valid_in=>broadcast1_c_flag_valid,

       broadcast1_z_flag_in=>broadcast1_z_flag,
       broadcast1_z_flag_rename_in=>broadcast1_z_flag_rename,
       broadcast1_z_flag_valid_in=>broadcast1_z_flag_valid,

       broadcast1_btag_in=>broadcast1_btag, --refers to btag of branch signal useful for updating branch copies
       


       broadcast2_rename_in=>broadcast2_rename,--refers to rename register broadcasted
       broadcast2_orig_destn_in=>broadcast2_orig_destn,--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast2_data_in=>broadcast2_data, --refers to data of rename register broadcasted
       broadcast2_valid_in=>broadcast2_valid,--refers whether broadcasted data is valid or not 
       

       broadcast2_c_flag_in=>broadcast2_c_flag,
       broadcast2_c_flag_rename_in=>broadcast2_c_flag_rename,
       broadcast2_c_flag_valid_in=>broadcast2_c_flag_valid,

       broadcast2_z_flag_in=>broadcast2_z_flag,
       broadcast2_z_flag_rename_in=>broadcast2_z_flag_rename,
       broadcast2_z_flag_valid_in=>broadcast2_z_flag_valid,

       broadcast2_btag_in=>broadcast2_btag,--refers to btag of branch signal useful for updating branch copies


       broadcast3_rename_in=>broadcast3_rename,--refers to rename register broadcasted
       broadcast3_orig_destn_in=>broadcast3_orig_destn,--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast3_data_in=>broadcast3_data, --refers to data of rename register broadcasted
       broadcast3_valid_in=>broadcast3_valid,--refers whether broadcasted data is valid or not 
       -- 
       broadcast3_btag_in=>broadcast3_btag,--refers to btag of branch signal useful for updating branch copies
       
       
       broadcast4_rename_in=>broadcast4_rename,--refers to rename register broadcasted
       broadcast4_orig_destn_in=>broadcast4_orig_destn,--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast4_data_in=>broadcast4_data, --refers to data of rename register broadcasted
       broadcast4_valid_in=>broadcast4_valid,--refers whether broadcasted data is valid or not 
       
       
       broadcast4_c_flag_in=>broadcast4_c_flag,
       broadcast4_c_flag_rename_in=>broadcast4_c_flag_rename,
       broadcast4_c_flag_valid_in=>broadcast4_c_flag_valid,

       broadcast4_z_flag_in=>broadcast4_z_flag,
       broadcast4_z_flag_rename_in=>broadcast4_z_flag_rename,
       broadcast4_z_flag_valid_in=>broadcast4_z_flag_valid,

       broadcast4_btag_in=>broadcast4_btag,--refers to btag of branch signal useful for updating branch copies

       branch_mispredict_broadcast_in=>branch_mispredict_broadcast, --00 implies no misprediction 01 implies first branch mispredicted 10 implies second branch mispredicted


       broadcast5_rename_in=>broadcast5_rename,
       broadcast5_orig_destn_in=>broadcast3_orig_destn,--used if a broadcast signal matches with arrival of other instr with same src register 
       broadcast5_data_in=>broadcast5_data, --refers to data of rename register broadcasted
       broadcast5_valid_in=>broadcast5_valid,--refers whether broadcasted data is valid or not \
       broadcast5_btag_in=>broadcast5_btag,
       

       --entry in ROB output

       curr_pc1_rob_out=>curr_pc1_rob,
       destn_code1_rob_out=>destn_code1_rob,
       op_code1_rob_out=>op_code1_rob,
       destn_rename1_rob_out=>destn_rename1_rob,
       destn_rename_c1_rob_out=>destn_rename_c1_rob,
       destn_rename_z1_rob_out=>destn_rename_z1_rob,

       curr_pc2_rob_out=>curr_pc2_rob,
       destn_code2_rob_out=>destn_code2_rob,
       op_code2_rob_out=>op_code2_rob,
       destn_rename2_rob_out=>destn_rename2_rob,
       destn_rename_c2_rob_out=>destn_rename_c2_rob,
       destn_rename_z2_rob_out=>destn_rename_z2_rob,



       alu_instr_valid_out=>alu_instr_valid,
       alu_op_code_out=>alu_op_code,
       alu_op_code_cz_out=>alu_op_code_cz,
       alu_destn_rename_code_out=>alu_destn_rename_code,
       alu_operand1_out=>alu_operand1,
       alu_valid1_out=>alu_valid1,

       alu_operand2_out=>alu_operand2,
       alu_valid2_out=>alu_valid2,

       alu_operand3_out=>alu_operand3,
       alu_valid3_out=>alu_valid3,

       alu_c_flag_out=>alu_c_flag,
       alu_c_flag_rename_out=>alu_c_flag_rename,
       alu_c_flag_valid_out=>alu_c_flag_valid,

       alu_z_flag_out=>alu_z_flag,
       alu_z_flag_rename_out=>alu_z_flag_rename,
       alu_z_flag_valid_out=>alu_z_flag_valid,

       alu_btag_out=>alu_btag,

       alu_orign_destn_out=>alu_orign_destn,

       alu_curr_pc_out=>alu_curr_pc,

       alu_scheduler_valid_out=>alu_scheduler_valid,       


       ls_instr_valid_out=>ls_instr_valid,
       ls_op_code_out=>ls_op_code,
       --_op_code_cz_out:out slv2_array_t(0 to 9);
       ls_destn_rename_code_out=>ls_destn_rename_code,
       ls_operand1_out=>ls_operand1,
       ls_valid1_out=>ls_valid1,

       ls_operand2_out=>ls_operand2,
       ls_valid2_out=>ls_valid2,


       ls_operand3_out=>ls_operand3,--denotes which register to load onto or store from
       ls_valid3_out=>ls_valid3,

       
       ls_btag_out=>ls_btag,

       ls_orign_destn_out=>ls_orign_destn,

       ls_curr_pc_out=>ls_curr_pc,
       --ls_imm_out:out slv16_array_t(0 to 9);


       ls_scheduler_valid_out=>ls_scheduler_valid,



       jmp_instr_valid_out=>jmp_instr_valid,
       jmp_op_code_out=>jmp_op_code,
       --_op_code_cz_out:out slv2_array_t(0 to 9);
       jmp_destn_rename_code_out=>jmp_destn_rename_code,
       jmp_operand1_out=>jmp_operand1,
       jmp_valid1_out=>jmp_valid1,

       jmp_operand2_out=>jmp_operand2,
       jmp_valid2_out=>jmp_valid2,


       jmp_operand3_out=>jmp_operand3,--denotes which register to load onto or store from
       jmp_valid3_out=>jmp_valid3,

       
       jmp_btag_out=>jmp_btag,

       jmp_orign_destn_out=>jmp_orign_destn,

       jmp_curr_pc_out=>jmp_curr_pc,
       --ls_imm_out:out slv16_array_t(0 to 9);


       jmp_scheduler_valid_out=>jmp_scheduler_valid,
       jmp_next_pc_out=>jmp_next_pc,

       jmp_self_tag_out=>jmp_self_tag,



       halt_out=>halt_out_RS--instr could not be written onto RS 
       -- 
       );
------------------------------------------------------------------------------------------------------------------------------------------
ALU_SCHEDULER: alu_sch port map (
    clk => top_clock,
    reset => system_reset,

    alu_instr_valid_in => alu_instr_valid,
    alu_op_code_in => alu_op_code,
    alu_op_code_cz_in => alu_op_code_cz,
    
    alu_original_dest_in => alu_orign_destn,
    alu_rename_dest_in => alu_destn_rename_code,
    
    alu_operand_1_in => alu_operand1,
    alu_operand_1_valid_in => alu_valid1,

    alu_operand_2_in => alu_operand2,
    alu_operand_2_valid_in => alu_valid2,

    alu_operand_3_in => alu_operand3,
    alu_operand_3_valid_in => alu_valid3,

    alu_c_flag_in => alu_c_flag,
    alu_c_flag_rename_in => alu_c_flag_rename,

    alu_z_flag_in => alu_z_flag,
    alu_z_flag_rename_in => alu_z_flag_rename,

    alu_pc_in => alu_curr_pc,
    alu_sch_valid_in => alu_scheduler_valid,

    alu_btag_in => alu_btag,

    alu_stall_in => alu_sch_stall_in,
    --------------------------------------------------------------------------------
    -- Execute Pipepline output
    alu_instr_valid_out_1 => alu_sch_instr_valid_out_1,
    alu_op_code_out_1 => alu_sch_op_code_out_1,
    alu_op_code_cz_out_1 => alu_sch_op_code_cz_out_1,
    
    alu_original_dest_out_1 => alu_sch_original_dest_out_1,
    alu_rename_dest_out_1 => alu_sch_rename_dest_out_1,
    
    alu_operand_1_out_1 => alu_sch_operand_1_out_1,
    
    alu_operand_2_out_1 => alu_sch_operand_2_out_1 ,
    
    alu_operand_3_out_1 => alu_sch_operand_3_out_1,
    
    alu_c_flag_out_1 => alu_sch_c_flag_out_1,
    alu_c_flag_rename_out_1 => alu_sch_c_flag_rename_out_1,

    alu_z_flag_out_1 => alu_sch_z_flag_out_1,
    alu_z_flag_rename_out_1 => alu_sch_z_flag_rename_out_1,

    alu_pc_out_1 => alu_sch_pc_out_1,
    
    alu_btag_out_1 => alu_sch_btag_out_1,
    -------------------------------------------------------------------------------------------
    --2 copies as 2 pipelines
    alu_instr_valid_out_2 => alu_sch_instr_valid_out_2,
    alu_op_code_out_2 => alu_sch_op_code_out_2,
    alu_op_code_cz_out_2 => alu_sch_op_code_cz_out_2,
    
    alu_original_dest_out_2 => alu_sch_original_dest_out_2,
    alu_rename_dest_out_2 => alu_sch_rename_dest_out_2,
    
    alu_operand_1_out_2 => alu_sch_operand_1_out_2,
    
    alu_operand_2_out_2 => alu_sch_operand_2_out_2,
    
    alu_operand_3_out_2 => alu_sch_operand_3_out_2,
    
    alu_c_flag_out_2 => alu_sch_c_flag_out_2,
    alu_c_flag_rename_out_2 => alu_sch_c_flag_rename_out_2,

    alu_z_flag_out_2 => alu_sch_z_flag_out_2,
    alu_z_flag_rename_out_2 => alu_sch_z_flag_rename_out_2,

    alu_pc_out_2 => alu_sch_pc_out_2,
    
    alu_btag_out_2 => alu_sch_btag_out_2,
    --------------------------------------------------------------------------------
    -- Data going back to RS
    rs_alu_index_1_out => alu_done_number1_RS,
    rs_alu_valid_1_out => alu_valid_done1_RS,
    rs_alu_index_2_out => alu_done_number2_RS,
    rs_alu_valid_2_out => alu_valid_done2_RS
  );
------------------------------------------------------------------------------------------------------------------------------------------
LS_SCHEDULER:lw_sw_sch port map (  
        clk => top_clock,
        reset => system_reset,

        ls_instr_valid_in => ls_instr_valid,
        ls_op_code_in => ls_op_code,
        ls_original_dest_in => ls_orign_destn,
        ls_rename_dest_in => ls_destn_rename_code,
        ls_operand_1_in => ls_operand1,
        ls_operand_1_valid_in => ls_valid1,

        ls_operand_2_in => ls_operand2,
        ls_operand_2_valid_in => ls_valid2,

        ls_operand_3_in => ls_operand3,
        ls_operand_3_valid_in => ls_valid3,

        ls_pc_in => ls_curr_pc,
        ls_sch_valid_in => ls_scheduler_valid,

        ls_btag_in => ls_btag,

        ls_stall_in => ls_sch_stall_in,
        --------------------------------------------------------------------------------
        -- Execute Pipepline output
        ls_instr_valid_out => ls_sch_instr_valid_out,
        ls_op_code_out => ls_sch_op_code_out,
        ls_original_dest_out => ls_sch_original_dest_out,
        ls_rename_dest_out => ls_sch_rename_dest_out,
        ls_operand_1_out => ls_sch_operand_1_out,
        ls_operand_2_out => ls_sch_operand_2_out,
        ls_operand_3_out => ls_sch_operand_3_out,
        ls_pc_out => ls_sch_pc_out,
        ls_btag_out => ls_sch_btag_out,

        --------------------------------------------------------------------------------
        -- Data going back to RS
        rs_ls_index_out => ls_done_number_RS,
        rs_ls_valid_out => ls_valid_done_RS
        );
------------------------------------------------------------------------------------------------------------------------------------------
BRANCH_SCHEDULER: branch_sch port map (
        clk => top_clock,
        reset => system_reset,

        br_instr_valid_in => jmp_instr_valid,
        br_op_code_in => jmp_op_code,
        br_original_dest_in => jmp_orign_destn,
        br_rename_dest_in => jmp_destn_rename_code,
        br_operand_1_in => jmp_operand1,
        br_operand_1_valid_in => jmp_valid1,

        br_operand_2_in => jmp_operand2,
        br_operand_2_valid_in => jmp_valid2,

        br_operand_3_in => jmp_operand3,
        br_operand_3_valid_in => jmp_valid3,

        br_pc_in => jmp_curr_pc,
        br_nxt_pc_in => jmp_next_pc,
        br_sch_valid_in => jmp_scheduler_valid,

        br_btag_in => jmp_btag,
        br_self_tag_in => jmp_self_tag,

        br_stall_in => br_sch_stall_in,
        -----------------------------------------------------------------------------------
        --Execute pipeline branch input
        br_instr_valid_out => br_sch_instr_valid_out,
        br_op_code_out => br_sch_op_code_out,
        br_original_dest_out => br_sch_original_dest_out,
        br_rename_dest_out => br_sch_rename_dest_out,
        br_operand_1_out => br_sch_operand_1_out,-- to Ra
        
        br_operand_2_out => br_sch_operand_2_out,--refers to Rb
        
        br_operand_3_out => br_sch_operand_3_out,--refers to immediate
        
        br_pc_out => br_sch_pc_out,
        br_nxt_pc_out => br_sch_nxt_pc_out,
        
        br_btag_out => br_sch_btag_out,
        br_self_tag_out => br_sch_self_tag_out,
        --------------------------------------------------------------------------------
        -- Data going back to RS
        rs_br_index_out => jmp_done_number_RS,
        rs_br_valid_out => jmp_valid_done_RS
        );
------------------------------------------------------------------------------------------------------------------------------------------









  process(decode_stall_out,halt_out_RS) --stall for stall_fetch_in --to be increased later

   begin
   if (decode_stall_out='1' or halt_out_RS='1') then --in case of reset no stall
     stall_fetch_in<='1';
   else
     stall_fetch_in<='0';
   end if;   

   
  end process;


  --process(decode_stall_out) --stall for stall_decode_in --to be increased later

  -- begin
  -- if (decode_stall_out='1') then
  --   stall_decode_in<='1';
  -- else
  --   stall_decode_in<='0';
  -- end if;   

   
  --end process;

  stall_decode_in<=(decode_stall_out or halt_out_RS); --things to be appended later



  --
  --invalidate_fetch_in<='1';
  --decode_invalidate_in<='1';
  
  process(system_reset) --invalidation for decode registers
  
  begin
   if (system_reset='1') then
    decode_invalidate_in<='1';
   else
    decode_invalidate_in<='0';
   end if;
  end process;    

  process(system_reset) --invalidation for decode registers
  
  begin
   if (system_reset='1') then
    invalidate_fetch_in<='1';
   else
    invalidate_fetch_in<='0';
   end if;
  end process;


  stall_reservation_center<='0';--controlling the reservation center update

  control_to_jmp<='0';--as branch predictor not used

 branch_mis_predicted<='0'; --to write a separate process here later to control when to use addr exec pipeline and when to do otherwise




  

--temporary mappings done to be mapped to actual objects later




  broadcast_branch_decode_valid<='0';--logic to be written later

  broadcast_branch_btag_in<=(others=>'0');--logic to be written later

  broadcast_branch_self_tag_in<=(others=>'0');--logic to be written later


  ls_sch_stall_in <= '0';
  alu_sch_stall_in <= '0';
  br_sch_stall_in <= '0';


  --alu_valid_done1_RS<='0';--
  
  
  --alu_valid_done2_RS<='0';

  --ls_valid_done_RS<='0';
  
  --jmp_valid_done_RS<='0';
  


 broadcast1_valid<='0';
 broadcast2_valid<='0';
 broadcast3_valid<='0';
 broadcast4_valid<='0';
 broadcast5_valid<='0';

 broadcast1_z_flag_valid<='0';
 broadcast1_c_flag_valid<='0';

 broadcast2_z_flag_valid<='0';
 broadcast2_c_flag_valid<='0';

 broadcast4_z_flag_valid<='0';
 broadcast4_c_flag_valid<='0';

 branch_mispredict_broadcast<="00";				  






end architecture struct;