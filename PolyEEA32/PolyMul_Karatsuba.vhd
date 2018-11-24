----------------------------------------------------------------------------
-- Polynomial Multiplier (Poly_multiplier.vhd)
-- Karatsuba Multiplier
-- Computes the polynomial multiplication 
-- Book: Hardware Implementation of Finite-Field Arithmetic
----------------------------------------------------------------------------
-- The Authors: Jean Pierre Deschamps, José Luis Imaña, and Gustavo D. Sutter
-- The book is published by McGraw Hill, March 2009. ISBN: 978-0-0715-4581-5
-- http://www.arithmetic-circuits.org/finite-field/vhdl_codes.htm
--------------------------------------------------------------
-- polynom_multiplier: Modified (32*32=32)
------------------------------------------------------------
library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PolyMul is
generic (M: integer:= 32);
port (
  a, b: in std_logic_vector(M-1 downto 0);
  d	: out std_logic_vector(M-1 downto 0)
);
end PolyMul;


architecture simple of PolyMul is
  type matrix_ands is array (0 to M-1) of STD_LOGIC_VECTOR(M-1 downto 0);
  signal a_by_b: matrix_ands;
begin

  gen_ands: for k in 0 to M-1 generate
    l1: for i in 0 to k generate
       a_by_b(k)(i) <= A(i) and B(k-i);
    end generate;
  end generate;

  gen_ands2: for k in M to M-1 generate
    l2: for i in k to M-1 generate
       a_by_b(k)(i) <= A(k-i+(M-1)) and B(i-(M-1));
    end generate;
  end generate;

  d(0) <= a_by_b(0)(0);
  gen_xors: for k in 1 to M-1 generate
    l3: process(a_by_b(k)) 
        variable aux: std_logic;
        begin
        if (k < M) then
          aux := a_by_b(k)(0);
          for i in 1 to k loop aux := a_by_b(k)(i) xor aux; end loop;
        else
          aux := a_by_b(k)(k);
          for i in k+1 to M-1 loop aux := a_by_b(k)(i) xor aux; end loop;
        end if;
        d(k) <= aux;
    end process;
  end generate;
end simple;

-- Originally
--architecture simple of polynom_multiplier is
--  type matrix_ands is array (0 to 2*M-2) of STD_LOGIC_VECTOR(2*M-2 downto 0);
--  signal a_by_b: matrix_ands;
--  signal d, c: std_logic_vector(2*M-2 downto 0);
--begin
--
--  gen_ands: for k in 0 to M-1 generate
--    l1: for i in 0 to k generate
--       a_by_b(k)(i) <= A(i) and B(k-i);
--    end generate;
--  end generate;
--
--  gen_ands2: for k in M to 2*M-2 generate
--    l2: for i in k to 2*M-2 generate
--       a_by_b(k)(i) <= A(k-i+(M-1)) and B(i-(M-1));
--    end generate;
--  end generate;
--
--  d(0) <= a_by_b(0)(0);
--  gen_xors: for k in 1 to 2*M-2 generate
--    l3: process(a_by_b(k),c(k)) 
--        variable aux: std_logic;
--        begin
--        if (k < M) then
--          aux := a_by_b(k)(0);
--          for i in 1 to k loop aux := a_by_b(k)(i) xor aux; end loop;
--        else
--          aux := a_by_b(k)(k);
--          for i in k+1 to 2*M-2 loop aux := a_by_b(k)(i) xor aux; end loop;
--        end if;
--        d(k) <= aux;
--    end process;
--  end generate;
--  ab <= d(31 downto 0);
--end simple;

