*model to optimize usage of PCM storage in cooling grid

*Name of optimization
$set    Name WWTResource

*reading in the parameters for optimization
$GDXIN input.gdx

$include WWTInitt.gms

$include WWTMod.gms

file hCplex_Option /cplex.opt/;
put hCplex_Option "epgap=" gap:0:12/;
put hCplex_Option "tilim="timelimit:0:0/;
put hCplex_Option "threads="threads:0:0 /;
put hCplex_Option 'mipkappastats 2' /;
put hCplex_Option 'quality 1' /;
put hCplex_Option 'mipstart 1' /;
putclose;

option  limrow=0
        limcol=0
        Solprint=off;
$Offsymlist
$Offsymxref

WWTModel.optfile=1;

solve WWTModel USING MIP MAXIMIZING Objective;

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* Generate GDX

execute_unload 'results_DisCostRec2.gdx' dis.l,len.l,PT.l,DelP.l,delt.l,mu.l,Chi.l,Pi.l,Z.l,alpha.l,v.l,phi.l,gamma.l,omega.l,dis.l,rs.l,fl.l,R.l,del_alt.l,epsil.l,z13.l,z1.l,z3.l,z4.l;
