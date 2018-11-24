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
					clk, Reset, Start, fgea, dfr0, a_deg0	: IN  		STD_LOGIC;
					Sel, Finish		 					: OUT   		STD_LOGIC
				);
END Poly_FSM;

ARCHITECTURE behav OF Poly_FSM IS

TYPE StateType IS (S0, S1); -- S2

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
	
	
	N_S: PROCESS (CurrentState, Start, fgea, dfr0, a_deg0)
	
	BEGIN
		
		CASE CurrentState IS
			
			WHEN S0 =>
				Sel	<= '0';
				IF (Start = '1') THEN					
					IF (a_deg0 = '1') THEN
						Finish <= '0';
						NextState 	<= S1;
					ELSE 	
						Finish <= '1';
						NextState 	<= S0;
					END IF;				
				ELSE 	
					Finish <= '0';
					NextState 	<= S0;
				END IF;				

			WHEN S1 =>
				Sel	<= '1';
				IF (fgea = '0' OR dfr0 = '0') THEN
					Finish <= '1';
					NextState 	<= S0;
				ELSE 	
					Finish <= '0';
					NextState 	<= S1;
				END IF;						
--
--			WHEN S2 =>
--				Sel	<= '1';
--				Finish <= '1';
--				NextState 	<= S0;
----				
		-- Default Case	
			WHEN OTHERS =>
				NextState 		<= S0;	
		END CASE;
		
	END PROCESS N_S;

END behav;