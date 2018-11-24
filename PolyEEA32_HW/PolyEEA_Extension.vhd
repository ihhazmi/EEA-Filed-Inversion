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
entity Ext_Poly is
    Generic (n: integer:= 32);
    Port ( a, r, q : in  STD_LOGIC_VECTOR (n-1 downto 0);
           Sel, En : in  STD_LOGIC;
           clock, reset, Start : in  STD_LOGIC;
           a_inv : out  STD_LOGIC_VECTOR (n-1 downto 0));
end Ext_Poly;

architecture Structural of Ext_Poly is
--Signal Sel_f,  Sel_a, En_a, fga, r0 : STD_LOGIC; -- r_RegEn = GN! 
Signal g1, g1_mux, g2, g2_mul, g2_xor, g2_mux: STD_LOGIC_VECTOR(n-1 downto 0);
begin
-- MUXs
MUX_g1: entity work.MUX2 Generic Map (32) Port Map (x"00000000", g2, Sel, g1_mux);
MUX_g2: entity work.MUX2 Generic Map (32) Port Map (x"00000001", g2_xor, Sel, g2_mux);
-- Registers 
Reg_g1: entity work.RegN Generic Map (32) Port Map (clock, reset, En, g1_mux, g1);
Reg_g2: entity work.RegN Generic Map (32) Port Map (clock, reset, En, g2_mux, g2);
--Multiplier
Mul_g: entity work.PolyMul Generic Map (32) Port Map (q, g2, g2_mul);
-- XOR
g2_xor <= g1 xor g2_mul;
a_inv <= g2;
end Structural;

--MUX_u: entity work.MUX2 Generic Map (32) Port Map (a, u_xor, Sel, u_mux);
--Reg_u: entity work.RegN Generic Map (32) Port Map (clock, reset, En, u_mux, u);
--Mul_u: entity work.PolyMul Generic Map (32) Port Map (q, u, u_mul);
-- u_xor  <= r xor u_mul;