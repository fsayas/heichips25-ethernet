v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 0 0 -0 20 {lab=Y}
N -60 -50 -40 -50 {lab=A}
N -60 50 -40 50 {lab=A}
N -60 -0 -60 50 {lab=A}
N 0 0 40 -0 {lab=Y}
N -0 -20 0 0 {lab=Y}
N -100 0 -60 -0 {lab=A}
N -60 -50 -60 -0 {lab=A}
N 0 80 0 120 {lab=#net1}
N -0 -120 0 -80 {lab=VDD}
C {sg13g2_pr/sg13_lv_nmos.sym} -20 50 0 0 {name=M1
l=0.13u
w=0.15u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} -20 -50 0 0 {name=M2
l=0.13u
w=0.15u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {ipin.sym} -100 0 0 0 {name=p1 lab=A}
C {iopin.sym} 0 -120 3 0 {name=p2 lab=VDD}
C {iopin.sym} 40 0 0 0 {name=p3 lab=Y}
C {iopin.sym} 0 120 1 0 {name=p4 lab=GND}
