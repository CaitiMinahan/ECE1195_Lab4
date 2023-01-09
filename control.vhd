library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
    Port ( Blsb : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           count : in STD_LOGIC_VECTOR(4 DOWNTO 0); 
           --output signals connecting the control unit to the enable signals for the other components (to enable each component)
           load : out STD_LOGIC; --tell it to enable/load values of A and B
           prod : out STD_LOGIC; --tell it to enable product register for writing result
           countInc : out STD_LOGIC; --tell it to enable the count register to increase the count by one
           shift : out STD_LOGIC; --tell it to enable the shift registers to shift left/right by one bit
           done : out STD_LOGIC --tell it to enable the done signal and flag it high 
           ); 
end control;

architecture Behavioral of control is
	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2);
	
	-- Register to hold the current state
	signal state : state_type;
	signal nextstate : state_type;
begin
    --section 1: FSM register for Mealy
    process(clk, reset)
    begin
        if reset = '1' then
	       state <= s0;
        elsif (rising_edge(clk)) then
            state <= nextstate;
        end if; 
    end process;
     
    --section 2: next state function for Mealy
	process (state, count)
	begin
      --if reset = '1' then
	--	 state <= s0;
    --  elsif (rising_edge(clk)) then
		case state is
			when s0=>
				nextstate <= s1; --s1 is where we go to do both use ALU and do shifting 
			when s1=>
			  if count = "11111" then
				nextstate <= s2;  --if we've reached 32 repetitions, go to s2 where we write to product reg and signal done flag 
			  else 
				nextstate <=s1; --start another repetition if count<32; repeat shifting until count=32
			  end if; 
			when s2=>
				nextstate <= s2; --stay in s2 bc we are done 
		end case;
	 -- end if; 
	end process;
	
	--I tried combining sections 2 and 3, but it gets hard when you need to test two inputs to assign the state and output 
	
	--section 3: output function 
	-- Determine the output based only on the current state and the input (do not wait for a clock edge)
	process (state, Blsb)
	begin
	--initialize all the signals to zero: 
		case state is
			when s0=>
			    load <= '1'; --load A and B when we're in s0 
			    prod <= '0'; 
	            shift <= '0'; 
	            countInc <= '0'; 
	            done <= '0'; 
			when s1=>
			   if Blsb = '1' then --multiplier0 = 1 
			      prod <= '1'; --write to the product register (R += R + multiplicand) aka adding partial products 
			   else 
			     prod <= '0'; 
			   end if;  
			     --always shift and increase count in s1 
				 shift <= '1'; 
				 countInc <= '1';
				 load <= '0'; --load A and B when we're in s0 
	              done <= '0';  
			when s2=>
			     --in s2 we will just turn the done signal HIGH 
			     done <= '1'; 
			     load <= '0'; 
			     --prod <= '0'; 
			     shift <= '0'; 
			     countInc <= '0'; 
		end case;
	end process;
end Behavioral;

