----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/27/2022 03:28:58 PM
-- Design Name: 
-- Module Name: MIPS_CPUTopLevel - Behavioral
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
USE ieee.std_logic_arith.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpu_tb is --where we connect the CPU to the memory 
    Port ( clock : in STD_LOGIC;
           reset : in STD_LOGIC);
end cpu_tb;

architecture Behavioral of cpu_tb is

    component CPU_memory IS
       PORT( 
          Clk      : IN     std_logic;
          MemWrite : IN     std_logic;
          addr     : IN     std_logic_vector (31 DOWNTO 0);
          dataIn   : IN     std_logic_vector (31 DOWNTO 0);
          dataOut  : OUT    std_logic_vector (31 DOWNTO 0)
       );
    
    -- Declarations
    
    END component ;
    
    component DataPath is
        Port ( MemWrite : out STD_LOGIC; --connects to memory unit 
               MemoryDataIn : in STD_LOGIC_VECTOR(31 DOWNTO 0); --DataIn signal (output of the memory unit)
               MemoryAddress : out STD_LOGIC_VECTOR(31 DOWNTO 0); --feeds the memory unit (output of the mux)
               MemoryDataOut : out STD_LOGIC_VECTOR(31 DOWNTO 0); --feeds the write data signal of the memory unit 
               Clock : in STD_LOGIC;
               Reset : in STD_LOGIC);
    end component;
    
--declare intermediate signals: 
signal Mem_Write : STD_LOGIC; 
signal addy, data_in, data_out : std_logic_vector(31 downto 0);     
    
begin --rename signals
    --tie the memory and cpu together: 
    U_0 : DataPath PORT MAP(MemWrite=>Mem_Write, MemoryDataIn=>data_in, MemoryAddress=>addy, MemoryDataOut=>data_out, clock=>clock, reset=>reset); 
    U_1 : CPU_memory PORT MAP(clk=>clock, MemWrite=>Mem_Write, addr=>addy, dataIn=>data_out, dataOut=>data_in); 

end Behavioral;
