% ----------------------------------------------------------------------
% Pulse sequence graphics
% (see seq.mp for examples of use)
%
% This file is part of Mark White's PhD thesis.
% MJ White <mark@celos.net> 2004
% $Id: pulses.mp 33 2004-11-22 18:38:31Z mark $
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% Macros for pulse element generation
%

% output settings (comment out first two lines for TeX fonts)
prologues:=2;   % EPS with Postscript fonts
%defaultfont:="hlm"; % Use helvetica
linejoin := mitered;

% default units and line width
u=1cm;
pensize = 0.8pt;

% y position of lines in the sequence diagram.
numeric g[];
rf=0;
g0=-3u;
g1=-5u;
g2=-7u;

% shared paths used by multiple macros.
path square, pulse, acq, arc;
square = (0,0)--(0,1u)--(1u,1u)--(1u,0);
pulse = (0,0){up}
  for i=1 upto 100:
  --(i/100,sind(i*(0.5*3.6))**3*sind(i*(6.5*3.6)))*u endfor;
acq = (0,0.5u)--(1u,0.5u)--(1u,-0.5u)--(0,-0.5u)--cycle;
arc = (-sqrt(2)/2*u,sqrt(2)/2*u)..(0,1u)..(sqrt(2)/2*u,sqrt(2)/2*u);

% convenience macro for creating text by point size
def fontpt(expr txt, sz) =
  txt infont defaultfont scaled (sz/fontsize defaultfont)
enddef;

% ----------------------------------------------------------------------
% Drawing functions
% These take absolute positions to draw elements of sequences.  Better
% to use xline, xsquare etc for actually composing sequences.
%

def squaref(expr off, xs, ys) =
  % Draw a square at offset OFF, scaled in x by XS,
  % and in y by YS. Effectively a rectangle.
  draw square xscaled xs yscaled ys shifted off;
enddef;

def blipf(expr off, xs, ys) =
  draw ((0,0)--(0.5u,1u)--(1u,0))
    xscaled xs yscaled ys shifted off;
enddef;

def tablef(expr off, xs, ys, gran, upd) =
  begingroup;
    for i=-gran upto gran:
      draw square xscaled xs yscaled (ys*(i/gran)) shifted off
        withcolor 0.5white withpen pencircle scaled 0.5pt;
    endfor;
  endgroup;
  squaref(off,xs,-upd*ys);
  drawarrow ((0.5u*xs,-0.9u*ys*upd)+off)--((0.5u*xs,0.9u*ys*upd)+off)
    withpen pencircle scaled 2pt withcolor 0.3white;
enddef;

def acqf(expr off, xs, ys) =
  picture la;
  unfill acq xscaled xs yscaled ys shifted off;
  draw acq xscaled xs yscaled ys shifted off;
  la = thelabel.rt("Acquire", off+(ys/4,0)*u);
  unfill bbox la;
  draw la;
enddef;

def namedacqf(expr off, xs, ys, name) =
  picture la;
  unfill acq xscaled xs yscaled ys shifted off;
  draw acq xscaled xs yscaled ys shifted off;
  la = thelabel.rt(name, off+(ys/4,0)*u);
  unfill bbox la;
  draw la;
enddef;

def pulsef(expr off, xs, ys, lab) =
  begingroup interim linejoin:=rounded;
    draw pulse xscaled xs yscaled ys shifted off;
  endgroup;
  label.lft(lab,off+(0.2u,0.5u));
enddef;

def spanf(expr yoff, st, en, lab) =
  picture la;
  mid := (st+en)/2;
  drawarrow reverse((st,yoff)--(mid,yoff));
  drawarrow        ((mid,yoff)--(en,yoff));
  la = thelabel(fontpt(lab,8pt), (mid,yoff));
  unfill bbox la;
  draw la;
enddef;

def linef(expr off, len) =
  draw off--(off+(len,0));
enddef;

def labelf(expr yoff, lab) =
  label.lft(lab infont defaultfont scaled 1.2, (0,yoff));
enddef;

def gradf(expr off, xs, ys) =
  draw ((0,0)--(0.25u,1u)--(0.75u,1u)--(1u,0))
    xscaled xs yscaled ys shifted off;
