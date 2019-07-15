----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:43:27 05/04/2019 
-- Design Name: 
-- Module Name:    snmp_agent - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity snmp_agent is
	port(
		recv_packet : in std_logic;
		send_packet : out std_logic;
		in_packet : in std_logic_vector(274 downto 0);
		out_packet : out std_logic_vector(274 downto 0)
	);
end snmp_agent;

architecture Behavioral of snmp_agent is


begin
	main:process(recv_packet)
		variable snmp_message_sent,snmp_message_received : std_logic_vector(274 downto 0);
		variable latency,throughput,packets_dropped : std_logic_vector(7 downto 0);
	begin
		if(recv_packet='0')then
			send_packet <= '0';
			snmp_message_sent := (others=>'0');
		else 
			snmp_message_received := in_packet;
			--get the values
			latency := "00000001";
			throughput := "00000010";
			packets_dropped := "00000011";
			snmp_message_sent := snmp_message_received;
			snmp_message_sent(105 downto 98) := latency;
			snmp_message_sent(56 downto 49) := throughput;
			snmp_message_sent(7 downto 0) := packets_dropped;
			send_packet <= '1';
		end if;
		out_packet <= snmp_message_sent;
	end process main;

end Behavioral;

