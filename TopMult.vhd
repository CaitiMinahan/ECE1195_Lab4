library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopMult is
    Port ( A : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           B : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           R : out STD_LOGIC_VECTOR(63 DOWNTO 0);
           Done : out STD_LOGIC);
end TopMult;

architecture Behavioral of TopMult is
    --declare components here
    
    --control unit 
    component control is
    Port ( Blsb : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           count : in STD_LOGIC_VECTOR(4 DOWNTO 0); 
           load : out STD_LOGIC;
           prod : out STD_LOGIC;
           countInc : out STD_LOGIC;
           shift : out STD_LOGIC;
           done : out STD_LOGIC
           ); 
    end component;
    --Shift registers
    --shift left
    component ShiftReg64 is
    Port ( D : in STD_LOGIC_VECTOR(63 DOWNTO 0);
           Load : in STD_LOGIC;
           Sin : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(63 DOWNTO 0));
    end component;
    
    --shift right
    component ShiftReg32 is
    Port ( D : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           Load : in STD_LOGIC;
           Sin : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(31 DOWNTO 0));
    end component;
    
    --ALU (adder)
    component adder is
	generic (
		WIDTH : positive := 64
	);
	port (
		A     : in  std_logic_vector(WIDTH-1 downto 0);
		B     : in  std_logic_vector(WIDTH-1 downto 0);
		S     : out std_logic_vector(WIDTH-1 downto 0)
	);
    end component;
    
    --counter
    component UpCounter5 is
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Enable : in STD_LOGIC;
           QCount : out STD_LOGIC_VECTOR(4 DOWNTO 0));
    end component;
    
    --product register (flipflop)
    component flipflop IS
    PORT( 
      CLK : IN     std_logic;
      D   : IN     std_logic_vector(63 downto 0);
      EN  : IN     std_logic;
      RST : IN     std_logic;
      Q   : OUT    std_logic_vector(63 downto 0));
    END component;
    
    --intermediate signals:
    signal countSig : STD_LOGIC_VECTOR(4 DOWNTO 0); 
    signal Qshifted_left : STD_LOGIC_VECTOR(63 DOWNTO 0); --shifted multiplicand which is the o/p of the 64-bit shift register 
    signal Ashifted : STD_LOGIC_VECTOR(63 DOWNTO 0);
    signal Qshifted_right : STD_LOGIC_VECTOR(31 DOWNTO 0); --shifted multiplier which is the o/p of the 32-bit shift register 
    signal sum : STD_LOGIC_VECTOR(63 DOWNTO 0); 
    signal LoadBit : STD_LOGIC;
    signal ProdBit : STD_LOGIC;
    signal IncCountBit : STD_LOGIC;
    signal ShiftBit : STD_LOGIC;
    signal ProdSig : STD_LOGIC_VECTOR(63 DOWNTO 0); 
    
begin
    --for the multiplicand shifter, the input needs to be a 64 bit number
    --we use an intermediate signal so we can send a i/p A to the 64-bit shift registers for shifting 
    Ashifted(31 downto 0) <= A; --since A is only 32-bits long, send A to the intermediate signal's first 32 bits
    Ashifted(63 downto 32) <= (others => '0'); --the remaining 32 bits will be filled with zeros for it to be shifted left

    --instantiate all components using port mapping 
    MULT_Control: control PORT MAP(Blsb=>Qshifted_right(0), clk=>clk, reset=>rst, count=>countSig , load=>LoadBit , prod=>ProdBit , shift=>ShiftBit , countInc=>IncCountBit , done=>Done ); 
    MULT_ShiftLeft : ShiftReg64 PORT MAP(D=>Ashifted, Load=>LoadBit, Sin=>ShiftBit, clk=>clk, reset=>rst, Q=>Qshifted_left); --i/p is shifted multiplicand and o/p keeps getting updated with shifted result 
    MULT_ShiftRight : ShiftReg32 PORT MAP(D=>B, Load=>LoadBit, Sin=>ShiftBit, clk=>clk, reset=>rst, Q=>Qshifted_right); 
    MULT_ALU : adder PORT MAP(A=>Qshifted_left, B=>ProdSig, S=>sum); 
    MULT_Counter : UpCounter5 PORT MAP(clk=>clk, reset=>rst, enable=>IncCountBit , QCount=>countSig); 
    MULT_Product : flipflop PORT MAP(clk=>clk, D=>sum, en=>ProdBit, rst=>rst, Q=>ProdSig); 

    --R = A * B 
    R <= ProdSig; --64 bit result that gets written to o/p from ProdSig    
end Behavioral;
