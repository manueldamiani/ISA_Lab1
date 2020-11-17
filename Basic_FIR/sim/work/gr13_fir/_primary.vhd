library verilog;
use verilog.vl_types.all;
entity gr13_fir is
    port(
        b               : in     vl_logic_vector(0 to 120);
        DIN             : in     vl_logic_vector(10 downto 0);
        VIN             : in     vl_logic;
        RST_n           : in     vl_logic;
        CLK             : in     vl_logic;
        DOUT            : out    vl_logic_vector(10 downto 0);
        VOUT            : out    vl_logic
    );
end gr13_fir;
