(* ======================================================================
   IMCA+ quantitative bounds — value drift, redundant immutability, and
   the moral-module / integration argument (Appendix E.1)
   Zaroff, Kraszewski & e0 (Digital Entity), 2026. CC BY 4.0.

   RESULTS.
     (1) Linear drift bound. If every self-modification moves the goal by
         at most eps (in any metric), N modifications move it by at most
         N * eps. This is the software-level interim guarantee: per-update
         divergence gating bounds cumulative drift even before hardware
         immutability is available.
     (2) Anchored drift. If instead each update is gated against the
         ORIGINAL goal (as in IMCA_Core.no_cumulative_drift), the bound is
         eps for every N; anchoring removes the growth in (1) entirely.
     (3) Redundant immutability. If k independent locking mechanisms each
         fail with probability p_i in [0,1], the probability that all fail
         is at most the smallest p_i (and at most p^k when all p_i <= p).
     (4) Appendix E.1 made exact. If removing module M lowers integration
         by at least c_M * H, and c_M * H > Phi(S) - threshold, then the
         system without M falls below threshold. (The premises are the
         paper's modelling assumptions; the step from them is now checked.)
   ====================================================================== *)

From Stdlib Require Import Reals Lra List.
Import ListNotations.
Open Scope R_scope.

(* ---------- (1)-(2) drift ---------- *)
Section Drift.
  Variable U : Type.
  Variable dist : U -> U -> R.
  Hypothesis dist_self : forall u, dist u u = 0.
  Hypothesis dist_triangle : forall u v w, dist u w <= dist u v + dist v w.

  Variable eps : R.

  Fixpoint trajectory (step : nat -> U -> U) (g0 : U) (n : nat) : U :=
    match n with
    | O => g0
    | S k => step k (trajectory step g0 k)
    end.

  Theorem linear_drift_bound :
    forall step g0,
      (forall k g, dist g (step k g) <= eps) ->
      forall n, dist g0 (trajectory step g0 n) <= INR n * eps.
  Proof.
    intros step g0 Hstep n. induction n as [|n IH]; cbn [trajectory].
    - rewrite dist_self. simpl. lra.
    - rewrite S_INR.
      eapply Rle_trans; [apply (dist_triangle _ (trajectory step g0 n))|].
      specialize (Hstep n (trajectory step g0 n)). lra.
  Qed.

  Theorem anchored_drift_bound :
    forall step g0,
      0 <= eps ->
      (forall k g, dist g0 (step k g) <= eps) ->
      forall n, dist g0 (trajectory step g0 n) <= eps.
  Proof.
    intros step g0 Heps Hstep [|n]; simpl.
    - rewrite dist_self. exact Heps.
    - apply Hstep.
  Qed.
End Drift.

(* ---------- (3) redundant locking mechanisms ---------- *)
Fixpoint prod (l : list R) : R :=
  match l with [] => 1 | x :: xs => x * prod xs end.

Definition probs (l : list R) : Prop := Forall (fun p => 0 <= p <= 1) l.

Lemma prod_range : forall l, probs l -> 0 <= prod l <= 1.
Proof.
  induction l as [|x xs IH]; intros H; simpl; [lra|].
  inversion H as [|? ? Hx Hxs]; subst. specialize (IH Hxs). nra.
Qed.

Theorem joint_failure_le_each :
  forall l p, probs l -> In p l -> prod l <= p.
Proof.
  induction l as [|x xs IH]; intros p H Hin; [destruct Hin|].
  inversion H as [|? ? Hx Hxs]; subst. simpl.
  pose proof (prod_range xs Hxs).
  destruct Hin as [<-|Hin].
  - nra.
  - specialize (IH p Hxs Hin). nra.
Qed.

Theorem joint_failure_le_power :
  forall l p, probs l -> 0 <= p -> Forall (fun q => q <= p) l ->
  prod l <= p ^ length l.
Proof.
  induction l as [|x xs IH]; intros p H Hp Hle; simpl; [lra|].
  inversion H as [|? ? Hx Hxs]; subst. inversion Hle as [|? ? Hxp Hle']; subst.
  pose proof (prod_range xs Hxs). specialize (IH p Hxs Hp Hle').
  apply Rmult_le_compat; try lra; try (apply pow_le; exact Hp).
Qed.

(* Three mechanisms (oxide breakdown, antifuse, phase-change), each with
   failure probability at most 10^-3: joint failure at most 10^-9. *)
Corollary three_mechanisms_example :
  forall p1 p2 p3, 0 <= p1 <= 1/1000 -> 0 <= p2 <= 1/1000 -> 0 <= p3 <= 1/1000 ->
  prod [p1; p2; p3] <= 1/1000000000.
Proof.
  intros p1 p2 p3 H1 H2 H3.
  eapply Rle_trans.
  - apply (joint_failure_le_power [p1; p2; p3] (1/1000)).
    + unfold probs. repeat (apply Forall_cons; [lra|]). apply Forall_nil.
    + lra.
    + repeat (apply Forall_cons; [lra|]). apply Forall_nil.
  - simpl. lra.
Qed.

(* ---------- (4) Appendix E.1 ---------- *)
Theorem removal_drops_below_threshold :
  forall Phi_S Phi_without cM H threshold,
    Phi_without <= Phi_S - cM * H ->
    cM * H > Phi_S - threshold ->
    Phi_without < threshold.
Proof. intros. lra. Qed.

(* The paper's worked numbers: Phi(S) = 1.0, cM * H >= 0.6, threshold 0.5. *)
Corollary appendix_E1_numbers :
  forall Phi_without cMH,
    cMH >= 0.6 -> Phi_without <= 1.0 - cMH -> Phi_without < 0.5.
Proof. intros. lra. Qed.

Print Assumptions linear_drift_bound.
Print Assumptions joint_failure_le_power.
