v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -30 -30 -30 -10 {lab=Vgs}
N -30 50 -30 80 {lab=GND}
N -30 -30 30 -30 {lab=Vgs}
N 30 -30 30 20 {lab=Vgs}
N 10 20 30 20 {lab=Vgs}
N -50 20 -30 20 {lab=GND}
N -50 20 -50 80 {lab=GND}
N -50 80 -30 80 {lab=GND}
N -30 100 -30 110 {lab=GND}
N -30 -240 -30 -220 {lab=Vds}
N -220 30 -220 100 {lab=GND}
N -220 100 -30 100 {lab=GND}
N -30 80 -30 100 {lab=GND}
N -220 -260 -220 -30 {lab=Vds}
N -220 -260 -30 -260 {lab=Vds}
N -30 -130 -30 -30 {lab=Vgs}
N -30 -240 30 -240 {lab=Vds}
N 30 -240 30 -190 {lab=Vds}
N 10 -190 30 -190 {lab=Vds}
N -50 -190 -30 -190 {lab=Vgs}
N -50 -190 -50 -130 {lab=Vgs}
N -30 -260 -30 -240 {lab=Vds}
N -50 -130 -30 -130 {lab=Vgs}
N -30 -160 -30 -130 {lab=Vgs}
N 250 -90 250 -10 {lab=#net1}
N 250 -260 250 -150 {lab=Vds}
N -30 -260 250 -260 {lab=Vds}
N 30 20 210 20 {lab=Vgs}
N 250 70 250 100 {lab=GND}
N -30 100 250 100 {lab=GND}
N 250 20 280 20 {lab=GND}
N 280 20 280 70 {lab=GND}
N 250 70 280 70 {lab=GND}
N 250 50 250 70 {lab=GND}
C {sg13g2_pr/sg13_lv_nmos.sym} -10 20 0 1 {name=M4
l=4u
w=10u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {gnd.sym} -30 110 0 0 {name=l3 lab=GND}
C {vsource.sym} -220 0 0 0 {name=Vdd value=1.5 savecurrent=false}
C {lab_wire.sym} 20 -30 0 0 {name=p5 sig_type=std_logic lab=Vgs}
C {devices/code_shown.sym} 160 -620 0 0 {name=NGSPICE only_toplevel=true 
value="
.param temp=27
.control
save all
save @n.xm4.nsg13_lv_nmos[ids]
save @n.xm2.nsg13_lv_nmos[ids]
tran 5n 500n
plot v(Vgs) v(Vds)
plot @n.xm4.nsg13_lv_nmos[ids] @n.xm2.nsg13_lv_nmos[ids]
.endc
"}
C {devices/code_shown.sym} 180 -370 0 0 {name=MODEL only_toplevel=true
format="tcleval( @value )"
value=".lib cornerMOSlv.lib mos_tt
"}
C {lab_wire.sym} -110 -260 0 0 {name=p1 sig_type=std_logic lab=Vds}
C {sg13g2_pr/sg13_lv_nmos.sym} -10 -190 0 1 {name=M1
l=10u
w=10u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} 230 20 0 0 {name=M2
l=1u
w=50u
ng=5
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {res.sym} 250 -120 0 0 {name=R1
value=100
footprint=1206
device=resistor
m=1}
