function Spk_info

%% Spike Info 
%  - Update below when a new rat is included
%
%  - Structure: 
%      CNT(.).name  = 'Rat_ID';
%      CNT(.).R_chn = {ctx_chn#_list, pyr_chn#_list, slm_chn#_list};  
%      CNT(.).L_chn = {ctx_chn#_list, pyr_chn#_list, slm_chn#_list};
%      CNT(.).R_cor = [];          u  % for old 32-chn recording
%      Same for SEE(.), AEE(.), W2A(.), W2C(.), M1Aare(.), M1C(.) etc
%      
%      .R_Unt(.).clustr = {'session1','session2','session3'};
%      .R_Unt(.).type   = [];         % 1-theta,2-sws,empty-n/a
%      .R_Unt(.).egTm   = {'Tm1','Tm2','Tm3','Tm4'};
%      Same for L_Unt.
%
%   - Add Unt in (call Spk_update_unt)
%      Based on parent info, add Unt to data structure (e.g, CNT, SEE...)
%
%   - Save everything in a mat file
% _________________________________________________________________________

% Update Rat Info

ACU(1).name  = 'A01';   ACU(1).L_cor = 32; ACU(1).R_chn = {[3 3 3], [11 11 11],    [15 15 15]};       ACU(1).L_chn = {[7 7 7], [26 26 29], [32 32 32]};
ACU(2).name  = 'A02';   ACU(2).L_cor = 32; ACU(2).R_chn = {[3 3 3], [11 11 11],    [15 15 15]};       ACU(2).L_chn = {[6 6 ],  [27 27 ],   [32 32]};
ACU(3).name  = 'A03';   ACU(3).L_cor = 32; ACU(3).R_chn = {[4 3 3], [11 11 11],    [16 16 16]};       ACU(3).L_chn = {[6 6 6], [23 25 25], [30 31 31]};
ACU(4).name  = 'A04';   ACU(4).L_cor = 32; ACU(4).R_chn = {[2 2 2], [11 10 10],    [15 15 15]};       ACU(4).L_chn = {[6 6 6], [23 23 23], [32 32 32]};
ACU(5).name  = 'A05';   ACU(5).L_cor = 32; ACU(5).R_chn = {[2 1 1], [11 10 10],    [16 15 15]};       ACU(5).L_chn = {[], [], []};
ACU(6).name  = 'A06';   ACU(6).L_cor = 32; ACU(6).R_chn = {[2 2 2], [12 12 12],    [16 16 16]};       ACU(6).L_chn = {[4 5 5], [24 25 25], [30 30 30]};
ACU(7).name  = 'A07';   ACU(7).L_cor = 32; ACU(7).R_chn = {[1 1 1], [10 10 10],    [15 15 15]};       ACU(7).L_chn = {[5 3 2], [22 20 18], [31 29 27]};
ACU(8).name  = 'A08';   ACU(8).L_cor = 32; ACU(8).R_chn = {[2 3 3], [11 12 12],    [16 15 15]};       ACU(8).L_chn = {[2 4 5], [21 24 25], [29 31 32]};
ACU(9).name  = 'A09';   ACU(9).L_cor = 32; ACU(9).R_chn = {[2 1 1], [10 8 8],    [14 16 16]};       ACU(9).L_chn = {[3 1 1], [20 15 15], [30 24 24]};
ACU(10).name = 'A10';   ACU(10).L_cor= 0;  ACU(10).R_chn= {[17 17 17], [26 25 25], [32 32 32]};    ACU(10).L_chn= {[5 1 1], [10 6 6],    [15 11 11]};
ACU(11).name = 'A11';   ACU(11).L_cor= 0;  ACU(11).R_chn= {[17 17 17], [26 25 26], [30 30 30]};    ACU(11).L_chn= {[5 1 2], [10 6 7],    [15 11 12]};
ACU(12).name = 'A12';   ACU(12).L_cor= 0;  ACU(12).R_chn= {[23 23 23], [26 26 26], [31 31 31]};    ACU(12).L_chn= {[1 1 1], [9 9 9],    [14 14 14]};

CCAO(1).name  = 'j01';   CCAO(1).L_cor = 32;  CCAO(1).R_chn = {[3 3 3], [12 12 12],    [16 16 16]};       CCAO(1).L_chn = {[5 5 5], [23 23 23], [31 31 31]};
CCAO(2).name  = 'j02';   CCAO(2).L_cor = 32;  CCAO(2).R_chn = {[3 3 3], [12 12 12],    [16 16 16]};       CCAO(2).L_chn = {[5 5 5], [23 23 23], [31 31 31]};
CCAO(3).name  = 'j03';   CCAO(3).L_cor = 32;  CCAO(3).R_chn = {[3 3 3], [12 12 12],    [16 16 16]};       CCAO(3).L_chn = {[5 5 5], [23 23 23], [31 31 31]};
CCAO(4).name  = 'j04';   CCAO(4).L_cor = 32;  CCAO(4).R_chn = {[3 3 3], [12 12 12],    [16 16 16]};       CCAO(4).L_chn = {[5 5 5], [23 23 23], [31 31 31]};
CCAO(5).name  = 'j05';   CCAO(5).L_cor = 32;  CCAO(5).R_chn = {[3 3 3], [12 12 12],    [16 16 16]};       CCAO(5).L_chn = {[5 5 5], [23 23 23], [31 31 31]};
CCAO(6).name  = 'j06';   CCAO(6).L_cor = 32;  CCAO(6).R_chn = {[3 3 3], [11 11 11],    [15 15 15]};       CCAO(6).L_chn = {[5 5 5], [26 26 26],[31 31 31]};
CCAO(7).name  = 'j07';   CCAO(7).L_cor = 32;  CCAO(7).R_chn = {[3 3 3], [12 12 12],    [16 16 16]};       CCAO(7).L_chn = {[5 5 5], [23 23 23], [31 31 31]};
CCAO(8).name  = 'j08';   CCAO(8).L_cor = 32;  CCAO(8).R_chn = {[3 3 3], [11 11 11],    [16 16 16]};       CCAO(8).L_chn = {[5 5 6], [24 24 25], [30 30 30]};
CCAO(9).name  = 'j09';   CCAO(9).L_cor = 32;  CCAO(9).R_chn = {[2 2 2], [10 10 10],    [15 15 15]};       CCAO(9).L_chn = {[6 6 6], [24 24 24], [30 30 28]};
CCAO(10).name = 'j10';   CCAO(10).L_cor = 32; CCAO(10).R_chn = {[2 1 1], [11 10 10],    [16 15 15]};      CCAO(10).L_chn = {[4 4 4], [22 22 22], [30 30 30]};
CCAO(11).name = 'j11';   CCAO(11).L_cor = 32; CCAO(11).R_chn = {[2 2 2], [10 10 10],    [15 15 15]};      CCAO(11).L_chn = {[4 4 3], [22 22 21], [30 30 29]};
CCAO(12).name = 'j12';   CCAO(12).L_cor = 32; CCAO(12).R_chn = {[1 1 1], [10 10 10],    [15 15 15]};      CCAO(12).L_chn = {[4 4 3], [21 21 20], [28 28 27]};

CNT(1).name  = 'C01';   CNT(1).L_cor = 32; CNT(1).R_chn = {[4 4 4], [9 9 9],    [16 16 16]}; CNT(1).L_chn = {[7 7 7], [18 18 18], [32 32 32]};
CNT(2).name  = 'C04';   CNT(2).L_cor = 32; CNT(2).R_chn = {[1 1 1], [7 7 7],    [15 15 15]}; CNT(2).L_chn = {[], [], []};
CNT(3).name  = 'C07';   CNT(3).L_cor = 0;  CNT(3).R_chn = {[17 17], [22 22],    [29 29]};    CNT(3).L_chn = {[], [], []};
CNT(4).name  = 'C10';   CNT(4).L_cor = 0;  CNT(4).R_chn = {[], [], []};                      CNT(4).L_chn = {[2 2],   [7 7],      [16 16]};
CNT(5).name  = 'C11';   CNT(5).L_cor = 0;  CNT(5).R_chn = {[17 17], [23 23],    [31 31]};    CNT(5).L_chn = {[1 1],   [7 7],      [15 15]};
CNT(6).name  = 'C18';   CNT(6).L_cor = 0;  CNT(6).R_chn = {[17 17], [23 23],    [31 31]};    CNT(6).L_chn = {[1 1],   [7 7],      [15 15]};
CNT(7).name  = 'C19';   CNT(7).L_cor = 0;  CNT(7).R_chn = {[17 17], [23 23],    [31 31]};    CNT(7).L_chn = {[1 1],   [7 7],      [15 15]};
CNT(8).name  = 'C20';   CNT(8).L_cor = 0;  CNT(8).R_chn = {[18 18], [23 24],    [31 32]};    CNT(8).L_chn = {[2 2],   [7 7],      [16 16]};
CNT(9).name  = 'C21';   CNT(9).L_cor = 0;  CNT(9).R_chn = {[17 17], [23 23],    [32 32]};    CNT(9).L_chn = {[1 1],   [7 7],      [15 15]};
CNT(10).name = 'C22';   CNT(10).L_cor= 0;  CNT(10).R_chn= {[18 18], [23 23],    [31 31]};    CNT(10).L_chn= {[1 1],   [7 7],      [15 15]};
CNT(11).name = 'C23';   CNT(11).L_cor= 0;  CNT(11).R_chn= {[17 17], [23 23],    [32 32]};    CNT(11).L_chn= {[1 1],   [7 7],      [15 15]};
CNT(12).name = 'C24';   CNT(12).L_cor= 0;  CNT(12).R_chn= {[18 18], [23 23],    [30 30]};    CNT(12).L_chn= {[1 1],   [7 7],      [15 15]};

CNQX(1).name  = 'E21';   CNQX(1).L_cor = 0; CNQX(1).R_chn = {[5 5 5 6], [11 11 11 12],    [16 16 16 16]};       CNQX(1).L_chn = {[], [], []};
CNQX(2).name  = 'E22';   CNQX(2).L_cor = 0; CNQX(2).R_chn = {[3 3 4 5], [9 9 10 11],    [14 14 15 16]};       CNQX(2).L_chn = {[], [], []};
CNQX(3).name  = 'E23';   CNQX(3).L_cor = 0; CNQX(3).R_chn = {[3 3 4 4], [9 9 10 10],    [14 14 15 15]};       CNQX(3).L_chn = {[], [], []};
CNQX(4).name  = 'E24';   CNQX(4).L_cor = 0; CNQX(4).R_chn = {[4 4 5 6], [10 10 11 12],    [15 15 16 16]};       CNQX(4).L_chn = {[], [], []};
CNQX(5).name  = 'E25';   CNQX(5).L_cor = 0; CNQX(5).R_chn = {[3 3 3 3], [9 9 9 9],    [14 14 14 14]};       CNQX(5).L_chn = {[], [], []};
CNQX(6).name  = 'E27';   CNQX(6).L_cor = 0; CNQX(6).R_chn = {[3 3 3 3], [9 9 9 9],    [14 14 14 14]};       CNQX(6).L_chn = {[], [], []};
CNQX(7).name  = 'E28';   CNQX(7).L_cor = 0; CNQX(7).R_chn = {[3 3 5 4], [9 9 11 10],    [14 14 16 15]};       CNQX(7).L_chn = {[], [], []};
CNQX(8).name  = 'E29';   CNQX(8).L_cor = 0; CNQX(8).R_chn = {[2 2 2 2], [8 8 8 8],    [13 13 13 13]};       CNQX(8).L_chn = {[], [], []};
CNQX(9).name  = 'E30';   CNQX(9).L_cor = 0; CNQX(9).R_chn = {[1 1 1 1], [7 7 7 7],    [12 12 12 12]};       CNQX(9).L_chn = {[], [], []};
CNQX(10).name  = 'E31a';   CNQX(10).L_cor = 0; CNQX(10).R_chn = {[5 5 5], [11 11 11],   [16 16 16]};       CNQX(10).L_chn = {[], [], []};
CNQX(11).name  = 'E32a';   CNQX(11).L_cor = 0; CNQX(11).R_chn = {[4 5 5], [10 11 11],   [15 16 16]};       CNQX(11).L_chn = {[], [], []};
CNQX(12).name  = 'E33a';   CNQX(12).L_cor = 0; CNQX(12).R_chn = {[4 4 4], [10 10 10],    [16 16 16]};       CNQX(12).L_chn = {[], [], []};
CNQX(13).name  = 'E34a';   CNQX(13).L_cor = 0; CNQX(13).R_chn = {[4 4 4], [10 10 10],    [15 15 15]};       CNQX(13).L_chn = {[], [], []};
CNQX(14).name  = 'E35a';   CNQX(14).L_cor = 0; CNQX(14).R_chn = {[4 4 4], [10 10 10],    [15 15 15]};       CNQX(14).L_chn = {[], [], []};

ACUX(1).name  = 'xsf04';   ACUX(1).L_cor = 32; ACUX(1).R_chn = {[1 4 4], [1 13 13], [1 16 16]};       ACUX(1).L_chn = {[13 13 13], [25 26 26], [32 32 32]};
ACUX(2).name  = 'xsf08';   ACUX(2).L_cor = 32; ACUX(2).R_chn = {[3 3 3 3 3 3 3 3], [12 12 12 12 12 12 12 12], [16 15 16 15 15 15 15 15]};       ACUX(2).L_chn = {[12 12 12 13 13 13 13 13],  [24 24 24 25 25 25 25 25], [30 30 30 31 31 31 31 31]};
ACUX(3).name  = 'xsf09';   ACUX(3).L_cor = 32; ACUX(3).R_chn = {[4 4 3 3 3], [14 12 11 11 11], [16 14 14 14 14]};  ACUX(3).L_chn = {[13 13 13 13 2], [25 25 25 25 11], [31 31 30 31 20]};
ACUX(4).name  = 'xsf15';   ACUX(4).L_cor = 32; ACUX(4).R_chn = {[4 4 4 3 3], [12 13 12 11 11], [15 16 15 14 14]};  ACUX(4).L_chn = {[13 13 13 13 13], [25 25 25 25 25], [31 31 31 31 31]};
% ACUX(5).name  = 'bx23';   ACUX(4).L_cor = 32; ACUX(4).R_chn = {[4 4 4 3 3], [12 13 12 11 11], [15 16 15 14 14]};  ACUX(4).L_chn = {[13 13 13 13 13], [25 25 25 25 25], [31 31 31 31 31]};
% ACUX(6).name  = 'bx35';   ACUX(4).L_cor = 32; ACUX(4).R_chn = {[4 4 4 3 3], [12 13 12 11 11], [15 16 15 14 14]};  ACUX(4).L_chn = {[13 13 13 13 13], [25 25 25 25 25], [31 31 31 31 31]};
% ACUX(7).name  = 'bx36';   ACUX(4).L_cor = 32; ACUX(4).R_chn = {[4 4 4 3 3], [12 13 12 11 11], [15 16 15 14 14]};  ACUX(4).L_chn = {[13 13 13 13 13], [25 25 25 25 25], [31 31 31 31 31]};

% dMCAO4W(1).name  = 'E21';   dMCAO4W(1).L_cor = 0; dMCAO4W(1).R_chn = {[5 5 5 6], [11 11 11 12],    [16 16 16 16]};  dMCAO4W(1).L_chn = {[], [], []};
% dMCAO4W(2).name  = 'E22';   dMCAO4W(2).L_cor = 0; dMCAO4W(2).R_chn = {[3 3 4 5], [9 9 10 11],    [14 14 15 16]};    dMCAO4W(2).L_chn = {[], [], []};
% dMCAO4W(3).name  = 'E23';   dMCAO4W(3).L_cor = 0; dMCAO4W(3).R_chn = {[3 3 4 4], [9 9 10 10],    [14 14 15 15]};    dMCAO4W(3).L_chn = {[], [], []};
% dMCAO4W(4).name  = 'E24';   dMCAO4W(4).L_cor = 0; dMCAO4W(4).R_chn = {[4 4 5 6], [10 10 11 12],    [15 15 16 16]};  dMCAO4W(4).L_chn = {[], [], []};
% dMCAO4W(5).name  = 'E25';   dMCAO4W(5).L_cor = 0; dMCAO4W(5).R_chn = {[3 3 3 3], [9 9 9 9],    [14 14 14 14]};      dMCAO4W(5).L_chn = {[], [], []};
% dMCAO4W(6).name  = 'E27';   dMCAO4W(6).L_cor = 0; dMCAO4W(6).R_chn = {[3 3 3 3], [9 9 9 9],    [14 14 14 14]};      dMCAO4W(6).L_chn = {[], [], []};
% dMCAO4W(7).name  = 'E28';   dMCAO4W(7).L_cor = 0; dMCAO4W(7).R_chn = {[3 3 5 4], [9 9 11 10],    [14 14 16 15]};    dMCAO4W(7).L_chn = {[], [], []};
% dMCAO4W(8).name  = 'E29';   dMCAO4W(8).L_cor = 0; dMCAO4W(8).R_chn = {[2 2 2 2], [8 8 8 8],    [13 13 13 13]};      dMCAO4W(8).L_chn = {[], [], []};

SEE(1).name  = 'SE01';  SEE(1).R_cor = 0;  SEE(1).R_chn = {[17 17], [23 23],    [30 30]};    SEE(1).L_chn = {[2 2],   [7 7],      [14 14]};
SEE(2).name  = 'SE02';  SEE(2).R_cor = 0;  SEE(2).R_chn = {[17 17], [23 23],    [30 30]};    SEE(2).L_chn = {[2 2],   [7 7],      [14 14]};
SEE(3).name  = 'SE03';  SEE(3).R_cor = 0;  SEE(3).R_chn = {[17 17], [22 22],    [30 30]};    SEE(3).L_chn = {[2 2],   [7 7],      [14 14]};
SEE(4).name  = 'SE04';  SEE(4).R_cor = 0;  SEE(4).R_chn = {[17 17], [23 23],    [31 31]};    SEE(4).L_chn = {[1 1],   [7 7],      [14 14]};
SEE(5).name  = 'SE05';  SEE(5).R_cor = 0;  SEE(5).R_chn = {[17 17], [22 23],    [31 31]};    SEE(5).L_chn = {[1 1],   [7 7],      [14 14]};
SEE(6).name  = 'SE06';  SEE(6).R_cor = 0;  SEE(6).R_chn = {[17 17], [22 22],    [31 31]};    SEE(6).L_chn = {[2 2],   [7 7],      [14 14]};
SEE(7).name  = 'SE07';  SEE(7).R_cor = 0;  SEE(7).R_chn = {[17 17], [23 23],    [31 31]};    SEE(7).L_chn = {[1 1],   [7 7],      [15 15]};
SEE(8).name  = 'SE08';  SEE(8).R_cor = 0;  SEE(8).R_chn = {[17 17], [23 23],    [31 31]};    SEE(8).L_chn = {[1 1],   [7 7],      [15 15]};
SEE(9).name  = 'SE09';  SEE(9).R_cor = 0;  SEE(9).R_chn = {[17 17], [22 22],    [30 30]};    SEE(9).L_chn = {[1 1],   [7 7],      [15 15]};
SEE(10).name = 'SE10';  SEE(10).R_cor= 0;  SEE(10).R_chn= {[17 17], [22 22],    [29 29]};    SEE(10).L_chn= {[2 2],   [7 7],      [14 14]};

AEE(1).name  = 'AEE01'; AEE(1).R_cor = 0;  AEE(1).R_chn = {[17 17], [22 22],    [29 29]};    AEE(1).L_chn = {[1 1],   [6 6],      [13 13]};
AEE(2).name  = 'AEE02'; AEE(2).R_cor = 0;  AEE(2).R_chn = {[17 17], [23 23],    [30 30]};    AEE(2).L_chn = {[1 1],   [7 7],      [15 15]};
AEE(3).name  = 'AEE03'; AEE(3).R_cor = 0;  AEE(3).R_chn = {[18 18], [23 23],    [30 30]};    AEE(3).L_chn = {[1 1],   [6 6],      [14 14]};
AEE(4).name  = 'AEE04'; AEE(4).R_cor = 0;  AEE(4).R_chn = {[17 17], [23 23],    [29 29]};    AEE(4).L_chn = {[1 1],   [6 6],      [14 14]};
AEE(5).name  = 'AEE05'; AEE(5).R_cor = 0;  AEE(5).R_chn = {[17 17], [23 23],    [30 30]};    AEE(5).L_chn = {[], [], []};
AEE(6).name  = 'AEE06'; AEE(6).R_cor = 0;  AEE(6).R_chn = {[18 18], [23 23],    [30 30]};    AEE(6).L_chn = {[1 1],   [6 6],      [16 16]};
AEE(7).name  = 'AEE07'; AEE(7).R_cor = 0;  AEE(7).R_chn = {[18 18], [23 23],    [31 31]};    AEE(7).L_chn = {[1 1],   [6 6],      [14 14]};
AEE(8).name  = 'AEE08'; AEE(8).R_cor = 0;  AEE(8).R_chn = {[18 18], [23 23],    [30 30]};    AEE(8).L_chn = {[1 1],   [6 6],      [14 14]};
AEE(9).name  = 'AEE09'; AEE(9).R_cor = 0;  AEE(9).R_chn = {[18 18], [23 23],    [31 31]};    AEE(9).L_chn = {[1 1],   [6 6],      [15 15]};
AEE(10).name = 'AEE10'; AEE(10).R_cor= 0;  AEE(10).R_chn= {[18 18], [23 23],    [31 31]};    AEE(10).L_chn= {[1 1],   [6 6],      [16 16]};

W2A(1).name  = '2WA01'; W2A(1).R_cor = 32; W2A(1).R_chn = {[3 3 3], [8 8 8],    [16 16 16]}; W2A(1).L_chn = {[], [], []};
W2A(2).name  = '2WA02'; W2A(2).R_cor = 32; W2A(2).R_chn = {[1 1 1], [7 7 7],    [14 14 14]}; W2A(2).L_chn = {[1 1 1], [14 14 14], [28 28 28]};
W2A(3).name  = '2WA04'; W2A(3).R_cor = 0;  W2A(3).R_chn = {[],[],[]};                        W2A(3).L_chn = {[2 2 2], [7  7  8],  [14 14 14]};
W2A(4).name  = '2WA05'; W2A(4).R_cor = 0;  W2A(4).R_chn = {[18 18 18],[23 23 23],[30 30 30]};W2A(4).L_chn = {[1 1 1], [6  6  6],  [15 15 15]};
W2A(5).name  = '2WA06'; W2A(5).R_cor = 0;  W2A(5).R_chn = {[17 17 17],[23 23 23],[32 32 32]};W2A(5).L_chn = {[2 2 2], [7  7  7],  [16 16 16]};
W2A(6).name  = '2WA07'; W2A(6).R_cor = 0;  W2A(6).R_chn = {[17 17 17],[23 23 23],[31 32 31]};W2A(6).L_chn = {[2 2 2], [7  7  7],  [16 16 16]};
W2A(7).name  = '2WA08'; W2A(7).R_cor = 0;  W2A(7).R_chn = {[17 17], [22 22],    [30 30]};    W2A(7).L_chn = {[1 1],   [7 7],      [15 15]};
W2A(8).name  = '2WA10'; W2A(8).R_cor = 0;  W2A(8).R_chn = {[17 17], [23 23],    [32 32]};    W2A(8).L_chn = {[2 2],   [7 7],      [16 16]};
W2A(9).name  = '2WA12'; W2A(9).R_cor = 0;  W2A(9).R_chn = {[17 17], [22 22],    [30 30]};    W2A(9).L_chn = {[1 1],   [6 6],      [14 14]};

W2C(1).name  ='14d-j02';W2C(1).R_cor = 32; W2C(1).R_chn = {[1  1],  [7 7],      [14 14]};    W2C(1).L_chn = {[], [], []};
W2C(2).name  ='14d-j17';W2C(2).R_cor = 0;  W2C(2).R_chn = {[17 17], [23 23],    [30 31]};    W2C(2).L_chn = {[1 1],   [6 6],      [15 15]};
W2C(3).name  ='14d-j19';W2C(3).R_cor = 0;  W2C(3).R_chn = {[17 17], [22 22],    [30 30]};    W2C(3).L_chn = {[], [], []};
W2C(4).name  ='14d-j20';W2C(4).R_cor = 0;  W2C(4).R_chn = {[17 17], [22 22],    [30 30]};    W2C(4).L_chn = {[], [], []};
W2C(5).name  ='14d-j21';W2C(5).R_cor = 0;  W2C(5).R_chn = {[17 17], [22 22],    [30 30]};    W2C(5).L_chn = {[2 2],   [7 7],      [15 15]};
W2C(6).name  ='14d-j22';W2C(6).R_cor = 0;  W2C(6).R_chn = {[17 17], [23 23],    [31 31]};    W2C(6).L_chn = {[1 1],   [7 7],      [14 14]};
W2C(7).name  ='14d-j23';W2C(7).R_cor = 0;  W2C(7).R_chn = {[17 17], [23 23],    [30 30]};    W2C(7).L_chn = {[1 1],   [7 7],      [14 14]};
W2C(8).name  ='14d-j24';W2C(8).R_cor = 0;  W2C(8).R_chn = {[17 17], [23 23],    [31 31]};    W2C(8).L_chn = {[1 1],   [7 7],      [15 15]};
W2C(9).name  ='14d-j25';W2C(9).R_cor = 0;  W2C(9).R_chn = {[17 17], [23 23],    [30 30]};    W2C(9).L_chn = {[2 2],   [7 7],      [15 15]};

M1A(1).name  = 'M1A01'; M1A(1).R_cor = 0;  M1A(1).R_chn = {[18 18 18],[23 23 23],[31 31 31]};M1A(1).L_chn = {[2 2 2], [7 7 7],    [15 15 15]};
M1A(2).name  = 'M1A02'; M1A(2).R_cor = 0;  M1A(2).R_chn = {[17 17],   [23 23],   [31 31]};   M1A(2).L_chn = {[2 2],   [7 7],      [15 15]};
M1A(3).name  = 'M1A03'; M1A(3).R_cor = 0;  M1A(3).R_chn = {[18 18],   [23 23],   [30 30]};   M1A(3).L_chn = {[1 1],   [6 6],      [14 14]};
M1A(4).name  = 'M1A04'; M1A(4).R_cor = 0;  M1A(4).R_chn = {[18 18],   [23 23],   [31 31]};   M1A(4).L_chn = {[2 2],   [7 7],      [15 15]};
M1A(5).name  = 'M1A05'; M1A(5).R_cor = 0;  M1A(5).R_chn = {[17 17],   [23 23],   [30 30]};   M1A(5).L_chn = {[],[],[]};
M1A(6).name  = 'M1A06'; M1A(6).R_cor = 0;  M1A(6).R_chn = {[17 17],   [23 23],   [30 30]};   M1A(6).L_chn = {[1 1],   [7 7],      [14 14]};
M1A(7).name  = 'M1A07'; M1A(7).R_cor = 0;  M1A(7).R_chn = {[18 18],   [23 23],   [31 31]};   M1A(7).L_chn = {[1 1],   [7 7],      [15 15]};
M1A(8).name  = 'M1A08'; M1A(8).R_cor = 0;  M1A(8).R_chn = {[18 18],   [23 23],   [30 30]};   M1A(8).L_chn = {[2 2],   [7 7],      [15 15]};
M1A(9).name  = 'M1A09'; M1A(9).R_cor = 0;  M1A(9).R_chn = {[18 18],   [23 23],   [30 30]};   M1A(9).L_chn = {[2 2],   [7 7],      [15 15]};
M1A(10).name = 'M1A10'; M1A(10).R_cor= 0;  M1A(10).R_chn= {[17 17],   [23 23],   [30 30]};   M1A(10).L_chn= {[1 1],   [7 7],      [15 15]};
M1A(11).name = 'M1A11'; M1A(11).R_cor= 0;  M1A(11).R_chn= {[18 18],   [23 23],   [30 30]};   M1A(11).L_chn= {[2 2],   [7 7],      [14 14]};

AD(1).name  = 'AD6'; AD(1).L_cor = 1;  AD(1).R_chn = {[1 1],[8 8],[12 12]};            AD(1).L_chn = {[2 2], [15 13], [18 21]};
AD(2).name  = 'AD8'; AD(2).L_cor = 1;  AD(2).R_chn = {[1 1 1],[7 7 7],[13 13 13]};     AD(2).L_chn = {[1 1 1], [7 7 7], [16 16 16]};
AD(3).name  = 'AD10'; AD(3).L_cor = 0;  AD(3).R_chn = {[2 2 2],[11 11 11],[15 15 15]}; AD(3).L_chn = {[], [], []};
AD(4).name  = 'AD11'; AD(4).L_cor = 1;  AD(4).R_chn = {[1 1 1 1],[5 5 5 5],[8 8 8 8]}; AD(4).L_chn = {[3 3 3 3], [12 12 12 12], [17 17 17 17]};
AD(5).name  = 'AD12'; AD(5).L_cor = 1;  AD(5).R_chn = {[1 1],[6 6],[10 10]};           AD(5).L_chn = {[2 2], [10 10], [18 18]};
AD(6).name  = 'AD13'; AD(6).L_cor = 1;  AD(6).R_chn = {[1 1 1 1],[9 9 9 9],[12 12 12 12]};AD(6).L_chn = {[7 7 7 7], [15 15 15 15], [24 24 24 24]};
AD(7).name  = 'AD14'; AD(7).L_cor = 1;  AD(7).R_chn = {[1],[9],[14]};                  AD(7).L_chn = {[7], [16], [23]};
AD(8).name  = 'AD15'; AD(8).L_cor = 0;  AD(8).R_chn = {[1 1 1 1],[7 7 7 7],[10 10 10 10]};AD(8).L_chn = {[], [], []};
AD(9).name  = 'AD16'; AD(9).L_cor = 0;  AD(9).R_chn = {[1 1 1],[7 7 7],[11 11 11]};AD(9).L_chn = {[], [], []};
AD(10).name  = 'AD17'; AD(10).L_cor = 0;  AD(10).R_chn = {[1 1 1],[7 7 7],[10 10 10]};AD(10).L_chn = {[], [], []};
AD(11).name  = 'AD18'; AD(11).L_cor = 1;  AD(11).R_chn = {[1 1 1],[5 5 5],[9 9 9]};AD(11).L_chn = {[5 5 5], [13 13 13], [22 22 22]};
AD(12).name  = 'AD19'; AD(12).L_cor = 0;  AD(12).R_chn = {[1 1 1],[8 8 8],[13 13 13]};AD(12).L_chn = {[], [], []};
AD(13).name  = 'AD20'; AD(13).L_cor = 0;  AD(13).R_chn = {[1 1 1],[4 4 5],[7 7 8]};AD(13).L_chn = {[], [], []};
AD(14).name  = 'AD21'; AD(14).L_cor = 0;  AD(14).R_chn = {[1 1 1],[3 2 2],[6 5 5]};AD(14).L_chn = {[], [], []};
AD(15).name  = 'AD22'; AD(14).L_cor = 0;  AD(15).R_chn = {[1 1 1],[6 6 6],[10 10 10]};AD(15).L_chn = {[], [], []};
AD(16).name  = 'AD24'; AD(16).L_cor = 0;  AD(16).R_chn = {[1 1 1],[4 4 4],[9 9 9]};AD(16).L_chn = {[], [], []};
AD(17).name  = 'AD27'; AD(17).L_cor = 0;  AD(17).R_chn = {[2 2 2 2 1],[9 9 9 9 7],[14 14 14 14 11]};AD(17).L_chn = {[], [], []};
AD(18).name  = 'AD29'; AD(18).L_cor = 0;  AD(18).R_chn = {[2 2 2 2],[9 9 9 9],[12 12 12 12]};AD(18).L_chn = {[], [], []};
AD(19).name  = 'AD30'; AD(19).L_cor = 0;  AD(19).R_chn = {[2],[9],[13]};AD(19).L_chn = {[], [], []};
AD(20).name  = 'AD31'; AD(19).L_cor = 0;  AD(20).R_chn = {[],[],[]};AD(20).L_chn = {[], [], []};
AD(21).name  = 'AD32'; AD(21).L_cor = 0;  AD(21).R_chn = {[1 1 1],[6 6 6],[10 10 10]};AD(21).L_chn = {[], [], []};
AD(22).name  = 'AD33'; AD(22).L_cor = 0;  AD(22).R_chn = {[2 2 2],[7 7 7],[11 11 11]};AD(22).L_chn = {[], [], []};
AD(23).name  = 'AD34'; AD(23).L_cor = 0;  AD(23).R_chn = {[1 1 1],[3 3 3],[7 7 7]};AD(23).L_chn = {[], [], []};
AD(24).name  = 'AD35'; AD(24).L_cor = 0;  AD(24).R_chn = {[3 3 3],[8 8 8],[12 12 12]};AD(24).L_chn = {[], [], []};
AD(25).name  = 'AD36'; AD(25).L_cor = 0;  AD(25).R_chn = {[5 5 5],[10 10 10],[14 14 14]};AD(25).L_chn = {[], [], []};
AD(26).name  = 'AD37'; AD(26).L_cor = 0;  AD(26).R_chn = {[3 3 3],[8 8 8],[12 12 12]};AD(26).L_chn = {[], [], []};
AD(27).name  = 'AD38'; AD(27).L_cor = 0;  AD(27).R_chn = {[5 5 5],[10 10 10],[14 14 14]};AD(27).L_chn = {[], [], []};
AD(28).name  = 'AD39'; AD(28).L_cor = 0;  AD(28).R_chn = {[3 3],[8 8],[12 12]};AD(28).L_chn = {[], [], []};
AD(29).name  = 'AD40'; AD(29).L_cor = 0;  AD(29).R_chn = {[5 5],[10 10],[14 14]};AD(29).L_chn = {[], [], []};
AD(30).name  = 'AD41'; AD(30).L_cor = 0;  AD(30).R_chn = {[3 3],[8 8],[12 12]};AD(30).L_chn = {[], [], []};

% save to an mat file in current dir
SpkInfo{1,1} = 'Acute dMCAO';   SpkInfo{1,2} = ACU;
SpkInfo{2,1} = 'Acute CCAO';   SpkInfo{2,2} = CCAO;
SpkInfo{3,1} = 'Control';   SpkInfo{3,2} = CNT;
SpkInfo{4,1} = 'CNQX';   SpkInfo{4,2} = CNQX;
SpkInfo{5,1} = 'Acute Xa';   SpkInfo{5,2} = ACUX;
SpkInfo{6,1} = 'EE Sham';   SpkInfo{6,2} = SEE;
SpkInfo{7,1} = '1M Strk';   SpkInfo{7,2} = M1A;
SpkInfo{8,1} = '2W Strk';   SpkInfo{8,2} = W2A;
SpkInfo{9,1} = '2W CCAO';   SpkInfo{9,2} = W2C;
SpkInfo{10,1} = 'EE Strk';   SpkInfo{10,2} = AEE;
SpkInfo{11,1} = '1M CCAO';   SpkInfo{11,2} = M1A;
SpkInfo{12,1} = 'AD';   SpkInfo{12,2} = AD;

save('SpkInfo.mat','SpkInfo')
    

end




