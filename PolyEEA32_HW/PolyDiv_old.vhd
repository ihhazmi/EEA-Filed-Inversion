----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:59:29 07/08/2015 
-- Design Name: 
-- Module Name:    PolyGCD - Behavioral 
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
Library UNISIM;
use UNISIM.vcomponents.all;
use IEEE.NUMERIC_STD.ALL;

entity PolyDiv is
    Generic (n: integer:= 32);
    Port ( a : in  STD_LOGIC_VECTOR (n-1 downto 0);
           f : in  STD_LOGIC_VECTOR (n-1 downto 0);
           clock, reset, Start : in  STD_LOGIC;
           Sel_f : in  STD_LOGIC;
           remainder : out  STD_LOGIC_VECTOR (n-1 downto 0);
           quotient : out  STD_LOGIC_VECTOR (n-1 downto 0);
			  fga, a_deg0 : inout  STD_LOGIC);
end PolyDiv;

architecture Behavioral of PolyDiv is

Signal GN, Sh_q, Sel_q, En_q, agr, dra0, dfa0, r_deg0 : STD_LOGIC; -- r_RegEn = GN! 
Signal a_deg, f_deg, r_deg, dfa, dfr, dra, dra2: STD_LOGIC_VECTOR(7 downto 0); -- d = sub_out
Signal f_xor, f_mux, f_reg, a_adj, q_mux0, q_mux, r_reg, q_reg, q00, q0, q01, q1: STD_LOGIC_VECTOR(n-1 downto 0); -- quotient <= q_reg;

begin
-- Sel_f<='0'; -- FSM state zero (internal state for BDA: Binary Division Algorithm)
-- Datapath
MUX_f: entity work.MUX2 Generic Map (32) Port Map (f, f_xor, Sel_f,f_mux);
-- reg_f should be enabled always
Reg_f: entity work.RegN Generic Map (32) Port Map (clock, reset, '1', f_mux, f_reg); -- Always enabled
---
CLZ_a: entity work.clz Generic Map (32) Port Map (a, a_deg);
CLZ_f: entity work.clz Generic Map (32) Port Map (f_reg, f_deg);
CLZ_r: entity work.clz Generic Map (32) Port Map (f_xor, r_deg); -- f_xor or r_reg?
---
Sub_d: entity work.CLASUB Port Map (f_deg, a_deg, fga, dfa); -- clz(a) - clz(f)
Sub_q: entity work.CLASUB Port Map (f_deg, r_deg, Sh_q, dfr); -- clz(r) - clz(f)
Sub_a: entity work.CLASUB Port Map (a_deg, r_deg, agr, dra); -- clz(r) - clz(a)
---
Adj_a: entity work.bshift Port Map (dfa, a, a_adj); -- a_adj = a << dfa;
---
f_xor <= a_adj xor f_reg; --XOR
---
Reg_r: entity work.RegN Generic Map (32) Port Map (clock, reset, fga, f_xor, r_reg);
---
-- When dra=0, we need Sel_q=0
dra0 <= dra(7) or dra(6) or dra(5) or dra(4) or dra(3) or dra(2) or dra(1) or dra(0);
Sel_q <= agr and dra0;
-- When dfa=0, we need GN=0;
dfa0 <= dfa(7) or dfa(6) or dfa(5) or dfa(4) or dfa(3) or dfa(2) or dfa(1) or dfa(0);
GN <= fga and dfa0;

-- Enable reg_q at S0 and whenever clz(r)-clz(f)>=1 
En_q <= not (Sel_f) or (Sh_q and (GN or not(Sel_q)));
-- En_q <= Sel_f nand (not(Sh_q) or (GN and Sel_q));

-- When r_deg = 0, Shift q only one bit to finalize the result, it was a problem when q should be 2 
r_deg0 <= r_deg(7) or r_deg(6) or r_deg(5) or r_deg(4) or r_deg(3) or r_deg(2) or r_deg(1) or r_deg(0);
--MUX_2: entity work.MUX2 Generic Map (8) Port Map (x"00", dra, r_deg0, dra2);
process(dra, r_deg0) -- Instead of MUX2 just AND dra with r_deg0 signal, if r_deg0=0 do ONE shift only!
begin
	for i in 0 to 7 loop
		dra2(i) <= dra(i) and r_deg0;
	end loop;
end process;
-- q0 = q << (clz(r)-clz(f)) + 1 : clz(r)-clz(f)>=1, clz(r)<=clz(a)
adq_0: entity work.bshift Port Map (dfr, q_reg, q00);
q0 <= q00(n-1 downto 1) & '1';
-- q1 = q << (clz(r)-clz(f)+1) : clz(r)-clz(f)>=1, clz(r)>clz(a)
adq_1: entity work.bshift Port Map (dra2, q_reg, q01);
q1 <= q01(n-2 downto 0) & '0';
-- clz(r)<=clz(a) vs clz(r)>clz(a) is the Sel signal
MUX_q: entity work.MUX2 Generic Map (32) Port Map (q0, q1, Sel_q, q_mux0);
-- q=1 at S0, in order to assert the 1st one which is necessary for q computaion ,MUX (1,q), S0: Sel=0, S1: Sel=1
MUX_1: entity work.MUX2 Generic Map (32) Port Map (x"00000001", q_mux0, Sel_f, q_mux);
-- clz(r)-clz(f)>=1 is the enable signal (Sh_q), En_q should enables req_q
Reg_q: entity work.RegN Generic Map (32) Port Map (clock, reset, En_q, q_mux, q_reg);

-- If a = 1 then q = f and r = 0
-- When a_deg = 0, i.e. a=1 
a_deg0 <= a_deg(7) or a_deg(6) or a_deg(5) or a_deg(4) or a_deg(3) or a_deg(2) or a_deg(1) or a_deg(0);
MUX_ra1: entity work.MUX2 Generic Map (32) Port Map (x"00000000", r_reg, a_deg0, remainder);
MUX_qa1: entity work.MUX2 Generic Map (32) Port Map (f, q_reg, a_deg0, quotient);

---- FSM Contrller
--FSM_0: entity work.Poly_FSM Port Map (clock, reset, Start, fgea, dfr0, a_deg0, Sel_f, Finish);

end Behavioral;
