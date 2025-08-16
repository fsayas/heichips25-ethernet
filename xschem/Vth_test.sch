v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 40 60 40 80 {lab=GND}
N -80 0 -80 10 {lab=Vgs}
N -80 0 -0 -0 {lab=Vgs}
N -80 70 -80 80 {lab=GND}
N -80 80 40 80 {lab=GND}
N 40 80 40 100 {lab=GND}
N 40 -80 190 -80 {lab=Vds}
N 60 60 190 60 {lab=GND}
N 40 30 40 60 {lab=GND}
N 190 30 190 60 {lab=GND}
N 40 -0 60 -0 {lab=GND}
N 60 0 60 60 {lab=GND}
N 40 60 60 60 {lab=GND}
N 40 -80 40 -30 {lab=Vds}
N 190 -80 190 -30 {lab=Vds}
C {sg13g2_pr/sg13_lv_nmos.sym} 20 0 0 0 {name=M3
l=0.13u
w=0.13u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {gnd.sym} 40 100 0 0 {name=l1 lab=GND}
C {vsource.sym} -80 40 0 0 {name=Vgs value=1.5 savecurrent=false}
C {vsource.sym} 190 0 0 0 {name=Vds value=1.5 savecurrent=false}
C {devices/code_shown.sym} 350 -210 0 0 {name=NGSPICE only_toplevel=true 
value="
.param temp=27
.control
save all
save @n.xm3.nsg13_lv_nmos[ids]
dc Vgs 0 1.5 0.1
plot v(Vgs) v(Vds)
plot @n.xm3.nsg13_lv_nmos[ids]
.endc
"}
C {devices/code_shown.sym} 350 50 0 0 {name=MODEL only_toplevel=true
format="tcleval( @value )"
value=".lib cornerMOSlv.lib mos_tt
"}
C {lab_wire.sym} -30 0 0 0 {name=p5 sig_type=std_logic lab=Vgs}
C {lab_wire.sym} 40 -50 0 0 {name=p1 sig_type=std_logic lab=Vds}
