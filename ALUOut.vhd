----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/15/2022 09:21:36 PM
-- Design Name: 
-- Module Name: A - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALUOut is
    Port ( ALU_Result : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           ALU_Out : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           En : in STD_LOGIC);
end ALUOut;

architecture Behavioral of ALUOut is

begin
CLKD : process(CLK, RST)
     begin
        if(RST = '1') then
           ALU_out <= x"00000000";
        elsif(CLK'event AND CLK = '1') then
           if(EN = '1') then
              ALU_out <= ALU_Result;
           end if;
        end if;
     end process CLKD;

end Behavioral;
