LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY flipflop IS
   PORT( 
      CLK : IN     std_logic;
      D   : IN     std_logic_vector(63 downto 0);
      EN  : IN     std_logic;
      RST : IN     std_logic;
      Q   : OUT    std_logic_vector(63 downto 0)
   );
END flipflop ;

--
ARCHITECTURE flipflop OF flipflop IS
    --this can be used as the product register for holding the result of R
BEGIN
     CLKD : process(CLK, RST)
     begin
        if(RST = '1') then --asynchronous goes before checking clk
           Q <= (others => '0');
        elsif(CLK'event AND CLK = '1') then
           if(EN = '1') then --synchronous enable bit 
              Q <= D;
           end if;
        end if;
     end process CLKD;
END flipflop;
