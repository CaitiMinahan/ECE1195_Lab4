library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ShiftReg64 is
    Port ( D : in STD_LOGIC_VECTOR(63 DOWNTO 0);
           Load : in STD_LOGIC;
           Sin : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(63 DOWNTO 0));
end ShiftReg64;

architecture Behavioral of ShiftReg64 is
    --the 64 shift register is for the multiplicand shift left 
    --when we aren't shifting, we are loading values 
    
    --temp signal for shifted result 
    signal Qtemp : STD_LOGIC_VECTOR(63 DOWNTO 0); 
    --assign temp to Q OUTSIDE of the process so it can be used later 
begin
    LEFT : process(CLK, Reset)
     begin
        if(Reset = '1') then --asynchronous goes before checking clk
           Qtemp <= (others => '0');
        elsif(CLK'event AND CLK = '1') then
           if(Load = '1') then --synchronous enable bit 
              Qtemp <= D;
            elsif(Sin = '1') then 
              Qtemp <= std_logic_vector(shift_left(unsigned(Qtemp), 1)); 
           end if;
        end if;
     end process LEFT;
    --assign Q output to the temp signal 
    Q <= Qtemp; 
end Behavioral;
