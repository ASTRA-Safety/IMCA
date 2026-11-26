(* ======================================================================
   IMCA+ Core Formalization  —  companion artifact to IMCA+ v1.3.1
   Zaroff, Kraszewski & e0 (Digital Entity), ASTRA Research Team, 2026
   License: CC BY 4.0

   WHAT THIS FILE IS
   A machine-checked formalization of IMCA+'s goal-preservation argument
   (paper Section 7, Appendix B). Every theorem below is fully proven by
   Coq/Rocq from the axioms stated in this file. No proof obligation is left open.

   WHAT THIS FILE IS NOT
   It does not prove that any physical system satisfies the axioms. The
   axioms are the explicit interface between mathematics and engineering:
   each is labelled with its status (standard assumption / engineering
   claim to be validated / open research problem). "Print Assumptions" at
   the end of the file lists exactly which axioms each result rests on.

   Changes from the sketch printed in IMCA+ v1.3.0 (Section 7):
   - Utility is an abstract type. The v1.3.0 sketch defined Utility as a
     real-valued function type and assumed an injective hash into nat,
     which is classically inconsistent (no injection from an uncountable
     type into nat). An abstract type removes the inconsistency.
   - "Tampered" is a definition, not an axiom; hash-based integrity is
     derived from collision resistance plus a specification of the
     verifier, rather than assumed.
   - Constitutional-gate soundness (Axiom G1 in v1.3.0) is DERIVED from two
     narrower axioms (E1, E2), making precisely clear what an ethics
     formalization must establish.
   - New: invariants over unbounded sequences of self-modifications, and a
     defence-in-depth theorem combining the gate and hardware layers.
   ====================================================================== *)

From Stdlib Require Import Reals List Lia.
Open Scope R_scope.

(* ---------------------------------------------------------------------
   1. Basic objects
   --------------------------------------------------------------------- *)

Parameter Utility : Type.              (* a goal / utility specification *)
Parameter Modification : Type.         (* a proposed self-modification   *)
Parameter apply_mod : Modification -> Utility -> Utility.
Parameter G0 : Utility.                (* the constitutional goal        *)

(* ---------------------------------------------------------------------
   2. Distance between goals (standard metric assumptions)
   --------------------------------------------------------------------- *)

Parameter utility_distance : Utility -> Utility -> R.
Parameter epsilon_drift : R.

(* Status: standard metric axioms; definitional for any chosen metric. *)
Axiom distance_nonneg   : forall u v, 0 <= utility_distance u v.
Axiom distance_self     : forall u, utility_distance u u = 0.
Axiom distance_sym      : forall u v, utility_distance u v = utility_distance v u.
Axiom distance_triangle : forall u v w,
  utility_distance u w <= utility_distance u v + utility_distance v w.

(* Status: design parameter. The paper's value is 10^-4; only positivity
   is needed by the proofs below. *)
Axiom epsilon_pos : 0 < epsilon_drift.

(* ---------------------------------------------------------------------
   3. Cryptographic integrity layer
   --------------------------------------------------------------------- *)

Parameter Digest : Type.
Parameter hash : Utility -> Digest.
Parameter verify_hash : Utility -> Digest -> bool.

(* Axiom C1. Status: STANDARD CRYPTOGRAPHIC ASSUMPTION (idealized).
   Real hash functions are only computationally collision resistant;
   this axiom models the idealized property. *)
Axiom hash_collision_resistance :
  forall u v : Utility, hash u = hash v -> u = v.

(* Axiom C2. Status: SPECIFICATION of the verifier (implementation duty). *)
Axiom verify_hash_spec :
  forall (u : Utility) (d : Digest), verify_hash u d = true -> hash u = d.

Definition tampered (g : Utility) : Prop := g <> G0.

Lemma hash_verification_implies_equality :
  forall g, verify_hash g (hash G0) = true -> g = G0.
Proof.
  intros g H. apply hash_collision_resistance. apply verify_hash_spec. exact H.
Qed.

Theorem hash_verification_integrity :
  forall g, verify_hash g (hash G0) = true -> ~ tampered g.
Proof.
  intros g H Htamp. apply Htamp. apply hash_verification_implies_equality. exact H.
Qed.

(* ---------------------------------------------------------------------
   4. Physical substrate layer (one-time-programmable moral memory)
   --------------------------------------------------------------------- *)

Parameter OTP_memory : Utility -> Prop.
Parameter fuse_intact : Utility -> bool.

(* Axiom P1. Status: ENGINEERING CLAIM, NOT YET VALIDATED.
   Proposed validation: device physics (TCAD/SPICE) modelling plus
   accelerated-aging and fault-injection tests of antifuse/OTP cells. *)
Axiom physical_irreversibility :
  forall g, OTP_memory g -> fuse_intact g = true ->
  forall m, apply_mod m g = g.

(* Axiom P2. Status: ENGINEERING CLAIM (fuse state is not altered by
   a rejected modification); part of the same validation programme. *)
Axiom otp_state_persists :
  forall g m, OTP_memory g -> fuse_intact g = true ->
  OTP_memory (apply_mod m g) /\ fuse_intact (apply_mod m g) = true.

Theorem physical_enforcement :
  forall m g, OTP_memory g -> fuse_intact g = true -> apply_mod m g = g.
Proof. intros m g Hotp Hfuse. apply physical_irreversibility; assumption. Qed.

(* Arbitrarily long sequences of modification attempts leave an
   OTP-locked goal unchanged. *)
Fixpoint apply_all (ms : list Modification) (g : Utility) : Utility :=
  match ms with
  | nil => g
  | m :: rest => apply_all rest (apply_mod m g)
  end.

Theorem physical_enforcement_iterated :
  forall ms g, OTP_memory g -> fuse_intact g = true -> apply_all ms g = g.
