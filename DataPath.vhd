library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DataPath is
    Port ( MemWrite : out STD_LOGIC; --connects to memory unit 
           MemoryDataIn : in STD_LOGIC_VECTOR(31 DOWNTO 0); --DataIn signal (output of the memory unit)
           MemoryAddress : out STD_LOGIC_VECTOR(31 DOWNTO 0); --feeds the memory unit (output of the mux)
           MemoryDataOut : out STD_LOGIC_VECTOR(31 DOWNTO 0); --feeds the write data signal of the memory unit 
           Clock : in STD_LOGIC;
           Reset : in STD_LOGIC);
end DataPath;

architecture Behavioral of DataPath is

component PC is
    Port ( En : in STD_LOGIC;
           Clk : IN STD_LOGIC; 
           Rst : IN STD_LOGIC; 
           PC_D : in STD_LOGIC_VECTOR(31 DOWNTO 0); --pc input 
           PC_Q : out STD_LOGIC_VECTOR(31 DOWNTO 0)); --pc output 
end component;

component IR is
    Port ( CLK : IN STD_LOGIC; 
           Rst : IN STD_LOGIC; 
           IRWrite : in STD_LOGIC;  --enable bit 
           MemData : in STD_LOGIC_VECTOR(31 DOWNTO 0); --D input 
           Inst : out STD_LOGIC_VECTOR(31 downto 0)); --inst31-0 are the Q outputs
end component;

component A is
    Port ( ReadData1 : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           Aout : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           En : in STD_LOGIC);
end component;

component B is
    Port ( ReadData2 : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           Bout : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           En : in STD_LOGIC);
end component;

component ALUOut is
    Port ( ALU_Result : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           ALU_Out : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           En : in STD_LOGIC);
end component;

component Lab02 is
    Port ( A : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           B : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           ALUOp : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           SHAMT : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           R : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           Zero : out STD_LOGIC;
           Overflow : out STD_LOGIC);
end component;

