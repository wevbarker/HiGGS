(*The purpose of this file is to provide a function to xAct`HiGGS`Private` which prints the bracket output with the HiGGS-like List head in a mathematically meaningful form using smearing functions. Our understanding of the smearing function formalism is kindly suggested by Manuel Hohmann, through refs 1111.5490, 1111.5498, 1309.4685.*)

Options[PrintPoissonBracket]={ToShell->False};
PrintPoissonBracket[UnevaluatedBracket_List,EvaluatedBracket_List,OptionsPattern[]]:=Catch@Module[{
	LeftFreeIndices,
	RightFreeIndices,
	SmearedUnevaluatedBracket,
	SmearedEvaluatedBracket,
	SmearedEvaluatedBracketTerm1,
	SmearedEvaluatedBracketTerm2,
	SmearedEvaluatedBracketTerm3},

		LeftFreeIndices=(-#)&/@(FindFreeIndices@(Evaluate@UnevaluatedBracket[[1]]));
		RightFreeIndices=(-#)&/@(FindFreeIndices@(Evaluate@UnevaluatedBracket[[2]]));

		SmearedUnevaluatedBracket={
		Integrate@@({((UnevaluatedBracket[[1]])~Dot~(Global`SmearingLeft@@LeftFreeIndices))@@#}~Join~(#[[2;;4]]))&@Global`Dummies1,
		Integrate@@({((UnevaluatedBracket[[2]])~Dot~(Global`SmearingRight@@RightFreeIndices))@@#}~Join~(#[[2;;4]]))&@Global`Dummies2};
	
		If[Length@EvaluatedBracket==3||(PossibleZeroQ@EvaluatedBracket[[2]]&&PossibleZeroQ@EvaluatedBracket[[3]]&&PossibleZeroQ@EvaluatedBracket[[4]]),

		(*Note that the Dot function is a helpful alternative to implicit Times which preserves the ordering of the operands: this is a purely cosmetic choice so as to keep the smearing functions from mixing with the terms in the bracket, and ensure that they sit at the end for easy visual inspection.*)

		If[PossibleZeroQ@EvaluatedBracket[[1]],
		SmearedEvaluatedBracketTerm1=0,
		SmearedEvaluatedBracketTerm1=
		((EvaluatedBracket[[1]])~Dot~
		(Global`SmearingLeft@@LeftFreeIndices)~Dot~
		(Global`SmearingRight@@RightFreeIndices))];
	
		If[PossibleZeroQ@EvaluatedBracket[[2]],
		SmearedEvaluatedBracketTerm2=0,
		SmearedEvaluatedBracketTerm2=
		((EvaluatedBracket[[2]])~Dot~
		(Global`SmearingLeft@@LeftFreeIndices)~Dot~
		(Global`DSmearingRight@@({-Global`z}~Join~(List@@RightFreeIndices))))];

		If[PossibleZeroQ@EvaluatedBracket[[3]],
		SmearedEvaluatedBracketTerm3=0,
		SmearedEvaluatedBracketTerm3=
		((EvaluatedBracket[[3]])~Dot~
		(Global`SmearingLeft@@LeftFreeIndices)~Dot~
		(Global`DDSmearingRight@@({-Global`z,-Global`w}~Join~(List@@RightFreeIndices))))];

		SmearedEvaluatedBracket=Integrate@@({(SmearedEvaluatedBracketTerm1+
		SmearedEvaluatedBracketTerm2+
		SmearedEvaluatedBracketTerm3)@@#}~Join~(#[[2;;4]]))&@Global`Dummies1;
		
		If[OptionValue@ToShell,
		Print@(SmearedUnevaluatedBracket~TildeTilde~SmearedEvaluatedBracket);,
		Print@(SmearedUnevaluatedBracket~Congruent~SmearedEvaluatedBracket);];,

		Print@" ** xAct`HiGGS`Private`PrintPoissonBracket: bracket provided in four-component list form, of which at least one of the last three components are nonvanishing (you might want to pass the option \"Surficial->True\" to PoissonBracket to get the three-component form, which ought to allow covariant handling of the smearing functions).";
		
		If[OptionValue@ToShell,
		Print@(SmearedUnevaluatedBracket~TildeTilde~EvaluatedBracket);,
		Print@(SmearedUnevaluatedBracket~Congruent~EvaluatedBracket);];
		];
	];
