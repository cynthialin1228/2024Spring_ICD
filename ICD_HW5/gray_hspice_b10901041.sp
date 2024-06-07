/// Example file gray_hspice_b10901041.sp ///
.lib 'cic018.l' TT
.include "gray_b10901041.pex.sp"

.global vdd gnd

xgray  G2 VDD GND OUT P2 G1 gray

Vvdd VDD GND 1.8V

Vg1 G1 GND PULSE 0 1.8V 0ps 1ns 1ns 20ns 40ns
Vg2 G2 GND PULSE 0 1.8V 0ps 1ns 1ns 40ns 80ns
Vp2 P2 GND P1ULSE 0 1.8V 0ps 1ns 1ns 80ns 160ns

.probe v(OUT)

.option post
.tran 10p 0.4u
.ic v(OUT) = 1.8V
.end
