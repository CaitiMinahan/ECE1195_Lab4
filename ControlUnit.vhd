library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlUnit is
    Port ( clk : in STD_LOGIC; 
           RST : IN STD_LOGIC;
           OpCode : in STD_LOGIC_VECTOR(5 DOWNTO 0); --101011
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
           done : in STD_LOGIC; --for mult
           HiRegEn : out STD_LOGIC; 
           LoRegEn : out STD_LOGIC; 
           MultReset : out STD_LOGIC; 
           LoadType : out STD_LOGIC_VECTOR(1 DOWNTO 0));
end ControlUnit;

architecture Behavioral of ControlUnit is
-- Build an enumerated type for the state machine
	type state_type is (fetch, decode, I_or_R_execute, Rcompletion, 
	                    BranchExecute, MultExec,  
	                    BranchCompletion, JumpCompletion, MemReadCompletion, 
	                    MemAddrComputation, MemAccessStr, MemAccessLoad, MultDone, MoveDone);
	
	-- Register to hold the current state
	signal state : state_type;
	signal nextstate : state_type;
	
begin
    --section 1: FSM register for Mealy 
    process(clk, rst)
    begin 
        if rst = '1' then 
            state <= fetch; 
        elsif (rising_edge(clk)) then
            state <= nextstate;
        end if; 
    end process;
    
    --section 2: next state logic for Mealy 
    process (state, OpCode, Funct, done)
    --process(state, done)
	begin
	   case state is 
	       when fetch =>
	           nextstate <= decode; --go to decode after we've fetched 
	       when decode =>
	           --test op code for each instr type to decide which execute branch to go to
	           --if instr is R-type or I-type (they have the same decode):
	           if(OpCode = "000000") OR (OpCode = "001000") OR (OpCode = "001101") OR (OpCode = "001010") OR (OpCode = "001111") then
	               nextstate <= I_or_R_execute; 
	           --if instr is J-Type: 
	           --if BNE
	           elsif(OpCode = "000101") then 
	               nextstate <= BranchExecute; 
	           --if J or JR:   
	           elsif(Opcode = "000010") OR ((Opcode = "000000") AND (Funct = "001000")) then 
	               nextstate <= JumpCompletion;    
	           --if instr is Memory-type
	           --LW, LH, or SW
	           elsif(OpCode = "100001") OR (OpCode = "100011") OR (OpCode = "101011") then 
	               nextstate <= MemAddrComputation; 
	           --if instr is Multiplication
	           --MULTU: 
	           elsif(Opcode = "000000") AND (Funct = "011001") then
	               nextstate <= MultExec; 
	           --MFHI, MFLO: 
	           elsif(Opcode = "000000") AND ((Funct = "010000") OR (Funct = "010010")) then
	               nextstate <= MoveDone; 
	           --CLO:
	           elsif(OpCode = "011100") then 
	               nextstate <= RCompletion; 
	           --include next state logic for CLO  
               end if; 
           when I_or_R_execute =>
                nextstate <= Rcompletion; 
           --repeat the process after we've completed
           when Rcompletion =>
                nextstate <= fetch; 
           when BranchExecute => 
                nextstate <= BranchCompletion; 
           when BranchCompletion => 
                nextstate <= fetch; 
           when JumpCompletion =>
                nextstate <= fetch;  
           when MemAddrComputation => 
                --test conditions for whether we are loading or storing a word: 
                --for load instrs: 
                if(OpCode = "100001") OR (OpCode = "001111") OR (OpCode = "100011") then
                    nextstate <= MemAccessLoad;  
                --for store instrs: 
                elsif(OpCode = "101011") then
                    nextstate <= MemAccessStr; 
                end if; 
           when MemAccessStr =>
                nextstate <= fetch; 
           when MemAccessLoad => 
                nextstate <= MemReadCompletion; 
           when MemReadCompletion =>
                nextstate <= fetch; 
           when MultExec =>
                if(done = '1') then 
                    nextstate <= MultDone; 
                elsif(done = '0') then 
                    nextstate <= MultExec; --loop
                end if; 
	       when MultDone => 
	           nextstate <= fetch; 
	       when MoveDone => 
	           nextstate <= fetch; 
        end case; 
    end process; 
    
    --section 3: output logic
    process(state, OpCode, Funct)
    --make variables bc my signals are screwing this up xoxo: 
     variable PCWriteCond_Var :  STD_LOGIC := '0'; 
     variable PCWrite_Var :  STD_LOGIC := '0';
     variable IorD_Var :  STD_LOGIC :='0'; 
     variable MemWrite_Var :  STD_LOGIC := '0';  
     variable MemtoReg_Var :  STD_LOGIC_VECTOR(2 DOWNTO 0) := "000"; 
     variable IRWrite_Var :  STD_LOGIC := '0'; 
     variable PCSource_Var :  STD_LOGIC_VECTOR(2 DOWNTO 0) := "000"; 
     variable ALUOp_Var :  STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"; 
     variable ALUSrcB_Var :  STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"; 
     variable BEnable_Var :  STD_LOGIC := '0'; 
     variable ALUSrcA_Var :  STD_LOGIC := '0'; 
     variable AEnable_Var :  std_logic := '0'; 
     variable RegWrite_Var :  STD_LOGIC := '0'; 
     variable RegDst_Var :  STD_LOGIC := '0'; 
     variable SLLV_Var :  STD_LOGIC := '0'; 
     variable Shift_En_Var :  STD_LOGIC := '0';  
     variable SignExt_Var :  STD_LOGIC := '0'; 
     variable NotGate_Var :  STD_LOGIC := '0'; 
     variable HiRegEn_Var :  STD_LOGIC := '0'; 
     variable LoRegEn_Var :  STD_LOGIC := '0'; 
     variable MultReset_Var :  STD_LOGIC := '0'; 
     variable LoadType_Var :  STD_LOGIC_VECTOR(1 DOWNTO 0) := "00"; 
     begin
     --set all vars to zero for resetting between states: 
     PCWriteCond_Var := '0'; 
     PCWrite_Var := '0';
     IorD_Var :='0'; 
     MemWrite_Var := '0';  
     MemtoReg_Var := "000"; 
     IRWrite_Var := '0'; 
     PCSource_Var := "000"; 
     ALUOp_Var := "0000"; 
     ALUSrcB_Var := "0000"; 
     BEnable_Var := '0'; 
     ALUSrcA_Var := '0'; 
     AEnable_Var := '0'; 
     RegWrite_Var := '0'; 
     RegDst_Var := '0'; 
     SLLV_Var := '0'; 
     Shift_En_Var := '0';  
     SignExt_Var := '0'; 
     NotGate_Var := '0'; 
     HiRegEn_Var := '0'; 
     LoRegEn_Var := '0'; 
     MultReset_Var := '0'; 
     LoadType_Var := "00"; 
        case state is 
            when fetch => 
                --fetch state is the same for all instructions 
                IRWrite_Var := '1'; 
                PCWrite_Var := '1'; 
                ALUOp_Var := "0101"; --ADDU 
                ALUSrcB_Var := "0001"; --controls the mux 
                --IorD_Var := '0'; --controls the mux 
                PCSource_Var := "000"; --controls the mux 
                ALUSrcA_Var := '0'; --controls the mux 
            when decode => 
                --we always want to write to A and B regs in decode: 
                AEnable_Var := '1'; 
                BEnable_Var := '1';
                --RegWrite_Var := '1'; 
               --control signals vary for the instrs below: 
	           --if MULTU: 
	           if(Opcode = "000000") AND (Funct = "011001") then
                    MultReset_Var := '1';                
	           --if BNE
	           elsif(OpCode = "000101") then
	                ALUSrcA_Var := '0'; 
                    ALUSrcB_Var := "0011"; 
	                ALUOp_Var := "0100"; --ADD (SIGNED)
                end if; 
           when I_or_R_execute =>
                ALUSrcA_Var := '1'; 
                ALUSrcB_Var := "0010";
                --test op code, funct code and define ALUOp  
                --if R-type: 
                if(OpCode = "000000") then
                    --set control signals
                    ALUSrcB_Var := "0000"; 
                    --now, test the different function codes for R-type instrs:
                    --ADDU 
                    if(Funct = "100001") then 
                        --refer to lab 2 for ALUOp code 
                        ALUOp_Var := "0101"; --for ADDU  
                    --AND
                    elsif(Funct = "100100") then
                        ALUOp_Var := "0000";
                    --SLL
                    elsif(Funct = "000000") then 
                        ALUOp_Var := "1101";
                    --SLLV 
                    elsif(Funct = "000100") then
                        SLLV_Var := '1'; 
                        ALUOp_Var := "1101";
                    --SRA 
                    elsif(Funct = "000011") then
                        ALUSrcA_Var := '1';
                        IorD_Var := '1'; 
                        ALUOp_Var := "1111"; 
                    --SUB  
                    elsif(Funct = "100010") then 
                        ALUOp_Var := "0110"; 
                    end if;
                --if instr is I-type: 
	            elsif(OpCode = "001000") OR (OpCode = "001101") OR (OpCode = "001010") OR (OpCode = "001111") then  
                  --test the OpCodes for the 3 I-type instr:
                  --ADDI 
                  if(OpCode = "001000") then 
                       ALUOp_Var := "0100"; --ALUOp for ADD SIGNED 
                  --ORI 
                  elsif(OpCode = "001101") then
                       ALUOp_Var := "0001"; --ALUOp for logical OR  
                       SignExt_Var := '1'; 
                  --LUI 
                  elsif(OpCode = "001111") then 
                        RegDst_Var := '1'; 
                        MemtoReg_Var := "000"; 
                        SignExt_Var := '0'; 
                        Shift_En_Var := '1'; 
                        ALUSrcB_Var := "0011";
                        ALUOp_Var := "0100"; 
                  --SLTI
                  elsif(OpCode = "001010") then
                       SignExt_Var := '0'; 
                       ALUOp_Var := "1010"; --ALUOp for SLT (signed less than)
	              end if; 
                end if; 
           when Rcompletion => 
                --if instr is I-type: 
	            if(OpCode = "001000") OR (OpCode = "001101") OR (OpCode = "001010") OR (OpCode = "001111") then
	               RegWrite_Var := '1'; 
	               RegDst_Var := '0'; 
	               MemtoReg_Var := "000"; 
                --if instr is R-type: 
                elsif(OpCode = "000000") then
	               RegWrite_Var := '1'; 
	               RegDst_Var := '1'; --instr 15-11
	               MemtoReg_Var := "000"; 
                --if instr is CLO: 
                elsif(OpCode = "011100") then 
	               RegWrite_Var := '1'; 
	               RegDst_Var := '1'; --instr 15-11
	               MemtoReg_Var := "010"; --select ALUOut
                end if; 
           when BranchExecute => 
                ALUSrcB_Var := "0000"; 
                ALUSrcA_Var := '1'; 
                ALUOp_Var := "0110"; --SUB 
           when BranchCompletion =>
                ALUSrcB_Var := "0001"; 
                ALUSrcA_Var := '0';
                PCWriteCond_Var := '1'; 
                PCSource_Var := "001"; 
                NotGate_Var := '1';  
           when JumpCompletion =>
                PCWrite_Var := '1'; --inc PC 
                --JR: 
                if(OpCode = "000000" AND Funct = "001000") then 
                    PCSource_Var := "011"; 
                else --If instr is J: 
                    PCSource_Var := "010"; 
                end if; 
           when MemAddrComputation =>
               -- MemWrite_Var := '1'; 
                SignExt_Var := '0'; 
                ALUOp_Var := "0100"; --ADD (SIGNED)
                ALUSrcA_Var := '1'; 
                ALUSrcB_Var := "0010"; 
           when MemAccessStr =>
                
                IorD_Var := '1'; 
                MemWrite_Var := '1'; --to write to the mem
           when MemAccessLoad =>
                IorD_Var := '1'; 
                MemWrite_Var := '0'; 
                --if LH: 
                if(OpCode = "100001") then
                    LoadType_Var := "01"; --to specify whether we are doing LH or LW 
                --if LW:
                elsif(OpCode = "100011") then 
                    LoadType_Var := "00"; 
                end if; 
           when MemReadCompletion =>
                --we only get here when we are using load instrs: 
                MemtoReg_Var := "001"; --select output of mem register to send to write data port of reg file 
                RegDst_Var := '0'; --selects instr(20-16) to send to write register port of reg file 
                RegWrite_Var := '1'; 
           when MultExec =>
                MultReset_Var := '0'; 
                ALUSrcB_Var := "0000"; 
                ALUSrcA_Var := '1'; 
	       when MultDone => 
	           --write partial products until done signal is flagged 
	           HiRegEn_Var := '1'; 
	           LoRegEn_Var := '1';
	       when MoveDone => 
	           --set the MemtoReg signal according to whether instr is MFHI or MFLO 
	           RegDst_Var := '1'; --instr 15-11
	           RegWrite_Var := '1'; --write to reg file 
               --if MFHI 
	           if(Opcode = "000000") AND (Funct = "010000") then
	               MemtoReg_Var := "011"; --select 3 on the mux feeding the reg file 
               --elsif MFLO
               elsif(Opcode = "000000") AND (Funct = "010010") then
                   MemtoReg_Var := "100"; --select 4 on the mux feeding the reg file   
               end if; 
           when others =>
             --do nothing   
          end case;  
          --now you need to assign all the variables to signals: 
           PCWriteCond <= PCWriteCond_Var;
           PCWrite <= PCWrite_Var;
           IorD <= IorD_Var;
           MemWrite <= MemWrite_Var;
           MemtoReg <= MemtoReg_Var;
           IRWrite <= IRWrite_Var;
           PCSource <= PCSource_Var;
           ALUOp <= ALUOp_Var;
           ALUSrcB <= ALUSrcB_Var;
           BEnable <= BEnable_Var; 
           ALUSrcA <= ALUSrcA_Var;
           AEnable <= AEnable_Var; 
           RegWrite <= RegWrite_Var;
           RegDst <= RegDst_Var;
           SLLV <= SLLV_Var;
           Shift_En <= Shift_En_Var; 
           SignExt <= SignExt_Var;
           NotGate <= NotGate_Var; 
           HiRegEn <= HiRegEn_Var; 
           LoRegEn <= LoRegEn_Var; 
           MultReset <= MultReset_Var; 
           LoadType <= LoadType_Var;
    end process; 
end Behavioral;
