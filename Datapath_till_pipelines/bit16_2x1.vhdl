library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity bit16_2x1 is
    Port ( c_0 : in  STD_LOGIC;
           d_0   : in  std_logic_vector(15 downto 0);
           d_1   : in  std_logic_vector(15 downto 0);
           o   : out std_logic_vector(15 downto 0));
end bit16_2x1;

architecture Behavioral of bit16_2x1 is
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