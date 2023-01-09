----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/15/2022 12:13:58 PM
-- Design Name: 
-- Module Name: LogicUnit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LogicUnit is
    Port ( A : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           B : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           Op : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           R : out STD_LOGIC_VECTOR(31 DOWNTO 0));
end LogicUnit;

architecture Behavioral of LogicUnit is

begin
    --use when-else statements for each logic operation: 
    R <= A AND B WHEN (Op="00") ELSE
        A OR B WHEN (Op="01") ELSE
        A XOR B WHEN (Op="10") ELSE
        A NOR B WHEN (Op="11");



end Behavioral;
