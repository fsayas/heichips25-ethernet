v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 40 -250 40 -220 {lab=VPWR}
N 260 -250 280 -250 {lab=VPWR}
N 280 -250 280 -220 {lab=VPWR}
N 40 30 40 60 {lab=#net1}
N 260 60 280 60 {lab=#net1}
N 280 30 280 60 {lab=#net1}
N 40 -190 60 -190 {lab=VPWR}
N 60 -250 60 -190 {lab=VPWR}
N 40 -250 60 -250 {lab=VPWR}
N 260 -190 280 -190 {lab=VPWR}
N 260 -250 260 -190 {lab=VPWR}
N 160 -250 260 -250 {lab=VPWR}
N 40 0 60 0 {lab=#net1}
N 60 0 60 60 {lab=#net1}
N 40 60 60 60 {lab=#net1}
N 260 0 280 0 {lab=#net1}
N 260 0 260 60 {lab=#net1}
N 160 -280 160 -250 {lab=VPWR}
N 60 -250 160 -250 {lab=VPWR}
N -20 -190 0 -190 {lab=dp_in}
N -20 0 -0 0 {lab=dp_in}
N 320 -190 340 -190 {lab=dn_in}
N 320 0 340 0 {lab=dn_in}
N -20 -100 -20 -0 {lab=dp_in}
N 40 -100 40 -30 {lab=dp}
N 280 -100 280 -30 {lab=dn}
N 340 -100 340 -0 {lab=dn_in}
N -60 -100 -20 -100 {lab=dp_in}
N -20 -190 -20 -100 {lab=dp_in}
N 340 -100 380 -100 {lab=dn_in}
N 340 -190 340 -100 {lab=dn_in}
N 40 -100 80 -100 {lab=dp}
N 40 -160 40 -100 {lab=dp}
N 240 -100 280 -100 {lab=dn}
N 280 -160 280 -100 {lab=dn}
N 160 60 260 60 {lab=#net1}
N 160 60 160 110 {lab=#net1}
N 60 60 160 60 {lab=#net1}
N 160 200 160 220 {lab=VGND}
N -140 140 120 140 {lab=#net2}
N -200 90 -200 110 {lab=#net2}
N -200 170 -200 200 {lab=VGND}
N -200 200 160 200 {lab=VGND}
N 160 190 160 200 {lab=VGND}
N -200 90 -140 90 {lab=#net2}
N -200 80 -200 90 {lab=#net2}
N -140 90 -140 140 {lab=#net2}
N -160 140 -140 140 {lab=#net2}
N -200 -280 160 -280 {lab=VPWR}
N 160 -310 160 -280 {lab=VPWR}
N 160 140 190 140 {lab=VGND}
N 190 140 190 190 {lab=VGND}
N 160 190 190 190 {lab=VGND}
N 160 170 160 190 {lab=VGND}
N -220 140 -200 140 {lab=VGND}
N -220 140 -220 200 {lab=VGND}
N -220 200 -200 200 {lab=VGND}
N -200 -20 -200 10 {lab=VPWR}
N -160 40 -140 40 {lab=VPWR}
N -140 -20 -140 40 {lab=VPWR}
N -200 -20 -140 -20 {lab=VPWR}
N -200 -280 -200 -20 {lab=VPWR}
N -220 40 -200 40 {lab=#net2}
N -220 80 -200 80 {lab=#net2}
N -220 40 -220 80 {lab=#net2}
N -200 70 -200 80 {lab=#net2}
C {sg13g2_pr/sg13_lv_nmos.sym} 20 0 0 0 {name=M1
l=1u
w=50u
ng=5
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} 300 0 0 1 {name=M2
l=1u
w=50u
ng=5
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 20 -190 0 0 {name=M5
l=1u
w=50u
ng=5
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 300 -190 0 1 {name=M6
l=1u
w=50u
ng=5
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {ipin.sym} -60 -100 0 0 {name=p3 lab=dp_in}
C {ipin.sym} 380 -100 2 0 {name=p4 lab=dn_in}
C {iopin.sym} 160 -310 3 0 {name=p5 lab=VPWR}
C {iopin.sym} 160 220 1 0 {name=p6 lab=VGND}
C {iopin.sym} 80 -100 0 0 {name=p1 lab=dp}
C {iopin.sym} 240 -100 2 0 {name=p2 lab=dn}
C {sg13g2_pr/sg13_lv_nmos.sym} 140 140 0 0 {name=M3
l=1u
w=50u
ng=5
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} -180 140 0 1 {name=M4
l=4u
w=10u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} -180 40 0 1 {name=M7
l=10u
w=10u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
