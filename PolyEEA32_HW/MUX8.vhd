
----------------------------------------------------------------------------------
-- VHDL Module for Mux 8x1   -----------------------------------------------------
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Mux8x1 is
	Generic (n: integer);
	Port (	a : in  STD_LOGIC_VECTOR (n-1 downto 0);
				b : in  STD_LOGIC_VECTOR (n-1 downto 0);
				c : in  STD_LOGIC_VECTOR (n-1 downto 0);
				d : in  STD_LOGIC_VECTOR (n-1 downto 0);
				e : in  STD_LOGIC_VECTOR (n-1 downto 0);
				f : in  STD_LOGIC_VECTOR (n-1 downto 0);
				g : in  STD_LOGIC_VECTOR (n-1 downto 0);
				h : in  STD_LOGIC_VECTOR (n-1 downto 0);
				s : in  STD_LOGIC_VECTOR (2 downto 0);
				o : out  STD_LOGIC_VECTOR (n-1 downto 0));
end Mux8x1;

architecture Behavioral of Mux8x1 is
begin
  process (a, b, c, d,e ,f ,g ,h ,s)
    begin
      case s is
			when "000" => o <= a;
			when "001" => o <= b;
			when "010" => o <= c;
			when "011" => o <= d;
			when "100" => o <= e;
			when "101" => o <= f;
			when "110" => o <= g;
			when "111" => o <= h;
			when others => 
				for i in 0 to n-1 loop
					result(i) <= 'Z';
				end loop;
      end case;
  end process;
end Behavioral;

  -- 1- (x + 1) is a multiplicative inverse of ((x) mod(x^2 + x + 1)) 
  -- 0x:(00000003) is a multiplicative inverse of ((00000002) mod(00000007))
  -- 2- (x^2 + x + 1) is a multiplicative inverse of ((x^2 + 1) mod(x^3 + x^2 + 1))
  -- 0x:(00000007) is a multiplicative inverse of ((00000005) mod(0000000d))
  -- 3- (x^3 + x^2 + x + 1) is a multiplicative inverse of ((x^3 + x^2 + x + 1) mod(x^4 + x^2 + 1))
  -- 0x:(0000000f) is a multiplicative inverse of ((0000000f) mod(00000015))
  -- 4- (x^7 + x^6 + x^3 + x) is a multiplicative inverse of ((x^6 + x^4 + x + 1) mod(x^8 + x^4 + x^3 + x + 1))
  -- 0x:(000000ca) is a multiplicative inverse of ((00000053) mod(0000011b))
