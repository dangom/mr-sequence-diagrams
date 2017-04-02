% ----------------------------------------------------------------------
% Pulse sequence graphics
%
% This file is part of Mark White's PhD thesis.
% MJ White <mark@celos.net> 2004
% $Id: seq.mp 32 2004-11-22 18:37:47Z mark $
% ----------------------------------------------------------------------

input pulses.mp

  filenametemplate "images/figs-%c.mps";

% FID acquisition
beginfig(0);

  initf;

  startline(rf,"RF");
  xline(1);
  xpulse(1,1,"a" % infont "Symbol"
      );
  xline(0.2);
  xacq(5);
  xline(1);

% save image to temp variable
  picture pic;
  pic := currentpicture;
  currentpicture := nullpicture;
  fillwhite(pic);

endfig;

% Spin-echo fragement
beginfig(1);

  initf;

  startline(rf,"RF");
  xline(1);
  xpulse(1,1,"a" % infont "Symbol"
      );
  ospan(-0.5,-1.8,4,"TE/2");
  xline(3);
  xpulse(1,1.6,"180");
  ospan(-0.5,-1.8,4,"TE/2");
  xline(2);
  oecho(1.5);
  oguide(1.5,-2);
  xacq(3);
  xline(1);

endfig;

% Gradient echo fragment
beginfig(2);

  initf;

  startline(rf,"RF");
  xline(1);
  xpulse(1,1,"a" % infont "Symbol"
      );
  ospan(-0.5,-1.5,4,"TE");
  ospan(-0.5,-2,2,"TE/2");
  xline(2);
  oecho(1.5);
  xacq(3);
  xline(2);

  startline(g0,"Gx");
  xline(1.5);
  oshade(0,2,-0.5);
  xsquare(2,-0.5);
  oshade(0,2,0.5);
  oguide(2,2);
  xsquare(4,0.5);
  xline(1.5);

endfig;

% Slice-selection fragment
beginfig(3);

  initf;

  startline(rf,"RF");
  xline(1);
  xpulse(1,1,"a" % infont "Symbol"
      );
  xline(3);

  startline(g0+1u,"Gz");
  xline(0.5);
  ospan(0,-1.0,2,"Ts");
  oshade(1,1,0.5);
  oguide(1,1);
  xsquare(2,0.5);
  ospan(0,-1.0,1,"Ts/2");
  oshade(0,1,-0.5);
  xsquare(1,-0.5);
  xline(1.5);

endfig;

% Readout encoding fragment with spin-echo
% (NB gradient-echo version would be the same as Figure 2)
beginfig(4);

  initf;

  startline(rf,"RF");
  xline(1);
  xpulse(1,1,"a" % infont "Symbol"
      );
  ospan(-0.5,-1.8,4,"TE/2");
  xline(3);
  xpulse(1,1.6,"180");
  ospan(-0.5,-1.8,4,"TE/2");
  xline(2);
  oecho(1.5);
  xacq(3);
  xline(1);

  startline(g0,"Gx");
  xline(2.5);
  ospan(0,-0.7,2,"Tr/2");
  oshade(0,2,0.5);
  xsquare(2,0.5);
  xline(3);
  ospan(0,-0.7,4,"Tr");
  oshade(0,2,0.5);
  xsquare(4,0.5);
  oguide(-2,2);
  xline(0.5);

endfig;

% Phase encoding fragment with spin-echo
beginfig(5);

  initf;

  startline(rf,"RF");
  xline(1);
  ospan(0.5,-1.8,4,"TE/2");
  xpulse(1,1,"a" % infont "Symbol"
      );
  xline(3);
  ospan(0.5,-1.8,4,"TE/2");
  xpulse(1,1.6,"180");
  xline(2);
  oecho(1.5);
  oguide(1.5,-2);
  xacq(3);
  xline(1);

  startline(g0,"Gy");
  xline(2.5);
  ospan(0,-1.2,2,"Tp");
  xtable(2,0.8,5,-1);
  xline(7.5);

endfig;

% Multislice SE volume acquisition - outline of sequence
beginfig(6);

  initf;

  startline(rf,"RF");
  xline(1);
  ospan(0.5,-1.8,4,"TE/2");
  xpulse(1,1,"a" % infont "Symbol"
      );
  xline(3);
  ospan(0.5,-1.8,4,"TE/2");
  xpulse(1,1.6,"180");
  xline(2);
  oecho(1.5);
  xacq(3);
  xline(1);

  startline(g0,"Gx");
  xline(2.5);
  ospan(0,-0.4,2,"Tr/2");
  xsquare(2,0.5);
  xline(3);
  ospan(0,-0.4,4,"Tr");
  xsquare(4,0.5);
  xline(0.5);

  startline(g1,"Gy");
  xline(2.5);
  ospan(0,-1.2,2,"Tp");
  xtable(2,0.8,5,-1);
  xline(7.5);

  startline(g2,"Gz");
  xline(0.5);
  ospan(0,-1.1,2,"Ts");
  xsquare(2,0.5);
  ospan(0,-1.1,1,"Ts/2");
  xsquare(1,-0.5);
  xline(8.5);

endfig;

% 3D gradient-echo sequence with EPI factor 3
beginfig(7);

  initf;

  startline(rf,"RF");
  xline(1);
  ospan(0.5,-1.5,3,"TE");
  xpulse(1,1,"a" % infont "Symbol"
      );
  xline(1.2);
  ospan(1.3,-1.5,3,"TE");
  oecho(1.3);
  xacq(2.6);
  xline(0.4);
  ospan(1.3,-1.5,3,"TE");
  oecho(1.3);
  xacq(2.6);
  xline(0.4);
  oecho(1.3);
  xacq(2.6);
  xline(1.4);

  startline(g0,"Gx");
  xline(1.5);
  xsquare(1.5,-0.5);
  xsquare(3,0.5);
  xsquare(3,-0.5);
  xsquare(3,0.5);
  xline(1);

  startline(g1,"Gy");
  xline(2);
  xtable(1,0.8,2,-1);
  xline(2.8);
  xblip(0.4,-0.4);
  xline(2.6);
  xblip(0.4,-0.4);
  xline(3.8);

  startline(g2,"Gz");
  xline(2);
  ospan(0,-1.2,1,"Tp");
  xtable(1,0.8,5,1);
  xline(10);

endfig;

% Echo symbol for key
beginfig(100);
  initf;
  oecho(0);
endfig;

end
