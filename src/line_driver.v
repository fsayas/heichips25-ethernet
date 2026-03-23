(* blackbox *)
module line_driver (
  input wire in_p,
  input wire in_n,
  output wire ethernet_dp,
  output wire ethernet_dn
);

  assign ethernet_dp = in_p;
  assign ethernet_dn = in_n;

endmodule
