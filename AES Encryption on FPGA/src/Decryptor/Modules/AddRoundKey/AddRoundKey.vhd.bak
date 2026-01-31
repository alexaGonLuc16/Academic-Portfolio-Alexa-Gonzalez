-- Company:          ITESM - CQ
-- Engineer:       Alexa Jimena González Lucio
-- 				  	 Brisa Itzel Reyes Castro 
-- Create Date:    20/April/2024 
-- Design Name: 
-- Module Name:    Add Round Key - Decryption
-- Project Name: 	 AES VHDL implementation
-- Target Devices: 
-- Tool versions: 
-- Description: This module gets the after mixingColumns matrix block 
--            	 using a state machine.
-- Dependencies: Cyphered key 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

-- Library and packages declaration section
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Entity Section
entity AddRoundKey is
  Port (Clk     : in     std_logic;
		  Start   : in     std_logic := '0'; -- Start flag
        Finish  : out    std_logic := '0'; -- End flag
		  DataIn  : in     std_logic_vector (127 downto 0);  -- ciphered text
		  DataOut : out    std_logic_vector (127 downto 0)); -- After mixColumns matrix block		  
end AddRoundKey;

-- Section 3: Define the contents of your entity
architecture InvAddRoundKey_Arch of AddRoundKey is
	-- states definition
	type state_values is (S0, S1);
	signal next_state, present_state : state_values;
	
	-- Signals used by the Frequency divider
   constant Fosc      : integer := 50_000_000;     -- Oscillator Frequency for the DE10-Lite board
   constant Fdiv      : integer := 50_000_000;     -- Desired Timebase Frequency
   constant CtaMax    : integer := Fosc / Fdiv;    -- Maximum count to obtain desired outputfreq
   signal   Cont      : integer range 0 to CtaMax; -- Define the counter
   signal   Timebase  : std_logic; 					   -- Flag used to indicate that timebase has ellapsed
	
	--Uncomment this section for InvAddRoundKey_tb1
--	signal   Key       : std_logic_vector (127 downto 0):= "11010000" & "11001001" & "11100001" & "10110000" &
--																			 "00010100" & "11101110" & "00111111" & "01100011" &
--																	       "11111001" & "00100101" & "00001100" & "00001100" &
--																	   	 "10101000" & "10001001" & "11001000" & "10100110";

	--Uncomment this section for InvAddRoundKey_tb2
--	signal   Key       : std_logic_vector (127 downto 0):= "10101100" & "00011001" & "00101000" & "01010111" &
--																			 "01110111" & "11111010" & "11010001" & "01011100" &
--																			 "01100110" & "11011100" & "00101001" & "00000000" & 
--																			 "11110011" & "00100001" & "01000001" & "01101110";
	--Uncomment this section for InvAddRoundKey_tb3
	signal   Key       : std_logic_vector (127 downto 0):= "11101010" & "10110101" & "00110001" & "01111111" &
																			 "11010010" & "10001101" & "00101011" & "10001101" &
																			 "01110011" & "10111010" & "11110101" & "00101001" &
																			 "00100001" & "11010010" & "01100000" & "00101111";

	begin
		-- Frequency divider process to obtain a Timebase signal used by the FSM
		FreqDiv: process(Clk)
		begin
			if (rising_edge(Clk)) then
				if Cont = CtaMax - 1 then
					Cont     <= 0;
					Timebase <= '1';
				else 
					Cont	   <= Cont + 1;
					Timebase <= '0';
				end if;
				
			end if;
		end process FreqDiv;
		
		--process to hold each cicle
		process(Clk)
		begin
			if rising_edge(Clk) and Timebase = '1' then
					present_state <= next_state;	
			end if;
		end process;
		
--		Define the Next-State Logic Process
--		Will obtain the next state based on the inputs and current state
		FSM: process(present_state,Start, Clk)
		begin
			if rising_edge(Clk) then
			 case present_state is
				when S0 =>
					if Start = '1' then
						next_state <= S1;
					else
						next_state <= S0;
					end if;
				when S1 =>
					next_state <= S1;
				when others  =>
					next_state <= S0;	
			 end case;
			end if;
		end process FSM;
	
		-- If implementing a Moore Machine use the following process
		-- The output of a Moore Machine is determined by the present_state only
		output: process (present_state,Start)
		begin
			case present_state is
				when S0 =>
					DataOut <= (others=>'0');
				when S1 =>
					for i in 0 to 127 loop
						if Key(i) = '0' then
							DataOut(i) <= DataIn(i);
						else
							if DataIn(i) = '1' then
								DataOut(i) <= '0';
							else
								DataOut(i) <= '1';
							end if;
						end if;
					end loop;
					Finish <= '1';
				when others =>
					DataOut <= (others => '0');
			end case;
		end process output;
		
end InvAddRoundKey_Arch;