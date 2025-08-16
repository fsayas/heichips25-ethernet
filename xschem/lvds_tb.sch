v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
B 5 147.5 -32.5 152.5 -27.5 {name=VPWR dir=inout}
B 5 147.5 -12.5 152.5 -7.5 {name=dn dir=inout}
B 5 -152.5 -32.5 -147.5 -27.5 {name=dn_in dir=in}
B 5 147.5 7.5 152.5 12.5 {name=dp dir=inout}
B 5 -152.5 -12.5 -147.5 -7.5 {name=dp_in dir=in}
B 5 147.5 27.5 152.5 32.5 {name=VGND dir=inout}
N 150 -10 250 -10 {lab=dn}
N 150 10 220 10 {lab=dp}
N -280 180 -280 200 {lab=GND}
N -180 -10 -180 40 {lab=dp_in}
N -180 -10 -150 -10 {lab=dp_in}
N -180 100 -180 120 {lab=GND}
N -280 -30 -280 120 {lab=dn_in}
N -280 -30 -150 -30 {lab=dn_in}
N 300 120 300 140 {lab=GND}
N 150 -30 300 -30 {lab=Vdd}
N 300 -30 300 60 {lab=Vdd}
N 150 30 180 30 {lab=GND}
N 180 30 180 80 {lab=GND}
N 220 10 220 80 {lab=dp}
N 220 80 250 80 {lab=dp}
N 250 50 250 80 {lab=dp}
C {vsource.sym} 300 90 0 0 {name=Vsup value=1.5 savecurrent=false}
C {vsource.sym} -180 70 0 0 {name=Vdat_p value="dc 0 ac 0 pulse(0, 1.5, 0, 100p, 100p, 50n, 100n)" savecurrent=false}
C {vsource.sym} -280 150 0 0 {name=Vdat_n value="dc 0 ac 0 pulse(1.5, 0, 0, 100p, 100p, 50n, 100n)" savecurrent=false}
C {gnd.sym} -280 200 0 0 {name=l1 lab=GND}
C {gnd.sym} 300 140 0 0 {name=l2 lab=GND}
C {gnd.sym} -180 120 0 0 {name=l3 lab=GND}
C {gnd.sym} 180 80 0 0 {name=l4 lab=GND}
C {devices/code_shown.sym} 520 160 0 0 {name=MODEL only_toplevel=true
format="tcleval( @value )"
value=".lib cornerMOSlv.lib mos_tt
"}
C {devices/code_shown.sym} 490 -210 0 0 {name=NGSPICE only_toplevel=true 
value="
.param temp=27
.control
save all 
tran 5n 500n
plot V(dp_in) V(dn_in) V(dp) V(dn)
.endc
"}
C {lab_wire.sym} -160 -10 0 0 {name=p2 sig_type=std_logic lab=dp_in}
C {lab_wire.sym} -160 -30 0 0 {name=p5 sig_type=std_logic lab=dn_in}
C {lab_wire.sym} 290 -30 0 0 {name=p1 sig_type=std_logic lab=Vdd}
C {res.sym} 250 20 0 0 {name=R1
value=100
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 200 -10 0 0 {name=p3 sig_type=std_logic lab=dn}
C {lab_wire.sym} 200 10 0 0 {name=p4 sig_type=std_logic lab=dp}
C {/home/pc/heichips25-ethernet/xschem/lvds.sym} 0 0 0 0 {name=x1}
