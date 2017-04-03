% Time-stamp: <2017-04-03 10:49:15 danielpgomez>

% Generate a Sequence Diagram for a Standard 2D EPI Sequence
% Generate a Sequence Diagram for a MESH EPI Sequence.

input pulses.mp;

numeric start_delay, end_delay;
start_delay := 0.3;
end_delay := 0.3;

numeric rf_duration, rf_intensity;
string rf_name;
rf_duration:= 1.2;
rf_intensity := 0.8;
rf_name := "";

numeric slice_select_duration, slice_rephase_duration, slice_select_intensity;
slice_select_duration := rf_duration;
slice_rephase_duration := slice_select_duration/2;
slice_select_intensity := 0.8;

numeric epi_factor_one, epi_factor_two,  epi_duration, epi_read_intensity, epi_blip_intensity;
  % Define 2 epi factors to mimic a longer one with a gap in the middle.
epi_factor_one := 3;
epi_factor_two := 2;
epi_duration := 0.25;
epi_read_intensity := 0.5;
epi_blip_intensity := 0.3;
numeric epi_dead_time;
epi_dead_time := 3.5;

numeric dashtime;
dashtime = 1.2;

%%%%%%%%%%%%
%%% EPI %%%%
%%%%%%%%%%%%
beginfig(0);

  initf;

%% The RF Axis
  numeric acq_duration, echo_time;
  acq_duration := epi_duration * epi_factor_one + dashtime + epi_duration * epi_factor_two;
  echo_time := rf_duration/2 + slice_rephase_duration + epi_dead_time + acq_duration/2;
  repetition_time := echo_time + acq_duration/2 +end_delay + rf_duration/2;

  startline(rf,"RF");
  xline(start_delay);

  ospan(rf_duration/2, -1.2, repetition_time, "TR");
  ospan(rf_duration/2, -1, echo_time, "TE");
  xpulse(rf_duration, rf_intensity, "A");
  xline(slice_rephase_duration);
  xline(epi_dead_time);
  %oecho(acq_duration/2);
  xnamedacq(acq_duration, "Acquire A");

  xline(end_delay);
  xpulse(rf_duration, rf_intensity, "B");
  xdashline(end_delay);

%% The Gz Slice Selection Axis
  startline(g0,"Slice");
  xline(start_delay);
  oguide(slice_select_duration/2, 1.2*slice_select_intensity);
  oshade(slice_select_duration/2,slice_select_duration/2,slice_select_intensity);
  xsquare(slice_select_duration, slice_select_intensity);
  oshade(0, slice_rephase_duration, -1*slice_select_intensity);
  xsquare(slice_rephase_duration, -1*slice_select_intensity);
  ospan(0,0.2,epi_dead_time*0.95, "Deadtime");
  xline(epi_dead_time);
  epireadoutz(epi_duration, 0.9*epi_blip_intensity, epi_factor_one);
  %ospan(0,0.2,dashtime*0.95, "CAIPI");
  xdashline(dashtime);
  epireadoutz(epi_duration, -0.9*epi_blip_intensity, epi_factor_two);

  xline(end_delay);
  xsquare(slice_select_duration, slice_select_intensity);% xline(rf_duration);
  xdashline(end_delay);

%% The Gy Phase Encoding Axis
  startline(g1,"Phase");
  xline(start_delay + slice_select_duration);
  xsquare(slice_rephase_duration, -1*epi_read_intensity / 2);
  %gradf((3.5cm, -5cm),1.5,-0.5);
  xline(epi_dead_time);
  epireadouty(epi_duration, epi_blip_intensity, epi_factor_one);
  xdashline(dashtime);
  epireadouty(epi_duration, epi_blip_intensity, epi_factor_two);

  xline(end_delay);
  xline(rf_duration);
  xdashline(end_delay);


%% The Gx Readout Axis
  startline(g2,"Read");
  xline(start_delay + slice_select_duration);
  xsquare(slice_rephase_duration, epi_read_intensity / 2);
  xline(epi_dead_time);
  epireadoutx(epi_duration, epi_read_intensity, epi_factor_one);
  xdashline(dashtime);
  epireadoutx(epi_duration, -epi_read_intensity, epi_factor_two);

  xline(end_delay);
  xline(rf_duration);
  xdashline(end_delay);


