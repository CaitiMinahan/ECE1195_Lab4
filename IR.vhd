----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/15/2022 09:13:33 PM
-- Design Name: 
-- Module Name: IR - Behavioral
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

entity IR is
    Port ( CLK : IN STD_LOGIC; 
           Rst : IN STD_LOGIC; 
           IRWrite : in STD_LOGIC;  --enable bit 
           MemData : in STD_LOGIC_VECTOR(31 DOWNTO 0); --D input 
           Inst : out STD_LOGIC_VECTOR(31 downto 0)); --inst31-0 are the Q outputs
end IR;

architecture Behavioral of IR is

begin
CLKD : process(CLK, RST)
     begin
        if(RST = '1') then
           Inst <= (others => '0') ; --reset to address zero 
        elsif(CLK'event AND CLK = '1') then
           if(IRWrite = '1') then
              Inst <= MemData; --get the new mem address 
           end if;
        end if;
     end process CLKD;
end Behavioral;
