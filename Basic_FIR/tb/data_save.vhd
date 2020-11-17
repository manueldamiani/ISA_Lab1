library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_save is
  port (
    CLK   : in std_logic;
    RST : in std_logic;
    VIN   : in std_logic;
    DIN   : in std_logic_vector(10 downto 0));
end data_save;

architecture beh of data_save is

begin  -- beh

  process (CLK, RST)
    file res_fp : text open WRITE_MODE is "./results.txt";
    variable line_out : line;    
  begin  -- process
    if RST = '0' then                 -- asynchronous reset (active low)
      null;
    elsif(CLK'event and CLK = '1') then  -- rising clock edge
      if (VIN = '1') then
        write(line_out, conv_integer(signed(DIN)));
        writeline(res_fp, line_out);
      end if;
    end if;
  end process;

end beh;
