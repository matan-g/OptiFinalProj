*option solvelink=5;

Sets
n /0*30/
w(n) dynamic set

* 47 major fuel specific facilities
i Total Producers/1*47/

coal(i) coal producers /1*7/
hydro(i) hydroelectric producers /8*9/
landfill(i) lanfill gas /10*13/
natural(i) natural gas /14*27/
nuclear(i) /28/
oil(i) /29*37/
solar(i) /38*42/
waste(i) /43*44/
wind(i) /45*46/
outState(i) /47/
;

Alias(i,j);
Alias(n,nn);

** capacity in MW
Parameter
capacity(i) Data used for 2010 & 2014
        /       1       1273
                2       399
                3       728
                4       550
                5       495
                6       1548
                7       229
                8       885
                9       572
                10  20
                11  6
                12  3
                13  3
                14  3
                15  289
                16  84
                17      104
                18      133
                19      11
                20      23
                21      144
                22      80.8
                23      244
                24      770
                25      27
                26      121
                27      150
                28      1829
                29      926
                30      10
                31      150
                32      69
                33      415
                34      323.2
                35      83
                36      9
                37      183
                38      2
                39      20
                40      16
                41      5
                42      2
                43      68
                44      65
                45      70
                46      50
                47      1548
        /
$ontext
capacity(i)  Data used for 2020
        /       1       1273
                2       399
                3       728
                4       550
                5       495
                6       1548
                7       229
                8       985
                9       972
                10  20
                11  16
                12  13
                13  13
                14  3
                15  289
                16  84
                17      104
                18      133
                19      11
                20      23
                21      144
                22      80.8
                23      244
                24      770
                25      27
                26      121
                27      150
                28      1829
                29      926
                30      10
                31      150
                32      69
                33      415
                34      323.2
                35      83
                36      9
                37      183
                38      20
                39      40
                40      32
                41      15
                42      20
                43      88
                44      75
                45      200
                46      250
                47      1548/
$offtext

capFactor(i)
c(i)
tax(i)
emission(i)
gamma(n)
gamma2(n)
RGS(i)
RenewablePercent/0.05/
*.02 for 2009, .055 for 2010, .128 for 2014, .2 for 2020 --> RPS standard
*        these  values were not achievable thus were adjusted for optimal integration
*        based on historical data
alpha
beta
K /1000/
*LB/205/
;

** emission of CO2, CO2 kg/GWh
emission(coal) = 0.9675136758;
* for 2020 emissions drops to .95
emission(hydro) = 0;
emission(landfill) = .1422521848;
emission(natural) = .5533833495;
emission(nuclear) = 0;
emission(oil) = .771107946;
emission(solar) = 0;
emission(waste) = .1422521848;
emission(wind) = 0;
** EDIT this is same as coal
emission(outState) = .9675136758;

** capacity factor in as a percentage represented in decimals --> 2014 values
capFactor(coal) = 0.9030;
*capFactor(coal) = .8; for 2020
*capFactor(hydro) = 0.3980 2009 &'10;
capFactor(hydro) = .4;
*(hydro).3980 or 2010 & .8 for 2020
capFactor(landfill) = 0.6870;
*capFactor(landfill) = .95;  for 2020
capFactor(natural) = 0.50;
* (natural) = .4250 & .95 for 2020
capFactor(nuclear) = 0.9030;
*(nuclear) =.93 for 2020
capFactor(oil) = 0.20;
capFactor(solar) = 0.25;
*capFactor(solar) = 0.4;  for 2020
capFactor(waste) = .6870;
*capFactor(waste) .95 for 2020
capFactor(wind) = 0.3390;
*capFactor(wind) = .8; for 2020
capFactor(outState) = 0.903;

* transform it into avg daily capacity in GWh
capacity(i) = capacity(i) / 1000 * 24 * capFactor(i);

** marginal cost of production $(thousands)/GWh
c(coal) = 8.407214612;
* 9.0 for 2020 due to additions of CCS
c(hydro) = 1.83390411;
c(landfill) = 28.29623288;
c(natural) = 14.16642314;
*15.1... for 2010 & 13.1.... for 2020
c(nuclear) = 12.78840183;
c(oil) = 17.16642314;
c(solar) = 4.554794521;
c(wind) = 6.481164384;
c(waste) = 28.29623288;
c(outState) = 20;

** Determine which producers get taxed
tax(coal) = 1;
tax(hydro) = 0;
tax(landfill) = 1;
tax(natural) = 1;
tax(nuclear) = 0;
tax(oil) = 1;
tax(solar) = 0;
tax(wind) = 0;
tax(waste) = 1;
tax(outState) = 1;


** Renewable Generation Source {0,1}
RGS(coal) = 0;
RGS(hydro) = 1;
RGS(landfill) = 1;
RGS(natural) = 0;
RGS(nuclear) = 0;
RGS(oil) = 0;
RGS(solar) = 1;
RGS(wind) = 1;
RGS(waste) = 1;
RGS(outState) = 0;


* updated inverse demand parameters
alpha = 660;
beta = 2.355290477;

