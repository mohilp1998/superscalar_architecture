library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decode is
  port (
	clk: in std_logic;
	reset: in std_logic;

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
end entity ; -- decode

architecture arch of decode is

	signal current_BTAG: std_logic_vector(2 downto 0) := "000";

begin


--- Important to note only INSTR2 will be a branch instruction
Stall_process : process(reset, Instr1_in,Instr2_in,current_BTAG,inst_1_valid_in,inst_2_valid_in)
	variable stall_out_var: std_logic;
begin
	if (reset = '1') then
		
		stall_out_var := '0';
	
	else
		--if (inst_1_valid_in = '1') then
		--	if (Instr1_in(15 downto 12) = "1100" or Instr1_in(15 downto 12) = "1000" or Instr1_in(15 downto 12) = "1001") then
		--		if (current_BTAG = "011") then
		--			stall_out_var := '1';
		--		else
		--			stall_out_var := '0';
		--		end if ;
		--	else
		--		stall_out_var := '0';
		--	end if ;
		--else
		--	stall_out_var := '0';
		--end if ;

		if (inst_2_valid_in = '1') then
			if(Instr2_in(15 downto 12) = "1100" or Instr2_in(15 downto 12) = "1000" or Instr2_in(15 downto 12) = "1001") then
				if (current_BTAG = "011") then
					stall_out_var := '1';
				else
					stall_out_var := '0';
				end if ;
			else
				stall_out_var := '0';
			end if;
		else
			stall_out_var := '0';	
		end if ;

	end if ;
	

	stall_out <= stall_out_var;
	
end process ; -- Stall_process





Decoder : process(clk,reset,inst_2_valid_in,inst_1_valid_in,Instr2_in,Instr1_in,PC_in,Nxt_PC_in)
	variable I1_valid_var: std_logic;
	variable I1_op_code_var: std_logic_vector(3 downto 0);
	variable I1_op_cz_var: std_logic_vector(1 downto 0);
	variable I1_dest_code_var: std_logic_vector(2 downto 0);
	variable I1_operand_1_code_var: std_logic_vector(2 downto 0);
	variable I1_operand_2_code_var: std_logic_vector(2 downto 0);
	variable I1_Imm_var: std_logic_vector(15 downto 0);
	variable I1_PC_var: std_logic_vector(15 downto 0);
	variable I1_Nxt_PC_var: std_logic_vector(15 downto 0);
	variable I1_BTAG_var: std_logic_vector(2 downto 0);
	variable I1_self_tag_var: std_logic_vector(2 downto 0); 


	variable I2_valid_var: std_logic;
	variable I2_op_code_var: std_logic_vector(3 downto 0);
	variable I2_op_cz_var: std_logic_vector(1 downto 0);
	variable I2_dest_code_var: std_logic_vector(2 downto 0);
	variable I2_operand_1_code_var: std_logic_vector(2 downto 0);
	variable I2_operand_2_code_var: std_logic_vector(2 downto 0);
	variable I2_Imm_var: std_logic_vector(15 downto 0);
	variable I2_PC_var: std_logic_vector(15 downto 0);
	variable I2_Nxt_PC_var: std_logic_vector(15 downto 0);
	variable I2_BTAG_var: std_logic_vector(2 downto 0);
	variable I2_self_tag_var: std_logic_vector(2 downto 0);

	variable current_BTAG_var: std_logic_vector(2 downto 0); 

	variable constant_zero: std_logic_vector(15 downto 0) := "0000000000000000";
	variable constant_zero_LHI: std_logic_vector(6 downto 0) := "0000000";

begin
-- IMP: Store will not have destination register so Ra i.e. 11 downto 8 is storing the value to be stored
	if (clk'event and clk = '1') then

		if (reset = '1') then
			
			I1_valid <= '0';
			I1_op_code <= (others => '0');
			I1_op_cz <= (others => '0');
			I1_dest_code <= (others => '0');
			I1_operand_1_code <= (others => '0');
			I1_operand_2_code <= (others => '0');
			I1_Imm <= (others => '0');
			I1_PC <= (others => '0');
			I1_Nxt_PC <= (others => '0');
			I1_BTAG <= (others => '0');
			I1_self_tag <= (others => '0');

			I2_valid <= '0';
			I2_op_code <= (others => '0');
			I2_op_cz <= (others => '0');
			I2_dest_code <= (others => '0');
			I2_operand_1_code <= (others => '0');
			I2_operand_2_code <= (others => '0');
			I2_Imm <= (others => '0');
			I2_PC <= (others => '0');
			I2_Nxt_PC <= (others => '0');
			I2_BTAG <= (others => '0');
			I2_self_tag <= (others => '0');

			current_BTAG <= (others => '0');
		else
			
			if (br_inst_valid_in = '1') then
				
				if (br_self_tag_in = "001" and br_btag_in = "000" and current_BTAG = "001") then
					current_BTAG_var := "000";
				elsif (br_self_tag_in = "001" and br_btag_in = "000" and current_BTAG = "011") then
					current_BTAG_var := "010";
				elsif (br_self_tag_in = "010" and br_btag_in = "000" and current_BTAG = "010") then
					current_BTAG_var := "000";
				elsif (br_self_tag_in = "010" and br_btag_in = "000" and current_BTAG = "011") then
					current_BTAG_var := "001";
				elsif (br_self_tag_in = "011" and br_btag_in = "001" and current_BTAG = "011") then
					current_BTAG_var := "001";
				elsif (br_self_tag_in = "011" and br_btag_in = "010" and current_BTAG = "011") then
					current_BTAG_var := "010";
				else
					current_BTAG_var:= current_BTAG;
				end if ;

			else
				current_BTAG_var := current_BTAG;
			end if ;

			if (stall_in = '1') then
				
				if (instr_invalidate_in = '1') then
					I1_valid <= '0';
					I2_valid <= '0';
				else
					
				end if ;
			else
				if (instr_invalidate_in = '1') then
					I1_valid <= '0';
					I2_valid <= '0';
				else
					
						--- Instruction 1
						if (inst_1_valid_in = '1') then
							
							current_BTAG_var := current_BTAG;

							case(Instr1_in(15 downto 12)) is
									
									when "0000" =>
									--ADD/ADC/ADZ
									I1_valid_var := inst_1_valid_in;
									I1_op_code_var := Instr1_in(15 downto 12);
									I1_op_cz_var := Instr1_in(1 downto 0);
									I1_dest_code_var := Instr1_in(11 downto 9);
									I1_operand_1_code_var := Instr1_in(8 downto 6);
									I1_operand_2_code_var := Instr1_in(5 downto 3);
									I1_Imm_var := constant_zero;
									I1_PC_var := PC_in;
									I1_Nxt_PC_var := std_logic_vector(unsigned(PC_in) + 1);

									I1_BTAG_var := current_BTAG_var;
									I1_self_tag_var := "000";

									when "0010" =>
									-- NDU/NDZ/NDC
									I1_valid_var := inst_1_valid_in;
									I1_op_code_var := Instr1_in(15 downto 12);
									I1_op_cz_var := Instr1_in(1 downto 0);
									I1_dest_code_var := Instr1_in(11 downto 9);
									I1_operand_1_code_var := Instr1_in(8 downto 6);
									I1_operand_2_code_var := Instr1_in(5 downto 3);
									I1_Imm_var := constant_zero;
									I1_PC_var := PC_in;
									I1_Nxt_PC_var := std_logic_vector(unsigned(PC_in) + 1);

									I1_BTAG_var := current_BTAG_var;
									I1_self_tag_var := "000";

									when "0001" =>
									-- ADI
									I1_valid_var := inst_1_valid_in;
									I1_op_code_var := Instr1_in(15 downto 12);
									I1_op_cz_var := Instr1_in(1 downto 0);
									I1_dest_code_var := Instr1_in(11 downto 9);
									I1_operand_1_code_var := Instr1_in(8 downto 6);
									I1_operand_2_code_var := Instr1_in(5 downto 3);
									I1_Imm_var := Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(4 downto 0) ;
									I1_PC_var := PC_in;
									I1_Nxt_PC_var := std_logic_vector(unsigned(PC_in) + 1);

									I1_BTAG_var := current_BTAG_var;
									I1_self_tag_var := "000";	
								
									when "0011" =>
									-- LHI
									I1_valid_var := inst_1_valid_in;
									I1_op_code_var := Instr1_in(15 downto 12);
									I1_op_cz_var := Instr1_in(1 downto 0);
									I1_dest_code_var := Instr1_in(11 downto 9);
									I1_operand_1_code_var := Instr1_in(8 downto 6);
									I1_operand_2_code_var := Instr1_in(5 downto 3);
									I1_Imm_var := Instr1_in(8 downto 0) & constant_zero_LHI;
									I1_PC_var := PC_in;
									I1_Nxt_PC_var := std_logic_vector(unsigned(PC_in) + 1);

									I1_BTAG_var := current_BTAG_var;
									I1_self_tag_var := "000";

									when "0100" =>
									-- LW
									I1_valid_var := inst_1_valid_in;
									I1_op_code_var := Instr1_in(15 downto 12);
									I1_op_cz_var := Instr1_in(1 downto 0);
									I1_dest_code_var := Instr1_in(11 downto 9);
									I1_operand_1_code_var := Instr1_in(8 downto 6);
									I1_operand_2_code_var := Instr1_in(5 downto 3);
									I1_Imm_var := Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(4 downto 0);
									I1_PC_var := PC_in;
									I1_Nxt_PC_var := std_logic_vector(unsigned(PC_in) + 1);

									I1_BTAG_var := current_BTAG_var;
									I1_self_tag_var := "000";

									when "0101" =>
									-- SW

									I1_valid_var := inst_1_valid_in;
									I1_op_code_var := Instr1_in(15 downto 12);
									I1_op_cz_var := Instr1_in(1 downto 0);
									I1_dest_code_var := Instr1_in(11 downto 9);
									I1_operand_1_code_var := Instr1_in(8 downto 6);
									I1_operand_2_code_var := Instr1_in(5 downto 3);
									I1_Imm_var := Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(4 downto 0);
									I1_PC_var := PC_in;
									I1_Nxt_PC_var := std_logic_vector(unsigned(PC_in) + 1);

									I1_BTAG_var := current_BTAG_var;
									I1_self_tag_var := "000";

									--when "1100" =>
									---- BEQ, But as only Instruction 2 is branch it will be irrelevant
									---- Also we will never see current tag =111 case as stall out of decode will also run stall in of the decode also
									--I1_valid_var := inst_1_valid_in;
									--I1_op_code_var := Instr1_in(15 downto 12);
									--I1_op_cz_var := Instr1_in(1 downto 0);
									--I1_dest_code_var := Instr1_in(11 downto 9);
									--I1_operand_1_code_var := Instr1_in(11 downto 9);
									--I1_operand_2_code_var := Instr1_in(8 downto 6);
									--I1_Imm_var := Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(5) & Instr1_in(4 downto 0);
									--I1_PC_var := PC_in;
									--I1_Nxt_PC_var := std_logic_vector(unsigned(PC_in) + 1);

									--I1_BTAG_var := current_BTAG_var;
									--if (current_BTAG_var = "000") then
									--	current_BTAG_var := "001";
									--	I1_self_tag_var := "001";
									
									--elsif (current_BTAG_var = "001") then
									-- 	current_BTAG_var := "011";
									--	I1_self_tag_var := "011";
									
									--elsif (current_BTAG_var = "010") then
									-- 	current_BTAG_var := "011";
									--	I1_self_tag_var := "011";
									
									--elsif (current_BTAG_var = "011") then
									-- 	current_BTAG_var := "111";
									--	I1_self_tag_var := "111";
									
									--elsif (current_BTAG_var = "101") then
									-- 	current_BTAG_var := "111";
									--	I1_self_tag_var := "111";
									
									--elsif (current_BTAG_var = "110") then
									-- 	current_BTAG_var := "111";
									--	I1_self_tag_var := "111";
									
									--elsif (current_BTAG_var = "100") then
									-- 	current_BTAG_var := "101";
									--	I1_self_tag_var := "101";
									--else
									--	current_BTAG_var := "111";
									--	I1_self_tag_var := "111";
									--end if;	
									
									--when "1000" =>
									---- JAL, But as only Instruction 2 is branch it will be irrelevant
									---- Also we will never see current tag =111 case as stall out of decode will also run stall in of the decode also
									--I1_valid_var := inst_1_valid_in;
									--I1_op_code_var := Instr1_in(15 downto 12);
									--I1_op_cz_var := Instr1_in(1 downto 0);
									--I1_dest_code_var := Instr1_in(11 downto 9);
									--I1_operand_1_code_var := Instr1_in(8 downto 6);
									--I1_operand_2_code_var := Instr1_in(5 downto 3);
									--I1_Imm_var := Instr1_in(8 downto 0) & constant_zero_LHI;
									--I1_PC_var := PC_in;
									--I1_Nxt_PC_var := std_logic_vector(unsigned(PC_in) + 1);

									--I1_BTAG_var := current_BTAG_var;
									--if (current_BTAG_var = "000") then
									--	current_BTAG_var := "001";
									--	I1_self_tag_var := "001";
									
									--elsif (current_BTAG_var = "001") then
									-- 	current_BTAG_var := "011";
									--	I1_self_tag_var := "011";
									
									--elsif (current_BTAG_var = "010") then
									-- 	current_BTAG_var := "011";
									--	I1_self_tag_var := "011";
									
									--elsif (current_BTAG_var = "011") then
									-- 	current_BTAG_var := "111";
									--	I1_self_tag_var := "111";
									
									--elsif (current_BTAG_var = "101") then
									-- 	current_BTAG_var := "111";
									--	I1_self_tag_var := "111";
									
									--elsif (current_BTAG_var = "110") then
									-- 	current_BTAG_var := "111";
									--	I1_self_tag_var := "111";
									
									--elsif (current_BTAG_var = "100") then
									-- 	current_BTAG_var := "101";
									--	I1_self_tag_var := "101";
									--else
									--	current_BTAG_var := "111";
									--	I1_self_tag_var := "111";
									--end if;	

									--when "1001" =>
									---- JLR, But as only Instruction 2 is branch it will be irrelevant
									---- Also we will never see current tag =111 case as stall out of decode will also run stall in of the decode also
									--I1_valid_var := inst_1_valid_in;
									--I1_op_code_var := Instr1_in(15 downto 12);
									--I1_op_cz_var := Instr1_in(1 downto 0);
									--I1_dest_code_var := Instr1_in(11 downto 9);
									--I1_operand_1_code_var := Instr1_in(8 downto 6);
									--I1_operand_2_code_var := Instr1_in(5 downto 3);
									--I1_Imm_var := constant_zero;
									--I1_PC_var := PC_in;
									--I1_Nxt_PC_var := std_logic_vector(unsigned(PC_in) + 1);

									--I1_BTAG_var := current_BTAG_var;
									--if (current_BTAG_var = "000") then
									--	current_BTAG_var := "001";
									--	I1_self_tag_var := "001";
									
									--elsif (current_BTAG_var = "001") then
									-- 	current_BTAG_var := "011";
									--	I1_self_tag_var := "011";
									
									--elsif (current_BTAG_var = "010") then
									-- 	current_BTAG_var := "011";
									--	I1_self_tag_var := "011";
									
									--elsif (current_BTAG_var = "011") then
									-- 	current_BTAG_var := "111";
									--	I1_self_tag_var := "111";
									
									--elsif (current_BTAG_var = "101") then
									-- 	current_BTAG_var := "111";
									--	I1_self_tag_var := "111";
									
									--elsif (current_BTAG_var = "110") then
									-- 	current_BTAG_var := "111";
									--	I1_self_tag_var := "111";
									
									--elsif (current_BTAG_var = "100") then
									-- 	current_BTAG_var := "101";
									--	I1_self_tag_var := "101";
									--else
									--	current_BTAG_var := "111";
									--	I1_self_tag_var := "111";
									--end if;	

									when others =>

									I1_valid_var := inst_1_valid_in;
									I1_op_code_var := Instr1_in(15 downto 12);
									I1_op_cz_var := Instr1_in(1 downto 0);
									I1_dest_code_var := Instr1_in(11 downto 9);
									I1_operand_1_code_var := Instr1_in(8 downto 6);
									I1_operand_2_code_var := Instr1_in(5 downto 3);
									I1_Imm_var := constant_zero;
									I1_PC_var := PC_in;
									I1_Nxt_PC_var := std_logic_vector(unsigned(PC_in) + 1);
									
									I1_BTAG_var := current_BTAG_var;
									I1_self_tag_var := "000";								
								end case ;	
						
						else
							I1_valid_var := inst_1_valid_in;
							I1_op_code_var := Instr1_in(15 downto 12);
							I1_op_cz_var := Instr1_in(1 downto 0);
							I1_dest_code_var := Instr1_in(11 downto 9);
							I1_operand_1_code_var := Instr1_in(8 downto 6);
							I1_operand_2_code_var := Instr1_in(5 downto 3);
							I1_Imm_var := constant_zero;
							I1_PC_var := PC_in;
							I1_Nxt_PC_var := std_logic_vector(unsigned(PC_in) + 1);

							I1_BTAG_var := current_BTAG_var;
							I1_self_tag_var := "000";
						end if ;

						if (inst_2_valid_in = '1') then
							
							case(Instr2_in(15 downto 12)) is
									
									when "0000" =>
									--ADD/ADC/ADZ
									I2_valid_var := inst_2_valid_in;
									I2_op_code_var := Instr2_in(15 downto 12);
									I2_op_cz_var := Instr2_in(1 downto 0);
									I2_dest_code_var := Instr2_in(11 downto 9);
									I2_operand_1_code_var := Instr2_in(8 downto 6);
									I2_operand_2_code_var := Instr2_in(5 downto 3);
									I2_Imm_var := constant_zero;
									I2_PC_var := std_logic_vector(unsigned(PC_in) + 1);
									I2_Nxt_PC_var := Nxt_PC_in;

									I2_BTAG_var := current_BTAG_var;
									I2_self_tag_var := "000";

									when "0010" =>
									-- NDU/NDZ/NDC
									I2_valid_var := inst_2_valid_in;
									I2_op_code_var := Instr2_in(15 downto 12);
									I2_op_cz_var := Instr2_in(1 downto 0);
									I2_dest_code_var := Instr2_in(11 downto 9);
									I2_operand_1_code_var := Instr2_in(8 downto 6);
									I2_operand_2_code_var := Instr2_in(5 downto 3);
									I2_Imm_var := constant_zero;
									I2_PC_var := std_logic_vector(unsigned(PC_in) + 1);
									I2_Nxt_PC_var := Nxt_PC_in;

									I2_BTAG_var := current_BTAG_var;
									I2_self_tag_var := "000";

									when "0001" =>
									-- ADI
									I2_valid_var := inst_2_valid_in;
									I2_op_code_var := Instr2_in(15 downto 12);
									I2_op_cz_var := Instr2_in(1 downto 0);
									I2_dest_code_var := Instr2_in(11 downto 9);
									I2_operand_1_code_var := Instr2_in(8 downto 6);
									I2_operand_2_code_var := Instr2_in(5 downto 3);
									I2_Imm_var := Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(4 downto 0) ;
									I2_PC_var := std_logic_vector(unsigned(PC_in) + 1);
									I2_Nxt_PC_var := Nxt_PC_in;

									I2_BTAG_var := current_BTAG_var;
									I2_self_tag_var := "000";
									when "0011" =>
									-- LHI
									I2_valid_var := inst_2_valid_in;
									I2_op_code_var := Instr2_in(15 downto 12);
									I2_op_cz_var := Instr2_in(1 downto 0);
									I2_dest_code_var := Instr2_in(11 downto 9);
									I2_operand_1_code_var := Instr2_in(8 downto 6);
									I2_operand_2_code_var := Instr2_in(5 downto 3);
									I2_Imm_var := Instr2_in(8 downto 0) & constant_zero_LHI;
									I2_PC_var := std_logic_vector(unsigned(PC_in) + 1);
									I2_Nxt_PC_var := Nxt_PC_in;

									I2_BTAG_var := current_BTAG_var;
									I2_self_tag_var := "000";

									when "0100" =>
									-- LW
									I2_valid_var := inst_2_valid_in;
									I2_op_code_var := Instr2_in(15 downto 12);
									I2_op_cz_var := Instr2_in(1 downto 0);
									I2_dest_code_var := Instr2_in(11 downto 9);
									I2_operand_1_code_var := Instr2_in(8 downto 6);
									I2_operand_2_code_var := Instr2_in(5 downto 3);
									I2_Imm_var := Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(4 downto 0) ;
									I2_PC_var := std_logic_vector(unsigned(PC_in) + 1);
									I2_Nxt_PC_var := Nxt_PC_in;

									I2_BTAG_var := current_BTAG_var;
									I2_self_tag_var := "000";

									when "0101" =>
									-- SW
									I2_valid_var := inst_2_valid_in;
									I2_op_code_var := Instr2_in(15 downto 12);
									I2_op_cz_var := Instr2_in(1 downto 0);
									I2_dest_code_var := Instr2_in(11 downto 9);
									I2_operand_1_code_var := Instr2_in(8 downto 6);
									I2_operand_2_code_var := Instr2_in(5 downto 3);
									I2_Imm_var := Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(4 downto 0) ;
									I2_PC_var := std_logic_vector(unsigned(PC_in) + 1);
									I2_Nxt_PC_var := Nxt_PC_in;

									I2_BTAG_var := current_BTAG_var;
									I2_self_tag_var := "000";

									when "1100" =>
									-- BEQ
									I2_valid_var := inst_2_valid_in;
									I2_op_code_var := Instr2_in(15 downto 12);
									I2_op_cz_var := Instr2_in(1 downto 0);
									I2_dest_code_var := Instr2_in(11 downto 9);
									I2_operand_1_code_var := Instr2_in(11 downto 9);
									I2_operand_2_code_var := Instr2_in(8 downto 6);
									I2_Imm_var := Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(5) & Instr2_in(4 downto 0) ;
									I2_PC_var := std_logic_vector(unsigned(PC_in) + 1);
									I2_Nxt_PC_var := Nxt_PC_in;

									I2_BTAG_var := current_BTAG_var;
									if (current_BTAG_var = "000") then
										current_BTAG_var := "001";
										I2_self_tag_var := "001";
									
									elsif (current_BTAG_var = "001") then
									 	current_BTAG_var := "011";
										I2_self_tag_var := "011";
									
									elsif (current_BTAG_var = "010") then
									 	current_BTAG_var := "011";
										I2_self_tag_var := "011";
									
									elsif (current_BTAG_var = "011") then
									 	current_BTAG_var := "111";
										I2_self_tag_var := "111";
									
									elsif (current_BTAG_var = "101") then
									 	current_BTAG_var := "111";
										I2_self_tag_var := "111";
									
									elsif (current_BTAG_var = "110") then
									 	current_BTAG_var := "111";
										I2_self_tag_var := "111";
									
									elsif (current_BTAG_var = "100") then
									 	current_BTAG_var := "101";
										I2_self_tag_var := "101";
									else
										current_BTAG_var := "111";
										I2_self_tag_var := "111";
									end if;

									when "1000" =>
									-- JAL
									I2_valid_var := inst_2_valid_in;
									I2_op_code_var := Instr2_in(15 downto 12);
									I2_op_cz_var := Instr2_in(1 downto 0);
									I2_dest_code_var := Instr2_in(11 downto 9);
									I2_operand_1_code_var := Instr2_in(8 downto 6);
									I2_operand_2_code_var := Instr2_in(5 downto 3);
									I2_Imm_var := Instr2_in(8 downto 0) & constant_zero_LHI;
									I2_PC_var := std_logic_vector(unsigned(PC_in) + 1);
									I2_Nxt_PC_var := Nxt_PC_in;

									I2_BTAG_var := current_BTAG_var;
									if (current_BTAG_var = "000") then
										current_BTAG_var := "001";
										I2_self_tag_var := "001";
									
									elsif (current_BTAG_var = "001") then
									 	current_BTAG_var := "011";
										I2_self_tag_var := "011";
									
									elsif (current_BTAG_var = "010") then
									 	current_BTAG_var := "011";
										I2_self_tag_var := "011";
									
									elsif (current_BTAG_var = "011") then
									 	current_BTAG_var := "111";
										I2_self_tag_var := "111";
									
									elsif (current_BTAG_var = "101") then
									 	current_BTAG_var := "111";
										I2_self_tag_var := "111";
									
									elsif (current_BTAG_var = "110") then
									 	current_BTAG_var := "111";
										I2_self_tag_var := "111";
									
									elsif (current_BTAG_var = "100") then
									 	current_BTAG_var := "101";
										I2_self_tag_var := "101";
									else
										current_BTAG_var := "111";
										I2_self_tag_var := "111";
									end if;

									when "1001" =>
									-- JLR
									I2_valid_var := inst_2_valid_in;
									I2_op_code_var := Instr2_in(15 downto 12);
									I2_op_cz_var := Instr2_in(1 downto 0);
									I2_dest_code_var := Instr2_in(11 downto 9);
									I2_operand_1_code_var := Instr2_in(8 downto 6);
									I2_operand_2_code_var := Instr2_in(5 downto 3);
									I2_Imm_var := constant_zero;
									I2_PC_var := std_logic_vector(unsigned(PC_in) + 1);
									I2_Nxt_PC_var := Nxt_PC_in;

									I2_BTAG_var := current_BTAG_var;
									if (current_BTAG_var = "000") then
										current_BTAG_var := "001";
										I2_self_tag_var := "001";
									
									elsif (current_BTAG_var = "001") then
									 	current_BTAG_var := "011";
										I2_self_tag_var := "011";
									
									elsif (current_BTAG_var = "010") then
									 	current_BTAG_var := "011";
										I2_self_tag_var := "011";
									
									elsif (current_BTAG_var = "011") then
									 	current_BTAG_var := "111";
										I2_self_tag_var := "111";
									
									elsif (current_BTAG_var = "101") then
									 	current_BTAG_var := "111";
										I2_self_tag_var := "111";
									
									elsif (current_BTAG_var = "110") then
									 	current_BTAG_var := "111";
										I2_self_tag_var := "111";
									
									elsif (current_BTAG_var = "100") then
									 	current_BTAG_var := "101";
										I2_self_tag_var := "101";
									else
										current_BTAG_var := "111";
										I2_self_tag_var := "111";
									end if;

									when others =>

									I2_valid_var := inst_2_valid_in;
									I2_op_code_var := Instr2_in(15 downto 12);
									I2_op_cz_var := Instr2_in(1 downto 0);
									I2_dest_code_var := Instr2_in(11 downto 9);
									I2_operand_1_code_var := Instr2_in(8 downto 6);
									I2_operand_2_code_var := Instr2_in(5 downto 3);
									I2_Imm_var := constant_zero;
									I2_PC_var := std_logic_vector(unsigned(PC_in) + 1);
									I2_Nxt_PC_var := Nxt_PC_in;

									I2_BTAG_var := current_BTAG_var;
									I2_self_tag_var :=  "000";

								end case ;	

						else
							I2_valid_var := inst_2_valid_in;
							I2_op_code_var := Instr2_in(15 downto 12);
							I2_op_cz_var := Instr2_in(1 downto 0);
							I2_dest_code_var := Instr2_in(11 downto 9);
							I2_operand_1_code_var := Instr2_in(8 downto 6);
							I2_operand_2_code_var := Instr2_in(5 downto 3);
							I2_Imm_var := constant_zero;
							I2_PC_var := std_logic_vector(unsigned(PC_in) + 1);
							I2_Nxt_PC_var := Nxt_PC_in;


							I2_BTAG_var := current_BTAG_var;
							I2_self_tag_var :=  "000";
						end if ;

						I1_valid <= I1_valid_var;
						I1_op_code <= I1_op_code_var;
						I1_op_cz <= I1_op_cz_var;
						I1_dest_code <= I1_dest_code_var;
						I1_operand_1_code <= I1_operand_1_code_var;
						I1_operand_2_code <= I1_operand_2_code_var;
						I1_Imm <= I1_Imm_var;
						I1_PC <= I1_PC_var;
						I1_Nxt_PC <= I1_Nxt_PC_var;

						I1_BTAG <= I1_BTAG_var;
						I1_self_tag <= I1_self_tag_var;

						I2_valid <= I2_valid_var;
						I2_op_code <= I2_op_code_var;
						I2_op_cz <= I2_op_cz_var;
						I2_dest_code <= I2_dest_code_var;
						I2_operand_1_code <= I2_operand_1_code_var;
						I2_operand_2_code <= I2_operand_2_code_var;
						I2_Imm <= I2_Imm_var;
						I2_PC <= I2_PC_var;
						I2_Nxt_PC <= I2_Nxt_PC_var;

						I2_BTAG <= I2_BTAG_var;
						I2_self_tag <= I2_self_tag_var;

						current_BTAG <= current_BTAG_var;
					end if ;
				end if ;
			end if ;		

		end if ;
	
end process ; -- Decoder


end architecture ; -- arch