%% Set background to white.
  picture pic;
  pic := currentpicture;
  currentpicture := nullpicture;
  fillwhite(pic);


endfig;

%%%%%%%%%%%%%
%%% MESH %%%%
%%%%%%%%%%%%%

epi_dead_time := 0.2;
slice_rephase_duration := slice_rephase_duration*2;
end_delay := slice_rephase_duration/2; % Rephase

beginfig(1);

  initf;

%% The RF Axis
  numeric acq_duration, echo_time;
  acq_duration := epi_duration * epi_factor_one + dashtime + epi_duration * epi_factor_two;
  echo_time := rf_duration/2 + slice_rephase_duration + epi_dead_time + acq_duration/2;
  repetition_time := echo_time + acq_duration/2 +end_delay + rf_duration/2;

  % MESH
  echo_time := echo_time + repetition_time;

  startline(rf,"RF");
  xline(start_delay);

  ospan(rf_duration/2, -1.2, repetition_time, "TR");
  ospan(rf_duration/2, -1, echo_time, "TE");


  xpulse(rf_duration, rf_intensity, "A");
  xline(slice_rephase_duration);
  xline(epi_dead_time);

  xnamedacq(acq_duration, "");

  xline(end_delay);
  %---------- Start new volume
  xpulse(rf_duration, rf_intensity, "B");
  xline(slice_rephase_duration);
  xline(epi_dead_time);

  xnamedacq(acq_duration, "Acquire A");

  xdashline(0.3);

%% The Gz Slice Selection Axis
  startline(g0,"Slice");
  xline(start_delay);
  oguide(slice_select_duration/2, 1.2*slice_select_intensity);
  oshade(slice_select_duration/2,slice_select_duration/2,slice_select_intensity);
  xsquare(slice_select_duration, slice_select_intensity);
  oshade(0, slice_rephase_duration/2, -1*slice_select_intensity);
  xsquare(slice_rephase_duration, -1*slice_select_intensity);
  oredshade(0, -slice_rephase_duration/2, -1*slice_select_intensity);
  %ospan(0,0.2,epi_dead_time*0.95, "Deadtime");
  xline(epi_dead_time);
  epireadoutz(epi_duration, 0.9*epi_blip_intensity, epi_factor_one);
  xdashline(dashtime);
  epireadoutz(epi_duration, -0.9*epi_blip_intensity, epi_factor_two);

  xsquare(slice_rephase_duration/2, 1*slice_select_intensity);
  oredshade(0, -slice_rephase_duration/2, 1*slice_select_intensity);
  oguide(0, 1.2*slice_select_intensity);
  oredshade(0, slice_select_duration/2, 1*slice_select_intensity);
  oguide( +slice_select_duration/2, 1.2*slice_select_intensity);

%  xline(end_delay);

  %-------- Start new volume
  xsquare(slice_select_duration, slice_select_intensity);% xline(rf_duration);
  xsquare(slice_rephase_duration, -1*slice_select_intensity);
  oredshade(0, -slice_rephase_duration/2, -1*slice_select_intensity);
  xline(epi_dead_time);
  epireadoutz(epi_duration, 0.9*epi_blip_intensity, epi_factor_one);
  xdashline(dashtime);
  epireadoutz(epi_duration, -0.9*epi_blip_intensity, epi_factor_two);

  xdashline(0.3);

 % xline(end_delay);




