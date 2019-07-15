--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:59:52 05/04/2019
-- Design Name:   
-- Module Name:   /home/manasshukla/Dropbox/academics@iitb/4th sem/cs_226/vhdl/snmp/snmpv3_tb.vhd
-- Project Name:  snmp
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: snmpv3
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY snmpv3_tb IS
END snmpv3_tb;
 
ARCHITECTURE behavior OF snmpv3_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT snmpv3
    PORT(
         service_number : IN  std_logic_vector(2 downto 0);
         clk : IN  std_logic;
         result_out : OUT  std_logic;
         latency : OUT  std_logic_vector(7 downto 0);
         throughput : OUT  std_logic_vector(7 downto 0);
         packets_dropped : OUT  std_logic_vector(7 downto 0);
         cstate : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal service_number : std_logic_vector(2 downto 0) := (others => '0');
   signal clk : std_logic := '0';

 	--Outputs
   signal result_out : std_logic;
   signal latency : std_logic_vector(7 downto 0);
   signal throughput : std_logic_vector(7 downto 0);
   signal packets_dropped : std_logic_vector(7 downto 0);
   signal cstate : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: snmpv3 PORT MAP (
          service_number => service_number,
          clk => clk,
          result_out => result_out,
          latency => latency,
          throughput => throughput,
          packets_dropped => packets_dropped,
          cstate => cstate
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
      service_number <= "001";
		wait for 30 ns;
		
		service_number <= "010";
		wait for 30 ns;
		service_number <= "011";
	
		wait for 30 ns;
		service_number <= "000";


      wait;
   end process;

END;
