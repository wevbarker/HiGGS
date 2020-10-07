with(StringTools):
with(LinearAlgebra):
with(CLIo):
read `tools.mpl`:
with(tools):

read(`parameters.mpl`):
read(`particle_content.mpl`):


read(`theory_tools.mpl`):

dit({},"test");

convert_parameters_print_equations(N,M);
convert_parameters_print_equations(N,Y);
convert_parameters_print_equations(Y,N);
convert_parameters_print_equations(N,W);
dit({},"now looking at function");

dit({},"simplify..");

read(`theories.mpl`):

sectors:=indices(Hamiltonian_partitions,`nolist`):
cases:=[indices(theories,`nolist`)]:
minimal_theories:=table([]):
eqs:=convert_parameters_return_equations(Y,N);

#eqs:=convert_parameters_return_equations(N,M);
#eqs:=convert_parameters_return_equations(M,N);
#fin();

cases:={seq(i,i=1..58)}:

viable_cases:={1,2,3,4,5,6,7,10,11,12,14,15,16,17,18,19}:

converted_theories:=table([]):

for ii in cases do
  converted_theories[ii]:=[simplify(theories[ii][1],eqs),theories[ii][2]]:
end do:

converted_theories_unitarity:=table([]):

for ii in cases do
  converted_theories_unitarity[ii]:=[simplify(theories[ii][3],eqs),theories[ii][2]]:
end do:

# here

selection:={3,17,20,24,25,26,28,32}:

cosmic_coefficients:=table([hA="\\alp{0}",hB1="\\bet{1}",hB2="\\bet{2}",hB3="\\bet{3}",hA1="\\alp{1}",hA2="\\alp{2}",hA3="\\alp{3}",hA4="\\alp{4}",hA5="\\alp{5}",hA6="\\alp{6}"]);

oneside:=proc(eq)
  return lhs(eq)-rhs(eq);
end proc:

for jj in selection do
  conditions:=converted_theories[jj][1]:
  better_condiions:=solve(conditions):
  best_conditions:=map(oneside,better_condiions) minus {0,hA}:
  constraint:=map(primpart,best_conditions):
  consr:=convert(constraint,string);
  for ii in hB1,hB2,hB3,hA1,hA2,hA3,hA4,hA5,hA6 do
    str:=eval(cosmic_coefficients[ii]);
    consr:=Substitute(consr,convert(ii,string),str);
    consr:=Substitute(consr,convert(ii,string),str);
  end do;
  star:=proc(s::string)::boolean;
    return evalb(s="*");
  end proc;
  consr:=Remove(star,consr);
  consr:=SubstituteAll(consr,",","=");
  consr:=cat("${",consr,"=0}$");
  constraint_||jj:=consr;

  conditions_unitarity:=converted_theories_unitarity[jj][1]:
  better_conditions_unitary:=map(simplify,conditions_unitarity,better_condiions):
  constraint:=better_conditions_unitary:
  inequalitise:=proc(expr::algebraic)::`<`;
    if op(1,expr)=-1 or op(1,expr)=-2 then
       return -primpart(expr)<0;	
    else
      return primpart(expr)>0;
    end if;
  end proc;
  constraint:=map(inequalitise,constraint);
  consr:=convert(constraint,string);
  for ii in hB1,hB2,hB3,hA1,hA2,hA3,hA4,hA5,hA6 do
    str:=eval(cosmic_coefficients[ii]);
    consr:=Substitute(consr,convert(ii,string),str);
    consr:=Substitute(consr,convert(ii,string),str);
    consr:=Substitute(consr,convert(ii,string),str);
  end do;
  star:=proc(s::string)::boolean;
    return evalb(s="*");
  end proc;
  consr:=Remove(star,consr);
  consr:=SubstituteAll(consr,",","\\wedge");
  consr:=cat("${",consr,"}$");
  unitarity_constraint_||jj:=consr;
  print(%);
end do;

