----------------------------------------------------------------------------------
-- Company: UVIC
-- Engineer: Ibrahim Hazmi
---- Create Date:    00:58:53 07/28/2015 
-- Module Name:    PolyGCD - Behavioral 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;
entity PolyEEA is
    Generic (n: integer:= 32);
    Port ( ax : in  STD_LOGIC_VECTOR (n-1 downto 0);
           fx : in  STD_LOGIC_VECTOR (n-1 downto 0);
           clock : in  STD_LOGIC;
           reset, Start : in  STD_LOGIC;
           GCD : out  STD_LOGIC_VECTOR (n-1 downto 0);
           a_inv : out  STD_LOGIC_VECTOR (n-1 downto 0);
			  Finish : out  STD_LOGIC);
end PolyEEA;

architecture Structural of PolyEEA is
Signal Sel_f,  Sel_a, En_a, fgea, a_deg0, dfr0, r0, Sel_Ext, En_Ext : STD_LOGIC; -- r_RegEn = GN! 
Signal ax_mux, a, f, r, q: STD_LOGIC_VECTOR(n-1 downto 0);
begin
-- GCD Block:
-- MUXs
MUX_fx: entity work.MUX2 Generic Map (32) Port Map (fx, a, Sel_a, f);
MUX_ax: entity work.MUX2 Generic Map (32) Port Map (ax, r, Sel_a, ax_mux);
-- reg_a 
Reg_a: entity work.RegN Generic Map (32) Port Map (clock, reset, En_a, ax_mux, a);
--PolyDiv
Div_P: entity work.PolyDiv Generic Map (32) Port Map (a, f, clock, reset, Start, Sel_f, r, q, fgea, a_deg0, dfr0);
-- remainder = 0
r0 <= r(7) or r (6) or r(5) or r (4) or r(3) or r (2) or r(1) or r (0);

--Poly Extension Block:(Extended Eucleadian)
Ext_P: entity work.Ext_Poly Generic Map (32) Port Map (ax, r, q,  Sel_Ext, En_Ext, clock, reset, Start, a_inv); -- En_a/fga

-- FSM Contrller
FSM_0: entity work.Poly_FSM Port Map (clock, reset, Start, fgea, a_deg0, dfr0, r0, En_a, Sel_a, Sel_f, En_Ext, Sel_Ext, Finish);
GCD <= a;

end Structural;