%% The Gy Phase Encoding Axis
  startline(g1,"Phase");
  xline(start_delay);
  xline(slice_select_duration);
  xsquare(slice_rephase_duration/2, -1*epi_read_intensity / 2);
  xline(slice_rephase_duration/2);
  %gradf((3.5cm, -5cm),1.5,-0.5);
  xline(epi_dead_time);
  epireadouty(epi_duration, epi_blip_intensity, epi_factor_one);
  xdashline(dashtime);
  epireadouty(epi_duration, epi_blip_intensity, epi_factor_two);

  oorangeshade(0, end_delay, -1*epi_read_intensity / 2);
  xsquare(end_delay, -1*epi_read_intensity / 2);
  %xline(end_delay/2);
  %xline(end_delay);

  %-------- Start new volume
  xline(rf_duration);
  %xline(slice_rephase_duration/2);
  xsquare(slice_rephase_duration/2, -1*epi_read_intensity / 2);
  xline(slice_rephase_duration/2);
  %gradf((3.5cm, -5cm),1.5,-0.5);
  xline(epi_dead_time);
  epireadouty(epi_duration, epi_blip_intensity, epi_factor_one);
  xdashline(dashtime);
  epireadouty(epi_duration, epi_blip_intensity, epi_factor_two);
  xdashline(0.3);
  %xline(end_delay);


%% The Gx Readout Axis
  startline(g2,"Read");
  xline(start_delay);
  xline(slice_select_duration);
  xsquare(slice_rephase_duration/2, epi_read_intensity / 2);
  xline(epi_dead_time);
  xline(slice_rephase_duration/2);
  epireadoutx(epi_duration, epi_read_intensity, epi_factor_one);
  xdashline(dashtime);
  epireadoutx(epi_duration, -epi_read_intensity, epi_factor_two);

  oorangeshade(0, end_delay, epi_read_intensity / 2);
  xsquare(end_delay, epi_read_intensity / 2);
  %xline(end_delay/2);

%  xline(end_delay);

  %-------- Start new volume

  xline(rf_duration);
  xsquare(slice_rephase_duration/2, epi_read_intensity / 2);
  xline(epi_dead_time);
  xline(slice_rephase_duration/2);
  epireadoutx(epi_duration, epi_read_intensity, epi_factor_one);
  xdashline(dashtime);
  epireadoutx(epi_duration, -epi_read_intensity, epi_factor_two);

  %xsquare(end_delay, epi_read_intensity / 2);
  xdashline(0.3);
  %xline(end_delay);


%% Set background to white.
  picture pic;
  pic := currentpicture;
  currentpicture := nullpicture;
  fillwhite(pic);


endfig;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dedicated explanations.
%%%%%%%%%%%%%%%%%%%%%%%%%%
beginfig(2);
  initf;

%% The RF Axis
  numeric acq_duration, echo_time;
  acq_duration := epi_duration * epi_factor_one + dashtime + epi_duration * epi_factor_two;
  echo_time := rf_duration/2 + slice_rephase_duration + epi_dead_time + acq_duration/2;
  repetition_time := echo_time + acq_duration/2 +end_delay + rf_duration/2;

  % MESH
  echo_time := echo_time + repetition_time;

  startline(rf,"RF");
  xline(start_delay);

  ospan(rf_duration/2, -1.2, repetition_time, "TR");
  ospan(rf_duration/2, -1, echo_time, "TE");


  xpulse(rf_duration, rf_intensity, "A");
  xline(slice_rephase_duration);
  xline(epi_dead_time);

  xnamedacq(acq_duration, "");

  xline(end_delay);
  %---------- Start new volume
  xpulse(rf_duration, rf_intensity, "B");
  xline(slice_rephase_duration);
  xline(epi_dead_time);

  xnamedacq(acq_duration, "Acquire A");

  xdashline(0.3);

%% The Gz Slice Selection Axis
  startline(g0,"Slice");
  xline(start_delay);
  oguide(slice_select_duration/2, 1.2*slice_select_intensity);
  oshade(slice_select_duration/2,slice_select_duration/2,slice_select_intensity);
  xsquare(slice_select_duration, slice_select_intensity);
  oshade(0, slice_rephase_duration/2, -1*slice_select_intensity);
  xsquare(slice_rephase_duration, -1*slice_select_intensity);
  oredshade(0, -slice_rephase_duration/2, -1*slice_select_intensity);
  %ospan(0,0.2,epi_dead_time*0.95, "Deadtime");
  xline(epi_dead_time);
  epireadoutz(epi_duration, 0.9*epi_blip_intensity, epi_factor_one);
  xdashline(dashtime);
  epireadoutz(epi_duration, -0.9*epi_blip_intensity, epi_factor_two);

  xsquare(slice_rephase_duration/2, 1*slice_select_intensity);
  oredshade(0, -slice_rephase_duration/2, 1*slice_select_intensity);
  oguide(0, 1.2*slice_select_intensity);
  oredshade(0, slice_select_duration/2, 1*slice_select_intensity);
  oguide( +slice_select_duration/2, 1.2*slice_select_intensity);

