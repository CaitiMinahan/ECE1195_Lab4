----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2022 02:57:34 PM
-- Design Name: 
-- Module Name: Shifter - Behavioral
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

entity Shifter is
    Port ( A : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           SHAMT : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           ALUOp : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           R : out STD_LOGIC_VECTOR(31 DOWNTO 0));
end Shifter;

architecture Behavioral of Shifter is
    --declare temp signals here 
    --left shifted result
    signal L_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal L_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal L_2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal L_3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal L_4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --right shifted result
    signal R_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal R_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal R_2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal R_3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal R_4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --fill signal 
    signal Fill : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --temp signal to get SHAMT values
    signal Sel_0 : STD_LOGIC; 
    signal Sel_1 : STD_LOGIC; 
    signal Sel_2 : STD_LOGIC; 
    signal Sel_3 : STD_LOGIC; 
    signal Sel_4 : STD_LOGIC; 
    --temp signal to get ALUOp values 
    signal ALUOp_Sel : STD_LOGIC; 
    
begin
    --fill Sel with the value of SHAMT
    Sel_0 <= SHAMT(0); 
    Sel_1 <= SHAMT(1); 
    Sel_2 <= SHAMT(2); 
    Sel_3 <= SHAMT(3); 
    Sel_4 <= SHAMT(4); 
    
    --fill the ALUOp_Sel with value of ALUOp(1):
    ALUOp_Sel <= ALUOp(1); 
    
    --set the Fill signal
    Fill <= (others => ALUOp(0) and A(31));
 
    --implementation for left shit 
        --since we are only doing logical shift left, we only need this one implementation: when ALUOp(1)=0
        --create a temp signal for the left-shifted result 
        --use when else statements
            --account for when SHAMT(n)= 1 or 0 
            L_0 <= (A(30 downto 0) & '0') when (Sel_0='1') else A; 
            L_1 <= (L_0(29 downto 0) & "00") when Sel_1='1' else L_0; 
            L_2 <= (L_1(27 downto 0) & "0000") when Sel_2='1' else L_1; 
            L_3 <= (L_2(23 downto 0) & "00000000") when Sel_3='1' else L_2;
            L_4 <= (L_3(15 downto 0) & "0000000000000000") when Sel_4='1' else L_3; 
        
    --implementation for right shift
        --here we can do either logic shift right or arithmetic shift right, but we can still only use one implementation here 
        --by creating another temp signal, 'fill', we take care of whether the left end will be filled with zeros or signed bits 
            R_0 <= (Fill(0) & A(31 downto 1)) when Sel_0='1' else A; 
            R_1 <= (Fill(1 downto 0) & R_0(31 downto 2)) when Sel_1='1' else R_0;  
            R_2 <= (Fill(3 downto 0) & R_1(31 downto 4)) when Sel_2='1' else R_1; 
            R_3 <= (Fill(7 downto 0) & R_2(31 downto 8)) when Sel_3='1' else R_2;  
            R_4 <= (Fill(15 downto 0) & R_3(31 downto 16)) when Sel_4='1' else R_3;  
                      
    --finally, create a 2:1 mux using 'when' statements
    --the output 'R' will get either the left or right shifted result pushed to it 
    --push L_4 or R_4 depending on the value of ALUOp(1)
        WITH ALUOp_Sel SELECT
            R <= L_4 when '0', 
                 R_4 when '1',
                 (others => '0') when others;  
end Behavioral;