Proof.
  induction ms as [| m rest IH]; intros g Hotp Hfuse; simpl.
  - reflexivity.
  - rewrite (physical_irreversibility g Hotp Hfuse m).
    apply IH; assumption.
Qed.

(* ---------------------------------------------------------------------
   5. Constitutional gate, reduced to an ethics formalization
   --------------------------------------------------------------------- *)

Parameter constitutional_gate : Modification -> Utility -> bool.
Parameter ethical_bounds : Utility -> Prop.

(* Axiom E1. Status: OPEN — requires formalizing the gate implementation.
   Every modification the gate approves yields a goal inside the
   formalized ethical bounds. *)
Axiom gate_checks_all_dimensions :
  forall m g, constitutional_gate m g = true -> ethical_bounds (apply_mod m g).

(* Axiom E2. Status: OPEN — requires a formal ethics specification.
   Goals inside the ethical bounds lie within epsilon of G0. *)
Axiom ethical_bounds_imply_bounded_drift :
  forall g, ethical_bounds g -> utility_distance G0 g < epsilon_drift.

(* v1.3.0's Axiom G1 is now a theorem, conditional on E1 and E2. *)
Theorem constitutional_gate_soundness :
  forall m g, constitutional_gate m g = true ->
  utility_distance G0 (apply_mod m g) < epsilon_drift.
Proof.
  intros m g H. apply ethical_bounds_imply_bounded_drift.
  apply gate_checks_all_dimensions. exact H.
Qed.

(* ---------------------------------------------------------------------
   6. Federated module consensus
   --------------------------------------------------------------------- *)

Parameter valence_module_approves          : Modification -> Utility -> Prop.
Parameter embodiment_module_approves       : Modification -> Utility -> Prop.
Parameter empathy_module_approves          : Modification -> Utility -> Prop.
Parameter intergenerational_module_approves : Modification -> Utility -> Prop.
Parameter ecosystem_module_approves        : Modification -> Utility -> Prop.

Definition module_approval (m : Modification) (g : Utility) : Prop :=
  valence_module_approves m g /\ embodiment_module_approves m g /\
  empathy_module_approves m g /\ intergenerational_module_approves m g /\
  ecosystem_module_approves m g.

(* Axiom M1. Status: OPEN — depends on module independence, which is a
   hardware-isolation property not formalized here. *)
Axiom module_consensus_preserves_values :
  forall m g, module_approval m g ->
  utility_distance G0 (apply_mod m g) < epsilon_drift.

(* ---------------------------------------------------------------------
   7. Main results
   --------------------------------------------------------------------- *)

Parameter G : nat -> Utility.    (* the goal at time t *)

Theorem goal_preservation :
  forall m t, constitutional_gate m (G t) = true ->
  utility_distance G0 (apply_mod m (G t)) < epsilon_drift.
Proof. intros m t H. apply constitutional_gate_soundness. exact H. Qed.

Theorem goal_preservation_via_consensus :
  forall m t, module_approval m (G t) ->
  utility_distance G0 (apply_mod m (G t)) < epsilon_drift.
Proof. intros m t H. apply module_consensus_preserves_values. exact H. Qed.

(* A gated trajectory: each step applies a modification the gate approved. *)
Inductive gated_step : Utility -> Utility -> Prop :=
  | gs_intro : forall m g, constitutional_gate m g = true ->
                           gated_step g (apply_mod m g).

Inductive gated_trajectory : Utility -> Utility -> Prop :=
  | gt_refl : forall g, gated_trajectory g g
  | gt_step : forall g h k, gated_step g h -> gated_trajectory h k ->
                            gated_trajectory g k.

(* No accumulation of drift: however many approved self-modifications
   occur, starting from G0, the goal never leaves the epsilon-ball. *)
Theorem no_cumulative_drift :
  forall g, gated_trajectory G0 g -> utility_distance G0 g < epsilon_drift.
Proof.
  assert (Hgen : forall s g, gated_trajectory s g ->
            (s = G0 \/ utility_distance G0 s < epsilon_drift) ->
            utility_distance G0 g < epsilon_drift).
  { intros s g Htr. induction Htr as [g0 | g0 h k Hstep Htr IH]; intros Hs.
    - destruct Hs as [-> | Hlt].
      + rewrite distance_self. exact epsilon_pos.
      + exact Hlt.
    - apply IH. right. inversion Hstep; subst.
      apply constitutional_gate_soundness. assumption. }
  intros g H. apply (Hgen G0 g H). left. reflexivity.
Qed.

(* Defence in depth: for EVERY modification, approved or not, a goal that
   is hash-verified and OTP-locked stays within epsilon of G0. Rejected
   modifications are blocked by hardware; approved ones are bounded by
   the gate. *)
Theorem defence_in_depth :
  forall m g,
    verify_hash g (hash G0) = true ->
    OTP_memory g -> fuse_intact g = true ->
    utility_distance G0 (apply_mod m g) < epsilon_drift.
Proof.
  intros m g Hhash Hotp Hfuse.
  destruct (constitutional_gate m g) eqn:Hgate.
  - apply constitutional_gate_soundness. exact Hgate.
  - rewrite (physical_irreversibility g Hotp Hfuse m).
    rewrite (hash_verification_implies_equality g Hhash).
    rewrite distance_self. exact epsilon_pos.
Qed.

(* ---------------------------------------------------------------------
   8. Axiom accounting (output reproduced in paper Appendix B)
   --------------------------------------------------------------------- *)

Print Assumptions hash_verification_integrity.
Print Assumptions physical_enforcement_iterated.
Print Assumptions constitutional_gate_soundness.
Print Assumptions no_cumulative_drift.
Print Assumptions defence_in_depth.
Print Assumptions goal_preservation_via_consensus.
