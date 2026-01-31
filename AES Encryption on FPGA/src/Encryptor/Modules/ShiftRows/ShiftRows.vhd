----------------------------------------------------------------------------------
-- Company:          ITESM - IRS 2024
-- Author:           Tomás Pérez Vera, Ulises Orlando Carrizalez Lerín
-- Create Date:      21/04/2024
-- Design Name:      ShiftRow
-- Module Name:      ShiftRow Component
-- Target Devices:   DE10-Lite
-- Description:      hiftRow Component for the AES Encryptor
--
-- Version 3.0 - File Creation
---------------------------------------------------------------------------------

-- Commonly used libraries
library ieee; 
use ieee.std_logic_1164.all;
-- Packages use for arithmetic operations
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity delcaration
entity ShiftRows is
    Port (
        Clk    : in  std_logic;
        Rst    : in  std_logic;
        Start : in  std_logic; -- Signal from the Master FSM, when '1' transformation begins 
        Finish : out std_logic; -- Signal to the Master FSM, when '1' transformation is finished
        TxtIn : in  std_logic_vector(127 downto 0); 
        TxtOut: out std_logic_vector(127 downto 0)
    );
end entity ShiftRows;

--Architecture
architecture Behavioural of ShiftRows is  
  
  -- Temporary Variable used for the transformation
  shared variable DataOut_tmp: std_logic_vector(127 downto 0);
  
  -- FSM signals
  type state_values is (St0,St1,St2);
  signal next_state, present_state : state_values;

begin
  -- Section 1: Communications with the Master FSM
  -- State Register Process
  -- Holds the current state of the FSM
  statereg: process (Clk, Rst)
  begin
    -- Asynchronous Reset
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
  
  -- Section 1: End
  
  -- Section 2: Perform the ShiftRows transformation
  transformation: process (clk, present_state)
  begin
    if (rising_edge(Clk) and present_state = St1) then
        DataOut_tmp(127 downto 96) := TxtIn(127 downto 96); 
        DataOut_tmp( 95 downto 64) := TxtIn( 87 downto 64) & TxtIn(95 downto 88);
        DataOut_tmp( 63 downto 32) := TxtIn( 47 downto 32) & TxtIn(63 downto 48);
        DataOut_tmp( 31 downto  0) := TxtIn(  7 downto  0) & TxtIn(31 downto  8);
     end if;
     -- Sent transformation to the output.
     TxtOut <= DataOut_tmp;
  end process transformation;
  --Section 2: END

end architecture Behavioural;