particles:=proc(critical_case::integer)::NULL;
  local tmp,tmp2,gauge,gauges,m,p;
  tmp:=new_particle_content[critical_case];
  for JP in {J0Pm,J0Pp,J1Pm,J1Pp,J2Pm,J2Pp} do
    tmp2:=tmp[JP];
    if assigned(tmp2) then
      texfilename:=cat("../paper-4/particle_content_icons/critical_case_",convert(critical_case,string),"_",convert(JP,string),".tex");
      gauge:=-1;
      gauges:=numelems(convert(eval(tmp2),list));
      if gauges=1 then
	m:=3.5;
	p:=3.5;
      elif gauges=2 then
	m:=2.5;
	p:=4.5;
      elif gauges=3 then
	m:=1.5;
	p:=5.5;
      end if;
      m:=convert(m,string);
      p:=convert(p,string);
      writeto(texfilename);
      printf("\\documentclass[preview]{standalone}\n");
      printf("\\usepackage{tikz}\n");
      printf("\\usetikzlibrary{calc}\n");
      printf("\\usepackage{xcolor}\n");
      printf("\\definecolor{tordion}{RGB}{0,0,255}\n");
      printf("\\definecolor{agraviton}{RGB}{255,0,0}\n");
      printf("\\definecolor{sgraviton}{RGB}{0,255,0}\n");
      printf("\\begin{document}\n");
      printf("\\begin{tikzpicture}[node distance = 1.4cm, auto]\n");
      printf(cat("\\clip (225:",m,") rectangle (45:",p,");\n"));
      for excitation in tmp2 do
	gauge:=gauge+1;
	print_excitation(excitation,gauge);
      end do;
      printf("\\end{tikzpicture}\n");
      printf("\\end{document}\n");
      writeto(terminal);
    end if;
  end do;
  return NULL;
end proc;

(*
sample_particles:=proc(critical_case::integer)::NULL;
  local tmp,tmp2,gauge,gauges,m,p;
  tmp:=particle_content[critical_case];
  for JP in {J0Pm,J0Pp,J1Pm,J1Pp,J2Pm,J2Pp} do
    tmp2:=tmp[JP];
    if assigned(tmp2) then
      texfilename:=cat("../paper-4/particle_content_icons/sample_critical_case_",convert(critical_case,string),"_",convert(JP,string),".tex");
      gauge:=-1;
      gauges:=numelems(convert(eval(tmp2),list));
      if gauges=1 then
	m:=2;
	p:=2;
      elif gauges=2 then
	m:=1;
	p:=3;
      elif gauges=3 then
	m:=0;
	p:=4;
      end if;
      m:=convert(m,string);
      p:=convert(p,string);
      writeto(texfilename);
      printf("\\documentclass[preview]{standalone}\n");
      printf("\\usepackage{tikz}\n");
      printf("\\usetikzlibrary{calc}\n");
      printf("\\usepackage{xcolor}\n");
      printf("\\definecolor{tordion}{RGB}{0,0,255}\n");
      printf("\\definecolor{agraviton}{RGB}{255,0,0}\n");
      printf("\\definecolor{sgraviton}{RGB}{0,255,0}\n");
      printf("\\begin{document}\n");
      printf("\\begin{tikzpicture}[node distance = 1.4cm, auto]\n");
      printf(cat("\\clip (225:",m,") rectangle (45:",p,");\n"));
      for excitation in tmp2 do
	gauge:=gauge+1;
	print_excitation(excitation,gauge);
      end do;
      printf("\\end{tikzpicture}\n");
      printf("\\end{document}\n");
      writeto(terminal);
    end if;
  end do;
  return NULL;
end proc;
*)

