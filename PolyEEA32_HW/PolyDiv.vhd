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
			  fgea, a_deg0, dfr0 : inout  STD_LOGIC);
end PolyDiv;

architecture Behavioral of PolyDiv is

Signal Sel_q, En_q, fga, agr, fgr, dfa0, xor0 : STD_LOGIC; -- rEn = GN! 
Signal a_deg, f_deg, r_deg, dfa, dfr, dar, dar2: STD_LOGIC_VECTOR(7 downto 0); -- d = sub_out
Signal f_xor, f_mux, f_reg, a_adj, q_mux0, q_mux, r, q_reg, q00, q0, q1: STD_LOGIC_VECTOR(n-1 downto 0); -- quotient <= q_reg;

begin
-- Datapath
-- Remainder Computaion Part
MUX_f: entity work.MUX2 Generic Map (32) Port Map (f, f_xor, Sel_f,f_mux);
-- reg_f should be enabled always
Reg_f: entity work.RegN Generic Map (32) Port Map (clock, reset, '1', f_mux, f_reg); -- Always enabled
-- Leading Zero/MSB Set for (f, a, and f xor a)
CLZ_a: entity work.clz Generic Map (32) Port Map (a, a_deg);
CLZ_f: entity work.clz Generic Map (32) Port Map (f_reg, f_deg);
CLZ_x: entity work.clz Generic Map (32) Port Map (f_xor, r_deg); -- f_xor or r?
-- Computing the degree differences for adjusting the divisor (a) and computing the quotient (q)
Sub_d: entity work.SAD Port Map (f_deg, a_deg, fga, dfa); -- clz(a) - clz(f)
Sub_q: entity work.SAD Port Map (f_deg, r_deg, fgr, dfr); -- clz(r) - clz(f); fgr is not used!
Cmp_a: entity work.cmp Generic Map (8) Port Map (a_deg, r_deg, agr); -- clz(r) < clz(a)
-- Aligne the divisor (a) to be in the same degree as the dividend (f) in order to do the right xor:
Adj_a: entity work.bshift Port Map (dfa, a, a_adj); -- a_adj = a << dfa;
f_xor <= a_adj xor f_reg; -- dividend XOR aligned divisor
-- Remainder Register
Reg_r: entity work.RegN Generic Map (32) Port Map (clock, reset, fgea, f_xor, r);
---
-- Quotient Computaion Part
-- Generating q Select and Enable Signals
dfr0 <= dfr(7) or dfr(6) or dfr(5) or dfr(4) or dfr(3) or dfr(2) or dfr(1) or dfr(0);
dfa0 <= dfa(7) or dfa(6) or dfa(5) or dfa(4) or dfa(3) or dfa(2) or dfa(1) or dfa(0);
xor0 <= f_xor(7) or f_xor(6) or f_xor(5) or f_xor(4) or f_xor(3) or f_xor(2) or f_xor(1) or f_xor(0);
fgea <= fga or not(dfa0);
-- When dar=0, we need Sel_q=0 Sel_q=1 when a>r
Sel_q <= agr or not(xor0);
-- Enable reg_q at S0 and whenever clz(r)-clz(f)>=1, En_q=1, when BDA_Finish=0
En_q <= not (Sel_f) or fga; 
-- q0 = q << (clz(r)-clz(f)) + 1 : clz(r)-clz(f)>=1, clz(r)<=clz(a)
adq_0: entity work.bshift Port Map (dfr, q_reg, q00);
q0 <= q00(n-1 downto 1) & '1';
-- q1 = q << (clz(a)-clz(f)) : clz(r)-clz(f)>=1, clz(r)>clz(a)
adq_1: entity work.bshift Port Map (dfa, q_reg, q1);
-- clz(r)<=clz(a) vs clz(r)>clz(a) is the Sel signal
MUX_q: entity work.MUX2 Generic Map (32) Port Map (q0, q1, Sel_q, q_mux0);
-- q=1 at S0, in order to assert the 1st one which is necessary for q computaion ,MUX (1,q), S0: Sel=0, S1: Sel=1
MUX_1: entity work.MUX2 Generic Map (32) Port Map (x"00000001", q_mux0, Sel_f, q_mux);
-- Quotient Register
-- clz(r)-clz(f)>=1 is the enable signal (fgr), En_q should enables req_q
Reg_q: entity work.RegN Generic Map (32) Port Map (clock, reset, En_q, q_mux, q_reg);
-- Special Case: When the Divisor (a) is 1, the quotient(q) should be the dividend(f) and the remainder(r) zero
-- If a = 1 then q = f and r = 0, When a_deg = 0, i.e. a=1 
a_deg0 <= a_deg(7) or a_deg(6) or a_deg(5) or a_deg(4) or a_deg(3) or a_deg(2) or a_deg(1) or a_deg(0);
MUX_ra1: entity work.MUX2 Generic Map (32) Port Map (x"00000000", r, a_deg0, remainder);
MUX_qa1: entity work.MUX2 Generic Map (32) Port Map (f, q_reg, a_deg0, quotient);

end Behavioral;

