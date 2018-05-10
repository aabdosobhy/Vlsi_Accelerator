LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;  

ENTITY dma IS 
GENERIC ( n : integer := 8); 
		PORT (	Clk,hardRst,readIAcc,readFAcc ,
		            size:IN std_logic;	
		            inputpixel1,inputpixel2,inputpixel3,inputpixel4,inputpixel5: IN std_logic_vector(n-1 DOWNTO 0);
		            imgAdd,lastWrAdd  : in std_logic_vector(19 DOWNTO 0);
		            ramAddrBus   : OUT std_logic_vector(19 DOWNTO 0);
			    outputpixel1,outputpixel2,outputpixel3,outputpixel4,outputpixel5 : OUT std_logic_vector(n-1 DOWNTO 0); 
			    FAck,IAck,readORs_out,Ors_F: OUT std_logic;
                            counter_delayed:OUT std_logic_vector(2 DOWNTO 0));       
END ENTITY dma;


ARCHITECTURE directingUnit OF dma IS

component my_nDFF IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enb : IN std_logic;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END component;

component my_nDFF_fall IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enb : IN std_logic;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END component;

component my_DFF IS --falling
     PORT( d,clk,rst,en : IN std_logic;   q : OUT std_logic);
END component;

component my_DFF_rise IS --rising
     PORT( clk,rst,en,d: IN std_logic;   q : OUT std_logic);
END component;

component mux2_1 IS 
GENERIC ( n : integer := 16); 
		PORT (in1,in2 : IN std_logic_vector(n-1 DOWNTO 0);
          		s:  IN std_logic;
  		      out1 : OUT std_logic_vector(n-1 DOWNTO 0));    
END component;

component mux_2x1_1_bit IS 
		PORT (in1,in2 : IN std_logic;
          		s:  IN std_logic;
  		      out1 : OUT std_logic);    
END component;

signal acc,buf,reg,readORs,
      --accF,bufF,regF,
      ramAddrMUX1Sel,ramAddrMUX2Sel,
      readIbufftwice , readFbufftwice,
      ramAddrEn,ramAddrRst,readingcntrdelayed1,
--      enReadReg,readReg,accDelayed,
      --rFilRegRst,
      mainRegsEn,
      FAckSig,IAckSig,ackBuff,
      FAckDelayedSig,IAckDelayedSig,
      filORs,readRegRst,ack,counterEn,
      readIReg,readFReg:std_logic;--,readFAcc 
signal  readingcntrout,readingcntr,cntrMUX5out,cntrMUX4out,counterDec,
      readingcntrdelayedout,ramAddrMUX2out   :std_logic_vector(2 downto 0);	--counterInc,
--signal accMUX,sizeMUX,readMUX:std_logic_vector(n-1 downto 0);
signal ramAddrout,ramAddInc,ramAddrMUX1out:std_logic_vector(19 downto 0);
BEGIN   
    acc <= readIAcc or readFAcc;
    reg<= readIReg or readFReg; ---heba --------
    buf<= readIbufftwice or readFbufftwice; ---------heba------
    readORs <= acc or buf or reg;
    readORs_out <= readORs;
    
--    readFAccMUX: mux_2x1_1_bit port map('0','1',start,readFAcc);
    ---------------------------------
    counterDec<=std_logic_vector(unsigned(readingcntrout)-1);
    cntrMUX5:mux2_1 GENERIC MAP (n=>3) port map("010","111",readIAcc,cntrMUX5out);
    cntrMUX4:mux2_1 GENERIC MAP (n=>3) port map("101",cntrMUX5out,size,cntrMUX4out);
    cntrMUX3:mux2_1 GENERIC MAP (n=>3) port map(counterDec,cntrMUX4out,acc,readingcntr);
    ---------------------------------
    --rFilRegL: my_DFF port map(readIAcc,Clk,rFilRegRst,'1',accDelayed);
    --rFilRegRst<=acc or hardRst;
    counterEn<=ramAddrEn and not ack;
    counter: my_nDFF GENERIC MAP (n=>3) port map(Clk,hardRst,counterEn,readingcntr,readingcntrout);
    readRegRst<= ((not(readingcntrout(0) or  readingcntrout(1) or readingcntrout(2)))or hardRst ) and  not acc; --counter=0
