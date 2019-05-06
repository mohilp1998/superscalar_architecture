library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pkg is
	type slv_array_t is array (natural range <>) of std_logic;
	type slv2_array_t is array (natural range <>) of std_logic_vector(1 downto 0);
	type slv3_array_t is array (natural range <>) of std_logic_vector(2 downto 0);
	type slv4_array_t is array (natural range <>) of std_logic_vector(3 downto 0);
	type slv6_array_t is array (natural range <>) of std_logic_vector(5 downto 0);
	type slv8_array_t is array (natural range <>) of std_logic_vector(7 downto 0);
	type slv16_array_t is array (natural range <>) of std_logic_vector(15 downto 0);
end package ; -- pkg 

package body pkg is
end package body;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.pkg.all;

entity alu_sch is
  port (
		clk: in std_logic;
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
end entity ; -- alu_sch

architecture arch of alu_sch is

begin

	rs_alu_asynchronous : process(alu_stall_in,alu_instr_valid_in,alu_sch_valid_in)
	
	begin

		if (alu_stall_in = '1') then
			
			rs_alu_index_1_out <= std_logic_vector(to_unsigned(0,rs_alu_index_1_out'length));
			rs_alu_valid_1_out <= '0';

			rs_alu_index_2_out <= std_logic_vector(to_unsigned(0,rs_alu_index_1_out'length));
			rs_alu_valid_2_out <= '0';

		else
			
			if (alu_instr_valid_in(0) = '1' and alu_sch_valid_in(0) = '1') then
				
				rs_alu_index_1_out <= std_logic_vector(to_unsigned(0,rs_alu_index_1_out'length));
				rs_alu_valid_1_out <= '1';

				if (alu_instr_valid_in(1) = '1' and alu_sch_valid_in(1) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(1,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(2) = '1' and alu_sch_valid_in(2) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(2,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(3) = '1' and alu_sch_valid_in(3) = '1') then
							
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(3,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(4) = '1' and alu_sch_valid_in(4) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(4,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(5) = '1' and alu_sch_valid_in(5) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(5,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(6) = '1' and alu_sch_valid_in(6) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(6,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(7,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
																		
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(8,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(9,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				else
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(0,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '0';
																																																																											
				end if ;

			elsif (alu_instr_valid_in(1) = '1' and alu_sch_valid_in(1) = '1') then
				
				rs_alu_index_1_out <= std_logic_vector(to_unsigned(1,rs_alu_index_1_out'length));
				rs_alu_valid_1_out <= '1';

				if (alu_instr_valid_in(2) = '1' and alu_sch_valid_in(2) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(2,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(3) = '1' and alu_sch_valid_in(3) = '1') then
						
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(3,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(4) = '1' and alu_sch_valid_in(4) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(4,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(5) = '1' and alu_sch_valid_in(5) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(5,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(6) = '1' and alu_sch_valid_in(6) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(6,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(7,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
																		
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(8,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(9,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				else
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(0,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '0';
																																																																											
				end if ;

			elsif (alu_instr_valid_in(2) = '1' and alu_sch_valid_in(2) = '1') then
				
				rs_alu_index_1_out <= std_logic_vector(to_unsigned(2,rs_alu_index_1_out'length));
				rs_alu_valid_1_out <= '1';

				if (alu_instr_valid_in(3) = '1' and alu_sch_valid_in(3) = '1') then
						
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(3,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(4) = '1' and alu_sch_valid_in(4) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(4,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(5) = '1' and alu_sch_valid_in(5) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(5,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(6) = '1' and alu_sch_valid_in(6) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(6,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(7,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
																		
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(8,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(9,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				else
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(0,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '0';
																																																																											
				end if ;

			elsif (alu_instr_valid_in(3) = '1' and alu_sch_valid_in(3) = '1') then
				
				rs_alu_index_1_out <= std_logic_vector(to_unsigned(3,rs_alu_index_1_out'length));
				rs_alu_valid_1_out <= '1';

				if (alu_instr_valid_in(4) = '1' and alu_sch_valid_in(4) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(4,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(5) = '1' and alu_sch_valid_in(5) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(5,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(6) = '1' and alu_sch_valid_in(6) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(6,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(7,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
																		
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(8,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(9,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				else
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(0,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '0';
																																																																											
				end if ;

			elsif (alu_instr_valid_in(4) = '1' and alu_sch_valid_in(4) = '1') then
				
				rs_alu_index_1_out <= std_logic_vector(to_unsigned(4,rs_alu_index_1_out'length));
				rs_alu_valid_1_out <= '1';

				if (alu_instr_valid_in(5) = '1' and alu_sch_valid_in(5) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(5,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(6) = '1' and alu_sch_valid_in(6) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(6,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(7,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
																		
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(8,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(9,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '1';

				else
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(0,rs_alu_index_2_out'length));
					rs_alu_valid_2_out <= '0';
																																																																											
				end if ;

			elsif (alu_instr_valid_in(5) = '1' and alu_sch_valid_in(5) = '1') then
				
				rs_alu_index_1_out <= std_logic_vector(to_unsigned(5,rs_alu_index_1_out'length));
				rs_alu_valid_1_out <= '1';

				if (alu_instr_valid_in(6) = '1' and alu_sch_valid_in(6) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(6,rs_alu_index_1_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(7,rs_alu_index_1_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(8,rs_alu_index_1_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(9,rs_alu_index_1_out'length));
					rs_alu_valid_2_out <= '1';

				else
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(0,rs_alu_index_1_out'length));
					rs_alu_valid_2_out <= '0';

				end if ;

			elsif (alu_instr_valid_in(6) = '1' and alu_sch_valid_in(6) = '1') then
				
				rs_alu_index_1_out <= std_logic_vector(to_unsigned(6,rs_alu_index_1_out'length));
				rs_alu_valid_1_out <= '1';

				if (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(7,rs_alu_index_1_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(8,rs_alu_index_1_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(9,rs_alu_index_1_out'length));
					rs_alu_valid_2_out <= '1';

				else
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(0,rs_alu_index_1_out'length));
					rs_alu_valid_2_out <= '0';

				end if ;

			elsif (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then
				
				rs_alu_index_1_out <= std_logic_vector(to_unsigned(7,rs_alu_index_1_out'length));
				rs_alu_valid_1_out <= '1';

				if (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
																		
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(8,rs_alu_index_1_out'length));
					rs_alu_valid_2_out <= '1';

				elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(9,rs_alu_index_1_out'length));
					rs_alu_valid_2_out <= '1';

				else
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(0,rs_alu_index_1_out'length));
					rs_alu_valid_2_out <= '0';

				end if ;

			elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
				
				rs_alu_index_1_out <= std_logic_vector(to_unsigned(8,rs_alu_index_1_out'length));
				rs_alu_valid_1_out <= '1';

				if (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
				
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(9,rs_alu_index_1_out'length));
					rs_alu_valid_2_out <= '1';

				else
					
					rs_alu_index_2_out <= std_logic_vector(to_unsigned(0,rs_alu_index_1_out'length));
					rs_alu_valid_2_out <= '0';

				end if ;

			elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
				
				rs_alu_index_1_out <= std_logic_vector(to_unsigned(9,rs_alu_index_1_out'length));
				rs_alu_valid_1_out <= '1';

				rs_alu_index_2_out <= std_logic_vector(to_unsigned(0,rs_alu_index_1_out'length));
				rs_alu_valid_2_out <= '0';

			else
				
				rs_alu_index_1_out <= std_logic_vector(to_unsigned(0,rs_alu_index_1_out'length));
				rs_alu_valid_1_out <= '0';

				rs_alu_index_2_out <= std_logic_vector(to_unsigned(0,rs_alu_index_1_out'length));
				rs_alu_valid_2_out <= '0';

			end if ;

		end if ;
				
	end process ; -- rs_alu_asynchronous



-----------------------------------------------------------------------------------------------------------------------------------------
	
	alu_scheduler : process(alu_stall_in,clk,alu_instr_valid_in,alu_sch_valid_in)
	
	begin
		
		if (clk'event and clk = '1') then

			if (alu_stall_in = '1') then
				
				--------------------------------------------------------------------------------------------------------------------------------
				alu_instr_valid_out_1 <= '0';
				alu_op_code_out_1 <= alu_op_code_in(0);
				alu_op_code_cz_out_1 <= alu_op_code_cz_in(0);
				
				alu_original_dest_out_1 <= alu_original_dest_in(0);
				alu_rename_dest_out_1 <= alu_rename_dest_in(0);
				
				alu_operand_1_out_1 <= alu_operand_1_in(0);
				
				alu_operand_2_out_1 <= alu_operand_2_in(0);
				
				alu_operand_3_out_1 <= alu_operand_3_in(0);
				
				alu_c_flag_out_1 <= alu_c_flag_in(0);
				alu_c_flag_rename_out_1 <= alu_c_flag_rename_in(0);

				alu_z_flag_out_1 <= alu_z_flag_in(0);
				alu_z_flag_rename_out_1 <= alu_z_flag_rename_in(0);

				alu_pc_out_1 <= alu_pc_in(0);
				
				alu_btag_out_1 <= alu_btag_in(0);

				--------------------------------------------------------------------------------------------------------------------------------

				--------------------------------------------------------------------------------------------------------------------------------
				alu_instr_valid_out_2 <= '0';
				alu_op_code_out_2 <= alu_op_code_in(1);
				alu_op_code_cz_out_2 <= alu_op_code_cz_in(1);
				
				alu_original_dest_out_2 <= alu_original_dest_in(1);
				alu_rename_dest_out_2 <= alu_rename_dest_in(1);
				
				alu_operand_1_out_2 <= alu_operand_1_in(1);
				
				alu_operand_2_out_2 <= alu_operand_2_in(1);
				
				alu_operand_3_out_2 <= alu_operand_3_in(1);
				
				alu_c_flag_out_2 <= alu_c_flag_in(1);
				alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(1);

				alu_z_flag_out_2 <= alu_z_flag_in(1);
				alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(1);

				alu_pc_out_2 <= alu_pc_in(1);
				
				alu_btag_out_2 <= alu_btag_in(1);

				--------------------------------------------------------------------------------------------------------------------------------

			else
				
				if (alu_instr_valid_in(0) = '1' and alu_sch_valid_in(0) = '1') then
					
					--------------------------------------------------------------------------------------------------------------------------------
					alu_instr_valid_out_1 <= alu_instr_valid_in(0);
					alu_op_code_out_1 <= alu_op_code_in(0);
					alu_op_code_cz_out_1 <= alu_op_code_cz_in(0);
					
					alu_original_dest_out_1 <= alu_original_dest_in(0);
					alu_rename_dest_out_1 <= alu_rename_dest_in(0);
					
					alu_operand_1_out_1 <= alu_operand_1_in(0);
					
					alu_operand_2_out_1 <= alu_operand_2_in(0);
					
					alu_operand_3_out_1 <= alu_operand_3_in(0);
					
					alu_c_flag_out_1 <= alu_c_flag_in(0);
					alu_c_flag_rename_out_1 <= alu_c_flag_rename_in(0);

					alu_z_flag_out_1 <= alu_z_flag_in(0);
					alu_z_flag_rename_out_1 <= alu_z_flag_rename_in(0);

					alu_pc_out_1 <= alu_pc_in(0);
					
					alu_btag_out_1 <= alu_btag_in(0);

					--------------------------------------------------------------------------------------------------------------------------------


					if (alu_instr_valid_in(1) = '1' and alu_sch_valid_in(1) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(1);
						alu_op_code_out_2 <= alu_op_code_in(1);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(1);
						
						alu_original_dest_out_2 <= alu_original_dest_in(1);
						alu_rename_dest_out_2 <= alu_rename_dest_in(1);
						
						alu_operand_1_out_2 <= alu_operand_1_in(1);
						
						alu_operand_2_out_2 <= alu_operand_2_in(1);
						
						alu_operand_3_out_2 <= alu_operand_3_in(1);
						
						alu_c_flag_out_2 <= alu_c_flag_in(1);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(1);

						alu_z_flag_out_2 <= alu_z_flag_in(1);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(1);

						alu_pc_out_2 <= alu_pc_in(1);
						
						alu_btag_out_2 <= alu_btag_in(1);

						--------------------------------------------------------------------------------------------------------------------------------


					elsif (alu_instr_valid_in(2) = '1' and alu_sch_valid_in(2) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(2);
						alu_op_code_out_2 <= alu_op_code_in(2);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(2);
						
						alu_original_dest_out_2 <= alu_original_dest_in(2);
						alu_rename_dest_out_2 <= alu_rename_dest_in(2);
						
						alu_operand_1_out_2 <= alu_operand_1_in(2);
						
						alu_operand_2_out_2 <= alu_operand_2_in(2);
						
						alu_operand_3_out_2 <= alu_operand_3_in(2);
						
						alu_c_flag_out_2 <= alu_c_flag_in(2);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(2);

						alu_z_flag_out_2 <= alu_z_flag_in(2);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(2);

						alu_pc_out_2 <= alu_pc_in(2);
						
						alu_btag_out_2 <= alu_btag_in(2);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(3) = '1' and alu_sch_valid_in(3) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(3);
						alu_op_code_out_2 <= alu_op_code_in(3);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(3);
						
						alu_original_dest_out_2 <= alu_original_dest_in(3);
						alu_rename_dest_out_2 <= alu_rename_dest_in(3);
						
						alu_operand_1_out_2 <= alu_operand_1_in(3);
						
						alu_operand_2_out_2 <= alu_operand_2_in(3);
						
						alu_operand_3_out_2 <= alu_operand_3_in(3);
						
						alu_c_flag_out_2 <= alu_c_flag_in(3);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(3);

						alu_z_flag_out_2 <= alu_z_flag_in(3);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(3);

						alu_pc_out_2 <= alu_pc_in(3);
						
						alu_btag_out_2 <= alu_btag_in(3);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(4) = '1' and alu_sch_valid_in(4) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(4);
						alu_op_code_out_2 <= alu_op_code_in(4);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(4);
						
						alu_original_dest_out_2 <= alu_original_dest_in(4);
						alu_rename_dest_out_2 <= alu_rename_dest_in(4);
						
						alu_operand_1_out_2 <= alu_operand_1_in(4);
						
						alu_operand_2_out_2 <= alu_operand_2_in(4);
						
						alu_operand_3_out_2 <= alu_operand_3_in(4);
						
						alu_c_flag_out_2 <= alu_c_flag_in(4);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(4);

						alu_z_flag_out_2 <= alu_z_flag_in(4);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(4);

						alu_pc_out_2 <= alu_pc_in(4);
						
						alu_btag_out_2 <= alu_btag_in(4);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(5) = '1' and alu_sch_valid_in(5) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(5);
						alu_op_code_out_2 <= alu_op_code_in(5);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(5);
						
						alu_original_dest_out_2 <= alu_original_dest_in(5);
						alu_rename_dest_out_2 <= alu_rename_dest_in(5);
						
						alu_operand_1_out_2 <= alu_operand_1_in(5);
						
						alu_operand_2_out_2 <= alu_operand_2_in(5);
						
						alu_operand_3_out_2 <= alu_operand_3_in(5);
						
						alu_c_flag_out_2 <= alu_c_flag_in(5);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(5);

						alu_z_flag_out_2 <= alu_z_flag_in(5);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(5);

						alu_pc_out_2 <= alu_pc_in(5);
						
						alu_btag_out_2 <= alu_btag_in(5);

						--------------------------------------------------------------------------------------------------------------------------------				
					elsif (alu_instr_valid_in(6) = '1' and alu_sch_valid_in(6) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(6);
						alu_op_code_out_2 <= alu_op_code_in(6);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(6);
						
						alu_original_dest_out_2 <= alu_original_dest_in(6);
						alu_rename_dest_out_2 <= alu_rename_dest_in(6);
						
						alu_operand_1_out_2 <= alu_operand_1_in(6);
						
						alu_operand_2_out_2 <= alu_operand_2_in(6);
						
						alu_operand_3_out_2 <= alu_operand_3_in(6);
						
						alu_c_flag_out_2 <= alu_c_flag_in(6);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(6);

						alu_z_flag_out_2 <= alu_z_flag_in(6);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(6);

						alu_pc_out_2 <= alu_pc_in(6);
						
						alu_btag_out_2 <= alu_btag_in(6);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(7);
						alu_op_code_out_2 <= alu_op_code_in(7);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(7);
						
						alu_original_dest_out_2 <= alu_original_dest_in(7);
						alu_rename_dest_out_2 <= alu_rename_dest_in(7);
						
						alu_operand_1_out_2 <= alu_operand_1_in(7);
						
						alu_operand_2_out_2 <= alu_operand_2_in(7);
						
						alu_operand_3_out_2 <= alu_operand_3_in(7);
						
						alu_c_flag_out_2 <= alu_c_flag_in(7);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(7);

						alu_z_flag_out_2 <= alu_z_flag_in(7);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(7);

						alu_pc_out_2 <= alu_pc_in(7);
						
						alu_btag_out_2 <= alu_btag_in(7);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(8);
						alu_op_code_out_2 <= alu_op_code_in(8);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(8);
						
						alu_original_dest_out_2 <= alu_original_dest_in(8);
						alu_rename_dest_out_2 <= alu_rename_dest_in(8);
						
						alu_operand_1_out_2 <= alu_operand_1_in(8);
						
						alu_operand_2_out_2 <= alu_operand_2_in(8);
						
						alu_operand_3_out_2 <= alu_operand_3_in(8);
						
						alu_c_flag_out_2 <= alu_c_flag_in(8);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(8);

						alu_z_flag_out_2 <= alu_z_flag_in(8);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(8);

						alu_pc_out_2 <= alu_pc_in(8);
						
						alu_btag_out_2 <= alu_btag_in(8);

						--------------------------------------------------------------------------------------------------------------------------------										
					elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(9);
						alu_op_code_out_2 <= alu_op_code_in(9);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(9);
						
						alu_original_dest_out_2 <= alu_original_dest_in(9);
						alu_rename_dest_out_2 <= alu_rename_dest_in(9);
						
						alu_operand_1_out_2 <= alu_operand_1_in(9);
						
						alu_operand_2_out_2 <= alu_operand_2_in(9);
						
						alu_operand_3_out_2 <= alu_operand_3_in(9);
						
						alu_c_flag_out_2 <= alu_c_flag_in(9);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(9);

						alu_z_flag_out_2 <= alu_z_flag_in(9);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(9);

						alu_pc_out_2 <= alu_pc_in(9);
						
						alu_btag_out_2 <= alu_btag_in(9);

						--------------------------------------------------------------------------------------------------------------------------------
					else
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= '0';
						alu_op_code_out_2 <= alu_op_code_in(1);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(1);
						
						alu_original_dest_out_2 <= alu_original_dest_in(1);
						alu_rename_dest_out_2 <= alu_rename_dest_in(1);
						
						alu_operand_1_out_2 <= alu_operand_1_in(1);
						
						alu_operand_2_out_2 <= alu_operand_2_in(1);
						
						alu_operand_3_out_2 <= alu_operand_3_in(1);
						
						alu_c_flag_out_2 <= alu_c_flag_in(1);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(1);

						alu_z_flag_out_2 <= alu_z_flag_in(1);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(1);

						alu_pc_out_2 <= alu_pc_in(1);
						
						alu_btag_out_2 <= alu_btag_in(1);

						--------------------------------------------------------------------------------------------------------------------------------																																																																					
					end if ;

				elsif (alu_instr_valid_in(1) = '1' and alu_sch_valid_in(1) = '1') then

					--------------------------------------------------------------------------------------------------------------------------------
					alu_instr_valid_out_1 <= alu_instr_valid_in(1);
					alu_op_code_out_1 <= alu_op_code_in(1);
					alu_op_code_cz_out_1 <= alu_op_code_cz_in(1);
					
					alu_original_dest_out_1 <= alu_original_dest_in(1);
					alu_rename_dest_out_1 <= alu_rename_dest_in(1);
					
					alu_operand_1_out_1 <= alu_operand_1_in(1);
					
					alu_operand_2_out_1 <= alu_operand_2_in(1);
					
					alu_operand_3_out_1 <= alu_operand_3_in(1);
					
					alu_c_flag_out_1 <= alu_c_flag_in(1);
					alu_c_flag_rename_out_1 <= alu_c_flag_rename_in(1);

					alu_z_flag_out_1 <= alu_z_flag_in(1);
					alu_z_flag_rename_out_1 <= alu_z_flag_rename_in(1);

					alu_pc_out_1 <= alu_pc_in(1);
					
					alu_btag_out_1 <= alu_btag_in(1);

					--------------------------------------------------------------------------------------------------------------------------------

					
					if (alu_instr_valid_in(2) = '1' and alu_sch_valid_in(2) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(2);
						alu_op_code_out_2 <= alu_op_code_in(2);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(2);
						
						alu_original_dest_out_2 <= alu_original_dest_in(2);
						alu_rename_dest_out_2 <= alu_rename_dest_in(2);
						
						alu_operand_1_out_2 <= alu_operand_1_in(2);
						
						alu_operand_2_out_2 <= alu_operand_2_in(2);
						
						alu_operand_3_out_2 <= alu_operand_3_in(2);
						
						alu_c_flag_out_2 <= alu_c_flag_in(2);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(2);

						alu_z_flag_out_2 <= alu_z_flag_in(2);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(2);

						alu_pc_out_2 <= alu_pc_in(2);
						
						alu_btag_out_2 <= alu_btag_in(2);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(3) = '1' and alu_sch_valid_in(3) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(3);
						alu_op_code_out_2 <= alu_op_code_in(3);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(3);
						
						alu_original_dest_out_2 <= alu_original_dest_in(3);
						alu_rename_dest_out_2 <= alu_rename_dest_in(3);
						
						alu_operand_1_out_2 <= alu_operand_1_in(3);
						
						alu_operand_2_out_2 <= alu_operand_2_in(3);
						
						alu_operand_3_out_2 <= alu_operand_3_in(3);
						
						alu_c_flag_out_2 <= alu_c_flag_in(3);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(3);

						alu_z_flag_out_2 <= alu_z_flag_in(3);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(3);

						alu_pc_out_2 <= alu_pc_in(3);
						
						alu_btag_out_2 <= alu_btag_in(3);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(4) = '1' and alu_sch_valid_in(4) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(4);
						alu_op_code_out_2 <= alu_op_code_in(4);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(4);
						
						alu_original_dest_out_2 <= alu_original_dest_in(4);
						alu_rename_dest_out_2 <= alu_rename_dest_in(4);
						
						alu_operand_1_out_2 <= alu_operand_1_in(4);
						
						alu_operand_2_out_2 <= alu_operand_2_in(4);
						
						alu_operand_3_out_2 <= alu_operand_3_in(4);
						
						alu_c_flag_out_2 <= alu_c_flag_in(4);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(4);

						alu_z_flag_out_2 <= alu_z_flag_in(4);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(4);

						alu_pc_out_2 <= alu_pc_in(4);
						
						alu_btag_out_2 <= alu_btag_in(4);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(5) = '1' and alu_sch_valid_in(5) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(5);
						alu_op_code_out_2 <= alu_op_code_in(5);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(5);
						
						alu_original_dest_out_2 <= alu_original_dest_in(5);
						alu_rename_dest_out_2 <= alu_rename_dest_in(5);
						
						alu_operand_1_out_2 <= alu_operand_1_in(5);
						
						alu_operand_2_out_2 <= alu_operand_2_in(5);
						
						alu_operand_3_out_2 <= alu_operand_3_in(5);
						
						alu_c_flag_out_2 <= alu_c_flag_in(5);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(5);

						alu_z_flag_out_2 <= alu_z_flag_in(5);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(5);

						alu_pc_out_2 <= alu_pc_in(5);
						
						alu_btag_out_2 <= alu_btag_in(5);

						--------------------------------------------------------------------------------------------------------------------------------				
					elsif (alu_instr_valid_in(6) = '1' and alu_sch_valid_in(6) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(6);
						alu_op_code_out_2 <= alu_op_code_in(6);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(6);
						
						alu_original_dest_out_2 <= alu_original_dest_in(6);
						alu_rename_dest_out_2 <= alu_rename_dest_in(6);
						
						alu_operand_1_out_2 <= alu_operand_1_in(6);
						
						alu_operand_2_out_2 <= alu_operand_2_in(6);
						
						alu_operand_3_out_2 <= alu_operand_3_in(6);
						
						alu_c_flag_out_2 <= alu_c_flag_in(6);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(6);

						alu_z_flag_out_2 <= alu_z_flag_in(6);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(6);

						alu_pc_out_2 <= alu_pc_in(6);
						
						alu_btag_out_2 <= alu_btag_in(6);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(7);
						alu_op_code_out_2 <= alu_op_code_in(7);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(7);
						
						alu_original_dest_out_2 <= alu_original_dest_in(7);
						alu_rename_dest_out_2 <= alu_rename_dest_in(7);
						
						alu_operand_1_out_2 <= alu_operand_1_in(7);
						
						alu_operand_2_out_2 <= alu_operand_2_in(7);
						
						alu_operand_3_out_2 <= alu_operand_3_in(7);
						
						alu_c_flag_out_2 <= alu_c_flag_in(7);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(7);

						alu_z_flag_out_2 <= alu_z_flag_in(7);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(7);

						alu_pc_out_2 <= alu_pc_in(7);
						
						alu_btag_out_2 <= alu_btag_in(7);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(8);
						alu_op_code_out_2 <= alu_op_code_in(8);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(8);
						
						alu_original_dest_out_2 <= alu_original_dest_in(8);
						alu_rename_dest_out_2 <= alu_rename_dest_in(8);
						
						alu_operand_1_out_2 <= alu_operand_1_in(8);
						
						alu_operand_2_out_2 <= alu_operand_2_in(8);
						
						alu_operand_3_out_2 <= alu_operand_3_in(8);
						
						alu_c_flag_out_2 <= alu_c_flag_in(8);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(8);

						alu_z_flag_out_2 <= alu_z_flag_in(8);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(8);

						alu_pc_out_2 <= alu_pc_in(8);
						
						alu_btag_out_2 <= alu_btag_in(8);

						--------------------------------------------------------------------------------------------------------------------------------										
					elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(9);
						alu_op_code_out_2 <= alu_op_code_in(9);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(9);
						
						alu_original_dest_out_2 <= alu_original_dest_in(9);
						alu_rename_dest_out_2 <= alu_rename_dest_in(9);
						
						alu_operand_1_out_2 <= alu_operand_1_in(9);
						
						alu_operand_2_out_2 <= alu_operand_2_in(9);
						
						alu_operand_3_out_2 <= alu_operand_3_in(9);
						
						alu_c_flag_out_2 <= alu_c_flag_in(9);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(9);

						alu_z_flag_out_2 <= alu_z_flag_in(9);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(9);

						alu_pc_out_2 <= alu_pc_in(9);
						
						alu_btag_out_2 <= alu_btag_in(9);

						--------------------------------------------------------------------------------------------------------------------------------
					else
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= '0';
						alu_op_code_out_2 <= alu_op_code_in(1);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(1);
						
						alu_original_dest_out_2 <= alu_original_dest_in(1);
						alu_rename_dest_out_2 <= alu_rename_dest_in(1);
						
						alu_operand_1_out_2 <= alu_operand_1_in(1);
						
						alu_operand_2_out_2 <= alu_operand_2_in(1);
						
						alu_operand_3_out_2 <= alu_operand_3_in(1);
						
						alu_c_flag_out_2 <= alu_c_flag_in(1);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(1);

						alu_z_flag_out_2 <= alu_z_flag_in(1);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(1);

						alu_pc_out_2 <= alu_pc_in(1);
						
						alu_btag_out_2 <= alu_btag_in(1);

						--------------------------------------------------------------------------------------------------------------------------------																																																																					
					end if ;

				elsif (alu_instr_valid_in(2) = '1' and alu_sch_valid_in(2) = '1') then

					--------------------------------------------------------------------------------------------------------------------------------
					alu_instr_valid_out_1 <= alu_instr_valid_in(2);
					alu_op_code_out_1 <= alu_op_code_in(2);
					alu_op_code_cz_out_1 <= alu_op_code_cz_in(2);
					
					alu_original_dest_out_1 <= alu_original_dest_in(2);
					alu_rename_dest_out_1 <= alu_rename_dest_in(2);
					
					alu_operand_1_out_1 <= alu_operand_1_in(2);
					
					alu_operand_2_out_1 <= alu_operand_2_in(2);
					
					alu_operand_3_out_1 <= alu_operand_3_in(2);
					
					alu_c_flag_out_1 <= alu_c_flag_in(2);
					alu_c_flag_rename_out_1 <= alu_c_flag_rename_in(2);

					alu_z_flag_out_1 <= alu_z_flag_in(2);
					alu_z_flag_rename_out_1 <= alu_z_flag_rename_in(2);

					alu_pc_out_1 <= alu_pc_in(2);
					
					alu_btag_out_1 <= alu_btag_in(2);

					--------------------------------------------------------------------------------------------------------------------------------

					
					if (alu_instr_valid_in(3) = '1' and alu_sch_valid_in(3) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(3);
						alu_op_code_out_2 <= alu_op_code_in(3);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(3);
						
						alu_original_dest_out_2 <= alu_original_dest_in(3);
						alu_rename_dest_out_2 <= alu_rename_dest_in(3);
						
						alu_operand_1_out_2 <= alu_operand_1_in(3);
						
						alu_operand_2_out_2 <= alu_operand_2_in(3);
						
						alu_operand_3_out_2 <= alu_operand_3_in(3);
						
						alu_c_flag_out_2 <= alu_c_flag_in(3);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(3);

						alu_z_flag_out_2 <= alu_z_flag_in(3);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(3);

						alu_pc_out_2 <= alu_pc_in(3);
						
						alu_btag_out_2 <= alu_btag_in(3);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(4) = '1' and alu_sch_valid_in(4) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(4);
						alu_op_code_out_2 <= alu_op_code_in(4);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(4);
						
						alu_original_dest_out_2 <= alu_original_dest_in(4);
						alu_rename_dest_out_2 <= alu_rename_dest_in(4);
						
						alu_operand_1_out_2 <= alu_operand_1_in(4);
						
						alu_operand_2_out_2 <= alu_operand_2_in(4);
						
						alu_operand_3_out_2 <= alu_operand_3_in(4);
						
						alu_c_flag_out_2 <= alu_c_flag_in(4);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(4);

						alu_z_flag_out_2 <= alu_z_flag_in(4);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(4);

						alu_pc_out_2 <= alu_pc_in(4);
						
						alu_btag_out_2 <= alu_btag_in(4);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(5) = '1' and alu_sch_valid_in(5) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(5);
						alu_op_code_out_2 <= alu_op_code_in(5);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(5);
						
						alu_original_dest_out_2 <= alu_original_dest_in(5);
						alu_rename_dest_out_2 <= alu_rename_dest_in(5);
						
						alu_operand_1_out_2 <= alu_operand_1_in(5);
						
						alu_operand_2_out_2 <= alu_operand_2_in(5);
						
						alu_operand_3_out_2 <= alu_operand_3_in(5);
						
						alu_c_flag_out_2 <= alu_c_flag_in(5);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(5);

						alu_z_flag_out_2 <= alu_z_flag_in(5);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(5);

						alu_pc_out_2 <= alu_pc_in(5);
						
						alu_btag_out_2 <= alu_btag_in(5);

						--------------------------------------------------------------------------------------------------------------------------------				
					elsif (alu_instr_valid_in(6) = '1' and alu_sch_valid_in(6) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(6);
						alu_op_code_out_2 <= alu_op_code_in(6);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(6);
						
						alu_original_dest_out_2 <= alu_original_dest_in(6);
						alu_rename_dest_out_2 <= alu_rename_dest_in(6);
						
						alu_operand_1_out_2 <= alu_operand_1_in(6);
						
						alu_operand_2_out_2 <= alu_operand_2_in(6);
						
						alu_operand_3_out_2 <= alu_operand_3_in(6);
						
						alu_c_flag_out_2 <= alu_c_flag_in(6);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(6);

						alu_z_flag_out_2 <= alu_z_flag_in(6);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(6);

						alu_pc_out_2 <= alu_pc_in(6);
						
						alu_btag_out_2 <= alu_btag_in(6);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(7);
						alu_op_code_out_2 <= alu_op_code_in(7);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(7);
						
						alu_original_dest_out_2 <= alu_original_dest_in(7);
						alu_rename_dest_out_2 <= alu_rename_dest_in(7);
						
						alu_operand_1_out_2 <= alu_operand_1_in(7);
						
						alu_operand_2_out_2 <= alu_operand_2_in(7);
						
						alu_operand_3_out_2 <= alu_operand_3_in(7);
						
						alu_c_flag_out_2 <= alu_c_flag_in(7);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(7);

						alu_z_flag_out_2 <= alu_z_flag_in(7);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(7);

						alu_pc_out_2 <= alu_pc_in(7);
						
						alu_btag_out_2 <= alu_btag_in(7);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(8);
						alu_op_code_out_2 <= alu_op_code_in(8);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(8);
						
						alu_original_dest_out_2 <= alu_original_dest_in(8);
						alu_rename_dest_out_2 <= alu_rename_dest_in(8);
						
						alu_operand_1_out_2 <= alu_operand_1_in(8);
						
						alu_operand_2_out_2 <= alu_operand_2_in(8);
						
						alu_operand_3_out_2 <= alu_operand_3_in(8);
						
						alu_c_flag_out_2 <= alu_c_flag_in(8);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(8);

						alu_z_flag_out_2 <= alu_z_flag_in(8);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(8);

						alu_pc_out_2 <= alu_pc_in(8);
						
						alu_btag_out_2 <= alu_btag_in(8);

						--------------------------------------------------------------------------------------------------------------------------------										
					elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(9);
						alu_op_code_out_2 <= alu_op_code_in(9);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(9);
						
						alu_original_dest_out_2 <= alu_original_dest_in(9);
						alu_rename_dest_out_2 <= alu_rename_dest_in(9);
						
						alu_operand_1_out_2 <= alu_operand_1_in(9);
						
						alu_operand_2_out_2 <= alu_operand_2_in(9);
						
						alu_operand_3_out_2 <= alu_operand_3_in(9);
						
						alu_c_flag_out_2 <= alu_c_flag_in(9);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(9);

						alu_z_flag_out_2 <= alu_z_flag_in(9);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(9);

						alu_pc_out_2 <= alu_pc_in(9);
						
						alu_btag_out_2 <= alu_btag_in(9);

						--------------------------------------------------------------------------------------------------------------------------------
					else
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= '0';
						alu_op_code_out_2 <= alu_op_code_in(1);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(1);
						
						alu_original_dest_out_2 <= alu_original_dest_in(1);
						alu_rename_dest_out_2 <= alu_rename_dest_in(1);
						
						alu_operand_1_out_2 <= alu_operand_1_in(1);
						
						alu_operand_2_out_2 <= alu_operand_2_in(1);
						
						alu_operand_3_out_2 <= alu_operand_3_in(1);
						
						alu_c_flag_out_2 <= alu_c_flag_in(1);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(1);

						alu_z_flag_out_2 <= alu_z_flag_in(1);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(1);

						alu_pc_out_2 <= alu_pc_in(1);
						
						alu_btag_out_2 <= alu_btag_in(1);

						--------------------------------------------------------------------------------------------------------------------------------																																																																					
					end if ;

				elsif (alu_instr_valid_in(3) = '1' and alu_sch_valid_in(3) = '1') then

					--------------------------------------------------------------------------------------------------------------------------------
					alu_instr_valid_out_1 <= alu_instr_valid_in(3);
					alu_op_code_out_1 <= alu_op_code_in(3);
					alu_op_code_cz_out_1 <= alu_op_code_cz_in(3);
					
					alu_original_dest_out_1 <= alu_original_dest_in(3);
					alu_rename_dest_out_1 <= alu_rename_dest_in(3);
					
					alu_operand_1_out_1 <= alu_operand_1_in(3);
					
					alu_operand_2_out_1 <= alu_operand_2_in(3);
					
					alu_operand_3_out_1 <= alu_operand_3_in(3);
					
					alu_c_flag_out_1 <= alu_c_flag_in(3);
					alu_c_flag_rename_out_1 <= alu_c_flag_rename_in(3);

					alu_z_flag_out_1 <= alu_z_flag_in(3);
					alu_z_flag_rename_out_1 <= alu_z_flag_rename_in(3);

					alu_pc_out_1 <= alu_pc_in(3);
					
					alu_btag_out_1 <= alu_btag_in(3);

					--------------------------------------------------------------------------------------------------------------------------------

					
					if (alu_instr_valid_in(4) = '1' and alu_sch_valid_in(4) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(4);
						alu_op_code_out_2 <= alu_op_code_in(4);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(4);
						
						alu_original_dest_out_2 <= alu_original_dest_in(4);
						alu_rename_dest_out_2 <= alu_rename_dest_in(4);
						
						alu_operand_1_out_2 <= alu_operand_1_in(4);
						
						alu_operand_2_out_2 <= alu_operand_2_in(4);
						
						alu_operand_3_out_2 <= alu_operand_3_in(4);
						
						alu_c_flag_out_2 <= alu_c_flag_in(4);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(4);

						alu_z_flag_out_2 <= alu_z_flag_in(4);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(4);

						alu_pc_out_2 <= alu_pc_in(4);
						
						alu_btag_out_2 <= alu_btag_in(4);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(5) = '1' and alu_sch_valid_in(5) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(5);
						alu_op_code_out_2 <= alu_op_code_in(5);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(5);
						
						alu_original_dest_out_2 <= alu_original_dest_in(5);
						alu_rename_dest_out_2 <= alu_rename_dest_in(5);
						
						alu_operand_1_out_2 <= alu_operand_1_in(5);
						
						alu_operand_2_out_2 <= alu_operand_2_in(5);
						
						alu_operand_3_out_2 <= alu_operand_3_in(5);
						
						alu_c_flag_out_2 <= alu_c_flag_in(5);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(5);

						alu_z_flag_out_2 <= alu_z_flag_in(5);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(5);

						alu_pc_out_2 <= alu_pc_in(5);
						
						alu_btag_out_2 <= alu_btag_in(5);

						--------------------------------------------------------------------------------------------------------------------------------				
					elsif (alu_instr_valid_in(6) = '1' and alu_sch_valid_in(6) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(6);
						alu_op_code_out_2 <= alu_op_code_in(6);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(6);
						
						alu_original_dest_out_2 <= alu_original_dest_in(6);
						alu_rename_dest_out_2 <= alu_rename_dest_in(6);
						
						alu_operand_1_out_2 <= alu_operand_1_in(6);
						
						alu_operand_2_out_2 <= alu_operand_2_in(6);
						
						alu_operand_3_out_2 <= alu_operand_3_in(6);
						
						alu_c_flag_out_2 <= alu_c_flag_in(6);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(6);

						alu_z_flag_out_2 <= alu_z_flag_in(6);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(6);

						alu_pc_out_2 <= alu_pc_in(6);
						
						alu_btag_out_2 <= alu_btag_in(6);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(7);
						alu_op_code_out_2 <= alu_op_code_in(7);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(7);
						
						alu_original_dest_out_2 <= alu_original_dest_in(7);
						alu_rename_dest_out_2 <= alu_rename_dest_in(7);
						
						alu_operand_1_out_2 <= alu_operand_1_in(7);
						
						alu_operand_2_out_2 <= alu_operand_2_in(7);
						
						alu_operand_3_out_2 <= alu_operand_3_in(7);
						
						alu_c_flag_out_2 <= alu_c_flag_in(7);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(7);

						alu_z_flag_out_2 <= alu_z_flag_in(7);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(7);

						alu_pc_out_2 <= alu_pc_in(7);
						
						alu_btag_out_2 <= alu_btag_in(7);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(8);
						alu_op_code_out_2 <= alu_op_code_in(8);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(8);
						
						alu_original_dest_out_2 <= alu_original_dest_in(8);
						alu_rename_dest_out_2 <= alu_rename_dest_in(8);
						
						alu_operand_1_out_2 <= alu_operand_1_in(8);
						
						alu_operand_2_out_2 <= alu_operand_2_in(8);
						
						alu_operand_3_out_2 <= alu_operand_3_in(8);
						
						alu_c_flag_out_2 <= alu_c_flag_in(8);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(8);

						alu_z_flag_out_2 <= alu_z_flag_in(8);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(8);

						alu_pc_out_2 <= alu_pc_in(8);
						
						alu_btag_out_2 <= alu_btag_in(8);

						--------------------------------------------------------------------------------------------------------------------------------										
					elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(9);
						alu_op_code_out_2 <= alu_op_code_in(9);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(9);
						
						alu_original_dest_out_2 <= alu_original_dest_in(9);
						alu_rename_dest_out_2 <= alu_rename_dest_in(9);
						
						alu_operand_1_out_2 <= alu_operand_1_in(9);
						
						alu_operand_2_out_2 <= alu_operand_2_in(9);
						
						alu_operand_3_out_2 <= alu_operand_3_in(9);
						
						alu_c_flag_out_2 <= alu_c_flag_in(9);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(9);

						alu_z_flag_out_2 <= alu_z_flag_in(9);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(9);

						alu_pc_out_2 <= alu_pc_in(9);
						
						alu_btag_out_2 <= alu_btag_in(9);

						--------------------------------------------------------------------------------------------------------------------------------
					else
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= '0';
						alu_op_code_out_2 <= alu_op_code_in(1);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(1);
						
						alu_original_dest_out_2 <= alu_original_dest_in(1);
						alu_rename_dest_out_2 <= alu_rename_dest_in(1);
						
						alu_operand_1_out_2 <= alu_operand_1_in(1);
						
						alu_operand_2_out_2 <= alu_operand_2_in(1);
						
						alu_operand_3_out_2 <= alu_operand_3_in(1);
						
						alu_c_flag_out_2 <= alu_c_flag_in(1);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(1);

						alu_z_flag_out_2 <= alu_z_flag_in(1);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(1);

						alu_pc_out_2 <= alu_pc_in(1);
						
						alu_btag_out_2 <= alu_btag_in(1);

						--------------------------------------------------------------------------------------------------------------------------------																																																																					
					end if ;

				elsif (alu_instr_valid_in(4) = '1' and alu_sch_valid_in(4) = '1') then

					--------------------------------------------------------------------------------------------------------------------------------
					alu_instr_valid_out_1 <= alu_instr_valid_in(4);
					alu_op_code_out_1 <= alu_op_code_in(4);
					alu_op_code_cz_out_1 <= alu_op_code_cz_in(4);
					
					alu_original_dest_out_1 <= alu_original_dest_in(4);
					alu_rename_dest_out_1 <= alu_rename_dest_in(4);
					
					alu_operand_1_out_1 <= alu_operand_1_in(4);
					
					alu_operand_2_out_1 <= alu_operand_2_in(4);
					
					alu_operand_3_out_1 <= alu_operand_3_in(4);
					
					alu_c_flag_out_1 <= alu_c_flag_in(4);
					alu_c_flag_rename_out_1 <= alu_c_flag_rename_in(4);

					alu_z_flag_out_1 <= alu_z_flag_in(4);
					alu_z_flag_rename_out_1 <= alu_z_flag_rename_in(4);

					alu_pc_out_1 <= alu_pc_in(4);
					
					alu_btag_out_1 <= alu_btag_in(4);

					--------------------------------------------------------------------------------------------------------------------------------

					
					if (alu_instr_valid_in(5) = '1' and alu_sch_valid_in(5) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(5);
						alu_op_code_out_2 <= alu_op_code_in(5);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(5);
						
						alu_original_dest_out_2 <= alu_original_dest_in(5);
						alu_rename_dest_out_2 <= alu_rename_dest_in(5);
						
						alu_operand_1_out_2 <= alu_operand_1_in(5);
						
						alu_operand_2_out_2 <= alu_operand_2_in(5);
						
						alu_operand_3_out_2 <= alu_operand_3_in(5);
						
						alu_c_flag_out_2 <= alu_c_flag_in(5);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(5);

						alu_z_flag_out_2 <= alu_z_flag_in(5);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(5);

						alu_pc_out_2 <= alu_pc_in(5);
						
						alu_btag_out_2 <= alu_btag_in(5);

						--------------------------------------------------------------------------------------------------------------------------------				
					elsif (alu_instr_valid_in(6) = '1' and alu_sch_valid_in(6) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(6);
						alu_op_code_out_2 <= alu_op_code_in(6);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(6);
						
						alu_original_dest_out_2 <= alu_original_dest_in(6);
						alu_rename_dest_out_2 <= alu_rename_dest_in(6);
						
						alu_operand_1_out_2 <= alu_operand_1_in(6);
						
						alu_operand_2_out_2 <= alu_operand_2_in(6);
						
						alu_operand_3_out_2 <= alu_operand_3_in(6);
						
						alu_c_flag_out_2 <= alu_c_flag_in(6);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(6);

						alu_z_flag_out_2 <= alu_z_flag_in(6);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(6);

						alu_pc_out_2 <= alu_pc_in(6);
						
						alu_btag_out_2 <= alu_btag_in(6);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(7);
						alu_op_code_out_2 <= alu_op_code_in(7);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(7);
						
						alu_original_dest_out_2 <= alu_original_dest_in(7);
						alu_rename_dest_out_2 <= alu_rename_dest_in(7);
						
						alu_operand_1_out_2 <= alu_operand_1_in(7);
						
						alu_operand_2_out_2 <= alu_operand_2_in(7);
						
						alu_operand_3_out_2 <= alu_operand_3_in(7);
						
						alu_c_flag_out_2 <= alu_c_flag_in(7);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(7);

						alu_z_flag_out_2 <= alu_z_flag_in(7);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(7);

						alu_pc_out_2 <= alu_pc_in(7);
						
						alu_btag_out_2 <= alu_btag_in(7);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(8);
						alu_op_code_out_2 <= alu_op_code_in(8);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(8);
						
						alu_original_dest_out_2 <= alu_original_dest_in(8);
						alu_rename_dest_out_2 <= alu_rename_dest_in(8);
						
						alu_operand_1_out_2 <= alu_operand_1_in(8);
						
						alu_operand_2_out_2 <= alu_operand_2_in(8);
						
						alu_operand_3_out_2 <= alu_operand_3_in(8);
						
						alu_c_flag_out_2 <= alu_c_flag_in(8);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(8);

						alu_z_flag_out_2 <= alu_z_flag_in(8);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(8);

						alu_pc_out_2 <= alu_pc_in(8);
						
						alu_btag_out_2 <= alu_btag_in(8);

						--------------------------------------------------------------------------------------------------------------------------------										
					elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(9);
						alu_op_code_out_2 <= alu_op_code_in(9);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(9);
						
						alu_original_dest_out_2 <= alu_original_dest_in(9);
						alu_rename_dest_out_2 <= alu_rename_dest_in(9);
						
						alu_operand_1_out_2 <= alu_operand_1_in(9);
						
						alu_operand_2_out_2 <= alu_operand_2_in(9);
						
						alu_operand_3_out_2 <= alu_operand_3_in(9);
						
						alu_c_flag_out_2 <= alu_c_flag_in(9);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(9);

						alu_z_flag_out_2 <= alu_z_flag_in(9);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(9);

						alu_pc_out_2 <= alu_pc_in(9);
						
						alu_btag_out_2 <= alu_btag_in(9);

						--------------------------------------------------------------------------------------------------------------------------------
					else
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= '0';
						alu_op_code_out_2 <= alu_op_code_in(1);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(1);
						
						alu_original_dest_out_2 <= alu_original_dest_in(1);
						alu_rename_dest_out_2 <= alu_rename_dest_in(1);
						
						alu_operand_1_out_2 <= alu_operand_1_in(1);
						
						alu_operand_2_out_2 <= alu_operand_2_in(1);
						
						alu_operand_3_out_2 <= alu_operand_3_in(1);
						
						alu_c_flag_out_2 <= alu_c_flag_in(1);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(1);

						alu_z_flag_out_2 <= alu_z_flag_in(1);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(1);

						alu_pc_out_2 <= alu_pc_in(1);
						
						alu_btag_out_2 <= alu_btag_in(1);

						--------------------------------------------------------------------------------------------------------------------------------																																																																					
					end if ;

				elsif (alu_instr_valid_in(5) = '1' and alu_sch_valid_in(5) = '1') then

					--------------------------------------------------------------------------------------------------------------------------------
					alu_instr_valid_out_1 <= alu_instr_valid_in(5);
					alu_op_code_out_1 <= alu_op_code_in(5);
					alu_op_code_cz_out_1 <= alu_op_code_cz_in(5);
					
					alu_original_dest_out_1 <= alu_original_dest_in(5);
					alu_rename_dest_out_1 <= alu_rename_dest_in(5);
					
					alu_operand_1_out_1 <= alu_operand_1_in(5);
					
					alu_operand_2_out_1 <= alu_operand_2_in(5);
					
					alu_operand_3_out_1 <= alu_operand_3_in(5);
					
					alu_c_flag_out_1 <= alu_c_flag_in(5);
					alu_c_flag_rename_out_1 <= alu_c_flag_rename_in(5);

					alu_z_flag_out_1 <= alu_z_flag_in(5);
					alu_z_flag_rename_out_1 <= alu_z_flag_rename_in(5);

					alu_pc_out_1 <= alu_pc_in(5);
					
					alu_btag_out_1 <= alu_btag_in(5);

					--------------------------------------------------------------------------------------------------------------------------------

					
					if (alu_instr_valid_in(6) = '1' and alu_sch_valid_in(6) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(6);
						alu_op_code_out_2 <= alu_op_code_in(6);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(6);
						
						alu_original_dest_out_2 <= alu_original_dest_in(6);
						alu_rename_dest_out_2 <= alu_rename_dest_in(6);
						
						alu_operand_1_out_2 <= alu_operand_1_in(6);
						
						alu_operand_2_out_2 <= alu_operand_2_in(6);
						
						alu_operand_3_out_2 <= alu_operand_3_in(6);
						
						alu_c_flag_out_2 <= alu_c_flag_in(6);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(6);

						alu_z_flag_out_2 <= alu_z_flag_in(6);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(6);

						alu_pc_out_2 <= alu_pc_in(6);
						
						alu_btag_out_2 <= alu_btag_in(6);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(7);
						alu_op_code_out_2 <= alu_op_code_in(7);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(7);
						
						alu_original_dest_out_2 <= alu_original_dest_in(7);
						alu_rename_dest_out_2 <= alu_rename_dest_in(7);
						
						alu_operand_1_out_2 <= alu_operand_1_in(7);
						
						alu_operand_2_out_2 <= alu_operand_2_in(7);
						
						alu_operand_3_out_2 <= alu_operand_3_in(7);
						
						alu_c_flag_out_2 <= alu_c_flag_in(7);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(7);

						alu_z_flag_out_2 <= alu_z_flag_in(7);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(7);

						alu_pc_out_2 <= alu_pc_in(7);
						
						alu_btag_out_2 <= alu_btag_in(7);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(8);
						alu_op_code_out_2 <= alu_op_code_in(8);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(8);
						
						alu_original_dest_out_2 <= alu_original_dest_in(8);
						alu_rename_dest_out_2 <= alu_rename_dest_in(8);
						
						alu_operand_1_out_2 <= alu_operand_1_in(8);
						
						alu_operand_2_out_2 <= alu_operand_2_in(8);
						
						alu_operand_3_out_2 <= alu_operand_3_in(8);
						
						alu_c_flag_out_2 <= alu_c_flag_in(8);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(8);

						alu_z_flag_out_2 <= alu_z_flag_in(8);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(8);

						alu_pc_out_2 <= alu_pc_in(8);
						
						alu_btag_out_2 <= alu_btag_in(8);

						--------------------------------------------------------------------------------------------------------------------------------										
					elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(9);
						alu_op_code_out_2 <= alu_op_code_in(9);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(9);
						
						alu_original_dest_out_2 <= alu_original_dest_in(9);
						alu_rename_dest_out_2 <= alu_rename_dest_in(9);
						
						alu_operand_1_out_2 <= alu_operand_1_in(9);
						
						alu_operand_2_out_2 <= alu_operand_2_in(9);
						
						alu_operand_3_out_2 <= alu_operand_3_in(9);
						
						alu_c_flag_out_2 <= alu_c_flag_in(9);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(9);

						alu_z_flag_out_2 <= alu_z_flag_in(9);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(9);

						alu_pc_out_2 <= alu_pc_in(9);
						
						alu_btag_out_2 <= alu_btag_in(9);

						--------------------------------------------------------------------------------------------------------------------------------
					else
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= '0';
						alu_op_code_out_2 <= alu_op_code_in(1);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(1);
						
						alu_original_dest_out_2 <= alu_original_dest_in(1);
						alu_rename_dest_out_2 <= alu_rename_dest_in(1);
						
						alu_operand_1_out_2 <= alu_operand_1_in(1);
						
						alu_operand_2_out_2 <= alu_operand_2_in(1);
						
						alu_operand_3_out_2 <= alu_operand_3_in(1);
						
						alu_c_flag_out_2 <= alu_c_flag_in(1);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(1);

						alu_z_flag_out_2 <= alu_z_flag_in(1);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(1);

						alu_pc_out_2 <= alu_pc_in(1);
						
						alu_btag_out_2 <= alu_btag_in(1);

						--------------------------------------------------------------------------------------------------------------------------------																																																																					
					end if ;

				elsif (alu_instr_valid_in(6) = '1' and alu_sch_valid_in(6) = '1') then

					--------------------------------------------------------------------------------------------------------------------------------
					alu_instr_valid_out_1 <= alu_instr_valid_in(6);
					alu_op_code_out_1 <= alu_op_code_in(6);
					alu_op_code_cz_out_1 <= alu_op_code_cz_in(6);
					
					alu_original_dest_out_1 <= alu_original_dest_in(6);
					alu_rename_dest_out_1 <= alu_rename_dest_in(6);
					
					alu_operand_1_out_1 <= alu_operand_1_in(6);
					
					alu_operand_2_out_1 <= alu_operand_2_in(6);
					
					alu_operand_3_out_1 <= alu_operand_3_in(6);
					
					alu_c_flag_out_1 <= alu_c_flag_in(6);
					alu_c_flag_rename_out_1 <= alu_c_flag_rename_in(6);

					alu_z_flag_out_1 <= alu_z_flag_in(6);
					alu_z_flag_rename_out_1 <= alu_z_flag_rename_in(6);

					alu_pc_out_1 <= alu_pc_in(6);
					
					alu_btag_out_1 <= alu_btag_in(6);

					--------------------------------------------------------------------------------------------------------------------------------

					
					if (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(7);
						alu_op_code_out_2 <= alu_op_code_in(7);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(7);
						
						alu_original_dest_out_2 <= alu_original_dest_in(7);
						alu_rename_dest_out_2 <= alu_rename_dest_in(7);
						
						alu_operand_1_out_2 <= alu_operand_1_in(7);
						
						alu_operand_2_out_2 <= alu_operand_2_in(7);
						
						alu_operand_3_out_2 <= alu_operand_3_in(7);
						
						alu_c_flag_out_2 <= alu_c_flag_in(7);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(7);

						alu_z_flag_out_2 <= alu_z_flag_in(7);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(7);

						alu_pc_out_2 <= alu_pc_in(7);
						
						alu_btag_out_2 <= alu_btag_in(7);

						--------------------------------------------------------------------------------------------------------------------------------
					elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(8);
						alu_op_code_out_2 <= alu_op_code_in(8);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(8);
						
						alu_original_dest_out_2 <= alu_original_dest_in(8);
						alu_rename_dest_out_2 <= alu_rename_dest_in(8);
						
						alu_operand_1_out_2 <= alu_operand_1_in(8);
						
						alu_operand_2_out_2 <= alu_operand_2_in(8);
						
						alu_operand_3_out_2 <= alu_operand_3_in(8);
						
						alu_c_flag_out_2 <= alu_c_flag_in(8);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(8);

						alu_z_flag_out_2 <= alu_z_flag_in(8);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(8);

						alu_pc_out_2 <= alu_pc_in(8);
						
						alu_btag_out_2 <= alu_btag_in(8);

						--------------------------------------------------------------------------------------------------------------------------------										
					elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(9);
						alu_op_code_out_2 <= alu_op_code_in(9);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(9);
						
						alu_original_dest_out_2 <= alu_original_dest_in(9);
						alu_rename_dest_out_2 <= alu_rename_dest_in(9);
						
						alu_operand_1_out_2 <= alu_operand_1_in(9);
						
						alu_operand_2_out_2 <= alu_operand_2_in(9);
						
						alu_operand_3_out_2 <= alu_operand_3_in(9);
						
						alu_c_flag_out_2 <= alu_c_flag_in(9);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(9);

						alu_z_flag_out_2 <= alu_z_flag_in(9);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(9);

						alu_pc_out_2 <= alu_pc_in(9);
						
						alu_btag_out_2 <= alu_btag_in(9);

						--------------------------------------------------------------------------------------------------------------------------------
					else
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= '0';
						alu_op_code_out_2 <= alu_op_code_in(1);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(1);
						
						alu_original_dest_out_2 <= alu_original_dest_in(1);
						alu_rename_dest_out_2 <= alu_rename_dest_in(1);
						
						alu_operand_1_out_2 <= alu_operand_1_in(1);
						
						alu_operand_2_out_2 <= alu_operand_2_in(1);
						
						alu_operand_3_out_2 <= alu_operand_3_in(1);
						
						alu_c_flag_out_2 <= alu_c_flag_in(1);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(1);

						alu_z_flag_out_2 <= alu_z_flag_in(1);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(1);

						alu_pc_out_2 <= alu_pc_in(1);
						
						alu_btag_out_2 <= alu_btag_in(1);

						--------------------------------------------------------------------------------------------------------------------------------																																																																					
					end if ;

				elsif (alu_instr_valid_in(7) = '1' and alu_sch_valid_in(7) = '1') then

					--------------------------------------------------------------------------------------------------------------------------------
					alu_instr_valid_out_1 <= alu_instr_valid_in(7);
					alu_op_code_out_1 <= alu_op_code_in(7);
					alu_op_code_cz_out_1 <= alu_op_code_cz_in(7);
					
					alu_original_dest_out_1 <= alu_original_dest_in(7);
					alu_rename_dest_out_1 <= alu_rename_dest_in(7);
					
					alu_operand_1_out_1 <= alu_operand_1_in(7);
					
					alu_operand_2_out_1 <= alu_operand_2_in(7);
					
					alu_operand_3_out_1 <= alu_operand_3_in(7);
					
					alu_c_flag_out_1 <= alu_c_flag_in(7);
					alu_c_flag_rename_out_1 <= alu_c_flag_rename_in(7);

					alu_z_flag_out_1 <= alu_z_flag_in(7);
					alu_z_flag_rename_out_1 <= alu_z_flag_rename_in(7);

					alu_pc_out_1 <= alu_pc_in(7);
					
					alu_btag_out_1 <= alu_btag_in(7);

					--------------------------------------------------------------------------------------------------------------------------------

					
					if (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(8);
						alu_op_code_out_2 <= alu_op_code_in(8);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(8);
						
						alu_original_dest_out_2 <= alu_original_dest_in(8);
						alu_rename_dest_out_2 <= alu_rename_dest_in(8);
						
						alu_operand_1_out_2 <= alu_operand_1_in(8);
						
						alu_operand_2_out_2 <= alu_operand_2_in(8);
						
						alu_operand_3_out_2 <= alu_operand_3_in(8);
						
						alu_c_flag_out_2 <= alu_c_flag_in(8);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(8);

						alu_z_flag_out_2 <= alu_z_flag_in(8);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(8);

						alu_pc_out_2 <= alu_pc_in(8);
						
						alu_btag_out_2 <= alu_btag_in(8);

						--------------------------------------------------------------------------------------------------------------------------------										
					elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(9);
						alu_op_code_out_2 <= alu_op_code_in(9);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(9);
						
						alu_original_dest_out_2 <= alu_original_dest_in(9);
						alu_rename_dest_out_2 <= alu_rename_dest_in(9);
						
						alu_operand_1_out_2 <= alu_operand_1_in(9);
						
						alu_operand_2_out_2 <= alu_operand_2_in(9);
						
						alu_operand_3_out_2 <= alu_operand_3_in(9);
						
						alu_c_flag_out_2 <= alu_c_flag_in(9);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(9);

						alu_z_flag_out_2 <= alu_z_flag_in(9);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(9);

						alu_pc_out_2 <= alu_pc_in(9);
						
						alu_btag_out_2 <= alu_btag_in(9);

						--------------------------------------------------------------------------------------------------------------------------------
					else
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= '0';
						alu_op_code_out_2 <= alu_op_code_in(1);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(1);
						
						alu_original_dest_out_2 <= alu_original_dest_in(1);
						alu_rename_dest_out_2 <= alu_rename_dest_in(1);
						
						alu_operand_1_out_2 <= alu_operand_1_in(1);
						
						alu_operand_2_out_2 <= alu_operand_2_in(1);
						
						alu_operand_3_out_2 <= alu_operand_3_in(1);
						
						alu_c_flag_out_2 <= alu_c_flag_in(1);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(1);

						alu_z_flag_out_2 <= alu_z_flag_in(1);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(1);

						alu_pc_out_2 <= alu_pc_in(1);
						
						alu_btag_out_2 <= alu_btag_in(1);

						--------------------------------------------------------------------------------------------------------------------------------																																																																					
					end if ;

				elsif (alu_instr_valid_in(8) = '1' and alu_sch_valid_in(8) = '1') then

					--------------------------------------------------------------------------------------------------------------------------------
					alu_instr_valid_out_1 <= alu_instr_valid_in(8);
					alu_op_code_out_1 <= alu_op_code_in(8);
					alu_op_code_cz_out_1 <= alu_op_code_cz_in(8);
					
					alu_original_dest_out_1 <= alu_original_dest_in(8);
					alu_rename_dest_out_1 <= alu_rename_dest_in(8);
					
					alu_operand_1_out_1 <= alu_operand_1_in(8);
					
					alu_operand_2_out_1 <= alu_operand_2_in(8);
					
					alu_operand_3_out_1 <= alu_operand_3_in(8);
					
					alu_c_flag_out_1 <= alu_c_flag_in(8);
					alu_c_flag_rename_out_1 <= alu_c_flag_rename_in(8);

					alu_z_flag_out_1 <= alu_z_flag_in(8);
					alu_z_flag_rename_out_1 <= alu_z_flag_rename_in(8);

					alu_pc_out_1 <= alu_pc_in(8);
					
					alu_btag_out_1 <= alu_btag_in(8);

					--------------------------------------------------------------------------------------------------------------------------------

					
					if (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= alu_instr_valid_in(9);
						alu_op_code_out_2 <= alu_op_code_in(9);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(9);
						
						alu_original_dest_out_2 <= alu_original_dest_in(9);
						alu_rename_dest_out_2 <= alu_rename_dest_in(9);
						
						alu_operand_1_out_2 <= alu_operand_1_in(9);
						
						alu_operand_2_out_2 <= alu_operand_2_in(9);
						
						alu_operand_3_out_2 <= alu_operand_3_in(9);
						
						alu_c_flag_out_2 <= alu_c_flag_in(9);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(9);

						alu_z_flag_out_2 <= alu_z_flag_in(9);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(9);

						alu_pc_out_2 <= alu_pc_in(9);
						
						alu_btag_out_2 <= alu_btag_in(9);

						--------------------------------------------------------------------------------------------------------------------------------
					else
						
						--------------------------------------------------------------------------------------------------------------------------------
						alu_instr_valid_out_2 <= '0';
						alu_op_code_out_2 <= alu_op_code_in(1);
						alu_op_code_cz_out_2 <= alu_op_code_cz_in(1);
						
						alu_original_dest_out_2 <= alu_original_dest_in(1);
						alu_rename_dest_out_2 <= alu_rename_dest_in(1);
						
						alu_operand_1_out_2 <= alu_operand_1_in(1);
						
						alu_operand_2_out_2 <= alu_operand_2_in(1);
						
						alu_operand_3_out_2 <= alu_operand_3_in(1);
						
						alu_c_flag_out_2 <= alu_c_flag_in(1);
						alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(1);

						alu_z_flag_out_2 <= alu_z_flag_in(1);
						alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(1);

						alu_pc_out_2 <= alu_pc_in(1);
						
						alu_btag_out_2 <= alu_btag_in(1);

						--------------------------------------------------------------------------------------------------------------------------------																																																																					
					end if ;

				elsif (alu_instr_valid_in(9) = '1' and alu_sch_valid_in(9) = '1') then

					--------------------------------------------------------------------------------------------------------------------------------
					alu_instr_valid_out_1 <= alu_instr_valid_in(9);
					alu_op_code_out_1 <= alu_op_code_in(9);
					alu_op_code_cz_out_1 <= alu_op_code_cz_in(9);
					
					alu_original_dest_out_1 <= alu_original_dest_in(9);
					alu_rename_dest_out_1 <= alu_rename_dest_in(9);
					
					alu_operand_1_out_1 <= alu_operand_1_in(9);
					
					alu_operand_2_out_1 <= alu_operand_2_in(9);
					
					alu_operand_3_out_1 <= alu_operand_3_in(9);
					
					alu_c_flag_out_1 <= alu_c_flag_in(9);
					alu_c_flag_rename_out_1 <= alu_c_flag_rename_in(9);

					alu_z_flag_out_1 <= alu_z_flag_in(9);
					alu_z_flag_rename_out_1 <= alu_z_flag_rename_in(9);

					alu_pc_out_1 <= alu_pc_in(9);
					
					alu_btag_out_1 <= alu_btag_in(9);

					--------------------------------------------------------------------------------------------------------------------------------

					--------------------------------------------------------------------------------------------------------------------------------
					alu_instr_valid_out_2 <= '0';
					alu_op_code_out_2 <= alu_op_code_in(1);
					alu_op_code_cz_out_2 <= alu_op_code_cz_in(1);
					
					alu_original_dest_out_2 <= alu_original_dest_in(1);
					alu_rename_dest_out_2 <= alu_rename_dest_in(1);
					
					alu_operand_1_out_2 <= alu_operand_1_in(1);
					
					alu_operand_2_out_2 <= alu_operand_2_in(1);
					
					alu_operand_3_out_2 <= alu_operand_3_in(1);
					
					alu_c_flag_out_2 <= alu_c_flag_in(1);
					alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(1);

					alu_z_flag_out_2 <= alu_z_flag_in(1);
					alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(1);

					alu_pc_out_2 <= alu_pc_in(1);
					
					alu_btag_out_2 <= alu_btag_in(1);

					--------------------------------------------------------------------------------------------------------------------------------

					
				
				else
					
					--------------------------------------------------------------------------------------------------------------------------------
					alu_instr_valid_out_1 <= '0';
					alu_op_code_out_1 <= alu_op_code_in(0);
					alu_op_code_cz_out_1 <= alu_op_code_cz_in(0);
					
					alu_original_dest_out_1 <= alu_original_dest_in(0);
					alu_rename_dest_out_1 <= alu_rename_dest_in(0);
					
					alu_operand_1_out_1 <= alu_operand_1_in(0);
					
					alu_operand_2_out_1 <= alu_operand_2_in(0);
					
					alu_operand_3_out_1 <= alu_operand_3_in(0);
					
					alu_c_flag_out_1 <= alu_c_flag_in(0);
					alu_c_flag_rename_out_1 <= alu_c_flag_rename_in(0);

					alu_z_flag_out_1 <= alu_z_flag_in(0);
					alu_z_flag_rename_out_1 <= alu_z_flag_rename_in(0);

					alu_pc_out_1 <= alu_pc_in(0);
					
					alu_btag_out_1 <= alu_btag_in(0);

					--------------------------------------------------------------------------------------------------------------------------------

					--------------------------------------------------------------------------------------------------------------------------------
					alu_instr_valid_out_2 <= '0';
					alu_op_code_out_2 <= alu_op_code_in(1);
					alu_op_code_cz_out_2 <= alu_op_code_cz_in(1);
					
					alu_original_dest_out_2 <= alu_original_dest_in(1);
					alu_rename_dest_out_2 <= alu_rename_dest_in(1);
					
					alu_operand_1_out_2 <= alu_operand_1_in(1);
					
					alu_operand_2_out_2 <= alu_operand_2_in(1);
					
					alu_operand_3_out_2 <= alu_operand_3_in(1);
					
					alu_c_flag_out_2 <= alu_c_flag_in(1);
					alu_c_flag_rename_out_2 <= alu_c_flag_rename_in(1);

					alu_z_flag_out_2 <= alu_z_flag_in(1);
					alu_z_flag_rename_out_2 <= alu_z_flag_rename_in(1);

					alu_pc_out_2 <= alu_pc_in(1);
					
					alu_btag_out_2 <= alu_btag_in(1);

					--------------------------------------------------------------------------------------------------------------------------------


				end if ;

			end if ;
			
			

		end if ;	


	end process ; -- alu_scheduler


end architecture ; -- arch