----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2021 07:19:36 AM
-- Design Name: 
-- Module Name: Multiplier_AM - Behavioral
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Multiplier_AM is
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
end entity;

architecture rtl of Multiplier_AM is
type states is (S0, S1, S2);
signal state : states;
signal A_temp, B_temp : std_logic_vector(WIDTH-1 downto 0);

begin

L1: process(clk, rst)
begin
    if (rst = '1') then
        state <= S0;
    elsif (rising_edge(clk)) then
        case state is
            when S0 =>
                state <= S1;
            when S1 =>
                state <= S2;
            when S2 =>
                state <= S2;
        end case;
    end if;
end process;

L2: process(state)
begin
    case state is
        when S0 =>
            done <= '0';
            R <= (others => '0');
        when S1 =>
            A_temp <= A;
            B_temp <= B;
            done <= '0';
        when S2 =>
            R <= std_logic_vector(unsigned(A_temp) * unsigned(B_temp));
            done <= '1';
    end case;
end process;

end architecture;