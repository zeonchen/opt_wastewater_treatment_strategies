SETS
         nx              cell number From (X-direction)
         ny              cell number From (Y-direction)
         j               wastestream number
         t               time steps
         p               components paramters & resources associated with waste stream
         dp(p)           Demand(useful) components associated with waste stream
*         mp(p)           Resources that are input to plants
         m               Technologies including treatment recovery and joints
         jm(m)           Joints between different waste streams
*         tr(m)           Treatment technology
         re(m)           recovery technology
         trure(m)        Union of tr re
         l               piping material
         el              elevation (between cells) sets
         obj_set         objective functions;

ALIAS (nx, np)
      (ny, nq);

$LOAD nx ny j t p dp m jm re trure l el obj_set

PARAMETERS
*         t_horizon       time horizon in years
         gen(p,j,nx,ny)          waste|resources generated in cell
         gYN(j,nx,ny)            is there a generation source here?
         Capl(el,l)              Transport capex
         Opl(l,el)               Transport opex
         distance(nx,ny,np,nq)   Distance between (nx ny) and (np nq)
         Flmin(m,p)              minimum flow restriction of technology
         Promax(m)             Maximum flow capacity for technology
         Con(m,p)                conversion through technology
         Con2(m,p)               Negative conversions through technology
         Con3(m,p)               Positive conversions through technology
         C(j,p)                  Concentration of p in flow j
         pmax(p)                 Max allowable discharge quantity for a specific waste constituent
         pmin(p)                 Min allowable discharge quantity for a specific waste constituent
         Del(nx,ny,np,nq,el)     Elevation classification between two cells
         Capm(m)                 Cost of different treatment technologies
         Opm(m)                  Operational cost of different treatment technologies
         Opdis(p)                Cost of waste disposal
         Price(dp)               Price of sellable component p
         Install(l,el)           Unit installation costs for pipe l and elevation el
         FLOW(l)                 Flow rate through particular pipe type
         fl_up                   Upper flow bound
         small                   Small number for optimisation
         small1                   Small number for optimisation
*         sig(p,re)               User-defined binary - resource\compound p flow through recovery technology
*         Tax(p)                  Tax on discharge of component
*         Sub(dp)                 Subsidy for discharge of component
         gap                     relative optimization tolerance
         timelimit               maximum allowed time for solver
         threads                 number of threads for solver;

$LOAD gen gYN Capl Opl distance Flmin Promax Con Con2 Con3 C pmax pmin Del Capm Price Install FLOW Opm Opdis fl_up small small1 gap timelimit threads