gamma2(n) = 180*(ord(n)-1)/(card(n)-1) + 0*(1-((ord(n)-1)/(card(n)-1)));
*change seccond multiplier to some larger value to increase run time

Binary Variable
r(i),r1(i
bRenew
;

Positive Variables
q(i),lambdacap(i)
t
lambdaRenew
;

Variable
z;

Equations
Objective
ObjCons
Cap,KKTCap, KKTCap2
KKT,KKTDC,KKTDC2
RenewableLB, KKTRenewable,KKTRenewable2
;

Objective.. z =e= (-1)*(sum(i,(alpha - beta*sum(j,q(j)))*q(i) - c(i)*q(i)) + 0.5*beta*sum(i,q(i))**2);
ObjCons(w)..  sum(i, emission(i)*q(i)) =l= gamma2(w);

KKT(i).. -alpha + beta*sum(j,q(j)) + beta*q(i) + c(i) + tax(i)*t + lambdacap(i) + RGS(i)*lambdaRenew  =g= 0;
KKTDC(i).. -alpha + beta*sum(j,q(j)) + beta*q(i) + c(i) + tax(i)*t + lambdacap(i) + RGS(i)*lambdaRenew =l= K*r(i);
KKTDC2(i).. q(i) =l= K*(1-r(i));

Cap(i).. capacity(i) - q(i) =g= 0;
KKTCap(i).. capacity(i) - q(i) =l= K*r1(i);
KKTCap2(i).. lambdacap(i) =l= K*(1-r1(i));

*as per executive order 01.01.2001.02 & Renewable Portfolio Standard
RenewableLB..  RenewablePercent*sum(i,q(i)) - sum(i, RGS(i)*q(i)) =g= 0;
KKTRenewable.. RenewablePercent*sum(i,q(i)) - sum(i, RGS(i)*q(i)) =l= K*bRenew;
KKTRenewable2.. lambdaRenew =l= K*(1-bRenew);


Model constraint /all/;

Parameter
totalEmission(n)
SocialWelfare(n)
totalQ(n)
avgProfits(n)
coalQ(n)
hydroQ(n)
landfillQ(n)
naturalQ(n)
nuclearQ(n)
oilQ(n)
solarQ(n)
windQ(n)
wasteQ(n)
outStateQ(n)
renewablesQ(n)
nonrenewablesQ(n)
report(n,*)
;

loop (nn,
w(n) = no;
w(nn) = yes;
option minlp = bonmin;
solve constraint using minlp minimizing z;
*func1(nn) =  (NGFactor*(sum(ng,q.l(ng)))+BGFactor*(sum(bg,q.l(bg))));
totalEmission(nn) =  sum(i, q.l(i) * emission(i));
SocialWelfare(nn) =  sum(i,(alpha - beta*sum(j,q.l(j)))*q.l(i) - c(i)*q.l(i)) + 0.5*beta*sum(i,q.l(i))**2;


totalQ(nn) = sum(i, q.l(i));
avgProfits(n) = sum(i, (alpha-beta*sum(j,q.l(j)))*q.l(i) - c(i)*q.l(i)) / 47;
coalQ(n) = sum(coal, q.l(coal));
hydroQ(n) = sum(hydro, q.l(hydro));
landfillQ(n) = sum(landfill, q.l(landfill));
naturalQ(n) = sum(natural, q.l(natural));
nuclearQ(n) = sum(nuclear, q.l(nuclear));
oilQ(n) = sum(oil, q.l(oil));
solarQ(n) = sum(solar, q.l(solar));
windQ(n) = sum(wind, q.l(wind));
wasteQ(n) = sum(waste, q.l(waste));
outStateQ(n) = sum(outState, q.l(outState));
renewablesQ(n) = hydroQ(n) + solarQ(n) + windQ(n);
nonrenewablesQ(n) = totalQ(n) - renewablesQ(n);

report(nn,'Emissions') = totalEmission(nn);
report(nn,'Social Welfare (Negative)') = SocialWelfare(nn);
report(nn,'Tax') = t.l;
report(nn,'Price') = (alpha - beta * sum(i,q.l(i)));
report(nn, 'Total Q') = totalQ(nn);
report(nn, 'Avg Profits') = avgProfits(nn);
report(nn, 'coalQ') = coalQ(nn);
report(nn, 'hydroQ') = hydroQ(nn);
report(nn, 'landfillQ') = landfillQ(nn);
report(nn, 'naturalQ') = naturalQ(nn);
report(nn, 'nuclearQ') = nuclearQ(nn);
report(nn, 'oilQ') = oilQ(nn);
report(nn, 'solarQ') = solarQ(nn);
report(nn, 'windQ') = windQ(nn);
report(nn, 'wasteQ') = wasteQ(nn);
report(nn, 'outStateQ') = outStateQ(nn);
report(nn, 'renewablesQ') = renewablesQ(nn);
report(nn, 'nonrenewablesQ') = nonrenewablesQ(nn);
);

Display
totalEmission,SocialWelfare, totalQ;
option report:3:1:1 ;
display report;
