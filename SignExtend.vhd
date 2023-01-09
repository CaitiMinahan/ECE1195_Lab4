----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/11/2022 10:47:17 PM
-- Design Name: 
-- Module Name: SignExtend - Behavioral
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

entity SignExtend is
    Port ( DataIn : in STD_LOGIC_VECTOR(15 DOWNTO 0);
           SignExEn : in STD_LOGIC; 
           DataOut : out STD_LOGIC_VECTOR(31 DOWNTO 0));
end SignExtend;

architecture Behavioral of SignExtend is

begin
    --have two scenarios:
    --1) when the MSB = 1
    --2) when MSB = 0
    --we can use a when else statement to only need one line: 
    --only sign extend when the Enable bit is set high 
   DataOut <= ("1111111111111111" & DataIn(15 DOWNtO 0)) when (DataIn(15) = '1') else 
              ("0000000000000000" & DataIn(15 DOWNtO 0)) when (DataIn(15) = '0') OR SignExEn = '1' else --always want to zero extend when sig is high 
               (others => '0'); 
--   DataOut <= DataIn when SignExEn = '0'; --keep the same output when not enabled 
end Behavioral;
