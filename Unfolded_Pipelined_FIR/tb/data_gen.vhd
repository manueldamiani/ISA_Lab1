library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_gen is  
  port (
    CLK     : in  std_logic;
    RST_n   : in  std_logic;
    b: out std_logic_vector(0 to 120);
    VOUT    : out std_logic;
    DOUT0    : out std_logic_vector(10 downto 0);
    DOUT1    : out std_logic_vector(10 downto 0);
    DOUT2   : out std_logic_vector(10 downto 0);
    END_SIM : out std_logic);
end data_gen;

architecture bhv of data_gen is

  constant tco : time := 1 ns;

  signal sEndSim : std_logic;
  signal END_SIM_i : std_logic_vector(0 to 10);  

begin

  -- b <= I need to assign the bits of coefficients bi
  -- conv_std_logic_vector(num, 11);
	b(0 to 10) <= conv_std_logic_vector(-1, 11);
	b(11 to 21) <= conv_std_logic_vector(-13, 11);
	b(22 to 32) <= conv_std_logic_vector(-26, 11);
	b(33 to 43) <= conv_std_logic_vector(65, 11);
	b(44 to 54) <= conv_std_logic_vector(281, 11);
	b(55 to 65) <= conv_std_logic_vector(407, 11);
	b(66 to 76) <= conv_std_logic_vector(281, 11);
	b(77 to 87) <= conv_std_logic_vector(65, 11);
	b(88 to 98) <= conv_std_logic_vector(-26, 11);
	b(99 to 109) <= conv_std_logic_vector(-13, 11);
	b(110 to 120) <= conv_std_logic_vector(-1, 11);

	 process (CLK, RST_n)
	    file fp_in : text open READ_MODE is "../src/samples.txt";
	    variable line_in : line;
	    variable x : integer;
	  begin  -- process
	    if RST_n = '0' then                 -- asynchronous reset (active low)
	      DOUT0 <= (others => '0') after tco;    
		DOUT1 <= (others => '0') after tco;
		DOUT2 <= (others => '0') after tco;  
	      VOUT <= '0' after tco;
	      sEndSim <= '0' after tco;
	    elsif CLK'event and CLK = '1' then  -- rising clock edge
	      if not endfile(fp_in) then
		readline(fp_in, line_in);
		read(line_in, x);
		DOUT0 <= conv_std_logic_vector(x, 11) after tco;

		readline(fp_in, line_in);
		read(line_in, x);
		DOUT1 <= conv_std_logic_vector(x, 11) after tco;

		readline(fp_in, line_in);
		read(line_in, x);
		DOUT2 <= conv_std_logic_vector(x, 11) after tco;

		VOUT <= '1' after tco;
		sEndSim <= '0' after tco;
	      else
		VOUT <= '0' after tco;        
		sEndSim <= '1' after tco;
	      end if;
	    end if;
	  end process;

	  process (CLK, RST_n)
	  begin  -- process
	    if RST_n = '0' then                 -- asynchronous reset (active low)
	      END_SIM_i <= (others => '0') after tco;
	    elsif CLK'event and CLK = '1' then  -- rising clock edge
	      END_SIM_i(0) <= sEndSim after tco;
	      END_SIM_i(1 to 10) <= END_SIM_i(0 to 9) after tco;
	    end if;
	  end process;

	  END_SIM <= END_SIM_i(10);  

end bhv;
