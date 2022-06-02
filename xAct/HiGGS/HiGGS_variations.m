(* ::Package:: *)

Needs["xAct`xPert`"]
Needs["xAct`xTensor`"]
PerturbAction[expr_,g_?MetricQ[a_?UpIndexQ,b_?UpIndexQ]|g_?MetricQ[a_?DownIndexQ,b_?DownIndexQ]]:=Module[{pertexpr,res,dgloc,(*dummyloc,*)hp,printer},
printer=PrintTemporary[" ** VarAction..."];
(* We define the metric perturbation, if not defined already *)
dgloc=SymbolJoin["\[Delta]",g];
hp=Head@Perturbation[g[DownIndex@a,DownIndex@b]];

If[hp===Perturbation,DefMetricPerturbation[g,dgloc,SymbolJoin["\[Epsilon]",g]],dgloc=hp];


Block[{$DefInfoQ=False},

(* We perturb wrt to the metric and if it is the inverse metric we put a minus sign *)
pertexpr=(If[DownIndexQ[a],1,-1])*ToCanonical@ContractMetric@ExpandPerturbation@Perturbation[expr]/.Perturbation[tens_]:>0;

(*We then use VarD. It happens that some trivial Kronecker appear which need to be handle manually *)
res=ToCanonical[(SameDummies@ContractMetric@VarD[dgloc[LI[1],a,b],CovDOfMetric[g]][pertexpr])/.delta[-LI[n_],LI[m_]]:>KroneckerDelta[NoScalar[n],NoScalar[m]]];
];
NotebookDelete[printer];
res
]

PerturbAction[expr_,tensor_?xTensorQ,covd_]:=Module[{res,dummyloc,pertexpr,inds,printer},
printer=PrintTemporary[" ** VarAction..."];
Block[{$DefInfoQ=False},

(* We use a dummy name for the variation of the tensor, 
and use it to replace the formal first order perturbation the tensor *)
(* So first we define this dummy tensor *)
dummyloc=SymbolJoin["Var",tensor];
inds=DummyIn/@SlotsOfTensor[tensor];
If[!xTensorQ[dummyloc],DefTensor[dummyloc@@inds,First@DependenciesOfTensor@tensor]];
SymmetryGroupOfTensor[dummyloc]^=SymmetryGroupOfTensor[tensor];

(* Then we perturb the action and replace Perturbation[Tensor[..]] by this dummy tensor *)
pertexpr=(ToCanonical@ContractMetric[ExpandPerturbation@Perturbation[expr]/.Perturbation[tens_?((#=!=tensor)&)[ar___]]:>0/.Perturbation[tensor[ind___]]:>dummyloc[ind]]);

(* With this simple head, VarD works correctly. Again we need to handel some trivial Kronecker *)
res=ToCanonical[(SameDummies@ContractMetric@VarD[dummyloc@@inds,covd][pertexpr])/.delta[-LI[n_],LI[m_]]:>KroneckerDelta[NoScalar[n],NoScalar[m]]];
];
NotebookDelete[printer];
res
]
PerturbAction[expr_,tensor_[inds___]]:=PerturbAction[expr,tensor[inds],CovDOfMetric@First@$Metrics]
PerturbAction[expr_,tensor_?xTensorQ[inds___],covd_]:=Module[{res,dummyloc,pertexpr,printer},
printer=PrintTemporary[" ** VarAction..."];
Block[{$DefInfoQ=False},
dummyloc=SymbolJoin["Var",tensor];

If[!xTensorQ[dummyloc],DefTensor[dummyloc[inds],First@DependenciesOfTensor@tensor]];
SymmetryGroupOfTensor[dummyloc]^=SymmetryGroupOfTensor[tensor];

(* Perturbation with xPert*)
pertexpr=(ToCanonical@ContractMetric[ExpandPerturbation@Perturbation[expr]/.Perturbation[tens_?((#=!=tensor)&)[ar___]]:>0/.Perturbation[tensor[ind___]]:>dummyloc[ind]]);
(* VarD and removal of KroneckerDelta*)
res=ToCanonical[(SameDummies@ContractMetric@VarD[dummyloc[inds],covd][pertexpr])/.delta[-LI[n_],LI[m_]]:>KroneckerDelta[NoScalar[n],NoScalar[m]]];
];
NotebookDelete[printer];
res
]
VarAction[expr_,g_?MetricQ[as__?((UpIndexQ[#]||DownIndexQ[#])&)]]:=Module[{sqrtg},
sqrtg=Sqrt[SignDetOfMetric[g]Determinant[g][]];
ToCanonical[PerturbAction[expr,g[as]]+ReplaceDummies@expr*PerturbAction[sqrtg,g[as]]/sqrtg ]
]
VarAction[expr_,tensor_?((xTensorQ[#]&&Not[MetricQ[#]])&),g_?MetricQ]:=PerturbAction[expr,tensor,CovDOfMetric[g]]
VarAction[expr_,tensor_?((xTensorQ[#]&&Not[MetricQ[#]])&)]:=VarAction[expr,tensor,First@$Metrics];

VarAction[expr_,tensor_?((xTensorQ[#]&&Not[MetricQ[#]])&)[inds___],g_?MetricQ]:=PerturbAction[expr,tensor[inds],CovDOfMetric[g]]
VarAction[expr_,tensor_?((xTensorQ[#]&&Not[MetricQ[#]])&)[inds___]]:=VarAction[expr,tensor[inds],First@$Metrics];