enddef;

def tablegrf(expr off, xs, ys, gran, upd) =
  begingroup;
    for i=-gran upto gran:
      draw ((0,0)--(0.25u,1u)--(0.75u,1u)--(1u,0))
        xscaled xs yscaled (ys*(i/gran)) shifted off
        withcolor 0.5white withpen pencircle scaled 0.5pt;
    endfor;
  endgroup;
  gradf(off,xs,-upd*ys);
  drawarrow ((0.5u*xs,-0.9u*ys*upd)+off)--((0.5u*xs,0.9u*ys*upd)+off)
    withpen pencircle scaled 2pt withcolor 0.3white;
enddef;

% ----------------------------------------------------------------------
% Progressive functions (start with x)
% These draw an object on the line and bump the current position
%

def initf =
  Ox := 0;
  Oy := 0;
  pickup pencircle scaled pensize;
enddef;

def startline(expr off, lab) =
  Ox := 0;
  Oy := off;
  labelf(Oy,lab);
enddef;

def xline(expr l) =
  linef((Ox,Oy),l*u);
  Ox := Ox + l*u;
enddef;

def xpulse(expr l, h, lab) =
  pulsef((Ox,Oy),l,h,lab);
  Ox := Ox + l*u;
enddef;

def xacq(expr l) =
  acqf((Ox,Oy),l,0.7);
  Ox := Ox + l*u;
enddef;

def xnamedacq(expr l, name) =
  namedacqf((Ox,Oy),l,0.7, name);
  Ox := Ox + l*u;
enddef;

def xsquare(expr l, h) =
  squaref((Ox,Oy),l,h);
  Ox := Ox + l*u;
enddef;

def xtable(expr l, h, grad, upd) =
  tablef((Ox,Oy),l,h,grad,upd);
  Ox := Ox + l*u;
enddef;

def xblip(expr l, h) =
  blipf((Ox,Oy),l,h);
  Ox := Ox + l*u;
enddef;

def xgrad(expr length, height) =
  gradf((Ox, Oy), length, height);
  Ox := Ox + length*u;
enddef;

def xtablegr(expr l, h, grad, upd) =
  tablegrf((Ox,Oy),l,h,grad,upd);
  Ox := Ox + l*u;
enddef;

% ----------------------------------------------------------------------
% Overlay functions
% These draw an object relative to the current position, but don't
% change it.  Most start with x (and maybe y) offset arguments.  They
% cover shading, vertical guidelines, time span indicators, and echoes.
%

def ospan(expr xoff, yoff, l, lab) =
  spanf(Oy+yoff*u, Ox+xoff*u, Ox+xoff*u+l*u, lab);
    % don't change current position
enddef;


def oshade(expr xoff, l, h) =
  fill square--cycle xscaled l yscaled h shifted (Ox+xoff*u,Oy)
    withcolor 0.7white;
    % don't change current position
enddef;

def oguide(expr xoff, h) =
  draw (Ox+xoff*u,Oy)--(Ox+xoff*u,Oy+h*u) dashed evenly;
    % don't change current position
enddef;


def oecho(expr xoff) =
  boolean symbolic;
  symbolic := true;   % two possibilities; adj to taste

  if symbolic:
    yoff := 0.5;
    draw (Ox+xoff*u,Oy+yoff*u) withpen pencircle scaled 0.1u;
    draw arc scaled 0.15 shifted (Ox+xoff*u,Oy+yoff*u);
    draw arc scaled 0.25 shifted (Ox+xoff*u,Oy+yoff*u);
    draw arc scaled 0.35 shifted (Ox+xoff*u,Oy+yoff*u);
  else:
    yoff := 0.7;
    begingroup
      interim linejoin:=rounded;
      draw pulse xscaled 0.5 yscaled 0.25
        shifted (Ox+xoff*u-0.25u,Oy+yoff*u)
        withpen pencircle scaled 0.3;
    endgroup;
  fi;
    % don't change current position
enddef;

def fillwhite(expr p) =
% fill a bounding pox of pic with color
  fill bbox p withcolor white;
% re-draw pic ontop
  draw p;
enddef;
