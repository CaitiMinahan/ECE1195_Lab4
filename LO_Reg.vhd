library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LO_Reg is
    Port ( LoDataIn : in STD_LOGIC_VECTOR(31 DOWNTO 0); --LSB 32 of Result output from multiplier 
           LoDataOut : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           En : in STD_LOGIC);
end LO_Reg;

architecture Behavioral of LO_Reg is

begin
CLKD : process(CLK, RST)
     begin
        if(RST = '1') then
           LoDataOut <= x"00000000";
        elsif(CLK'event AND CLK = '1') then
           if(EN = '1') then
              LoDataOut <= LoDataIn; 
           end if;
        end if;
     end process CLKD;

end Behavioral;
