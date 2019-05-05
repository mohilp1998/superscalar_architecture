library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_pipeline is
  port(pipeline_valid_in: in std_logic;
  		op_code_in: in std_logic_vector(3 downto 0);
  		destn_rename_code_in: in std_logic_vector(5 downto 0);
  		operand1: in std_logic_vector(15 downto 0);
  		operand2:in std_logic_vector(15 downto 0);
		operand3:in std_logic_vector(15 downto 0);
  		c_flag_in:in std_logic;
  		z_flag_in:in std_logic;
  		c_rename_in:in std_logic_vector(3 downto 0);
  		z_rename_in: in std_logic_vector(3 downto 0);
  		b_tag_in:in std_logic_vector(2 downto 0);
  		orig_destn_in:in std_logic_vector(2 downto 0);
  		op_code_cz:in std_logic_vector(1 downto 0);
      curr_pc_in:in std_logic_vector(15 downto 0);
  		data_out: out std_logic_vector(15 downto 0);
        pipeline_valid_out: out std_logic;
        op_code_out: out std_logic_vector(3 downto 0);
  		destn_rename_code_out: out std_logic_vector(5 downto 0);
   		c_flag_out:out std_logic;
  		z_flag_out:out std_logic;
  		c_rename_out:out std_logic_vector(3 downto 0);
  		z_rename_out: out std_logic_vector(3 downto 0);
  		b_tag_out:out std_logic_vector(2 downto 0);
  		orig_destn_out:out std_logic_vector(2 downto 0);
      curr_pc_out:out std_logic_vector(15 downto 0));
end entity;

architecture alu_struct of ALU_pipeline is
signal result,alu_in_a: unsigned(16 downto 0):= (others => '0');
signal alu_in_c:unsigned (16 downto 0):=(others=>'0');
signal alu_in_b:unsigned (16 downto 0):=(others=>'0');
signal op_code: std_logic_vector(3 downto 0) := "0000";
signal op_code_cz_in:std_logic_vector(1 downto 0);
--signal is_one: std_logic;
begin
	alu_in_b(15 downto 0) <= unsigned (operand1);
	alu_in_a(15 downto 0) <= unsigned (operand2);
	alu_in_c(15 downto 0) <= unsigned (operand3);
	process(op_code_in,op_code_cz,alu_in_a,alu_in_b,alu_in_c,c_flag_in,z_flag_in,result)
	 begin
	  if(op_code_in = "0000" ) then
        if (op_code_cz="00") then --addition op-code
         result<=alu_in_a+alu_in_b;
         c_flag_out<=std_logic(result(16));--just discuss if it would cause a pblm
         z_flag_out<=std_logic(not(result(15)or result(14)or result(13)or result(12) or result(11)or result(10)or result(9)or result(8)
	                           or result(7)or result(6)or result(5)or result(4)
	                           or result(3)or result(2)or result(1)or result(0)));--just discuss if it would cause a pblm
        elsif (op_code_cz="10") then --c flag cond
          if (c_flag_in = '0') then
           result<=alu_in_c;
           c_flag_out<=c_flag_in;
           z_flag_out<=z_flag_in;
          else
           result<=alu_in_a+alu_in_b;
           c_flag_out<=std_logic(result(16));--just discuss if it would cause a pblm
           z_flag_out<=std_logic(not(result(15)or result(14)or result(13)or result(12) or result(11)or result(10)or result(9)or result(8)
	                           or result(7)or result(6)or result(5)or result(4)
	                           or result(3)or result(2)or result(1)or result(0)));--just discuss if it would cause a pblm   
          end if;

        else  
          if (z_flag_in = '0') then --z flag condn
           result<=alu_in_c;
           c_flag_out<=c_flag_in;
           z_flag_out<=z_flag_in;
          else
           result<=alu_in_a+alu_in_b;
           c_flag_out<=std_logic(result(16));--just discuss if it would cause a pblm
           z_flag_out<=std_logic(not(result(15)or result(14)or result(13)or result(12) or result(11)or result(10)or result(9)or result(8)
	                           or result(7)or result(6)or result(5)or result(4)
	                           or result(3)or result(2)or result(1)or result(0)));--just discuss if it would cause a pblm   
          end if;  
        end if;

       elsif (op_code_in = "0001") then --adi opcode
         result<=alu_in_a+alu_in_b;
         c_flag_out<=std_logic(result(16));--just discuss if it would cause a pblm
         z_flag_out<=std_logic(not(result(15)or result(14)or result(13)or result(12) or result(11)or result(10)or result(9)or result(8)
	                           or result(7)or result(6)or result(5)or result(4)
	                           or result(3)or result(2)or result(1)or result(0)));--just discuss if it would cause a pblm

       else
        if (op_code_cz="00") then --uncondition operation
         result<=(alu_in_a) nand (alu_in_b);
         c_flag_out<=c_flag_in;
         z_flag_out<=std_logic(not(result(15)or result(14)or result(13)or result(12) or result(11)or result(10)or result(9)or result(8)
	                           or result(7)or result(6)or result(5)or result(4)
	                           or result(3)or result(2)or result(1)or result(0)));--just discuss if it would cause a pblm
        elsif (op_code_cz="10") then --operation if carry
          if (c_flag_in = '0') then
           result<=alu_in_c;
           c_flag_out<=c_flag_in;
           z_flag_out<=z_flag_in;
          else
           result<=(alu_in_a) nand (alu_in_b);
           c_flag_out<=c_flag_in;
           z_flag_out<=std_logic(not(result(15)or result(14)or result(13)or result(12) or result(11)or result(10)or result(9)or result(8)
	                           or result(7)or result(6)or result(5)or result(4)
	                           or result(3)or result(2)or result(1)or result(0)));--just discuss if it would cause a pblm   
          end if;

        else  
          if (z_flag_in = '0') then --operation if zero
           result<=alu_in_c;
           c_flag_out<=c_flag_in;
           z_flag_out<=z_flag_in;
          else
           result<=(alu_in_a) nand (alu_in_b);
           c_flag_out<=c_flag_in;
           z_flag_out<=std_logic(not(result(15)or result(14)or result(13)or result(12) or result(11)or result(10)or result(9)or result(8)
	                           or result(7)or result(6)or result(5)or result(4)
	                           or result(3)or result(2)or result(1)or result(0)));--just discuss if it would cause a pblm   
          end if;  
        end if; 
       end if;

      end process;

    pipeline_valid_out<=pipeline_valid_in;
    op_code_out<=op_code_in;
    destn_rename_code_out<=destn_rename_code_in;
    c_rename_out<=c_rename_in;
    z_rename_out<=z_rename_in;
    b_tag_out<=b_tag_in;
    orig_destn_out<=orig_destn_in;
    curr_pc_out<=curr_pc_in;


    data_out <= std_logic_vector(result(15 downto 0));
	

end architecture alu_struct;