print_excitation:=proc(excitation,gauge::integer)::NULL;
    local colour,x,y,r,coordinate,excitation_string;
    x:=convert(1.5*gauge,string);
    y:=convert(1.5*gauge,string);
    r:=convert(2*gauge,string);
    coordinate:=cat("gauge",convert(gauge,string));
    #printf(cat("\\coordinate (",coordinate,") at (",x,",",y,");\n"));
    printf(cat("\\coordinate (",coordinate,") at (45:",r,");\n"));
    if type(excitation,list) then
      excitation_string:=convert(excitation[1],string);
      colour:=colour_selector(excitation_string);
      if Search("v",excitation_string)<>0 then
	printf(cat("\\fill[",colour,"] (",coordinate,") -- (45:1) arc (45:225:1) -- cycle;\n"));
      elif Search("l",excitation_string)<>0 then
	printf(cat("\\fill[",colour,"] ($(",coordinate,")+(45:1)$) arc (45:225:1) -- ($(",coordinate,")+(225:0.5)$) -- ($(",coordinate,")+(225:0.5)$) arc (225:45:0.5) -- cycle;\n"));
      end if;
      excitation_string:=convert(excitation[2],string);
      colour:=colour_selector(excitation_string);
      if Search("v",excitation_string)<>0 then
	printf(cat("\\fill[",colour,"] (",coordinate,") -- (-135:1) arc (-135:45:1) -- cycle;\n"));
      elif Search("l",excitation_string)<>0 then
	printf(cat("\\fill[",colour,"] ($(",coordinate,")+(-135:1)$) arc (-135:45:1) -- ($(",coordinate,")+(45:0.5)$) -- ($(",coordinate,")+(45:0.5)$) arc (45:-135:0.5) -- cycle;\n"));
      end if;
    else
      excitation_string:=convert(excitation,string);
      colour:=colour_selector(excitation_string);
      if Search("v",excitation_string)<>0 then
	printf(cat("\\fill[",colour,"] (",coordinate,") circle (1);\n"));
      elif Search("l",excitation_string)<>0 then
	printf(cat("\\fill[",colour,",even odd rule] (",coordinate,") circle (1) (",coordinate,") circle (0.5);\n"));
      end if;
    end if;
  return NULL;
end proc;

colour_selector:=proc(excitation_string::string)::string;
  local colour;
  if Search("A",excitation_string)<>0 then
    colour:="tordion";
  elif Search("a",excitation_string)<>0 then
    colour:="agraviton";
  elif Search("s",excitation_string)<>0 then
    colour:="sgraviton";
  end if;
  return colour;
end proc;

for ii in selection do
    if assigned(particle_content[ii]) then
     particles(ii);
     sample_particles(ii);
    end if;
end do;

#	now we would like to craft the flesh of the table

writeto("../paper-4/particle_content_table.tex");
for ii in selection do
  printf(cat("\\criticalcase{",convert(ii,string),"}"));
  printf(cat("&",constraint_||ii));
  printf(cat("&",unitarity_constraint_||ii));
  printf(cat("& \\includegraphics[width=0.5cm]{particle_content_icons/critical_case_",convert(ii,string),"_J0Pm.pdf}"));
  printf(cat("& \\includegraphics[width=0.5cm]{particle_content_icons/critical_case_",convert(ii,string),"_J0Pp.pdf}"));
  printf(cat("& \\includegraphics[width=0.5cm]{particle_content_icons/critical_case_",convert(ii,string),"_J1Pm.pdf}"));
  printf(cat("& \\includegraphics[width=0.5cm]{particle_content_icons/critical_case_",convert(ii,string),"_J1Pp.pdf}"));
  printf(cat("& \\includegraphics[width=0.5cm]{particle_content_icons/critical_case_",convert(ii,string),"_J2Pm.pdf}"));
  printf(cat("& \\includegraphics[width=0.5cm]{particle_content_icons/critical_case_",convert(ii,string),"_J2Pp.pdf}"));
  if ii=3 then
     printf(cat("& \\includegraphics[width=0.5cm]{massive.pdf}\\includegraphics[width=0.5cm]{massless.pdf}\\includegraphics[width=0.5cm]{massless.pdf}"));
  elif ii=17 then
     printf(cat("& \\includegraphics[width=0.5cm]{massless.pdf}\\includegraphics[width=0.5cm]{massless.pdf}"));
  elif ii=20 then
     printf(cat("& \\multirow{6}{*}{\\includegraphics[width=0.5cm]{massive.pdf}}"));
  else
    printf("&");
  end if;
  printf("\\\\ \n");
  if ii in {3,17} then
    printf("\\hline \n");
  end if;
end do;
writeto(terminal);

fin();

