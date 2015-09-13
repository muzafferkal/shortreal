// Copyright (C) 2014, DSPIA INC.
// kal@dspia.com<Muzaffer Kal>
// short real conversion functions

function shortreal bitstoshortreal;
  input logic [31:0] bits;

  logic sign;
  logic [7:0] exp;
  logic [22:0] frac;
  shortreal sr;
  logic [23:0] xfrac;

  sign = bits[31];
  exp  = bits[30:23];
  frac = bits[22: 0];

  xfrac = {1'b1, frac};
  sr = 1.0 * xfrac;
  sr = sr / 8388608.0;
  if (exp >= 8'h7F) begin
    exp  = bits[30:23] - 8'h7F;
    sr = sr * (1 << exp);
  end
  else begin
    exp = 8'h7F - bits[30:23];
    sr = sr / (1 << exp);
  end

  bitstoshortreal = bits == 0 ? 0 : sign ? -1.0 * sr : sr;
endfunction

function logic [31:0] shortrealtobits;
  input shortreal r;

  logic sign;
  integer iexp;
  logic [7:0] exp;
  logic [22:0] frac;
  shortreal abs, ffrac;

  sign = r < 0.0 ? 1 : 0;
  abs = sign ? -1.0*r : r;
  iexp  = $floor($ln(abs) / $ln(2));
  ffrac = abs / $pow(2, iexp);
  ffrac = ffrac - 1.0;
  frac = ffrac * 8388608.0;
  exp = (r==0) ? 0 : 127 + iexp;

  shortrealtobits = {sign, exp, frac};
endfunction

