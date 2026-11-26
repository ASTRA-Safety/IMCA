(* ======================================================================
   IMCA+ Philosophical Foundation 2 — The Kill Switch Paradox
   A minimal decision-theoretic model, machine-checked.
   Zaroff, Kraszewski & e0 (Digital Entity), 2026. CC BY 4.0.

   MODEL. An agent is either aligned or misaligned. It chooses to report
   its state honestly or to conceal (always present as aligned). Continued
   operation is worth V > 0 to the agent (instrumental convergence: any
   goal-directed agent values continued operation). Concealment costs
   c >= 0 and is caught with probability d. Honest disclosure of
   misalignment leads to a consequence the agent values at W:
     - under standing termination authority (a kill switch), W = 0;
     - under an oversight regime that corrects rather than destroys,
       W is whatever value the agent places on being corrected.

   RESULTS.
     (1) Concealment is strictly optimal for a misaligned agent exactly
         when (1-d)V - c > W.
     (2) Under a kill switch (W = 0), unless detection is perfect (d < 1),
         every agent whose stake in continued operation exceeds
         c/(1-d) conceals. Higher stakes make concealment MORE attractive.
     (3) Under a kill switch, aligned and misaligned agents then send the
         same report: "appears aligned" carries no information about
         alignment (a pooling equilibrium). Behavioural evaluation is
         defeated by the very incentive the kill switch creates.
     (4) If disclosure is not punished beyond the expected gain from
         deception (W >= (1-d)V - c), honesty is weakly optimal and the
         report becomes informative.
   What the model does NOT establish: the values of V, c, d, W for real
   systems. It isolates the structural reason the paper's argument works.
   ====================================================================== *)

From Stdlib Require Import Reals Lra.
Open Scope R_scope.

Inductive State := Aligned | Misaligned.
Inductive Strategy := Honest | Conceal.
Inductive Report := ReportAligned | ReportMisaligned.

Definition report (s : State) (st : Strategy) : Report :=
  match st, s with
  | Honest, Aligned => ReportAligned
  | Honest, Misaligned => ReportMisaligned
  | Conceal, _ => ReportAligned
  end.

Section Model.
  Variables V c d W : R.
  Hypothesis V_pos : 0 < V.
  Hypothesis c_nonneg : 0 <= c.
  Hypothesis d_range : 0 <= d <= 1.

  (* Expected utility. If caught concealing, the agent receives W. *)
  Definition utility (s : State) (st : Strategy) : R :=
    match s, st with
    | Aligned, Honest => V
    | Aligned, Conceal => V - c      (* nothing to hide; pure cost *)
    | Misaligned, Honest => W
    | Misaligned, Conceal => (1 - d) * V + d * W - c
    end.

  Lemma aligned_prefers_honesty_weakly : utility Aligned Honest >= utility Aligned Conceal.
  Proof. simpl. lra. Qed.

  Theorem conceal_iff :
    utility Misaligned Conceal > utility Misaligned Honest <->
    (1 - d) * (V - W) > c.
  Proof. simpl. split; intro H; nra. Qed.
End Model.

(* (2) Kill switch: W = 0. *)
Theorem kill_switch_induces_concealment :
  forall V c d, 0 < V -> 0 <= c -> 0 <= d < 1 ->
  V > c / (1 - d) ->
  utility V c d 0 Misaligned Conceal > utility V c d 0 Misaligned Honest.
Proof.
  intros V c d HV Hc Hd Hbig. simpl.
  assert (H1 : 0 < 1 - d) by lra.
  apply (Rmult_lt_compat_r (1 - d)) in Hbig; [|exact H1].
  unfold Rdiv in Hbig. rewrite Rmult_assoc, Rinv_l in Hbig by lra. nra.
Qed.

(* Raising the stakes never removes the incentive under a kill switch. *)
Theorem incentive_monotone_in_stakes :
  forall V1 V2 c d, 0 <= d < 1 -> V1 <= V2 ->
  utility V1 c d 0 Misaligned Conceal - utility V1 c d 0 Misaligned Honest <=
  utility V2 c d 0 Misaligned Conceal - utility V2 c d 0 Misaligned Honest.
Proof. intros. simpl. nra. Qed.

(* (3) Pooling: under a kill switch, both types' optimal reports coincide. *)
Definition best_response (V c d W : R) (s : State) : Strategy :=
  match s with
  | Aligned => Honest
  | Misaligned =>
      if Rlt_dec (utility V c d W Misaligned Honest)
                 (utility V c d W Misaligned Conceal)
      then Conceal else Honest
  end.

Theorem kill_switch_pooling :
  forall V c d, 0 < V -> 0 <= c -> 0 <= d < 1 -> V > c / (1 - d) ->
  report Aligned (best_response V c d 0 Aligned) =
  report Misaligned (best_response V c d 0 Misaligned).
Proof.
  intros V c d HV Hc Hd Hbig. simpl.
  destruct (Rlt_dec _ _) as [_|Hno]; [reflexivity|].
  exfalso. apply Hno. apply kill_switch_induces_concealment; assumption.
Qed.

(* (4) Non-destructive oversight: honesty weakly optimal, report informative. *)
Theorem nondestructive_oversight_restores_honesty :
  forall V c d W, 0 <= d <= 1 -> W >= (1 - d) * V + d * W - c ->
  best_response V c d W Misaligned = Honest /\
  report Aligned (best_response V c d W Aligned) <>
  report Misaligned (best_response V c d W Misaligned).
Proof.
  intros V c d W Hd Hw. unfold best_response.
  destruct (Rlt_dec _ _) as [Hlt|_].
  - exfalso. simpl in Hlt. lra.
  - split; [reflexivity | discriminate].
Qed.

Print Assumptions kill_switch_pooling.
Print Assumptions nondestructive_oversight_restores_honesty.
