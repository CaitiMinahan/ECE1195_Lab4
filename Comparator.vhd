----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2022 05:42:21 PM
-- Design Name: 
-- Module Name: Comparator - Behavioral
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

entity Comparator is
    Port ( A_31 : in STD_LOGIC;
           B_31 : in STD_LOGIC;
           S_31 : in STD_LOGIC;
           CO : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           R : out STD_LOGIC_VECTOR(31 DOWNTO 0));
end Comparator;

architecture Behavioral of Comparator is

begin
    --since we are only setting R(0), then we must fill the other 31 bits
    R(31 downto 1) <= (others => '0');
    --signed comparator 
    --take values from the table given
    R(0) <= '0' when (ALUOp(1)='1' AND ALUOp(0)='0' AND A_31='0' AND B_31='0' AND S_31='0') else 
            '1' when (ALUOp(1)='1' AND ALUOp(0)='0' AND A_31='0' AND B_31='0' AND S_31='1') else
            '0' when (ALUOp(1)='1' AND ALUOp(0)='0' AND A_31='1' AND B_31='1' AND S_31='0') else  
            '1' when (ALUOp(1)='1' AND ALUOp(0)='0' AND A_31='1' AND B_31='1' AND S_31='1') else 
            '1' when (ALUOp(1)='1' AND ALUOp(0)='0' AND A_31='1' AND B_31='0') else
            '0' when (ALUOp(1)='1' AND ALUOp(0)='0' AND A_31='0' AND B_31='1') else
            --ADD TWO MORE CONDITIONS HERE
        --unsigned comparator
            '0' when (ALUOp(1)='1' AND ALUOp(0)='1' AND CO='1') else 
            '1' when (ALUOp(1)='1' AND ALUOp(0)='1' AND CO='0'); 
 
end Behavioral;
