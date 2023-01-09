library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UpCounter5 is
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Enable : in STD_LOGIC;
           QCount : out STD_LOGIC_VECTOR(4 DOWNTO 0));
end UpCounter5;

architecture Behavioral of UpCounter5 is
    --this will be a 5 bit up counter with an asyncrhonous reset 
    SIGNAL Count : STD_LOGIC_VECTOR(4 downto 0); 
begin
    PROCESS(Clk, Reset)
    BEGIN 
        if Reset = '1' then 
            Count <= "00000"; --5 bit counter 
        elsif (CLK'event AND CLK = '1') then
            if(Enable = '1') then 
                Count <= Count + 1; 
            end if; 
        end if; 
    end process; 
    QCount <= Count;       
end Behavioral;
