v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -130 0 130 0 {lab=Vgs}
N -190 -50 -190 -30 {lab=Vgs}
N -190 30 -190 60 {lab=GND}
N 170 50 170 80 {lab=GND}
N -190 -50 -130 -50 {lab=Vgs}
N -130 -50 -130 0 {lab=Vgs}
N -150 0 -130 0 {lab=Vgs}
N 170 0 200 0 {lab=GND}
N 200 0 200 50 {lab=GND}
N 170 50 200 50 {lab=GND}
N 170 30 170 50 {lab=GND}
N -210 0 -190 0 {lab=GND}
N -210 0 -210 60 {lab=GND}
N -210 60 -190 60 {lab=GND}
N 330 20 330 40 {lab=GND}
N 170 -280 330 -280 {lab=Vdd}
N 170 -280 170 -30 {lab=Vdd}
N 330 -280 330 -40 {lab=Vdd}
N -190 -280 170 -280 {lab=Vdd}
N -190 60 -190 90 {lab=GND}
N -190 -280 -190 -240 {lab=Vdd}
N -190 -180 -190 -50 {lab=Vgs}
C {sg13g2_pr/sg13_lv_nmos.sym} 150 0 0 0 {name=M3
l=0.13u
w=1u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} -170 0 0 1 {name=M4
l=0.13u
w=1u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {vsource.sym} 330 -10 0 0 {name=Vsup value=1.5 savecurrent=false}
C {gnd.sym} 330 40 0 0 {name=l2 lab=GND}
C {gnd.sym} 170 80 0 0 {name=l1 lab=GND}
C {gnd.sym} -190 90 0 0 {name=l3 lab=GND}
C {lab_wire.sym} 40 0 0 0 {name=p1 sig_type=std_logic lab=Vgs}
C {lab_wire.sym} 70 -280 0 0 {name=p2 sig_type=std_logic lab=Vdd}
C {devices/code_shown.sym} 470 90 0 0 {name=MODEL only_toplevel=true
format="tcleval( @value )"
value=".lib cornerMOSlv.lib mos_tt
"}
C {devices/code_shown.sym} 440 -280 0 0 {name=NGSPICE only_toplevel=true 
value="
.param temp=27
.control
save all 
save @n.xm4.nsg13_lv_nmos[ids]
save @n.xm3.nsg13_lv_nmos[ids]
tran 5n 500n
plot V(Vgs)
plot @n.xm4.nsg13_lv_nmos[ids] @n.xm3.nsg13_lv_nmos[ids]
.endc
"}
C {isource.sym} -190 -210 0 0 {name=I0 value=1.5m}
