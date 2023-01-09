----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/15/2022 12:12:46 PM
-- Design Name: 
-- Module Name: Lab02 - Behavioral
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

entity Lab02 is
    Port ( A : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           B : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           ALUOp : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           SHAMT : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           R : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           Zero : out STD_LOGIC;
           Overflow : out STD_LOGIC);
end Lab02;

architecture Behavioral of Lab02 is
    --declare components here 
    --logic unit 
    component LogicUnit is
        Port ( A : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           B : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           Op : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           R : out STD_LOGIC_VECTOR(31 DOWNTO 0));
    end component;
    
    --arithmetic unit 
    component Arith_Unit IS
        GENERIC (
            n       : positive := 32);
        PORT( 
            A       : IN     std_logic_vector (n-1 DOWNTO 0);
            B       : IN     std_logic_vector (n-1 DOWNTO 0);
            C_op    : IN     std_logic_vector (1 DOWNTO 0);
            CO      : OUT    std_logic;
            OFL     : OUT    std_logic;
            S       : OUT    std_logic_vector (n-1 DOWNTO 0);
            Z       : OUT    std_logic);
     END component;
    
    --comparator 
    component Comparator is
        Port ( A_31 : in STD_LOGIC;
           B_31 : in STD_LOGIC;
           S_31 : in STD_LOGIC;
           CO : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           R : out STD_LOGIC_VECTOR(31 DOWNTO 0));
    end component;    
    
    --shifter 
    component Shifter is
        Port ( A : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           SHAMT : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           ALUOp : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           R : out STD_LOGIC_VECTOR(31 DOWNTO 0));
    end component;
    
    --declare intermediate signals here
    --each R o/p for each component gets assigned to these intermediate signals 
    signal LogicalR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal ArithR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal Carryout : STD_LOGIC;
    signal CompR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal ShiftR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --temp signal to get ALUOp values 
    signal ALUOp_Sel : STD_LOGIC_VECTOR(1 DOWNTO 0); 
    
begin
    --instantiate all top level ALU components here using portmaps
    ALU_Logical: LogicUnit PORT MAP(A=>A, B=>B, Op=>ALUOp(1 downto 0), R=>LogicalR); 
    ALU_Arith: Arith_Unit PORT MAP(A=>A, B=>B, C_op => ALUOP(1 downto 0), CO => Carryout, OFL => Overflow, S => ArithR, Z => Zero); 
    ALU_Comp: Comparator PORT MAP(A_31=>A(31), B_31=>B(31), CO=>Carryout, S_31=>ArithR(31), ALUOp=>ALUOp(1 downto 0), R=>CompR); 
    ALU_Shift: Shifter PORT MAP(A=>B, SHAMT=>SHAMT, ALUOp=>ALUOp(1 downto 0), R=>ShiftR); 
    
    --fill the ALUOp_Sel with value of ALUOp(1):
    ALUOp_Sel <= ALUOp(3 downto 2); 
    
    --create ALU MUX here 
    --4 i/p to the MUX includes: LogicalR, ArithR, CompR, and ShiftR 
    --1 select bit: ALUOp(3:2)
    --1 o/p: R(31:0)
     WITH ALUOp_Sel SELECT
    --R=LogicalR when ALUOp(3 DOWNTO 2) = "00"
        R <= LogicalR when "00", 
    --R=ArtihR when ALUOp(3 downto 2) = "01"
          ArithR when "01", 
    --R=CompR when ALUOp(3 downto 2) = "10"
          CompR when "10",
    --R=ShiftR when ALUOp(3 downto 2) = "11"
          ShiftR when "11",
          (others => '0') when others;  

end Behavioral;
