----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/15/2022 09:07:24 PM
-- Design Name: 
-- Module Name: PC - Behavioral
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

entity PC is
    Port ( En : in STD_LOGIC;
           Clk : IN STD_LOGIC; 
           Rst : IN STD_LOGIC; 
           PC_D : in STD_LOGIC_VECTOR(31 DOWNTO 0); --pc input 
           PC_Q : out STD_LOGIC_VECTOR(31 DOWNTO 0)); --pc output 
end PC;

architecture Behavioral of PC is

begin
    CLKD : process(CLK, RST)
     begin
        if(RST = '1') then
           PC_Q <= x"00000000";
        elsif(CLK'event AND CLK = '1') then
           if(EN = '1') then
              PC_Q <= PC_D; --expecting that PC_D = PC + 4
           end if;
        end if;
     end process CLKD;

end Behavioral;
