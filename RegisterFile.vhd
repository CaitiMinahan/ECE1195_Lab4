----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/11/2022 09:44:39 PM
-- Design Name: 
-- Module Name: RegisterFile - Behavioral
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

entity RegisterFile is
    Port ( RegWrite : in STD_LOGIC;
           ReadReg1 : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           ReadReg2 : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           WriteReg : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           WriteData : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ReadData1 : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           ReadData2 : out STD_LOGIC_VECTOR(31 DOWNTO 0));
end RegisterFile;

architecture Behavioral of RegisterFile is
    --create an array of vectors (b/c for some reason you can't have a vector of vectors in VHDL)
    type Reg_Array is array (0 to 31) of STD_LOGIC_VECTOR(31 DOWNTO 0); --now we have a 32 element array of 32-bit vectors 
    signal regArray : Reg_Array; 
    
begin
    --the read data ports get the data from a certain register (one of them) so we need to be able to index our array 
    --logic for reading from the registers   
    ReadData1 <= regarray(to_integer(unsigned(ReadReg1))); --must typecast to an integer bc we can only index arrays using ints 
    ReadData2 <= regarray(to_integer(unsigned(ReadReg2)));  
    
    --logic for writing to the registers:
    process(clk, rst)
        begin
            if(rst = '1') then 
                --if the reset is high, fill your array with zeros: 
                FOR i IN 0 to 31 LOOP
                    regarray(i) <= (others => '0'); 
                end loop; 
             elsif(CLK' event AND CLK = '1') then 
                if(RegWrite = '1') then 
                    regarray(to_integer(unsigned(WriteReg))) <= WriteData; --write back to value from the ALU to the correct register (which is denoted by the element in the array)
                end if; 
             end if;      
        
    end process;

end Behavioral;