%  xline(end_delay);

  %-------- Start new volume
  xsquare(slice_select_duration, slice_select_intensity);% xline(rf_duration);
  xsquare(slice_rephase_duration, -1*slice_select_intensity);
  oredshade(0, -slice_rephase_duration/2, -1*slice_select_intensity);
  xline(epi_dead_time);
  epireadoutz(epi_duration, 0.9*epi_blip_intensity, epi_factor_one);
  xdashline(dashtime);
  epireadoutz(epi_duration, -0.9*epi_blip_intensity, epi_factor_two);

  xdashline(0.3);

%% Set background to white.
  picture pic;
  pic := currentpicture;
  currentpicture := nullpicture;
  fillwhite(pic);



 % xline(end_delay);

endfig;

beginfig(3);

  %% The Gy Phase Encoding Axis
  startline(g1,"Phase");
  xline(start_delay);
  xline(slice_select_duration);
  xsquare(slice_rephase_duration/2, -1*epi_read_intensity / 2);
  xline(slice_rephase_duration/2);
  %gradf((3.5cm, -5cm),1.5,-0.5);
  xline(epi_dead_time);
  epireadouty(epi_duration, epi_blip_intensity, epi_factor_one);
  xdashline(dashtime);
  epireadouty(epi_duration, epi_blip_intensity, epi_factor_two);

  oorangeshade(0, end_delay, -1*epi_read_intensity / 2);
  xsquare(end_delay, -1*epi_read_intensity / 2);
  %xline(end_delay/2);
  %xline(end_delay);

  %-------- Start new volume
  xline(rf_duration);
  %xline(slice_rephase_duration/2);
  xsquare(slice_rephase_duration/2, -1*epi_read_intensity / 2);
  xline(slice_rephase_duration/2);
  %gradf((3.5cm, -5cm),1.5,-0.5);
  xline(epi_dead_time);
  epireadouty(epi_duration, epi_blip_intensity, epi_factor_one);
  xdashline(dashtime);
  epireadouty(epi_duration, epi_blip_intensity, epi_factor_two);
  xdashline(0.3);
  %xline(end_delay);


%% The Gx Readout Axis
  startline(g2,"Read");
  xline(start_delay);
  xline(slice_select_duration);
  xsquare(slice_rephase_duration/2, epi_read_intensity / 2);
  xline(epi_dead_time);
  xline(slice_rephase_duration/2);
  epireadoutx(epi_duration, epi_read_intensity, epi_factor_one);
  xdashline(dashtime);
  epireadoutx(epi_duration, -epi_read_intensity, epi_factor_two);

  oorangeshade(0, end_delay, epi_read_intensity / 2);
  xsquare(end_delay, epi_read_intensity / 2);
  %xline(end_delay/2);

%  xline(end_delay);

  %-------- Start new volume

  xline(rf_duration);
  xsquare(slice_rephase_duration/2, epi_read_intensity / 2);
  xline(epi_dead_time);
  xline(slice_rephase_duration/2);
  epireadoutx(epi_duration, epi_read_intensity, epi_factor_one);
  xdashline(dashtime);
  epireadoutx(epi_duration, -epi_read_intensity, epi_factor_two);

  %xsquare(end_delay, epi_read_intensity / 2);
  xdashline(0.3);
  %xline(end_delay);


%% Set background to white.
  picture pic;
  pic := currentpicture;
  currentpicture := nullpicture;
  fillwhite(pic);


endfig;



end;
