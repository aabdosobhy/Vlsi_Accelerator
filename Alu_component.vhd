LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity alu_component is 
	port (Clk,Rst,R_F_Ack,R_I_Ack , en_S,en_P: in std_logic;
		Data_from_cache : in std_logic_vector(7 downto 0);
		result : out std_logic_vector(7 downto 0)
		);

end entity alu_component;


architecture my_alu_component of alu_component is

component my_nadder_noCout IS
       GENERIC (n : integer := 17);
PORT(a,b : IN std_logic_vector(n-1  DOWNTO 0);
             f : OUT std_logic_vector(n-1 DOWNTO 0)
             );
END component;

component my_nDFF_fall IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enb : IN std_logic;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END component;


component mux4 is 
	Generic (m : integer :=16);
port ( s1,s0: in std_logic;
	input1,input2,input3,input4: in std_logic_vector(m-1 downto 0);
	output: out std_logic_vector(m-1 downto 0));
end component;

component mux2_1 IS 
GENERIC ( n : integer := 16); 
		PORT (in1,in2 : IN std_logic_vector(n-1 DOWNTO 0);
                    s	:  IN std_logic;
  		   out1 : OUT std_logic_vector(n-1 DOWNTO 0));    
END component;

signal Alu_out,Out_shift,Alu_shift_one,S_in_createSig , S_In_out_mux, S_out,
	A_in_createSig,A_out,P_in_createSig , P_In_out_mux, P_out , RT_OP_ALU,LFT_OP_ALU: std_logic_vector (16 downto 0);
signal const_Carry_one , const_zero: std_logic_vector (16 downto 0);
signal Sel_H_Lft_OP_mux , not_en_S: std_logic;

begin

S_in_createSig <= not (Data_from_cache) & "000000000" ;
A_in_createSig <= Data_from_cache & "000000000" ;
P_in_createSig<= "00000000" & Data_from_cache & '0';
const_Carry_one <= "00000001000000000";
const_zero <= "00000000000000000" ;


Mux_S_reg : mux2_1 GENERIC map ( n=>17) port map  (Out_shift , S_in_createSig , R_F_Ack , S_In_out_mux);
Mux_P_reg : mux2_1 GENERIC map ( n=>17) port map  (Out_shift , P_in_createSig , R_I_Ack ,P_In_out_mux );

S_reg : my_nDFF_fall GENERIC map  ( n=> 17)PORT map ( Clk,Rst , en_S , S_In_out_mux , S_out );
A_reg : my_nDFF_fall GENERIC map  ( n=> 17)PORT map ( Clk,Rst , R_F_Ack , A_in_createSig , A_out);
P_reg : my_nDFF_fall GENERIC map  ( n=> 17)PORT map ( Clk,Rst , en_P , P_In_out_mux , P_out);


Mux_Rt_OP : mux2_1 GENERIC map ( n=>17) port map  (P_out , const_Carry_one , en_S , RT_OP_ALU);

Sel_H_Lft_OP_mux <= P_out(1) or en_S;
Mux_LFT_OP : mux4 Generic map (m =>17)port map ( Sel_H_Lft_OP_mux,P_out(0), const_zero, A_out, S_out, const_zero, LFT_OP_ALU);
	
ALU: my_nadder_noCout GENERIC map(n=> 17) PORT map (LFT_OP_ALU , RT_OP_ALU , Alu_out);

not_en_S <= not(en_S);
Alu_shift_one <= Alu_out(16)& Alu_out(16 downto 1);

Mux_shift_result : mux2_1 GENERIC map ( n=>17) port map  (Alu_out , Alu_shift_one , not_en_S ,Out_shift );

result<=Out_shift(7 downto 0);

end my_alu_component;