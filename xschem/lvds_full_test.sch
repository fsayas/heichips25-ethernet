v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 40 -250 40 -220 {lab=vpwr}
N 260 -250 280 -250 {lab=vpwr}
N 280 -250 280 -220 {lab=vpwr}
N 40 30 40 60 {lab=vds_bot}
N 260 60 280 60 {lab=vds_bot}
N 280 30 280 60 {lab=vds_bot}
N 40 -190 60 -190 {lab=vpwr}
N 60 -250 60 -190 {lab=vpwr}
N 40 -250 60 -250 {lab=vpwr}
N 260 -190 280 -190 {lab=vpwr}
N 260 -250 260 -190 {lab=vpwr}
N 160 -250 260 -250 {lab=vpwr}
N 40 0 60 0 {lab=vds_bot}
N 60 0 60 60 {lab=vds_bot}
N 40 60 60 60 {lab=vds_bot}
N 260 0 280 0 {lab=vds_bot}
N 260 0 260 60 {lab=vds_bot}
N 160 -280 160 -250 {lab=vpwr}
N 60 -250 160 -250 {lab=vpwr}
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
N 40 -100 130 -100 {lab=dp}
N 40 -160 40 -100 {lab=dp}
N 280 -160 280 -100 {lab=dn}
N 160 60 260 60 {lab=vds_bot}
N 160 60 160 110 {lab=vds_bot}
N 60 60 160 60 {lab=vds_bot}
N -140 140 120 140 {lab=vgs_ref}
N -200 90 -200 110 {lab=vgs_ref}
N -200 170 -200 200 {lab=GND}
N -40 200 160 200 {lab=GND}
N 160 190 160 200 {lab=GND}
N -200 90 -140 90 {lab=vgs_ref}
N -140 90 -140 140 {lab=vgs_ref}
N -160 140 -140 140 {lab=vgs_ref}
N 160 140 190 140 {lab=GND}
N 190 140 190 190 {lab=GND}
N 160 190 190 190 {lab=GND}
N 160 170 160 190 {lab=GND}
N -220 140 -200 140 {lab=GND}
N -220 140 -220 200 {lab=GND}
N -220 200 -200 200 {lab=GND}
N -350 200 -220 200 {lab=GND}
N -350 90 -350 200 {lab=GND}
N -350 -280 -350 30 {lab=vpwr}
N -200 -280 160 -280 {lab=vpwr}
N -40 200 -40 240 {lab=GND}
N -200 200 -40 200 {lab=GND}
N -820 80 -820 100 {lab=GND}
N -720 -110 -720 -60 {lab=dp_in}
N -720 -110 -690 -110 {lab=dp_in}
N -720 0 -720 20 {lab=GND}
N -820 -130 -820 20 {lab=dn_in}
N -820 -130 -690 -130 {lab=dn_in}
N 190 -100 280 -100 {lab=dn}
N -220 130 -220 140 {lab=GND}
N -200 -200 -140 -200 {lab=vpwr}
N -140 -200 -140 -150 {lab=vpwr}
N -160 -150 -140 -150 {lab=vpwr}
N -200 -200 -200 -180 {lab=vpwr}
N -200 -280 -200 -200 {lab=vpwr}
N -350 -280 -200 -280 {lab=vpwr}
N -200 -100 -200 90 {lab=vgs_ref}
N -220 -150 -200 -150 {lab=vgs_ref}
N -220 -150 -220 -100 {lab=vgs_ref}
N -220 -100 -200 -100 {lab=vgs_ref}
N -200 -120 -200 -100 {lab=vgs_ref}
C {sg13g2_pr/sg13_lv_nmos.sym} 20 0 0 0 {name=M1
l=1u
w=40u
ng=4
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} 300 0 0 1 {name=M2
l=1u
w=40u
ng=4
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 20 -190 0 0 {name=M5
l=1u
w=40u
ng=4
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 300 -190 0 1 {name=M6
l=1u
w=40u
ng=4
m=1
model=sg13_lv_pmos
spiceprefix=X
}
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
C {vsource.sym} -350 60 0 0 {name=V1 value=1.5 savecurrent=false}
C {devices/code_shown.sym} 480 -10 0 0 {name=MODEL only_toplevel=true
format="tcleval( @value )"
value=".lib cornerMOSlv.lib mos_tt
"}
C {devices/code_shown.sym} 470 -250 0 0 {name=NGSPICE only_toplevel=true 
value="
.param temp=27
.control
save all 
tran 5n 500n
plot V(vgs_ref) V(vds_bot) V(dp) V(dn)
plot @n.xm3.nsg13_lv_nmos[ids] 
.endc
"}
C {gnd.sym} -40 240 0 0 {name=l1 lab=GND}
C {lab_wire.sym} -90 -280 0 0 {name=p5 sig_type=std_logic lab=vpwr}
C {lab_wire.sym} 80 -100 0 0 {name=p1 sig_type=std_logic lab=dp}
C {lab_wire.sym} 380 -100 0 0 {name=p2 sig_type=std_logic lab=dn_in}
C {lab_wire.sym} -60 -100 2 0 {name=p3 sig_type=std_logic lab=dp_in}
C {lab_wire.sym} 240 -100 2 0 {name=p4 sig_type=std_logic lab=dn}
C {vsource.sym} -720 -30 0 0 {name=Vdat_p value="dc 0 ac 0 pulse(0, 1.5, 0, 100p, 100p, 50n, 100n)" savecurrent=false}
C {vsource.sym} -820 50 0 0 {name=Vdat_n value="dc 0 ac 0 pulse(1.5, 0, 0, 100p, 100p, 50n, 100n)" savecurrent=false}
C {gnd.sym} -820 100 0 0 {name=l2 lab=GND}
C {gnd.sym} -720 20 0 0 {name=l3 lab=GND}
C {lab_wire.sym} -690 -110 0 0 {name=p6 sig_type=std_logic lab=dp_in}
C {lab_wire.sym} -690 -130 0 0 {name=p7 sig_type=std_logic lab=dn_in}
C {res.sym} 160 -100 1 0 {name=R1
value=100
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} -30 140 0 0 {name=p8 sig_type=std_logic lab=vgs_ref}
C {lab_wire.sym} 140 60 0 0 {name=p9 sig_type=std_logic lab=vds_bot}
C {sg13g2_pr/sg13_lv_nmos.sym} -180 -150 0 1 {name=M7
l=10u
w=10u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