component RegisterFile is
    Port ( RegWrite : in STD_LOGIC;
           ReadReg1 : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           ReadReg2 : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           WriteReg : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           WriteData : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ReadData1 : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           ReadData2 : out STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

component SignExtend is
    Port ( DataIn : in STD_LOGIC_VECTOR(15 DOWNTO 0); --instr (15 downto 0)
           SignExEn : in STD_LOGIC; 
           DataOut : out STD_LOGIC_VECTOR(31 DOWNTO 0)); --sign extended instr feeding the mux 
end component;

component MemoryDataReg is
    Port ( LoadType : in STD_LOGIC_VECTOR(1 DOWNTO 0); --LoadType = control signal 
           clk, rst, En : in STD_LOGIC; 
           MemDataIn : in STD_LOGIC_VECTOR(31 DOWNTO 0); --DataIn signal connected to the memory 
           MemRegOut : out STD_LOGIC_VECTOR(31 DOWNTO 0)); --Dataout signal connected to the mux for the regfile's write data signal 
end component;

component CLO is
    Port ( ipFromA : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           CLOout : out STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

component Multiplier_AM is
	generic (
		WIDTH : positive := 32
	);
	port (
		A     : in  std_logic_vector(WIDTH-1 downto 0);
		B     : in  std_logic_vector(WIDTH-1 downto 0);
		R     : out std_logic_vector(2*WIDTH-1 downto 0);
		clk   : in  std_logic;
		rst   : in  std_logic;
		done  : out std_logic
	);
end component;

component HI_Reg is
    Port ( HiDataIn : in STD_LOGIC_VECTOR(31 DOWNTO 0); --MSB 32 of Result output from multiplier 
           HiDataOut : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           En : in STD_LOGIC);
end component;

component LO_Reg is
    Port ( LoDataIn : in STD_LOGIC_VECTOR(31 DOWNTO 0); --LSB 32 of Result output from multiplier 
           LoDataOut : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           En : in STD_LOGIC);
end component;

component Shift is
    Port ( ip : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           ShiftedOp : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           ShiftEn : in STD_LOGIC);
end component;

component ControlUnit is
    Port ( clk : in STD_LOGIC; 
           RST : IN STD_LOGIC;
           OpCode : in STD_LOGIC_VECTOR(5 DOWNTO 0);
           Funct : in STD_LOGIC_VECTOR(5 DOWNTO 0);
           PCWriteCond : out STD_LOGIC;
           PCWrite : out STD_LOGIC;
           --PCEnable : OUT STD_LOGIC; 
           IorD : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC_VECTOR(2 DOWNTO 0);
           IRWrite : out STD_LOGIC;
           PCSource : out STD_LOGIC_VECTOR(2 DOWNTO 0);
           ALUOp : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           ALUSrcB : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           BEnable : out STD_LOGIC; 
           ALUSrcA : out STD_LOGIC;
           AEnable : out std_logic; 
           RegWrite : out STD_LOGIC;
           RegDst : out STD_LOGIC;
           SLLV : out STD_LOGIC;
           Shift_En : out STD_LOGIC; 
           SignExt : out STD_LOGIC;
           NotGate : out STD_LOGIC; 
           done : in STD_LOGIC; 
           HiRegEn : out STD_LOGIC; 
           LoRegEn : out STD_LOGIC; 
           MultReset : out STD_LOGIC; 
           LoadType : out STD_LOGIC_VECTOR(1 DOWNTO 0));
end component;

--declare intermediate signals to be connected to the control signals:
--for PC 
signal Mem_toPC : STD_LOGIC_VECTOR(31 DOWNTO 0); --i/p to the PC 
signal PC_Write, PC_WriteCond, PC_Enable, I_orD : std_logic; 
signal PC_Source : std_logic_vector(2 downto 0); 
signal JumpAddr : STD_LOGIC_VECTOR(31 DOWNTO 0); 
--for the memory register: 
signal Mem_Write : std_logic;
signal Mem_toReg : std_logic_vector(2 downto 0);
--memreg_out is the output of the memory register  
--Mem_AddrSig is the output of the mux between PC and the memory, feeding next addr
signal Mem_AddrSig, PC_Output, MemReg_Out: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal Load_Type : STD_LOGIC_VECTOR(1 DOWNTO 0);  
--for IR 
signal IR_Write : std_logic;
--For Reg file 
signal Reg_Write, Reg_Dst : std_logic;
--for the instructions: 
signal Instr, Read_Data1, Read_Data2: STD_LOGIC_VECTOR(31 DOWNTO 0);
--for the ALU: 
signal ALU_SrcA, A_Enable, B_Enable, Overflow, Zerosig: std_logic;
signal ALU_SrcB : STD_LOGIC_VECTOR(3 DOWNTO 0); 
signal A_out, B_out, A_ip, B_ip, ALU_out, ALU_result : STD_LOGIC_VECTOR(31 DOWNTO 0); --alu_out is the output of the ALUOut reg, ALU_result is the output of the alu 
signal ALU_op : std_logic_vector(3 downto 0);
signal SHAMT : STD_LOGIC_VECTOR(4 DOWNTO 0); 
signal SLLV_sig : STD_LOGIC;
signal ShiftEnable : STD_LOGIC;  
signal ShiftedOp_sig : STD_LOGIC_VECTOR(31 DOWNTO 0); 
--for control unit
signal Func_t : std_logic_vector(5 downto 0); 
--for the muxes:
signal Write_Reg : STD_LOGIC_VECTOR(4 DOWNTO 0); --controlled by the RegDst bit (0 or 1)
signal Write_Data : STD_LOGIC_VECTOR(31 downto 0); 
--for the sign extend:
signal SignExtd_DataOut : STD_LOGIC_VECTOR(31 DOWNTO 0); --don't need a sig for DataIn since that directly gets Instr(15 downto 0)
signal SignEx_En : STD_LOGIC; --enable bit for the sign extender 
--for the CLO: 
signal CLO_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
--for the multiplier: 
signal done, HiReg_En, LoReg_En, MultRst : STD_LOGIC; 
signal MultR : STD_LOGIC_VECTOR(63 DOWNTO 0);
signal Hi_DataOut, Lo_DataOut : STD_LOGIC_VECTOR(31 DOWNTO 0); 
signal Not_Gate : STD_LOGIC; 
--**SIGNALS FOR THE MULT AND HI AND LO REGS**
--*******************************************  

begin
--port map all the control signals here: 
    MIPS_PC : PC PORT MAP(En=>PC_Enable, Clk=>Clock, Rst=>Reset, PC_D=>Mem_toPC, PC_Q=>PC_output); 
        --mux: logic for the mux feeding into the PC 
        --this signal is fed to the PC from the output of the mux  
        Mem_toPC <= ALU_Result when PC_Source = "000" else 
                   ALU_Out when PC_Source = "001" else
                   (PC_Output(31 downto 28) & (Instr(25 downto 0) & "00")) when PC_Source = "010" else --shift left 2 instr 25 downto 0 concat with PC_output(31 downto 28)
                    A_out when PC_Source = "011"; --for JR 
        --combinational logic for the PC_Enable bit: 
        Zerosig <= Zerosig when Not_Gate = '0' else 
                   NOT(zerosig) when Not_Gate = '1'; 
        PC_Enable <= (Zerosig AND PC_WriteCond) OR PC_Write; 
                   
    MIPS_IR : IR PORT MAP(Clk=>Clock, Rst=>Reset, IRWrite=>IR_Write, MemData=>MemoryDataIn, Inst=>Instr); 
    MIPS_RegFile : RegisterFile PORT MAP(RegWrite=>Reg_Write, ReadReg1=>Instr(25 downto 21), ReadReg2=>Instr(20 downto 16), 
                                          WriteReg=>Write_Reg, WriteData=>Write_Data, clk=>clock, rst=>reset, ReadData1=>Read_Data1, 
                                          ReadData2=>Read_Data2); 
        --mux: logic for WriteRegister signal 
        Write_Reg <= Instr(20 downto 16) when Reg_Dst = '0' else 
                     Instr(15 downto 11) when Reg_Dst = '1'; 
        --mux: logic for WriteData signal 
        Write_Data <= ALU_Out when Mem_toReg = "000" else 
                      MemReg_Out when Mem_toReg = "001" else
                      CLO_out when Mem_toReg = "010" else
                      Hi_DataOut when Mem_toReg = "011" else
                      Lo_DataOut when Mem_toReg = "100"; 
                           
    MIPS_A : A PORT MAP(ReadData1=>Read_Data1, Aout=>A_out, Clk=>clock, rst=>reset, En=>A_Enable); 
    MIPS_B : B PORT MAP(ReadData2=>Read_Data2, Bout=>B_out, Clk=>clock, rst=>reset, En=>B_Enable);
    MIPS_ALUoutReg : ALUOut PORT MAP(ALU_Result=>ALU_Result, ALU_out=>ALU_out, clk=>clock, rst=>reset, en=>'1'); --keep the enable bit to always be 1 
    --port map the ALU (for some reason, I named mine 'Lab02') 
    MIPS_ALU : Lab02 PORT MAP(A=>A_ip, B=>B_ip, ALUOp=>ALU_op, SHAMT=>SHAMT, R=>ALU_Result, 
                              Zero=>Zerosig, Overflow=>Overflow); 
        --mux: logic for muxes going into the ALU 
        A_ip <= A_out when ALU_SrcA = '1' else  
                PC_output when ALU_SrcA = '0'; 
        B_ip <= B_out when ALU_SrcB = x"0" else --B register value 
                x"00000004" when ALU_SrcB = x"1" else -- PC + 4 
                SignExtd_DataOut when ALU_SrcB = x"2" else --sign extended result 
                ShiftedOp_sig when ALU_SrcB = x"3"; --sign extended shift left 2 result 
       --logic for the SHAMT bit for SLLV instruction
       SHAMT <= A_out(4 downto 0) when SLLV_sig = '1' else --SLLV: shift by rs 
                Instr(10 downto 6) when SLLV_sig = '0' else --Shift: shift by SHAMT 
                (others => '0'); 
    MIPS_SignExtend : SignExtend PORT MAP(DataIn=>Instr(15 downto 0), SignExEn=>SignEx_En, DataOut=>SignExtd_DataOut); 
    MIPS_MemoryReg : MemoryDataReg PORT MAP(En=> '1', clk=>clock, rst=>reset, LoadType=>Load_Type, MemDataIn=>MemoryDataIn, MemRegOut=>MemReg_Out); 
    MIPS_CLO : CLO PORT MAP(ipFromA=>A_out, CLOout=>CLO_out); 
    MIPS_MULTIPLIER : Multiplier_AM PORT MAP(A=>A_ip, B=>B_ip, clk=>clock, rst=>MultRst, R=>MultR , done=>done); 
    MIPS_HIReg : HI_Reg PORT MAP(HiDataIn=>MultR(63 downto 32), HiDataOut=>Hi_DataOut, clk=>clock, rst=>reset, en=>HiReg_En); 
    MIPS_LoReg : LO_Reg PORT MAP(LoDataIn=>MultR(31 downto 0), LoDataOut=>Lo_DataOut, clk=>clock, rst=>reset, en=>LoReg_En); 
    MIPS_SHIFTER : Shift PORT MAP(ip=>SignExtd_DataOut, ShiftedOp=>ShiftedOp_sig, ShiftEn=>ShiftEnable); 
    MemWrite <= Mem_Write;     
    MIPS_ControlUnit : ControlUnit PORT MAP(clk=>clock, rst=>reset, OpCode=>Instr(31 downto 26), Funct=>Instr(5 downto 0), 
                                         PCWriteCond=>PC_WriteCond, PCWrite=>PC_Write, SLLV=>SLLV_sig, 
                                         IorD=>I_orD, MemWrite=>Mem_Write, MemtoReg=>Mem_toReg, IRWrite=>IR_Write, SignExt=>SignEx_En, --MemWrite of control unit and Datapath are connected directly
                                         PCSource=>PC_Source, ALUOp=>ALU_op, ALUSrcA=>ALU_SrcA, ALUSrcB=>ALU_SrcB,LoadType=>Load_Type, Shift_En=>ShiftEnable, 
                                         BEnable=>B_Enable, AEnable=>A_Enable, RegWrite=>Reg_Write, RegDst=>Reg_Dst, done=>done, MultReset=>MultRst, NotGate=>NOt_Gate,  
                                         HiRegEn=>HiReg_En, LoRegEn=>LoReg_En); 
    --send output of B reg to the MemWriteData signal: 
    MemoryDataOut <= B_out; --directly tied to the output of the B reg
    --mux: going into the memory unit (between the PC and IR)
    MemoryAddress <= PC_output when I_orD = '0' else 
                  ALU_out when I_orD = '1'; 
end Behavioral;
