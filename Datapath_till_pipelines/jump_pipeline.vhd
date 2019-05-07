library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity jump_pipeline is
  port(pipeline_valid_in: in std_logic;
  		op_code_in: in std_logic_vector(3 downto 0);
  		destn_rename_code_in: in std_logic_vector(5 downto 0);
  		operand1: in std_logic_vector(15 downto 0);--refers to Ra
  		operand2:in std_logic_vector(15 downto 0);--refers to Rb
      operand3: in std_logic_vector(15 downto 0);--refers to immediate
		  --c_flag_in:in std_logic;
  		--z_flag_in:in std_logic;
  		--c_rename_in:in std_logic_vector(3 downto 0);
  		--z_rename_in: in std_logic_vector(3 downto 0);
  		b_tag_in:in std_logic_vector(2 downto 0);
  		orig_destn_in:in std_logic_vector(2 downto 0);
  		--op_code_cz:in std_logic_vector(1 downto 0);
      curr_pc_in:in std_logic_vector(15 downto 0);
      next_pc_in: in std_logic_vector(15 downto 0);
      self_branch_tag_in: in std_logic_vector(2 downto 0);
  		data_out: out std_logic_vector(15 downto 0);
      pipeline_valid_out: out std_logic;
      op_code_out: out std_logic_vector(3 downto 0);
  		destn_rename_code_out: out std_logic_vector(5 downto 0);
   		--c_flag_out:out std_logic;
  		--z_flag_out:out std_logic;
  		--c_rename_out:out std_logic_vector(3 downto 0);
  		--z_rename_out: out std_logic_vector(3 downto 0);
  		b_tag_out:out std_logic_vector(2 downto 0);
  		orig_destn_out:out std_logic_vector(2 downto 0);
      curr_pc_out:out std_logic_vector(15 downto 0);
      self_branch_tag_out:out std_logic_vector(2 downto 0);
      branch_addr:out std_logic_vector(15 downto 0);
      reg_write:out std_logic;
      correct: out std_logic;

      jump_brdcst_rename_out:out std_logic_vector(5 downto 0);
      jump_brdcst_orig_destn_out:out std_logic_vector(2 downto 0);
      jump_brdcst_data_out:out std_logic_vector(15 downto 0); 
      jump_brdcst_valid_out:out std_logic;
       
      jump_brdcst_btag_out:out std_logic_vector(2 downto 0);

      jump_branch_mispredictor:out std_logic_vector(1 downto 0) --to be sent to RS for branch misprediction

      );
      
     
end entity;


architecture struct of jump_pipeline is
  
  signal opr1:unsigned (15 downto 0):=(others=>'0');
  signal opr2:unsigned (15 downto 0):=(others=>'0');
  --signal opr3:unsigned (15 downto 0):=(others=>'0');
  signal opr3:unsigned (15 downto 0):=(others=>'0');
  signal result:unsigned(15 downto 0):=(others=>'0');
  signal incr:unsigned(15 downto 0):=(others=>'0');
  signal branch:unsigned(15 downto 0):=(others=>'0');

  --signal 


  begin
   opr1<=unsigned(operand1);
   opr2<=unsigned(operand2);
   opr3<=unsigned(operand3);
   incr<=to_unsigned(2, 16);
  process(op_code_in,opr1,opr2,opr3,curr_pc_in,incr)
  
  begin

   if (op_code_in="1100") then--BEQ instruction
     reg_write<='0';
     result<=(others=>'0');
     if (opr1=opr2) then      --BEQ
      branch<=(unsigned(curr_pc_in)+opr3);
     else
      branch<=(unsigned(curr_pc_in)+incr);
       
     end if;
     
   elsif (op_code_in="1000") then -----JAL instruction   
    reg_write<='1';
    result<=unsigned(curr_pc_in);
    branch<=(unsigned(curr_pc_in)+opr3);


   else ------------------------------------------------------------------------JLR instr
     reg_write<='1';
     result<=unsigned(curr_pc_in);
     branch<=(opr2); 

   end if;

  end process; 

  process(pipeline_valid_in,branch,next_pc_in) 

   begin

    if (branch=unsigned(next_pc_in) or pipeline_valid_in='0' ) then --we give correct one implying no change in next address
      correct<='1';
    else
       correct<='0';

    end if;   

  end process;



  process(op_code_in,pipeline_valid_in) 

   begin

    if (op_code_in="1100") then--BEQ instruction
      jump_brdcst_valid_out <= '0'; 
    
    else 
      jump_brdcst_valid_out <= pipeline_valid_in;
    end if;

  end process;

  
  process (self_branch_tag_in,pipeline_valid_in,branch,next_pc_in) --aded on 7 to adrress the instr sending to RS on branch misprediction

   begin

    if(pipeline_valid_in='1' and self_branch_tag_in="001" and not(branch=unsigned(next_pc_in))) then

     jump_branch_mispredictor<="01";

    elsif (pipeline_valid_in='1' and self_branch_tag_in="010" and not(branch=unsigned(next_pc_in))) then

     jump_branch_mispredictor<="10";


    else
     jump_branch_mispredictor<="00";

    end if;  

  end process; 




    jump_brdcst_rename_out <= destn_rename_code_in;
    jump_brdcst_orig_destn_out <= orig_destn_in;
    jump_brdcst_data_out <= std_logic_vector(result);
           
    jump_brdcst_btag_out <= b_tag_in;


    branch_addr<=std_logic_vector(branch);
    data_out<=std_logic_vector(result);

    pipeline_valid_out<=pipeline_valid_in;
    op_code_out<=op_code_in;
    destn_rename_code_out<=destn_rename_code_in;
    --c_rename_out<=c_rename_in;
    --z_rename_out<=z_rename_in;
    b_tag_out<=b_tag_in;
    orig_destn_out<=orig_destn_in;
    curr_pc_out<=curr_pc_in;
    self_branch_tag_out<=self_branch_tag_in;

             
    


    

    
  end architecture struct;