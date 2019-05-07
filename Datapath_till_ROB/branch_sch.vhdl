library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--package pkg is
--	type slv_array_t is array (natural range <>) of std_logic;
--	type slv3_array_t is array (natural range <>) of std_logic_vector(2 downto 0);
--	type slv4_array_t is array (natural range <>) of std_logic_vector(3 downto 0);
--	type slv6_array_t is array (natural range <>) of std_logic_vector(5 downto 0);
--	type slv8_array_t is array (natural range <>) of std_logic_vector(7 downto 0);
--	type slv16_array_t is array (natural range <>) of std_logic_vector(15 downto 0);
--end package ; -- pkg 

--package body pkg is
--end package body;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.pkg.all;

entity branch_sch is
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
end entity ; -- branch_sch

architecture arch of branch_sch is

begin

rs_br_asynchronous : process(reset,br_instr_valid_in,br_sch_valid_in,br_stall_in)

begin
	
	if (reset = '1') then
		
		rs_br_index_out <= std_logic_vector(to_unsigned(0,rs_br_index_out'length));
		rs_br_valid_out <= '0';

	else
		
		if (br_stall_in = '1') then
			
			rs_br_valid_out <= '0';
			rs_br_index_out <= std_logic_vector(to_unsigned(0,rs_br_index_out'length));

		else
			
			if (br_instr_valid_in(0) = '1' and br_sch_valid_in(0) = '1') then

				rs_br_valid_out <= '1';
				rs_br_index_out <= std_logic_vector(to_unsigned(0,rs_br_index_out'length));

			elsif (br_instr_valid_in(1) = '1' and br_sch_valid_in(1) = '1') then
				
				rs_br_valid_out <= '1';
				rs_br_index_out <= std_logic_vector(to_unsigned(1,rs_br_index_out'length));

			elsif (br_instr_valid_in(2) = '1' and br_sch_valid_in(2) = '1') then
				
				rs_br_valid_out <= '1';
				rs_br_index_out <= std_logic_vector(to_unsigned(2,rs_br_index_out'length));

			elsif (br_instr_valid_in(3) = '1' and br_sch_valid_in(3) = '1') then
				
				rs_br_valid_out <= '1';
				rs_br_index_out <= std_logic_vector(to_unsigned(3,rs_br_index_out'length));

			elsif (br_instr_valid_in(4) = '1' and br_sch_valid_in(4) = '1') then
				
				rs_br_valid_out <= '1';
				rs_br_index_out <= std_logic_vector(to_unsigned(4,rs_br_index_out'length));

			elsif (br_instr_valid_in(5) = '1' and br_sch_valid_in(5) = '1') then
				
				rs_br_valid_out <= '1';
				rs_br_index_out <= std_logic_vector(to_unsigned(5,rs_br_index_out'length));

			elsif (br_instr_valid_in(6) = '1' and br_sch_valid_in(6) = '1') then
				
				rs_br_valid_out <= '1';
				rs_br_index_out <= std_logic_vector(to_unsigned(6,rs_br_index_out'length));

			elsif (br_instr_valid_in(7) = '1' and br_sch_valid_in(7) = '1') then
				
				rs_br_valid_out <= '1';
				rs_br_index_out <= std_logic_vector(to_unsigned(7,rs_br_index_out'length));

			elsif (br_instr_valid_in(8) = '1' and br_sch_valid_in(8) = '1') then
				
				rs_br_valid_out <= '1';
				rs_br_index_out <= std_logic_vector(to_unsigned(8,rs_br_index_out'length));

			elsif (br_instr_valid_in(9) = '1' and br_sch_valid_in(9) = '1') then
				
				rs_br_valid_out <= '1';
				rs_br_index_out <= std_logic_vector(to_unsigned(9,rs_br_index_out'length));

			else
				
				rs_br_index_out <= std_logic_vector(to_unsigned(0,rs_br_index_out'length));
				rs_br_valid_out <= '0';

			end if ;

		end if ;

	end if ;
	
	
end process ; -- rs_br_asynchronous


Branch_Instruction_scheduler : process(clk,br_stall_in,br_instr_valid_in,br_op_code_in,br_original_dest_in,br_rename_dest_in,br_operand_1_in,br_operand_1_valid_in,br_operand_2_in,br_operand_2_valid_in,br_operand_3_in,br_operand_3_valid_in,br_pc_in,br_nxt_pc_in,br_sch_valid_in,br_self_tag_in,br_btag_in)
	
	variable br_instr_valid_var: slv_array_t(0 to 9);
	variable br_op_code_var: slv4_array_t(0 to 9);
	variable br_original_dest_var: slv3_array_t(0 to 9);
	variable br_rename_dest_var: slv6_array_t(0 to 9);
	variable br_operand_1_var: slv16_array_t(0 to 9);
	variable br_operand_1_valid_var: slv_array_t(0 to 9);

	variable br_operand_2_var: slv16_array_t(0 to 9);
	variable br_operand_2_valid_var: slv_array_t(0 to 9);

	variable br_operand_3_var: slv16_array_t(0 to 9);
	variable br_operand_3_valid_var: slv_array_t(0 to 9);

	variable br_pc_var: slv16_array_t(0 to 9);
	variable br_nxt_pc_var: slv16_array_t(0 to 9);
	variable br_sch_valid_var: slv_array_t(0 to 9);

	variable br_btag_var: slv3_array_t(0 to 9);
	variable br_self_tag_var: slv3_array_t(0 to 9);
	-------------------------------------------------------------------------------------
	variable br_instr_valid_out_var: std_logic;
	variable br_op_code_out_var: std_logic_vector(3 downto 0);
	variable br_original_dest_out_var: std_logic_vector(2 downto 0);
	variable br_rename_dest_out_var: std_logic_vector(5 downto 0);
	variable br_operand_1_out_var: std_logic_vector(15 downto 0);

	variable br_operand_2_out_var: std_logic_vector(15 downto 0);

	variable br_operand_3_out_var: std_logic_vector(15 downto 0);

	variable br_pc_out_var: std_logic_vector(15 downto 0);
	variable br_nxt_pc_out_var: std_logic_vector(15 downto 0);
	
	variable br_btag_out_var: std_logic_vector(2 downto 0);
	variable br_self_tag_out_var: std_logic_vector(2 downto 0);

begin
	if (clk'event and clk = '1') then

		if (reset = '1') then
			

			br_instr_valid_out <= '0';
			br_op_code_out <= (others => '0');
			br_original_dest_out <= (others => '0');
			br_rename_dest_out <= (others => '0');
			br_operand_1_out <= (others => '0');

			br_operand_2_out <= (others => '0');

			br_operand_3_out <= (others => '0');

			br_pc_out <= (others => '0');
			br_nxt_pc_out <= (others => '0');

			br_btag_out <= (others => '0');
			br_self_tag_out <= (others => '0');

		else
				
			br_instr_valid_var:= br_instr_valid_in;  
			br_op_code_var:=  br_op_code_in;
			br_original_dest_var:=  br_original_dest_in;
			br_rename_dest_var:=  br_rename_dest_in;
			br_operand_1_var:=  br_operand_1_in;
			br_operand_1_valid_var:=  br_operand_1_valid_in;

			br_operand_2_var:=  br_operand_2_in;
			br_operand_2_valid_var:=  br_operand_2_valid_in;

			br_operand_3_var:=  br_operand_3_in;
			br_operand_3_valid_var:=  br_operand_3_valid_in;

			br_pc_var:=  br_pc_in;
			br_nxt_pc_var:=  br_nxt_pc_in;
			br_sch_valid_var:=  br_sch_valid_in;

			br_btag_var:=  br_btag_in;
			br_self_tag_var:=  br_self_tag_in;

			if (br_stall_in = '1') then
				
				br_instr_valid_out_var := '0';

			else
				
				if (br_instr_valid_var(0) = '1' and br_sch_valid_var(0) = '1') then
					
					br_instr_valid_out_var:= br_instr_valid_var(0);  
					br_op_code_out_var:=  br_op_code_var(0);
					br_original_dest_out_var:=  br_original_dest_var(0);
					br_rename_dest_out_var:=  br_rename_dest_var(0);
					br_operand_1_out_var:=  br_operand_1_var(0);

					br_operand_2_out_var:=  br_operand_2_var(0);

					br_operand_3_out_var:=  br_operand_3_var(0);

					br_pc_out_var:=  br_pc_var(0);
					br_nxt_pc_out_var:=  br_nxt_pc_var(0);
					
					br_btag_out_var:=  br_btag_var(0);
					br_self_tag_out_var:=  br_self_tag_var(0);

				elsif (br_instr_valid_var(1) = '1' and br_sch_valid_var(1) = '1') then
					
					br_instr_valid_out_var:= br_instr_valid_var(1);  
					br_op_code_out_var:=  br_op_code_var(1);
					br_original_dest_out_var:=  br_original_dest_var(1);
					br_rename_dest_out_var:=  br_rename_dest_var(1);
					br_operand_1_out_var:=  br_operand_1_var(1);

					br_operand_2_out_var:=  br_operand_2_var(1);

					br_operand_3_out_var:=  br_operand_3_var(1);

					br_pc_out_var:=  br_pc_var(1);
					br_nxt_pc_out_var:=  br_nxt_pc_var(1);
					
					br_btag_out_var:=  br_btag_var(1);
					br_self_tag_out_var:=  br_self_tag_var(1);

				elsif (br_instr_valid_var(2) = '1' and br_sch_valid_var(2) = '1') then
					
					br_instr_valid_out_var:= br_instr_valid_var(2);  
					br_op_code_out_var:=  br_op_code_var(2);
					br_original_dest_out_var:=  br_original_dest_var(2);
					br_rename_dest_out_var:=  br_rename_dest_var(2);
					br_operand_1_out_var:=  br_operand_1_var(2);

					br_operand_2_out_var:=  br_operand_2_var(2);

					br_operand_3_out_var:=  br_operand_3_var(2);

					br_pc_out_var:=  br_pc_var(2);
					br_nxt_pc_out_var:=  br_nxt_pc_var(2);
					
					br_btag_out_var:=  br_btag_var(2);
					br_self_tag_out_var:=  br_self_tag_var(2);

				elsif (br_instr_valid_var(3) = '1' and br_sch_valid_var(3) = '1') then
					
					br_instr_valid_out_var:= br_instr_valid_var(3);  
					br_op_code_out_var:=  br_op_code_var(3);
					br_original_dest_out_var:=  br_original_dest_var(3);
					br_rename_dest_out_var:=  br_rename_dest_var(3);
					br_operand_1_out_var:=  br_operand_1_var(3);

					br_operand_2_out_var:=  br_operand_2_var(3);

					br_operand_3_out_var:=  br_operand_3_var(3);

					br_pc_out_var:=  br_pc_var(3);
					br_nxt_pc_out_var:=  br_nxt_pc_var(3);
					
					br_btag_out_var:=  br_btag_var(3);
					br_self_tag_out_var:=  br_self_tag_var(3);

				elsif (br_instr_valid_var(4) = '1' and br_sch_valid_var(4) = '1') then
					
					br_instr_valid_out_var:= br_instr_valid_var(4);  
					br_op_code_out_var:=  br_op_code_var(4);
					br_original_dest_out_var:=  br_original_dest_var(4);
					br_rename_dest_out_var:=  br_rename_dest_var(4);
					br_operand_1_out_var:=  br_operand_1_var(4);

					br_operand_2_out_var:=  br_operand_2_var(4);

					br_operand_3_out_var:=  br_operand_3_var(4);

					br_pc_out_var:=  br_pc_var(4);
					br_nxt_pc_out_var:=  br_nxt_pc_var(4);
					
					br_btag_out_var:=  br_btag_var(4);
					br_self_tag_out_var:=  br_self_tag_var(4);

				elsif (br_instr_valid_var(5) = '1' and br_sch_valid_var(5) = '1') then
					
					br_instr_valid_out_var:= br_instr_valid_var(5);  
					br_op_code_out_var:=  br_op_code_var(5);
					br_original_dest_out_var:=  br_original_dest_var(5);
					br_rename_dest_out_var:=  br_rename_dest_var(5);
					br_operand_1_out_var:=  br_operand_1_var(5);

					br_operand_2_out_var:=  br_operand_2_var(5);

					br_operand_3_out_var:=  br_operand_3_var(5);

					br_pc_out_var:=  br_pc_var(5);
					br_nxt_pc_out_var:=  br_nxt_pc_var(5);
					
					br_btag_out_var:=  br_btag_var(5);
					br_self_tag_out_var:=  br_self_tag_var(5);

				elsif (br_instr_valid_var(6) = '1' and br_sch_valid_var(6) = '1') then
					
					br_instr_valid_out_var:= br_instr_valid_var(6);  
					br_op_code_out_var:=  br_op_code_var(6);
					br_original_dest_out_var:=  br_original_dest_var(6);
					br_rename_dest_out_var:=  br_rename_dest_var(6);
					br_operand_1_out_var:=  br_operand_1_var(6);

					br_operand_2_out_var:=  br_operand_2_var(6);

					br_operand_3_out_var:=  br_operand_3_var(6);

					br_pc_out_var:=  br_pc_var(6);
					br_nxt_pc_out_var:=  br_nxt_pc_var(6);
					
					br_btag_out_var:=  br_btag_var(6);
					br_self_tag_out_var:=  br_self_tag_var(6);

				elsif (br_instr_valid_var(7) = '1' and br_sch_valid_var(7) = '1') then
					
					br_instr_valid_out_var:= br_instr_valid_var(7);  
					br_op_code_out_var:=  br_op_code_var(7);
					br_original_dest_out_var:=  br_original_dest_var(7);
					br_rename_dest_out_var:=  br_rename_dest_var(7);
					br_operand_1_out_var:=  br_operand_1_var(7);

					br_operand_2_out_var:=  br_operand_2_var(7);

					br_operand_3_out_var:=  br_operand_3_var(7);

					br_pc_out_var:=  br_pc_var(7);
					br_nxt_pc_out_var:=  br_nxt_pc_var(7);
					
					br_btag_out_var:=  br_btag_var(7);
					br_self_tag_out_var:=  br_self_tag_var(7);

				elsif (br_instr_valid_var(8) = '1' and br_sch_valid_var(8) = '1') then
					
					br_instr_valid_out_var:= br_instr_valid_var(8);  
					br_op_code_out_var:=  br_op_code_var(8);
					br_original_dest_out_var:=  br_original_dest_var(8);
					br_rename_dest_out_var:=  br_rename_dest_var(8);
					br_operand_1_out_var:=  br_operand_1_var(8);

					br_operand_2_out_var:=  br_operand_2_var(8);

					br_operand_3_out_var:=  br_operand_3_var(8);

					br_pc_out_var:=  br_pc_var(8);
					br_nxt_pc_out_var:=  br_nxt_pc_var(8);
					
					br_btag_out_var:=  br_btag_var(8);
					br_self_tag_out_var:=  br_self_tag_var(8);

				elsif (br_instr_valid_var(9) = '1' and br_sch_valid_var(9) = '1') then
					
					br_instr_valid_out_var:= br_instr_valid_var(9);  
					br_op_code_out_var:=  br_op_code_var(9);
					br_original_dest_out_var:=  br_original_dest_var(9);
					br_rename_dest_out_var:=  br_rename_dest_var(9);
					br_operand_1_out_var:=  br_operand_1_var(9);

					br_operand_2_out_var:=  br_operand_2_var(9);

					br_operand_3_out_var:=  br_operand_3_var(9);

					br_pc_out_var:=  br_pc_var(9);
					br_nxt_pc_out_var:=  br_nxt_pc_var(9);
					
					br_btag_out_var:=  br_btag_var(9);
					br_self_tag_out_var:=  br_self_tag_var(9);

				else
					
					br_instr_valid_out_var := '0';

				end if ;

			end if ;

			br_instr_valid_out <= br_instr_valid_out_var;
			br_op_code_out <= br_op_code_out_var;
			br_original_dest_out <= br_original_dest_out_var;
			br_rename_dest_out <= br_rename_dest_out_var;
			br_operand_1_out <= br_operand_1_out_var;

			br_operand_2_out <= br_operand_2_out_var;

			br_operand_3_out <= br_operand_3_out_var;

			br_pc_out <= br_pc_out_var;
			br_nxt_pc_out <= br_nxt_pc_out_var;

			br_btag_out <= br_btag_out_var;
			br_self_tag_out <= br_self_tag_out_var;

		end if ;
		
		
	end if ;

end process ; -- Branch_Instruction_scheduler

end architecture ; -- arch