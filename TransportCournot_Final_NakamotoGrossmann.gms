*OPTION solvelink=5;

SET
* 47 major fuel specific facilities
i Total Producers                       /1*47/

coal(i)         coal                    /1*7/
hydro(i)        hydroelectric   /8*9/
landfill(i)     lanfill gas             /10*13/
natural(i)      natural gas             /14*27/
nuclear(i)      nuclear                 /28/
oil(i)          oil                     /29*37/
solar(i)        solar                   /38*42/
waste(i)        waste                   /43*44/
wind(i)         wind                    /45*46/
outState(i) out of state        /47/

z "zones" /1*5/
** EDIT
* separate each producer by zone
z1(i)   zone1   /4,7,9,27,31,39,40,45,46/
z2(i)   zone2   /1,2,5,10,11,17,18,19,21,22,23,26,33,34,35,43,44/
z3(i)   zone3   /8,13,24,30,32,36,37,42/
z4(i)   zone4   /3,6,12,14,15,16,20,25,28,29,38,41/
z5(i)   zone5   /47/
;

ALIAS(i,j);

PARAMETER
capacity(i) for 2020
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
                47      1548
        /
$ontext


** EDIT caacity of out of state producer?
capacity(i)  for 2010 & 2014
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
                47      2000
        /
$offtext

** factor used to determine the maximum energy that can be produced depending on the facility's capacity
** changes capcity of MW to cacity of MWh for a given time frame
capFactor(i)
** marginal cost of production
c(i)
tax(i)
emission(i)
alpha
beta
RGS(i)
RenewablePercent
** Zonal Transmission Costs
cz(i,z)
**Zonal Upper Bound
zUB(z)
**Zonal Lower Bound
zLB(z)
** tax as prescribed by the MOPEC
*tax values: --> values from MOPEC_FINAL_NamkamotoGrossmann
t/94.607/
** producers who get taxed
tax(i)
;

** intercept and slope of inverse demand curve
alpha = 660;
beta = 2.355290477;

** capacity factor in as a percentage represented in decimals
capFactor(coal) = 0.8;
*(coal) = .9030 for 2010 - 2014
capFactor(hydro) = 0.8;
* (hydro) = .3980 for 2010/ .4 for 2014
capFactor(landfill) = 0.95;
*(hydro) = .3980 for 2010 /.5 for 2014
capFactor(natural) = 0.95;
* (naturual) =  .4250 for 2010  / .5 for 2014
capFactor(nuclear) = 0.93;
*.(nuclear) = .9030 for 2010 - 2014
capFactor(oil) = 0.20;
capFactor(solar) = 0.4;
*(solar) = .25 for 2010 & 2014
capFactor(waste) = 0.95;
*(waste) = .6870 for 2010 - 2014
capFactor(wind) = 0.8;
*(wind) = .3390 for 2010 - 2014.8 for 2020
capFactor(outState) = 0.8;
*(outState) = .903 for 2010-2014


** capacity of production in a day
capacity(i) = capacity(i) / 1000 * 24 * capFactor(i);

** marginal cost of production (thousands of $)/GWh
c(coal) = 9.0;
*(coal) = 8.407214612 for 2010 - 2014
c(hydro) = 1.83390411;
c(landfill) = 28.29623288;
c(natural) = 13.16642314;
*(natural) =  15.1.. for 2010/  14.1... for 2014
c(nuclear) = 12.78840183;
c(oil) = 17.16642314;
c(solar) = 4.554794521;
c(wind) = 6.481164384;
c(waste) = 28.29623288;
c(outState) = 20;

** producers getting taxed
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


** marginal cost of transfer zone to zone (based on Location of Transmission Lines)
cz(z1,'1') = 0;
cz(z1,'2') = 1;
cz(z1,'3') = 1.75;
cz(z1,'4') = 1;
cz(z1,'5') = 3;

cz(z2,'1') = 1;
cz(z2,'2') = 0;
cz(z2,'3') = 1;
cz(z2,'4') = 1;
cz(z2,'5') = 3;

cz(z3,'1') = 1.75;
cz(z3,'2') = 1;
cz(z3,'3') = 0;
cz(z3,'4') = 1.75;
cz(z3,'5') = 3;

