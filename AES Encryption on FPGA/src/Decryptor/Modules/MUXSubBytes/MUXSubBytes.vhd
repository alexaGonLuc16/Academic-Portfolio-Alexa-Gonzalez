----------------------------------------------------------------------------------
-- Company:				ITESM - IRS 2024
-- Author:           
-- Create Date: 		30/04/2024
-- Design Name: 		MUXSubBytes
-- Module Name:		MUXSubBytes Module
-- Target Devices: 	DE10-Lite
-- Description: 		MUXSubBytes Module
--
-- Version 0.0 - File Creation
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MUXSubBytes is
    Port (
        -- Input ports
        TxtIn : in std_logic_vector(127 downto 0);
        KeyIn : in std_logic_vector(127 downto 0);
		  Clk : in std_logic;
		  Start : in std_logic;
		  Rst : in std_logic;
        -- Output ports
        TxtOut: out std_logic_vector(127 downto 0);
		  Finish : out std_logic);
end MUXSubBytes;

architecture Behavioral of MUXSubBytes is
    -- Internal signals
	 -- Temporary Variable used for the transformation
    shared variable InternalData : std_logic_vector(127 downto 0);
	 
	 -- FSM signals
  type state_values is (St0,St1,St2);
  signal next_state, present_state : state_values;

begin

	-- Section 1: Communications with the Master FSM
	-- State Register Process
	-- Holds the current state of the FSM
	statereg: process (Clk, Rst)
	begin
    -- Asynchronous Rst
    if Rst = '1' then
       present_state <= St0;
     elsif rising_edge(Clk) then
       present_state <= next_state;
     end if;
  end process statereg;
  
  -- Define the Next-State Logic Process
  -- Will obtain the next state based on the inputs and current state
  fsm: process (present_state, Start)
  begin
    case present_state is
      when St0 => 
          if Start = '0' then
            next_state <= St0;
          else
            next_state <= St1; 
          end if;
      when St1 =>
            next_state <= St2;
      when St2 =>
          if Start = '0' then
            next_state <= St0;
          else
            next_state <= St2; 
          end if;
      when others =>
            next_state <= St0;
     end case;
  end process fsm;
  
  -- The output of a Moore Machine is determined by the present_state only
  output: process (present_state)
  begin
    case present_state is
       when St0 =>
          Finish <= '0';
       when St1 =>
          Finish <= '0';
       when St2 =>
          Finish <= '1';
      when others =>
          Finish <= '0';
    end case;
  end process output;
	
	
	-- Process for AddRoundKeys operation

	operation : process(Clk, present_state)
	begin
		if (rising_edge(Clk) and present_state = St1) then
	 
		-- XOR operation between TxtIn and KeyIn, store result in InternalData
		InternalData := TxtIn xor KeyIn;
		end if;
		-- Sent transformation to the output.
		TxtOut <= InternalData;
	end process operation;

end architecture Behavioral;