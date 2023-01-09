----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/29/2022 08:09:38 PM
-- Design Name: 
-- Module Name: Shift - Behavioral
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

entity Shift is
    Port ( ip : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           ShiftedOp : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           ShiftEn : in STD_LOGIC);
end Shift;

architecture Behavioral of Shift is

begin
    --we either shift by 2 or 16 
    ShiftedOp <= std_logic_vector(shift_left(unsigned(ip), 2)) when ShiftEN = '0' else
                 std_logic_vector(shift_left(unsigned(ip), 16)) when ShiftEN = '1' else
                 (others => '0');  


end Behavioral;
