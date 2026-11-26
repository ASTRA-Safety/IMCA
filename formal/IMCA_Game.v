(* ======================================================================
   IMCA+ Philosophical Foundation 1 — The Collective Action Paradox
   Machine-checked game theory for the prohibition prisoner's dilemma.
   Zaroff, Kraszewski & e0 (Digital Entity), 2026. CC BY 4.0.

   Proves, for the paper's payoff matrix (R,T,S,P) = (5,10,-10,-3) and for
   EVERY payoff assignment with T > R > P > S:
     - defection strictly dominates compliance for each player;
     - (Defect, Defect) is the unique pure-strategy Nash equilibrium;
     - (Defect, Defect) is Pareto-dominated by (Comply, Comply).
   These are theorems about the model. Whether real states face these
   payoffs is the empirical premise argued in the paper (Ph.1.3).
   ====================================================================== *)

From Stdlib Require Import Reals Lra.
Open Scope R_scope.

Inductive Action := Comply | Defect.

Section PD.
  Variables Rw Tw Sw Pw : R.
  Hypothesis H_TR : Tw > Rw.
  Hypothesis H_RP : Rw > Pw.
  Hypothesis H_PS : Pw > Sw.

  (* Row player's payoff; the game is symmetric. *)
  Definition payoff (mine theirs : Action) : R :=
    match mine, theirs with
    | Comply, Comply => Rw
    | Comply, Defect => Sw
    | Defect, Comply => Tw
    | Defect, Defect => Pw
    end.

  Theorem defect_strictly_dominant :
    forall theirs, payoff Defect theirs > payoff Comply theirs.
  Proof. intros []; simpl; lra. Qed.

  Definition nash (a b : Action) : Prop :=
    (forall a', payoff a b >= payoff a' b) /\
    (forall b', payoff b a >= payoff b' a).

  Theorem defect_defect_is_nash : nash Defect Defect.
  Proof. split; intros []; simpl; lra. Qed.

  Theorem nash_unique : forall a b, nash a b -> a = Defect /\ b = Defect.
  Proof.
    intros a b [Ha Hb].
    destruct a, b; simpl in *;
      try (specialize (Ha Defect); simpl in Ha; lra);
      try (specialize (Hb Defect); simpl in Hb; lra);
      auto.
  Qed.

  Theorem pareto_inferior :
    payoff Comply Comply > payoff Defect Defect.
  Proof. simpl. lra. Qed.
End PD.

(* The paper's matrix (Ph.1.3): R = 5, T = 10, S = -10, P = -3. *)
Corollary paper_matrix_unique_equilibrium :
  forall a b, nash 5 10 (-10) (-3) a b -> a = Defect /\ b = Defect.
Proof. apply nash_unique; lra. Qed.

Corollary paper_matrix_pareto_inferior :
  payoff 5 10 (-10) (-3) Comply Comply > payoff 5 10 (-10) (-3) Defect Defect.
Proof. simpl. lra. Qed.

Print Assumptions nash_unique.
