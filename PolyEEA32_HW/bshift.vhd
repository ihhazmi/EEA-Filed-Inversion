-- bshift.vhdl  A barrel shifter for 32 bit words

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

Entity bshift is   -- barrel shifter
      port (shift   : in  std_logic_vector(7 downto 0);  -- shift count
            input   : in  std_logic_vector (31 downto 0);
            output  : out std_logic_vector (31 downto 0) );
end entity bshift;

architecture circuits of bshift is
  signal L1s  : std_logic_vector(31 downto 0);
  signal L2s  : std_logic_vector(31 downto 0);
  signal L4s  : std_logic_vector(31 downto 0);
  signal L8s  : std_logic_vector(31 downto 0);
  signal L16s : std_logic_vector(31 downto 0);
  signal L1   : std_logic_vector(31 downto 0);
  signal L2   : std_logic_vector(31 downto 0);
  signal L4   : std_logic_vector(31 downto 0);
  signal L8   : std_logic_vector(31 downto 0);

begin  -- circuits
  L1w:  L1s <= input(30 downto 0) & '0'; -- just wiring
  L1m:  entity work.mux2 Generic Map (32) port map (in0=>input, in1=>L1s, ctl=>shift(0), result=>L1);
  L2w:  L2s <= L1(29 downto 0) & "00"; -- just wiring
  L2m:  entity work.mux2 Generic Map (32) port map (in0=>L1, in1=>L2s, ctl=>shift(1), result=>L2);
  L4w:  L4s <= L2(27 downto 0) & "0000"; -- just wiring
  L4m:  entity work.mux2 Generic Map (32) port map (in0=>L2, in1=>L4s, ctl=>shift(2), result=>L4);
  L8w:  L8s <= L4(23 downto 0) & "00000000"; -- just wiring
  L8m:  entity work.mux2 Generic Map (32) port map (in0=>L4, in1=>L8s, ctl=>shift(3), result=>L8);
  L16w: L16s <= L8(15 downto 0) & "0000000000000000"; -- just wiring
  L16m: entity work.mux2 Generic Map (32) port map (in0=>L8, in1=>L16s, ctl=>shift(4), result=>output);
end architecture circuits;  -- of bshift




