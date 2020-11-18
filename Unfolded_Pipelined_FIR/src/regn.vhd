library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

entity regn is
	port( D: in std_logic_vector(2*NB-1 downto 0);
		  CLK: in std_logic;
		  RST: in std_logic;
		  Q: out std_logic_vector(2*NB-1 downto 0));
end regn;

architecture bhv of regn is

begin
	reg_proc: process(CLK, RST)
		begin
		if(RST = '0') then
			Q <= (others => '0');
		else if(CLK = '1' AND CLK'event) then
			Q <= D;
		end if;
		end if;
	end process reg_proc;

end bhv;