--    rFilRegL: my_DFF port map(readIAcc,Clk,acc,accDelayed);
    counterDelayed: my_nDFF_fall GENERIC MAP (n=>3) port map(Clk,hardRst,ramAddrEn,readingcntrout,readingcntrdelayedout);
     ----- heba added-----------
     counter_delayed <= readingcntrdelayedout;
    readingcntrdelayed1<= (not readingcntrdelayedout(0)) and (not readingcntrdelayedout(1)) and readingcntrdelayedout(2);--delayed counter=1
    ---------------------------------------

    ramAddrMUX2Sel<= size and readingcntrdelayed1;
    ramAddrMUX2: mux2_1 GENERIC MAP (n=>3) port map("101","100",ramAddrMUX2Sel,ramAddrMUX2out);
    ramAddInc<=std_logic_vector(unsigned(ramAddrout)+unsigned(ramAddrMUX2out));
    filORs<= readFAcc or readFReg or readFbufftwice;
    ramAddrMUX1Sel<=filORs and not FAckDelayedSig;

    Ors_F <= filORs; --heba---
    ramAddrMUX1: mux2_1 GENERIC MAP (n=>20) port map(imgAdd,ramAddInc,ramAddrMUX1Sel,ramAddrMUX1out);
    
    ramAddrEn<=readORs and ackBuff;
    ramAddrRst<=hardRst or readFAcc;
    ramAddr: my_nDFF GENERIC MAP (n=>20) port map(Clk,ramAddrRst,ramAddrEn,ramAddrMUX1out,ramAddrout);
      
    ------------------------------------------
    
    ramAddrBusL:mux2_1 GENERIC MAP (n=>20) port map(lastWrAdd,ramAddrout,mainRegsEn,ramAddrBus);
 
    --------------------------------------
    readIRegL: my_DFF_rise  port map(Clk,readRegRst,acc,readIAcc,readIReg);
    readFRegL: my_DFF_rise  port map(Clk,readRegRst,acc,readFAcc,readFReg);
      
    readIRegL2: my_DFF_rise  port map(Clk,hardRst,'1',readIReg,readIbufftwice);
    readFRegL2: my_DFF_rise  port map(Clk,hardRst,'1',readFReg,readFbufftwice);
    ----------------------------------------
    ackIBuff: my_DFF  port map(Clk,hardRst,'1',IAckSig,IAckDelayedSig);
    ackFbuff: my_DFF  port map(Clk,hardRst,'1',FAckSig,FAckDelayedSig);
      
    FAckSig<=not mainRegsEn and readFbufftwice;
    IAckSig<=not mainRegsEn and readIbufftwice;
    
    FAck<=FAckSig;-- FAckDelayedSig ;
    IAck<=IAckSig;--IAckDelayedSig;
    ack<= FAckSig or IAckSig;
    
    ackBuff<= IAckDelayedSig nor FAckDelayedSig;
    -----------------------------------
    mainRegsEn<= acc or reg;
    reg1: my_nDFF_fall GENERIC MAP (n=>8) port map(Clk,hardRst,mainRegsEn,inputpixel1,outputpixel1);
    reg2: my_nDFF_fall GENERIC MAP (n=>8) port map(Clk,hardRst,mainRegsEn,inputpixel2,outputpixel2);
    reg3: my_nDFF_fall GENERIC MAP (n=>8) port map(Clk,hardRst,mainRegsEn,inputpixel3,outputpixel3);
    reg4: my_nDFF_fall GENERIC MAP (n=>8) port map(Clk,hardRst,mainRegsEn,inputpixel4,outputpixel4);
    reg5: my_nDFF_fall GENERIC MAP (n=>8) port map(Clk,hardRst,mainRegsEn,inputpixel5,outputpixel5);
    -----------------------------------
    
END directingUnit;




