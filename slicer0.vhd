----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/03/2022 10:26:06 PM
-- Design Name: 
-- Module Name: slicer0 - Behavioral
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

entity slicer0 is
    Port ( a : in STD_LOGIC_VECTOR(63 DOWNTO 0);
           b1 : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           b2 : out STD_LOGIC_VECTOR(31 DOWNTO 0));
end slicer0;

architecture Behavioral of slicer0 is

begin
    --b1 is the top half of R 
    b1 <= a(63 downto 32);
    --b2 is the bottom half of R 
    b2 <= a(31 downto 0); 
end Behavioral;
