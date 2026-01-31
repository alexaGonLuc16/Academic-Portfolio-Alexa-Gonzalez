---------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Karina Maldonado 
-- 
-- Create Date:    29/04/2024 
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
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity StateMachine is
  port (
	 Rst    							: in  STD_LOGIC;
    Clk    							: in  STD_LOGIC;
	 MuxSel 							: out STD_LOGIC;
	 
	 
	 Start_AddRound0		 		: out STD_LOGIC;	
	 Start_SubBytes_loop		 	: out STD_LOGIC;	
	 Start_ShiftRow_loop		 	: out STD_LOGIC;	
	 Start_MixColumns_loop	 	: out STD_LOGIC;	
	 Start_AddRoundKey_loop 	: out STD_LOGIC;	
	 Start_SubBytes_final    	: out STD_LOGIC;	
	 Start_ShiftRow_final    	: out STD_LOGIC;	
	 Start_AddRoundKey_final 	: out STD_LOGIC;
	 Start_Key						: out STD_LOGIC;

	 
	 Finish_AddRound0		      : in  STD_LOGIC;
	 Finish_SubBytes_loop		: in  STD_LOGIC;
	 Finish_ShiftRow_loop		: in  STD_LOGIC;
	 Finish_MixColumns_loop		: in  STD_LOGIC;
	 Finish_AddRoundKey_loop 	: in  STD_LOGIC;
	 Finish_SubBytes_final 	   : in  STD_LOGIC; 
	 Finish_ShiftRow_final 	   : in  STD_LOGIC;
	 Finish_AddRoundKey_final 	: in  STD_LOGIC;
	 Finish_Key						: in  STD_LOGIC;
	 
	 Key_Sel							: out integer := 0 
	 );

end StateMachine;




architecture StateMachine_Arch of StateMachine is

	-- states definition
	type state_values is (St_KeySchedule,St_AddRound0,St_SubBytes_loop,St_ShiftRows_loop, St_MixColumns_loop,St_AddRoundKey_loop,St_SubBytes_final,St_ShiftRows_final,St_AddRoundKey_final,St_Finish);
	signal next_state, present_state : state_values;
	signal Count : integer := 0; 

						
begin

	-- hold each cicle
		Hold_cicle: process(Rst, Clk)
		begin
			-- Syncronous Reset
			if Rst = '1' then --rst = 1 = true 
				present_state <= St_AddRound0;
			elsif rising_edge(Clk) then
				present_state <= next_state;	
			end if;
		end process Hold_cicle;
		
		-- Define the Next-State Logic Process
		-- Will obtain the next state based on the inputs and current state
		FSM: process(present_state)
		begin
			case present_state is
					when St_KeySchedule =>
						if Finish_Key ='1' then
							next_state <= St_AddRound0;
						else
							next_state <= St_KeySchedule;
					end if;
					
					when St_AddRound0 =>
						if Finish_AddRound0 ='1' then
							next_state <= St_SubBytes_loop;
						else
							next_state <= St_AddRound0;
					end if;
					
					when St_SubBytes_loop =>
						if Finish_SubBytes_loop ='1' then
							next_state <= St_ShiftRows_loop;
						else
							next_state <= St_SubBytes_loop;
						end if;
							
					when  St_ShiftRows_loop =>
						if Finish_ShiftRow_loop ='1' then
							next_state <= St_MixColumns_loop;
						else
							next_state <= St_ShiftRows_loop;
						end if;
							
					when  St_MixColumns_loop =>
						if Finish_MixColumns_loop ='1' then
							next_state <= St_AddRoundKey_loop;
						else
							next_state <= St_MixColumns_loop;
						end if;

					when  St_AddRoundKey_loop =>
						if ((Finish_AddRoundKey_loop ='1') and (Count = 10)) then
							next_state <= St_SubBytes_final;
						elsif  ((Finish_AddRoundKey_loop ='1') and (Count < 10)) then
							next_state <= St_SubBytes_loop;
							Count <= (Count + 1); 
						else 
							next_state <= St_AddRoundKey_loop;
						end if;
										
					when  St_SubBytes_final =>
						if Finish_SubBytes_final ='1' then
							next_state <= St_ShiftRows_final;
						else
							next_state <= St_SubBytes_final;
						end if;
							
					when  St_ShiftRows_final =>
						if Finish_ShiftRow_final ='1' then
							next_state <= St_AddRoundKey_final;
						else
							next_state <= St_ShiftRows_final;
						end if;
								
					when  St_AddRoundKey_final =>
						if Finish_AddRoundKey_final ='1' then
							next_state <= St_Finish;
						else
							next_state <= St_AddRoundKey_final;
						end if;
					
					when St_Finish =>
						if  Finish_AddRoundKey_final = '1' then 
							next_state <= St_AddRound0;
						else
							next_state <= St_Finish;
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
			
				when St_KeySchedule =>
					Start_Key <='1';

				when St_AddRound0 =>
					Start_AddRound0 <='1';
					Key_Sel <= 0;
					MuxSel  <= '1';	
					
				when St_SubBytes_loop =>
					Start_SubBytes_loop <= '1';

				when  St_ShiftRows_loop=>
					Start_ShiftRow_loop <= '1';

				when  St_MixColumns_loop=>
					 Start_MixColumns_loop <= '1';
				
				when  St_AddRoundKey_loop=>
					 Start_AddRoundKey_loop <= '1';
					 Key_Sel <= Count;
					 MuxSel  <= '1';	
					
				when  St_SubBytes_final=>
					Start_SubBytes_final <= '1';

				when  St_ShiftRows_final=>
					Start_ShiftRow_final <= '1';
			
				when  St_AddRoundKey_final=>
					 Start_AddRoundKey_final<= '1';
					 Key_Sel <= 10;
					 
			when St_Finish=>
					Start_AddRound0 <= '0';
					Start_SubBytes_loop <= '0';
					Start_ShiftRow_loop <= '0';
					Start_MixColumns_loop <= '0';
				   Start_AddRoundKey_loop <= '0';
					Start_SubBytes_final <= '0';
					Start_ShiftRow_final <= '0';
					Start_AddRoundKey_final<= '0';
					Key_Sel <= 0;
				   MuxSel  <= '0';

				when others =>	
					Start_Key <='1';
				end case;	
				
		end process output;
		
		
end StateMachine_Arch;