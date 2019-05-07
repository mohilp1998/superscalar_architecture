library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity bit1_2x1 is
    Port ( c_0 : in  STD_LOGIC;
           d_0   : in  std_logic;
           d_1   : in  std_logic;
           o   : out std_logic);
end entity;

architecture Behavioral of bit1_2x1 is
begin
	process(d_0,d_1,c_0)
	begin
		if (c_0 = '0') then
			o <= d_0;
		else
			o <= d_1;
		end if;
    end process;
end Behavioral;