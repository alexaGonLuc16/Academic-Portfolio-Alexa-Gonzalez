---------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 José Angel Huerta
--						 Fiona Stasi Fernandez
--    				 Tomas Perez Vera
-- 
-- Create Date:    13:12:06 27/04/2024 
-- Design Name: 
-- Module Name:    State Machine
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.04 - FSM of decrypt
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DE_StateMachine is
  port (
	 Rst    							: in  STD_LOGIC;
    Clk    							: in  STD_LOGIC;
	 Enable							: in	STD_LOGIC;
	 MuxSel 							: out STD_LOGIC;
	 
	 
	 Start_DEAddRoundKey0		 	: out STD_LOGIC;	
	 Start_DESubBytes_loop		 	: out STD_LOGIC;	
	 Start_DEShiftRows_loop		 	: out STD_LOGIC;	
	 Start_DEMixColumns_loop	 	: out STD_LOGIC;	
	 Start_DEAddRoundKey_loop 		: out STD_LOGIC;	
	 Start_DESubBytes_final    	: out STD_LOGIC;	
	 Start_DEShiftRows_final    	: out STD_LOGIC;	
	 Start_DEAddRoundKey_final 	: out STD_LOGIC;
	 Start_Key							: out STD_LOGIC;

	 
	 Finish_DEAddRoundKey0		   : in  STD_LOGIC;
	 Finish_DESubBytes_loop			: in  STD_LOGIC;
	 Finish_DEShiftRows_loop		: in  STD_LOGIC;
	 Finish_DEMixColumns_loop		: in  STD_LOGIC;
	 Finish_DEAddRoundKey_loop 	: in  STD_LOGIC;
	 Finish_DESubBytes_final 	   : in  STD_LOGIC; 
	 Finish_DEShiftRows_final 	   : in  STD_LOGIC;
	 Finish_DEAddRoundKey_final 	: in  STD_LOGIC;
	 Finish_Key							: in  STD_LOGIC;
	 
	 Key_Sel							: out integer := 0 
	 );

end DE_StateMachine;




architecture DE_StateMachine_Arch of DE_StateMachine is

	-- states definition
	type state_values is (St_Off,St_KeySchedule,St_DEAddRoundKey0,St_DESubBytes_loop,St_DEShiftRows_loop, St_DEMixColumns_loop,St_DEAddRoundKey_loop,St_DESubBytes_final,St_DEShiftRows_final,St_DEAddRoundKey_final,St_Finish);
	signal next_state, present_state : state_values;
	signal Count : integer := 0; 

						
begin

	-- hold each cicle
		Hold_cicle: process(Rst, Clk)
		begin
			-- Syncronous Reset
			if Rst = '1' then --rst = 1 = true 
				present_state <= St_DEAddRoundKey0;
			elsif rising_edge(Clk) then
				present_state <= next_state;	
			end if;
		end process Hold_cicle;
		
		-- Define the Next-State Logic Process
		-- Will obtain the next state based on the inputs and current state
		FSM: process(present_state)
		begin
			case present_state is

				when St_Off =>
						if Enable ='1' then
							next_state <= St_DEAddRoundKey_final;
						else
							next_state <= St_Off;
					end if;
					
					when St_DEAddRoundKey_final =>
						if Finish_DEAddRoundKey_final ='1' then
							next_state <= St_DEShiftRows_final;
						else
							next_state <= St_DEAddRoundKey0;
					end if;
					
					when St_DEShiftRows_final =>
						if Finish_DEShiftRows_final ='1' then
							next_state <= St_DESubBytes_final;
						else
							next_state <= St_DEShiftRows_final;
						end if;
							
					when  St_DESubBytes_final =>
						if Finish_DESubBytes_final ='1' then
							next_state <= St_DEAddRoundKey_loop;
						else
							next_state <= St_DESubBytes_final;
						end if;
							
					when  St_DEAddRoundKey_loop =>
						if Finish_DEAddRoundKey_loop ='1' then
							next_state <= St_DEMixColumns_loop;
						else
							next_state <= St_DEAddRoundKey_loop;
						end if;
						
					when  St_DEMixColumns_loop =>
						if Finish_DEMixColumns_loop ='1' then
							next_state <= St_DEShiftRows_loop;
						else
							next_state <= St_DEMixColumns_loop;
						end if;
						
					when  St_DEShiftRows_loop =>
						if Finish_DEShiftRows_loop ='1' then
							next_state <= St_DESubBytes_loop;
						else
							next_state <= St_DEShiftRows_loop;
						end if;
						
					when  St_DESubBytes_loop =>
						if ((Finish_DESubBytes_loop ='1') and (Count = 1)) then
							next_state <= St_DEAddRoundKey0;
						elsif  ((Finish_DESubBytes_loop ='1') and (Count > 1)) then
							next_state <= St_DEAddRoundKey_loop;
							Count <= (Count - 1); 
						else 
							next_state <= St_DESubBytes_loop;
						end if;
										
								
					when  St_DEAddRoundKey0 =>
						if Finish_DEAddRoundKey0 ='1' then
							next_state <= St_Finish;
						else
							next_state <= St_DEAddRoundKey0;
						end if;
								
					when others =>
						next_state <= St_KeySchedule;

			end case;	
		end process FSM;
		
		-- If implementing a Moore Machine use the following process
		-- The output of a Moore Machine is determined by the present_state only
		output: process (present_state)
		begin
			case present_state is
			
--				when St_KeySchedule =>
--					Start_Key <='1';

				when St_DEAddRoundKey0 =>
					Start_DEAddRoundKey0 <='1';
					Key_Sel <= 0;
					MuxSel  <= '1';	
					
				when St_DESubBytes_loop =>
					Start_DESubBytes_loop <= '1';

				when  St_DEShiftRows_loop=>
					Start_DEShiftRows_loop <= '1';

				when  St_DEMixColumns_loop=>
					 Start_DEMixColumns_loop <= '1';
				
				when  St_DEAddRoundKey_loop=>
					 Start_DEAddRoundKey_loop <= '1';
					 Key_Sel <= Count;
					 MuxSel  <= '1';	
					
				when  St_DESubBytes_final=>
					Start_DESubBytes_final <= '1';

				when  St_DEShiftRows_final=>
					Start_DEShiftRows_final <= '1';
			
				when  St_DEAddRoundKey_final=>
					 Start_DEAddRoundKey_final<= '1';
					 Key_Sel <= 10;
					 
--			when St_Finish=>
----				Start_Finish <= '0';
--					Start_DEAddRoundKey0 <= '0';
--					Start_DESubBytes_loop <= '0';
--					Start_DEShiftRows_loop <= '0';
--					Start_DEMixColumns_loop <= '0';
--				   Start_DEAddRoundKey_loop <= '0';
--					Start_DESubBytes_final <= '0';
--					Start_DEShiftRows_final <= '0';
--					Start_DEAddRoundKey_final<= '0';
--					KeySel <= "0000";
--				   MuxSel  <= '0';

				when others =>	
					Start_Key <='1';
				end case;	
				
		end process output;
		
		
end DE_StateMachine_Arch;