cz(z4,'1') = 1;
cz(z4,'2') = 1;
cz(z4,'3') = 1.75;
cz(z4,'4') = 0;
cz(z4,'5') = 3;

cz(z5,'1') = 3;
cz(z5,'2') = 3;
cz(z5,'3') = 3;
cz(z5,'4') = 3;
cz(z5,'5') = 15;

** Zonal Upper Bounds --> '10 Values
zUB('1') = 137.468;
*2009/135.093/, 2014/147.622/, 2020/157.641/
zUB('2') = 97.315;
*2009/95.693/, 2014/103.956/, 2020/114.559/
zUB('3') = 52.685;
*2009/52.427/, 2014/57.975/, 2020/63.471/
zUB('4') =91.482 ;
*2009/90.584/, 2014/96.997/, 2020/103.537/
zUB('5') = 1000;
*2010/1000/, 2014/1000/, 2020/1000/

**Zonal Lower Bounds --> values unchanging over time (stangnant baseline)
*                        chosen from historic lows * 0.8
zLB('1') =  74.301;
zLB('2') =  52.631;
zLB('3') =  28.835;
zLB('4') =  49.821;
zLB('5') = 0;


** Binary variable dtermining Renewable Generation Source
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

** percent of total prodcution required to be from renewable sources
RenewablePercent = 0.2;


POSITIVE VARIABLES
q1(i), q2(i), q3(i), q4(i), q5(i), q6(i)
q(i)
qz(i,z)
*qq(i,b)
*q
lambdacap(i)
muRLB
lambdaUBZ(z)
lambdaLBZ(z)
;

EQUATIONS
Cournot(i,z)
Cap(i) "upper limit on generation output"
ZoneUB(z)
ZoneLB(z)
TotalProduced(i)
RenewableLB
;

Cournot(i,z).. c(i) + cz(i,z) + tax(i)*t - ( alpha - beta*sum(j,q(j))) +beta*q(i) + lambdacap(i) + muRLB*RGS(i)
                                + lambdaUBZ(z) - lambdaLBZ(z)  =e= 0;

TotalProduced(i).. q(i) - sum(z, qz(i,z)) =e= 0;

Cap(i).. capacity(i) - q(i) =g= 0;

RenewableLB..  RenewablePercent*sum(i,q(i)) - sum(i, RGS(i)*q(i)) =g= 0;

ZoneUB(z)..  zUB(z) - sum(i,qz(i,z)) =g= 0;

ZoneLB(z).. sum(i, qz(i,z)) - zLB(z) =g= 0;




***************************************************************************
* MODEL
***************************************************************************
MODEL CournotModel /
Cournot.qz
TotalProduced.q
RenewableLB.muRLB
Cap.lambdacap
ZoneUB.lambdaUBZ
ZoneLB.lambdaLBZ
/ ;

Solve CournotModel using mcp ;

Parameter
price, totalQ, monthQ, yearQ, emission(i), NetEmit
RenewableQ
RenewableQ2
CoalQ
NaturalGasQ
NuclearQ
;

price = (alpha - beta*sum(i, q.l(i)));
totalQ = sum(i, q.l(i));
monthQ = totalQ*30;
yearQ = monthQ*12;

emission(coal) = 0.95;
*(coal) 2010-2014 = .9675136758
emission(hydro) = 0;
emission(landfill) = .1422521848;
emission(natural) = .5533833495;
emission(nuclear) = 0;
emission(oil) = .771107946;
emission(solar) = 0;
emission(waste) = .1422521848;
emission(wind) = 0;
emission(outState) = .95;
** (outState) EDIT this is same as coal

NetEmit = sum(i, emission(i)*q.l(i));

RenewableQ = sum(hydro, q.l(hydro)) + sum(landfill, q.l(landfill))
         + sum(solar, q.l(solar)) + sum(waste, q.l(waste))+ sum(wind,q.l(wind));

CoalQ = sum(coal, q.l(coal));
NaturalGasQ = sum(natural, q.l(natural));
NuclearQ = sum(nuclear, q.l(nuclear));


Display price, totalQ, monthQ, yearQ, q.l, NetEmit, RenewableQ
CoalQ, NaturalGasQ, NuclearQ;
