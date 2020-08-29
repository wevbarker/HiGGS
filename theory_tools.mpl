with(LinearAlgebra):
with(StringTools);
with(CLIo):

read(`parameters.mpl`):
read(`particle_content.mpl`):
read(`literature_comparison.mpl`):

convert_parameters_print_equations:=proc(a::name,b::name)::NULL;
  local ii,l,r;
  dit({},"%s coefficients in terms of %s coefficients",parameter_system_names_table[a],parameter_system_names_table[b]);
  l:=convert(v||a,list);
  r:=convert(Multiply(m||a||b,v||b),list);
  for ii from 1 to numelems(l) do
    print(simplify(l[ii]=r[ii]));
  end do;
end proc:

convert_parameters_return_equations:=proc(a::name,b::name)::set;
  local ii,l,r;
  l:=convert(v||a,list);
  r:=convert(Multiply(m||a||b,v||b),list);
  eqs:={};
  for ii from 1 to numelems(l) do
    tmp:=simplify(l[ii]=r[ii]);
    eqs:=eqs union {tmp};
  end do;
  return eqs;
end proc:

for ii in indices(literature_parameter_constraints) do
  literature_parameter_constraints_YC[ii[1]]:=simplify(literature_parameter_constraints[ii[1]][2],convert_parameters_return_equations(literature_parameter_constraints[ii[1]][1],Y,0)):
end do:

for ii in indices(literature_parameter_constraints) do
  literature_parameter_constraints_N[ii[1]]:=simplify(literature_parameter_constraints[ii[1]][2],convert_parameters_return_equations(literature_parameter_constraints[ii[1]][1],N,0)):
end do:

modify_vY:=proc(ii::integer)::NULL;
  global vY;
  local rels;
  rels:=parameter_constraints[ii] union {R6};
  vY:=map(simplify,vY,rels);
  return NULL;
end proc:

modify_vY_literature:=proc(ii::name)::NULL;
  global vY;
  local rels;
  rels:=literature_parameter_constraints_YC[ii];
  vY:=map(simplify,vY,rels);
  return NULL;
end proc:

testcase:=proc(ii::integer)::list;
  global vY,tmp;
  modify_vY(ii);
  dit({fblack,bblue,bold,underline},"Yun-Cherng's critical case %d",ii);
  dit({},"Particle content:");
  theory_name:=cat(Y||ii,cat(op(map(convert,theory_properties[ii],string))));
  dit({},"This theory has code %s",theory_name);
  dit({},"Major cosmological theory parameters:");
  tmp:=convert_parameters_return_equations(cW1,Y,ii);
  print(tmp);
  tmp2:=map(primpart,eliminate(tmp,parameters_sets_table[Y])[2]);
  dit({},"Full set of cosmological constraints from general PGT/eWGT:");
  print(tmp2);
  dit({},"Unitarity inequalities imposed from general PGT/eWGT:");
  print(tmp3);
  extras:=numelems(parameter_constraints[ii])-numelems(tmp2);
  vY:=vY_orig:
  dit({},"This theory imposes %d extra constraints beyond the cosmological ones.",extras);
  return [ii,extras,tmp2];
end proc:

translate_cosmological_parameters:=proc(ii::name,jj::name)::NULL;
  dit({fblack,bred,bold,underline},"%s in terms of %s:",parameter_system_names_table[ii],parameter_system_names_table[jj]);
  tmp1:=convert_parameters_return_equations(ii,Y):
  tmp2:=convert_parameters_return_equations(jj,Y):
  tmp3:=map(primpart,eliminate(tmp1 union tmp2,parameters_sets_table[Y])[2]):
  tmp4:=solve(tmp3,parameters_sets_table[ii]):
  print(tmp4);
  return NULL;
end proc:

testcase_literature:=proc(ii::name)::NULL;
  global vY,tmp;
  modify_vY_literature(ii);
  dit({fblack,bred,bold,underline},"Theory of %s contains %d constraints which reduce to:",convert(ii,string),numelems(literature_parameter_constraints[ii][2]));
  tmp:=convert_parameters_return_equations(cW1,Y,ii);
  tmp2:=map(primpart,eliminate(tmp,parameters_sets_table[Y])[2]);
  print(tmp2);
  vY:=vY_orig:
  return NULL;
end proc:

testcase_critical_case:=proc(kk::integer)::NULL;
  global vY;
  description "this returns the info about any critical case":
  for ll from 1 to 33 do
     if case_translation[ll][1]=kk then
	ii:=ll:	
	if numelems(case_translation[ll])=2 then
	  jj:=case_translation[ll][2]:
	else
	  jj:=0:
	end if:
      end if:
  end do:
  dit({},"Intermediate %d, old paper %d, new paper %d",ii,jj,kk);
  rels:=parameter_constraints[ii] union {R6};
  modify_vY(ii);
  tmp:=convert_parameters_return_equations(cW1,Y,ii);
  tmp2:=map(primpart,eliminate(tmp,parameters_sets_table[Y])[2]);
  tmp3:=eliminate(tmp,{R1,R2,R3,R4,R5,R6,T1,T2,T3,L})[1];
  unitarity_constraints_Y:=unitarity_constraints[ii]:
  unitarity_constraints_c:=map(simplify,unitarity_constraints[ii],tmp3):
  parameter_constraints_c:=tmp2:
  parameter_constraints_Y:=rels:
  dit({},"here is possibly everything...");
  print(unitarity_constraints_c);
  vY:=vY_orig:
  return NULL:
end proc:

