----------------------------------------------------------------------------------
-- Company:  UNIVERSITY OF VICTORIA - Dept. of Electrical & Computer Engineering.
-- Engineer: Ibrahim Hazmi - ihaz@ece.uvic.ca
-- 
-- Create Date:    06:51:08 19/10/2014
-- Design Name:	 ModN_bit
-- Module Name:    FSM - behav. 
-- Project Name:   GCD_Nbit  Implementation.
-- Target Devices: SPARTAN6 - XC6SLX45T
-- Tool versions:  ISE 13.4
-- Description: 	 Modular FSM.
-- Dependencies:   N/A
-- Revision:       0
-- Revision 0.01 - File Created
-- Additional Comments: N/A
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Sel_f (MUX_f Select Signal)
ENTITY Poly_FSM IS
	PORT(
					clk, Reset, Start, fgea, a_deg0, dfr0, r0	: IN  		STD_LOGIC;
					En_a, Sel_a, Sel_f, En_Ext, Sel_Ext, Finish	: OUT   		STD_LOGIC
				);
END Poly_FSM;

ARCHITECTURE behav OF Poly_FSM IS

TYPE StateType IS (S0, S1, S2); -- S2

SIGNAL CurrentState	: StateType; -- C_S
SIGNAL NextState		: StateType; -- N_S

BEGIN
	
	C_S: PROCESS (clk, Reset)
	BEGIN
	
	IF (Reset = '1') THEN		
		CurrentState 	<= 	S0;			
		ELSIF (clk'event and clk='1') THEN
			CurrentState 	<= 	NextState;			
	END IF;
		
	END PROCESS C_S;
	
	
	N_S: PROCESS (CurrentState, Start, fgea, a_deg0, dfr0, r0)
	
	BEGIN
		
--	Finish <= '0';
--	Sel_a	<= '0';
--	Sel_f	<= '0';
--	En_a	<= '0';
	CASE CurrentState IS
			
			WHEN S0 =>
				Finish <= '0';
				Sel_a	<= '0';
				Sel_f	<= '0';
				Sel_Ext	<= '0';
				En_a	<= '1';
				En_Ext	<= '1';
				IF (Start = '1') THEN					
					NextState 	<= S1;
				ELSE 	
					NextState 	<= S0;
				END IF;				

			WHEN S1 =>
				Sel_f	<= '1';
				Sel_Ext	<= '1';
				En_a	<= '0';
				En_Ext	<= '0';
				IF (r0 = '0' AND (dfr0 = '0'  OR a_deg0 = '0')) THEN
					Finish <= '1';
					NextState 	<= S0;
				ELSE
					Finish <= '0';
					IF (fgea = '0' OR dfr0 = '0'  OR a_deg0 = '0') THEN
						NextState 	<= S2;
					ELSE 	
						NextState 	<= S1;
					END IF;						
				END IF;						


			WHEN S2 => -- a=r, f=a
				Sel_a	<= '1';
				Sel_f	<= '0';
				Sel_Ext	<= '1';
				En_a	<= '1';
				En_Ext	<= '1';
				IF (r0 = '0' AND (dfr0 = '0'  OR a_deg0 = '0')) THEN
					Finish <= '1';
					NextState 	<= S0;
				ELSE
					Finish <= '0';
					NextState 	<= S1;
				END IF;						
--				
		-- Default Case	
			WHEN OTHERS =>
				Finish <= '0';
				Sel_a	<= '0';
				Sel_f	<= '0';
				En_a	<= '0';
				NextState 		<= S0;	
		END CASE;
		
	END PROCESS N_S;

END behav;


--			WHEN S1 =>
--				IF (fga = '1') THEN
--					Finish <= '0';
--					En_a	<= '0';
--					Sel_f	<= '1';
--					NextState 	<= S1;
--				ELSE 	
--					En_a	<= '1';
--					Sel_f	<= '0';
--					IF (r0 = '1') THEN
--						Finish <= '0';
--						Sel_a	<= '1';
--						NextState 	<= S1;
--					ELSE 	
--						Finish <= '1';
--						Sel_a	<= '0';
--						NextState 	<= S0;
--					END IF;						
--				END IF;						
