FREE VARIABLE
         Z(obj_set)              Objectives
         OBJECTIVE               Objective
         Costl                   Transport costs
         Costt                   Treatment costs
         Costfin                 Miscellaneous costs (taxes subsidies etc.)
         DelP(j,p,nx,ny,m,t)     Removal efficiency of a plant or technology unit for stream j

POSITIVE VARIABLE
         PT(m,nx,ny,p,t)         Production rate of tech m in cell x over t (output_unit time)
         fl(j,nx,ny,np,nq,t)     Flowrate of j passing from x to x at time t
         dis(j,p,t)              resources disposed of from stream
         rs(p,t)                 resources recovered of from stream
         R(m,nx,ny,p,t)          Recovery_removal for p at removal_recovery plant m (output_unit time)
         len                     Total pipeline length
         mu(l)                   Hypothetical cost of pipeline all pipelines
         z1(l)                      Linearisation variable for Eq28
         z4(j,nx,ny,np,nq,t)        Linearisation variable for Eq18
*         z8(j,nx,ny,np,nq,t)        Linearisation variable for Eq24
         z13(j,nx,ny,np,nq,m,t)     alpha(m_x)*fl(x'_x)
*         z13a(j,nx,ny,np,nq,jm,t)   alpha(jm_x)*fl(x_x')

BINARY VARIABLE
         alpha(j,nx,ny,m)        Technology specifically applied to wastestream j in cell? (1->yes|0->no)
         omega(nx,ny,m)          Technology applied to any wastestream in cell? (1->yes|0->no)
         v(j,nx,ny)              Is at least one technology in a cell for waste stream j? (1->yes|0->no)
         gamma(nx,ny,np,nq)      Is there a direct path between (nx ny) and (np nq) without passing a connection?
         delt(l)                 Pipe type installation method l is selected
         epsil(j)                Does j pass through any joint? (1->yes|0->no)
         phi(nx,ny,np,nq)        Does any stream go from a generation at x to a joint at x?
         PI(nx,ny,np,nq)         Does any stream go from a joint at x to a technology at x?
         del_alt(nx,ny,np,nq)    Is a pipe line present between x and x?
         Chi(j,nx,ny,np,nq)      Is there a path between a joint and a treatment plant between x and x
*         z2(j,nx,ny,np,nq,jm,trure)  Linearisation variable for Eq23
         z3(j,np,nq)                 Linearisation variable for Eq25

EQUATIONS
*Pipeline constraints:
         Eq1     Cost of stream j pipeline based on elevation
         Eq2     Only one pipe type

         Eq4     All generated waste in a cell must go somewhere
         Eq4_a     All generated waste in a cell must go to somewhere
         Eq4_a1     All generated waste in a cell must go to somewhere
         Eq4_a2     All generated waste in a cell must go to somewhere
         Eq4_a3     All generated waste in a cell must go to somewhere
         Eq4_a4     All generated waste in a cell must go to somewhere
         Eq5     Flow bounds through pipe
*         Eq5_a     Flow bounds through pipe
;

Eq1(l)..                mu(l) =e= sum((nx,ny,np,nq,el),Del(nx,ny,np,nq,el)*(Install(l,el)+Opl(l,el))*del_alt(nx,ny,np,nq)*distance(nx,ny,np,nq)*5);
Eq2..                   sum(l,delt(l))=e=1;
*Flow rate calcs
Eq4(j,nx,ny,p,t)..      sum((np,nq),fl(j,nx,ny,np,nq,t)*C(j,p)) =l= gen(p,j,nx,ny)+sum((jm,np,nq),z13(j,nx,ny,np,nq,jm,t)*C(j,p));
Eq4_a(j,nx,ny,np,nq,t)..   sum(jm,z13(j,np,nq,nx,ny,jm,t)) =e= z4(j,nx,ny,np,nq,t)*gYN(j,nx,ny);
Eq4_a1(j,nx,ny,np,nq,t)..  z4(j,nx,ny,np,nq,t) =l= epsil(j)*36500000;
Eq4_a2(j,nx,ny,np,nq,t)..  z4(j,nx,ny,np,nq,t) =l= fl(j,nx,ny,np,nq,t);
Eq4_a3(j,nx,ny,np,nq,t)..  z4(j,nx,ny,np,nq,t) =g= fl(j,nx,ny,np,nq,t)-(1-epsil(j))*36500000;
Eq4_a4(j,nx,ny,np,nq,t)..  z4(j,nx,ny,np,nq,t) =g= 0;
Eq5(nx,ny,np,nq,t)..       sum(j,fl(j,nx,ny,np,nq,t)) =l= sum(l,FLOW(l)*delt(l));
*Eq5_a(np,nq,t)..        sum((j,nx,ny),fl(j,nx,ny,np,nq,t)) =l= sum(l,FLOW(l)*delt(l));

*Treatment technology constraints
EQUATIONS
         Eq7     The removed resource is ProductionRate x Conversion parameter associated with a technology
         Eq9     For each plant the amount converted is equal to the total flow into the cell times the Concentration of each times a binary (1 if tech is in cell 0 if not)
         Eq9_1   Linearisation of Eq9
         Eq9_2   Linearisation of Eq9
         Eq9_3   Linearisation of Eq9
         Eq9_4   Linearisation of Eq9
*         Eq9_5   Flow through joint
         Eq9a    Flow into cell with joint is same as flow out of cell with joint
*         Eq9a_1  Linearisation of joint binary times flow out of cell
*         Eq9a_2  Linearisation of joint binary times flow out of cell
*         Eq9a_3  Linearisation of joint binary times flow out of cell
*         Eq9a_4  Linearisation of joint binary times flow out of cell
         Eq10    The resource removed is less than the upper capacity bound of technology
         Eq11    Removed resource by tech in stream in cell is the sum of total flow into the cell times the Concentration times the conversion times a binary (1 if tech is in cell 0 if not)
         Eq12    Discharged resource is generated plus change in resource
         Eq13    Recovered resources are the sum of the changes resource across all useful resources
         Eq15    Discharged is leq than some restricted limit
         Eq15a    Discharged is leq than some restricted limit
*         Eq16    Discharged is geq than some restricted limit
*         Eq17    Removed resource is geq than some restricted limit
         ;

Eq7(m,nx,ny,p,t)..     R(m,nx,ny,p,t) =e= Con3(m,p)*PT(m,nx,ny,p,t);

Eq9(trure,nx,ny,p,t)$(Con(trure,p)<0).. PT(trure,nx,ny,p,t) =l= -sum((j,np,nq),z13(j,nx,ny,np,nq,trure,t)*C(j,p)*Con(trure,p));
Eq9_1(j,nx,ny,np,nq,m,p,t)..            z13(j,nx,ny,np,nq,m,t) =l= alpha(j,nx,ny,m)*36500000;
Eq9_2(j,nx,ny,np,nq,m,p,t)..            z13(j,nx,ny,np,nq,m,t) =l= fl(j,np,nq,nx,ny,t);
Eq9_3(j,nx,ny,np,nq,m,p,t)..            z13(j,nx,ny,np,nq,m,t) =g= fl(j,np,nq,nx,ny,t)-(1-alpha(j,nx,ny,m))*36500000;
Eq9_4(j,nx,ny,np,nq,m,p,t)..            z13(j,nx,ny,np,nq,m,t) =g= 0;

Eq9a(j,nx,ny,t)..               sum((np,nq),fl(j,nx,ny,np,nq,t)) =g= sum((jm,np,nq),z13(j,nx,ny,np,nq,jm,t));
*Eq9a(j,nx,ny,t)..               sum((jm,np,nq),z13a(j,nx,ny,np,nq,jm,t)) =e= sum((jm,np,nq),z13(j,nx,ny,np,nq,jm,t));
*Eq9a_1(j,nx,ny,np,nq,jm,p,t)..  z13a(j,nx,ny,np,nq,jm,t) =l= alpha(j,nx,ny,jm)*36500000;
*Eq9a_2(j,nx,ny,np,nq,jm,p,t)..  z13a(j,nx,ny,np,nq,jm,t) =l= fl(j,nx,ny,np,nq,t);
*Eq9a_3(j,nx,ny,np,nq,jm,p,t)..  z13a(j,nx,ny,np,nq,jm,t) =g= fl(j,nx,ny,np,nq,t)-(1-alpha(j,nx,ny,jm))*36500000;
*Eq9a_4(j,nx,ny,np,nq,jm,p,t)..  z13a(j,nx,ny,np,nq,jm,t) =g= 0;

Eq10(trure,nx,ny,p,t)..    sum((j,np,nq),z13(j,nx,ny,np,nq,trure,t)) =l= Promax(trure);
*Eq10(m,nx,ny,p,t)..        sum(j,DelP(j,p,nx,ny,m,t)) =l= Promax(m,p);
Eq11(j,p,nx,ny,trure,t)..  DelP(j,p,nx,ny,trure,t) =e= sum((np,nq),z13(j,nx,ny,np,nq,trure,t)*C(j,p)*Con2(trure,p));
Eq12(j,p,t)..              dis(j,p,t) =e= sum((nx,ny),gen(p,j,nx,ny)+sum((trure),DelP(j,p,nx,ny,trure,t)));
Eq13(dp,t)..               rs(dp,t) =e= sum((nx,ny,re),R(re,nx,ny,dp,t));
*Eq16(j,p,t)..              pmin(p)-dis(j,p,t) =l= 0;
Eq15(t)..                 sum(j,dis(j,'p_2',t)) =l= pmax('p_5');
Eq15a(t)..                sum(j,dis(j,'p_3',t)) =l= pmax('p_6');
*Eq16(j,p,t)..              pmin(p)-dis(j,p,t) =l= 0;
*Eq17(m,p,nx,ny,t)..        Flmin(m,p)-R(m,nx,ny,p,t) =l= 0;


*Transport constraints
EQUATIONS
         Eq19    For each stream in each cell is there a Treatment_recovery plant
         Eq19a   For each stream in each cell is there a Treatment_recovery plant
         Eq20    For any of the streams in each cell is there a plant or joint
         Eq20a   For any of the streams in each cell is there a plant or joint
         Eq21    Does each stream pass a joint in each cell
         Eq21a   Does each stream pass a joint in each cell
         Eq22    Is there a pathway between a waste generator in x and a joint in x
         Eq22a   Is there a pathway between a waste generator in x and a joint in x
         Eq23    Is there a potential pathway between a joint in x and a treatment plant in x
         Eq23_1  Linearisation of Eq23
         Eq23_2  Linearisation of Eq23
*         Eq23_3  Linearisation of Eq23
*         Eq23a   Is there a potential pathway between a joint in x and a treatment plant in x
         Eq24    Is there flow between a joint in x and a treatment plant in x
*         Eq24_1  Linearisation of Eq24
*         Eq24_2  Linearisation of Eq24
*         Eq24_3  Linearisation of Eq24
*         Eq24_4  Linearisation of Eq24
         Eq24a   Is there flow between a joint in x and a treatment plant in x
         Eq25    Is there a direct pathway between a generator and Treatment plant
         Eq25_1  Linearisation of Eq25
         Eq25_2  Linearisation of Eq25
         Eq25_3  Linearisation of Eq25
         Eq25a   Is there a direct pathway between a generator and Treatment plant
         Eq26    Is there any pathway between x and x
         Eq27    Total transport distance calculaton;


Eq19(j,nx,ny)..           v(j,nx,ny) =g= small*sum(trure,alpha(j,nx,ny,trure));
Eq19a(j,nx,ny)..          1-v(j,nx,ny) =g= -small*(sum(trure,alpha(j,nx,ny,trure)))+small/2;
Eq20(nx,ny,m)..           omega(nx,ny,m) =g= small*sum(j,alpha(j,nx,ny,m));
Eq20a(nx,ny,m)..          1-omega(nx,ny,m) =g= -small*(sum(j,alpha(j,nx,ny,m)))+small/2;
Eq21(j)..                 epsil(j) =g= small*sum((jm,nx,ny),alpha(j,nx,ny,jm));
Eq21a(j)..                1-epsil(j) =g= -small*(sum((jm,nx,ny),alpha(j,nx,ny,jm)))+small/2;
Eq22(nx,ny,np,nq,jm)..    phi(nx,ny,np,nq) =g= small*sum(j,alpha(j,nx,ny,jm)*gYN(j,np,nq));
Eq22a(nx,ny,np,nq,jm)..   1-phi(nx,ny,np,nq) =g= -small*(sum(j,alpha(j,nx,ny,jm)*gYN(j,np,nq)))+small/2;

Eq23(j,nx,ny,np,nq)..     Chi(j,nx,ny,np,nq) =g= -1+sum(jm,alpha(j,nx,ny,jm))+sum(trure,alpha(j,np,nq,trure));
Eq23_1(j,nx,ny,np,nq)..   Chi(j,nx,ny,np,nq) =l= sum(jm,alpha(j,nx,ny,jm));
Eq23_2(j,nx,ny,np,nq)..   Chi(j,nx,ny,np,nq) =l= sum(trure,alpha(j,np,nq,trure));

*Eq23(j,nx,ny,np,nq)..               Chi(j,nx,ny,np,nq) =g= small*sum((jm,trure),z2(j,nx,ny,np,nq,jm,trure));
*Eq23_1(j,nx,ny,np,nq,jm,trure)..    z2(j,nx,ny,np,nq,jm,trure) =l= alpha(j,nx,ny,jm);
*Eq23_2(j,nx,ny,np,nq,jm,trure)..    z2(j,nx,ny,np,nq,jm,trure) =l= alpha(j,np,nq,trure);
*Eq23_3(j,nx,ny,np,nq,jm,trure)..    z2(j,nx,ny,np,nq,jm,trure) =g= alpha(j,nx,ny,jm)+alpha(j,np,nq,trure)-1;
*Eq23a(j,nx,ny,np,nq)..              1-Chi(j,nx,ny,np,nq) =g= -small*(sum((jm,trure),z2(j,nx,ny,np,nq,jm,trure)))+small/2;

Eq24(nx,ny,np,nq)..           Pi(nx,ny,np,nq) =g= small*sum(j,Chi(j,nx,ny,np,nq));
*Eq24_1(j,nx,ny,np,nq,t)..     z8(j,nx,ny,np,nq,t) =l= Chi(j,nx,ny,np,nq)*36500000;
*Eq24_2(j,nx,ny,np,nq,t)..     z8(j,nx,ny,np,nq,t) =l= fl(j,nx,ny,np,nq,t);
*Eq24_3(j,nx,ny,np,nq,t)..     z8(j,nx,ny,np,nq,t) =g= fl(j,nx,ny,np,nq,t)-(1-Chi(j,nx,ny,np,nq))*36500000;
*Eq24_4(j,nx,ny,np,nq,t)..     z8(j,nx,ny,np,nq,t) =g= 0;

Eq24a(nx,ny,np,nq)..          1-Pi(nx,ny,np,nq) =g= -small*(sum(j,Chi(j,nx,ny,np,nq)))+small/2;

Eq25(nx,ny,np,nq)..       gamma(nx,ny,np,nq) =g= small*sum(j,gYN(j,nx,ny)*v(j,np,nq)-gYN(j,nx,ny)*z3(j,np,nq));
Eq25_1(j,np,nq)..         z3(j,np,nq) =l= v(j,np,nq);
Eq25_2(j,np,nq)..         z3(j,np,nq) =l= epsil(j);
Eq25_3(j,np,nq)..         z3(j,np,nq) =g= v(j,np,nq)+epsil(j)-1;
Eq25a(nx,ny,np,nq)..      1-gamma(nx,ny,np,nq) =g= -small*(sum(j,gYN(j,nx,ny)*v(j,np,nq)-gYN(j,nx,ny)*z3(j,np,nq)))+small/2;

Eq26(nx,ny,np,nq)..      del_alt(nx,ny,np,nq) =g= small*(phi(np,nq,nx,ny)+gamma(nx,ny,np,nq)+Pi(nx,ny,np,nq));
Eq27..                   len =e= sum((nx,ny,np,nq),del_alt(nx,ny,np,nq)*distance(nx,ny,np,nq));

*Costs and objectives
EQUATIONS
         Eq28      Cost of the pipeline
         Eq28_1    Linearisation of Eq28
         Eq28_2    Linearisation of Eq28
         Eq28_3    Linearisation of Eq28
         Eq28_4    Linearisation of Eq28
         Eq29      Cost of the technology
         Eq30      Miscellaneous financial and policy based costs;

Eq28..              Costl =e= sum((l),z1(l));
Eq28_1(l)..         z1(l) =l= delt(l)*1000000;
Eq28_2(l)..         z1(l) =l= mu(l);
Eq28_3(l)..         z1(l) =g= mu(l)-(1-delt(l))*1000000;
Eq28_4(l)..         z1(l) =g= 0;

Eq29..                Costt =e= sum((nx,ny,m),Capm(m)*omega(nx,ny,m)+sum((j,np,nq,t),z13(j,nx,ny,np,nq,m,t))*Opm(m));
Eq30..                Costfin =e= sum((j,p,t),dis(j,p,t)*(Opdis(p)));

EQUATIONS
         CostTot      Total costs
         CostPipe     Pipeline cost
         CostTreat    Treatment_recovery_connection costs
         CostMisc     Miscellaneous financial and policy costs
         MoneyIn      Resources sold
         TotObj       Full problem objective
         total        Set objective variable;

CostTot..   Z('TotalCost') =e= Costl + Costt + Costfin;
*CostTot..   Z('TotalCost') =e= Costl + Costfin;
CostPipe..  Z('PipeCost') =e= Costl;
CostTreat.. Z('TreatCost') =e= Costt;
CostMisc..  Z('MiscCost') =e= Costfin;
MoneyIn..   Z('ResourceSold') =e= sum((t,dp),rs(dp,t)*Price(dp)/2);
TotObj..    Z('Obj') =e= Z('ResourceSold')-Z('TotalCost');
total..     Z('Obj') =e= OBJECTIVE;


EQUATIONS
         ExtraEq1         Set inputs and outputs
         ExtraEq2         Set inputs and outputs
         ExtraEq3         Set inputs and outputs
         ExtraEq4         Set inputs and outputs
         ExtraEq5         Set inputs and outputs
         ExtraEq6         Set inputs and outputs

         ExtraEq100         Set inputs and outputs
         ExtraEq101         Set inputs and outputs
         ExtraEq102         Set inputs and outputs
*         ExtraEq103         Set inputs and outputs
*         ExtraEq104         Set inputs and outputs
*         ExtraEq105         Set inputs and outputs
*         ExtraEq106         Set inputs and outputs
*         ExtraEq107         Set inputs and outputs
*         ExtraEq108         Set inputs and outputs
*         ExtraEq7         Set inputs and outputs
*         ExtraEq8         Set inputs and outputs
*         ExtraEq9         Set inputs and outputs
*         ExtraEq10        Set inputs and outputs
*         ExtraEq11        Set inputs and outputs
*         ExtraEq12        Set inputs and outputs
*         ExtraEq13        Set inputs and outputs

*         ExtraEq7        Set inputs and outputs
*         ExtraEq8        Set inputs and outputs
*         ExtraEq9        Set inputs and outputs
*         ExtraEq10        Set inputs and outputs
*         ExtraEq11        Set inputs and outputs
*         ExtraEq12        Set inputs and outputs
*         ExtraEq13        Set inputs and outputs
*         ExtraEq14        Set inputs and outputs
*         ExtraEq15        Set inputs and outputs
*         ExtraEq16        Set inputs and outputs
*         ExtraEq17        Set inputs and outputs
*         ExtraEq18        Set inputs and outputs
*         ExtraEq19        Set inputs and outputs
*         ExtraEq20        Set inputs and outputs
;

ExtraEq1(m,nx,ny,t)..       PT(m,nx,ny,'p_1',t) =e= PT(m,nx,ny,'p_4',t);
ExtraEq2(m,nx,ny,t)..       PT(m,nx,ny,'p_2',t) =e= PT(m,nx,ny,'p_5',t);
ExtraEq3(m,nx,ny,t)..       PT(m,nx,ny,'p_3',t) =e= PT(m,nx,ny,'p_6',t);

ExtraEq4(j)..            sum((trure,nx,ny),alpha(j,nx,ny,trure)) =e= 1;
ExtraEq5(j)..            sum((jm,nx,ny),alpha(j,nx,ny,jm)) =l= 1;
ExtraEq6(j,nx,ny)..      sum(m,alpha(j,nx,ny,m)) =l= 1;

ExtraEq100(j)..           sum((trure,nx,ny),alpha(j,nx,ny,trure)) =g= sum((jm,nx,ny),alpha(j,nx,ny,jm));
ExtraEq101(nx,ny,np,nq).. phi(nx,ny,np,nq) =l= sum((j,jm),alpha(j,nx,ny,jm));
ExtraEq102(nx,ny,np,nq).. phi(np,nq,nx,ny) =l= sum(j,gYN(j,nx,ny));

*ExtraEq103(t)..      sum((np,nq),fl('j_1','nx_2','ny_1',np,nq,t)) =e= 36500000;
*ExtraEq104(t)..      sum((np,nq),fl('j_2','nx_1','ny_2',np,nq,t)) =e= 36500000;
*ExtraEq105(t)..      sum((np,nq),fl('j_3','nx_4','ny_1',np,nq,t)) =e= 29200000;
*ExtraEq106(t)..      sum((np,nq),fl('j_4','nx_7','ny_6',np,nq,t)) =e= 14600000;
*ExtraEq106(t)..      sum((np,nq),fl('j_4','nx_3','ny_4',np,nq,t)) =e= 14600000;
*ExtraEq107(t)..      sum((np,nq),fl('j_5','nx_6','ny_6',np,nq,t)) =e= 10950000;
*ExtraEq107(t)..      sum((np,nq),fl('j_5','nx_4','ny_4',np,nq,t)) =e= 10950000;

*ExtraEq108(j,nx,ny,jm)..      alpha(j,nx,ny,jm) =e= 0;

*ExtraEq108..      sum((trure,nx,ny),omega(nx,ny,trure)) =e= 1;

*ExtraEq7.. delt('l_2') =e= 1;
**ExtraEq4..       rs('p_4','t_1') =g= 0.001;
**ExtraEq6..       phi('nx_5','ny_3','nx_7','ny_6') =e= 1;
*ExtraEq9..       fl('j_4','nx_7','ny_6','nx_5','ny_3','t_1') =g= 0.0001;
*ExtraEq10..       fl('j_4','nx_5','ny_3','nx_4','ny_1','t_1') =g= 0.0001;
*ExtraEq11..       alpha('j_4','nx_4','ny_1','m_2') =e= 1;
*ExtraEq12..       fl('j_5','nx_6','ny_6','nx_5','ny_3','t_1') =g= 0.0001;
*ExtraEq13..       fl('j_5','nx_5','ny_3','nx_4','ny_1','t_1') =g= 0.0001;
**phi('nx_6','ny_6','nx_5','ny_3') =e= 1;

*ExtraEq7..       alpha('j_1','nx_2','ny_2','m_1') =e= 1;
*ExtraEq8..       alpha('j_2','nx_2','ny_2','m_1') =e= 1;
*ExtraEq9..       alpha('j_1','nx_5','ny_4','m_3') =e= 1;
*ExtraEq10..      alpha('j_2','nx_5','ny_4','m_3') =e= 1;
*ExtraEq11..      alpha('j_3','nx_5','ny_4','m_3') =e= 1;
*ExtraEq12..      alpha('j_4','nx_5','ny_4','m_3') =e= 1;
*ExtraEq13..      alpha('j_5','nx_5','ny_4','m_3') =e= 1;
*ExtraEq14..      fl('j_1','nx_2','ny_1','nx_2','ny_2','t_1') =e= 36500000;
*ExtraEq15..      fl('j_1','nx_2','ny_2','nx_5','ny_4','t_1') =e= 36500000;
*ExtraEq16..      fl('j_2','nx_1','ny_2','nx_2','ny_2','t_1') =e= 36500000;
*ExtraEq17..      fl('j_2','nx_2','ny_2','nx_5','ny_4','t_1') =e= 36500000;
*ExtraEq18..      fl('j_3','nx_4','ny_1','nx_5','ny_4','t_1') =e= 29200000;
*ExtraEq19..      fl('j_4','nx_7','ny_6','nx_5','ny_4','t_1') =e= 14600000;
*ExtraEq20..      fl('j_5','nx_6','ny_6','nx_5','ny_4','t_1') =e= 10950000;


*alpha.l('j_1','nx_2','ny_2','m_1') = 1;
*alpha.l('j_2','nx_2','ny_2','m_1') = 1;
*alpha.l('j_1','nx_5','ny_4','m_3') = 1;
*alpha.l('j_2','nx_5','ny_4','m_3') = 1;
*alpha.l('j_3','nx_5','ny_4','m_3') = 1;
*alpha.l('j_4','nx_5','ny_4','m_3') = 1;
*alpha.l('j_5','nx_5','ny_4','m_3') = 1;
*fl.l('j_1','nx_2','ny_1','nx_2','ny_2','t_1') = 36500000;
*fl.l('j_1','nx_2','ny_2','nx_5','ny_4','t_1') = 36500000;
*fl.l('j_2','nx_1','ny_2','nx_2','ny_2','t_1') = 36500000;
*fl.l('j_2','nx_2','ny_2','nx_5','ny_4','t_1') = 36500000;
*fl.l('j_3','nx_4','ny_1','nx_5','ny_4','t_1') = 29200000;
*fl.l('j_4','nx_7','ny_6','nx_5','ny_4','t_1') = 14600000;
*fl.l('j_5','nx_6','ny_6','nx_5','ny_4','t_1') = 10950000;
*z13.l('j_1','nx_2','ny_2','nx_2','ny_1','m_1','t_1') = 36500000;
*z13.l('j_1','nx_5','ny_4','nx_2','ny_2','m_3','t_1') = 36500000;
*z13.l('j_2','nx_2','ny_2','nx_1','ny_2','m_1','t_1') = 36500000;
*z13.l('j_2','nx_5','ny_4','nx_2','ny_2','m_3','t_1') = 36500000;
*z13.l('j_3','nx_5','ny_4','nx_4','ny_1','m_3','t_1') = 29200000;
*z13.l('j_4','nx_5','ny_4','nx_7','ny_6','m_3','t_1') = 14600000;
*z13.l('j_5','nx_5','ny_4','nx_6','ny_6','m_3','t_1') = 10950000;
*Pi.l('nx_2','ny_2','nx_5','ny_4') = 1;
*phi.l('nx_2','ny_2','nx_1','ny_2') = 1;
*phi.l('nx_2','ny_2','nx_2','ny_1') = 1;
model WWTModel /all/;

