* File: gray_b10901041.pex.sp
* Created: Sun May 19 15:57:57 2024
* Program "Calibre xRC"
* Version "v2022.3_33.19"
* 
.include "gray_b10901041.pex.sp.pex"
.subckt gray  G2 VDD GND OUT P2 G1
* 
* G1	G1
* P2	P2
* OUT	OUT
* GND	GND
* VDD	VDD
* G2	G2
MM2 N_NET35_MM2_d N_G2_MM2_g N_GND_MM2_s N_GND_MM0_b N_18 L=1.8e-07 W=5e-07
+ AD=2.45e-13 AS=2.45e-13 PD=1.48e-06 PS=1.48e-06
MM5 N_NET35_MM5_d N_G2_MM5_g N_VDD_MM5_s N_VDD_MM12_b P_18 L=1.8e-07 W=1e-06
+ AD=4.9e-13 AS=4.9e-13 PD=1.98e-06 PS=1.98e-06
MM0 N_OUT_MM0_d N_NET35_MM0_g N_NET39_MM0_s N_GND_MM0_b N_18 L=1.8e-07 W=5e-07
+ AD=2.45e-13 AS=1.275e-13 PD=1.48e-06 PS=5.1e-07
MM1 N_NET39_MM1_d N_NET41_MM1_g N_GND_MM1_s N_GND_MM0_b N_18 L=1.8e-07 W=5e-07
+ AD=1.275e-13 AS=2.45e-13 PD=5.1e-07 PS=1.48e-06
MM12 N_OUT_MM12_d N_NET35_MM12_g N_VDD_MM12_s N_VDD_MM12_b P_18 L=1.8e-07
+ W=1e-06 AD=2.55e-13 AS=4.9e-13 PD=5.1e-07 PS=1.98e-06
MM13 N_OUT_MM13_d N_NET41_MM13_g N_VDD_MM13_s N_VDD_MM12_b P_18 L=1.8e-07
+ W=1e-06 AD=2.55e-13 AS=4.9e-13 PD=5.1e-07 PS=1.98e-06
MM7 N_NET41_MM7_d N_P2_MM7_g N_NET27_MM7_s N_GND_MM0_b N_18 L=1.8e-07 W=5e-07
+ AD=2.45e-13 AS=1.275e-13 PD=1.48e-06 PS=5.1e-07
MM10 N_NET27_MM10_d N_G1_MM10_g N_GND_MM10_s N_GND_MM0_b N_18 L=1.8e-07 W=5e-07
+ AD=1.275e-13 AS=2.45e-13 PD=5.1e-07 PS=1.48e-06
MM14 N_NET41_MM14_d N_P2_MM14_g N_VDD_MM14_s N_VDD_MM12_b P_18 L=1.8e-07 W=1e-06
+ AD=2.55e-13 AS=4.9e-13 PD=5.1e-07 PS=1.98e-06
MM15 N_NET41_MM15_d N_G1_MM15_g N_VDD_MM15_s N_VDD_MM12_b P_18 L=1.8e-07 W=1e-06
+ AD=2.55e-13 AS=4.9e-13 PD=5.1e-07 PS=1.98e-06
*
.include "gray_b10901041.pex.sp.GRAY.pxi"
*
.ends
*
*
