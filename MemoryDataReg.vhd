----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/23/2022 02:09:22 PM
-- Design Name: 
-- Module Name: MemoryDataReg - Behavioral
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

entity MemoryDataReg is
    Port ( LoadType : in STD_LOGIC_VECTOR(1 DOWNTO 0); --LoadType = control signal 
           clk, rst, En : in STD_LOGIC; 
           MemDataIn : in STD_LOGIC_VECTOR(31 DOWNTO 0); --DataIn signal connected to the memory 
           MemRegOut : out STD_LOGIC_VECTOR(31 DOWNTO 0)); --Dataout signal connected to the mux for the regfile's write data signal 
end MemoryDataReg;

architecture Behavioral of MemoryDataReg is
    --intermediate signal for sign extended offset for LH 
    --signal SignExtOffset : STD_LOGIC_VECTOR(15 DOWNTO 0); 
    signal MemRegOutExt : signed(31 downto 0); 
    signal MemDataInExt : signed(31 downto 0); 

begin
--logic for the sign extended offset: testing the MSB of dataIn 
--SignExtOffset <= "1111111111111111"  when MemDataIn(15) = '1' else 
--                 "0000000000000000"  when MemDataIn(15) = '0'; 
MemRegOut <= std_logic_vector(MemRegOutExt); 
MemDataInExt <= signed(MemDataIn); 

--create a process and test for the various loadtype values for which load instr to do:
--GPR[base] will be the LSB 16 bits for LH, and the MSB 16 bits for LUI  
CLKD : process(CLK, RST, LoadType)
     begin
        if(RST = '1') then
            MemRegOutExt <= (others => '0'); 
        elsif(CLK'event AND CLK = '1') then
            if(en = '1') then 
                --test the different values of LoadType:
                --LH: 
                if(LoadType = "01") then 
                    MemRegOutExt <= resize(MemDataInExt(31 downto 16), 32); 
                --LW:
                elsif(LoadType = "00") then 
                    MemRegOutExt <= MemDataInExt; --load the full word of MemDataIn 
                else 
                    MemRegOutExt <= (others => '0'); 
                end if; 
            end if; 
        end if; 
    end process; 
end Behavioral;
