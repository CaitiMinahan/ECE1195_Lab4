----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/23/2022 03:23:18 PM
-- Design Name: 
-- Module Name: CLO - Behavioral
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

entity CLO is
    Port ( ipFromA : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           CLOout : out STD_LOGIC_VECTOR(31 DOWNTO 0));
end CLO;

architecture Behavioral of CLO is
    --signal rd : STD_LOGIC_VECTOR(31 DOWNTO 0); 
begin
    --we are going to read in the value of A and assign rd accordingly 
    --rd will hold the number of leading zeros that we have after scanning A 
    --the max number of leading zeros we could have is 32, the value 32 
    --don't know how to make this a for loop so let's just hard code it
    CLOout <=   x"00000000" when ipFromA = "0-------------------------------" else 
                x"00000001" when ipFromA = "10------------------------------" else 
                x"00000002" when ipFromA = "110-----------------------------" else 
                x"00000003" when ipFromA = "1110----------------------------" else 
                x"00000004" when ipFromA = "11110---------------------------" else 
                x"00000005" when ipFromA = "111110--------------------------" else 
                x"00000006" when ipFromA = "1111110-------------------------" else 
                x"00000007" when ipFromA = "11111110------------------------" else 
                x"00000008" when ipFromA = "111111110-----------------------" else 
                x"00000009" when ipFromA = "1111111110----------------------" else 
                x"0000000A" when ipFromA = "11111111110---------------------" else 
                x"0000000B" when ipFromA = "111111111110--------------------" else 
                x"0000000C" when ipFromA = "1111111111110-------------------" else 
                x"0000000D" when ipFromA = "11111111111110------------------" else 
                x"0000000E" when ipFromA = "111111111111110-----------------" else 
                x"0000000F" when ipFromA = "1111111111111110----------------" else 
                x"00000010" when ipFromA = "11111111111111110---------------" else 
                x"00000011" when ipFromA = "111111111111111110--------------" else 
                x"00000012" when ipFromA = "1111111111111111110-------------" else 
                x"00000013" when ipFromA = "11111111111111111110------------" else 
                x"00000014" when ipFromA = "111111111111111111110-----------" else 
                x"00000015" when ipFromA = "1111111111111111111110----------" else 
                x"00000016" when ipFromA = "11111111111111111111110---------" else 
                x"00000017" when ipFromA = "111111111111111111111110--------" else 
                x"00000018" when ipFromA = "1111111111111111111111110-------" else 
                x"00000019" when ipFromA = "11111111111111111111111110------" else 
                x"0000001a" when ipFromA = "111111111111111111111111110-----" else 
                x"0000001b" when ipFromA = "1111111111111111111111111110----" else 
                x"0000001c" when ipFromA = "11111111111111111111111111110---" else 
                x"0000001d" when ipFromA = "111111111111111111111111111110--" else 
                x"0000001e" when ipFromA = "1111111111111111111111111111110-" else 
                x"0000001f" when ipFromA = "11111111111111111111111111111110" else 
                x"00000020" when ipFromA = "11111111111111111111111111111111" else
                (others => '0');
end Behavioral;
