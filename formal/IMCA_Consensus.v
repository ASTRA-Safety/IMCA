(* ======================================================================
   IMCA+ Federated Conscience / Section 4.2 — Byzantine quorum safety
   Zaroff, Kraszewski & e0 (Digital Entity), 2026. CC BY 4.0.

   RESULTS.
     (1) Quorum intersection. Among n nodes of which at most f are
         faulty (Byzantine), if every decision requires a quorum of q
         distinct nodes and 2q > n + f, then any two quorums share at
         least one HONEST node. Hence two conflicting decisions can never
         both be certified by honest participants.
     (2) Corollary: with n = 3f + 1 and q = 2f + 1 the condition holds for
         every f.
     (3) Counterexample: n = 3, q = 2, f = 1 (\"2-of-3 signatures\") does
         NOT tolerate one Byzantine node: two quorums can overlap only in
         the faulty node. The v1.3.0 specification of Section 4.2 is
         corrected accordingly in v1.3.1.
   Nodes are natural numbers below n; sets are duplicate-free lists.
   ====================================================================== *)

From Stdlib Require Import List Arith Lia.
Import ListNotations.

Definition universe (n : nat) : list nat := seq 0 n.

Definition within (n : nat) (l : list nat) : Prop := incl l (universe n).

Lemma count_filter_split (p : nat -> bool) (l : list nat) :
  length (filter p l) + length (filter (fun x => negb (p x)) l) = length l.
Proof.
  induction l as [|x l IH]; simpl; [reflexivity|].
  destruct (p x); simpl; lia.
Qed.

Lemma nodup_filter_len_le (p : nat -> bool) (l F : list nat) :
  NoDup l -> (forall x, In x l -> p x = true -> In x F) ->
  length (filter p l) <= length F.
Proof.
  intros Hnd Hsub.
  apply NoDup_incl_length.
  - apply NoDup_filter. exact Hnd.
  - intros x Hx. apply filter_In in Hx as [Hin Hp]. apply Hsub; assumption.
Qed.

Definition memb (F : list nat) (x : nat) : bool :=
  if in_dec Nat.eq_dec x F then true else false.

Theorem quorum_intersection_honest :
  forall (n q f : nat) (Q1 Q2 F : list nat),
    NoDup Q1 -> NoDup Q2 -> NoDup F ->
    within n Q1 -> within n Q2 ->
    length Q1 >= q -> length Q2 >= q -> length F <= f ->
    2 * q > n + f ->
    exists x, In x Q1 /\ In x Q2 /\ ~ In x F.
Proof.
  intros n q f Q1 Q2 F Hn1 Hn2 HnF Hw1 Hw2 Hl1 Hl2 HlF Hq.
  (* Honest part of Q2 *)
  set (H2 := filter (fun x => negb (memb F x)) Q2).
  destruct (existsb (fun x => if in_dec Nat.eq_dec x Q1 then true else false) H2)
    eqn:Hex.
  - apply existsb_exists in Hex as [x [HxH2 HxQ1]].
    exists x. unfold H2 in HxH2. apply filter_In in HxH2 as [HxQ2 Hneg].
    destruct (in_dec Nat.eq_dec x Q1) as [HinQ1|]; [|discriminate].
    split; [exact HinQ1|]. split; [exact HxQ2|].
    unfold memb in Hneg. destruct (in_dec Nat.eq_dec x F); [discriminate|assumption].
  - exfalso.
    (* Q1 and H2 are disjoint, so Q1 ++ H2 is duplicate-free inside the universe. *)
    assert (Hdisj : forall x, In x H2 -> ~ In x Q1).
    { intros x Hx Hq1.
      assert (existsb (fun x => if in_dec Nat.eq_dec x Q1 then true else false) H2 = true).
      { apply existsb_exists. exists x. split; [exact Hx|].
        destruct (in_dec Nat.eq_dec x Q1); [reflexivity|contradiction]. }
      congruence. }
    assert (HndH2 : NoDup H2) by (apply NoDup_filter; exact Hn2).
    assert (Hnd : NoDup (Q1 ++ H2)).
    { apply NoDup_app; try assumption.
      intros x Hx1 Hx2. exact (Hdisj x Hx2 Hx1). }
    assert (Hincl : incl (Q1 ++ H2) (universe n)).
    { intros x Hx. apply in_app_or in Hx as [Hx|Hx].
      - apply Hw1; exact Hx.
      - unfold H2 in Hx. apply filter_In in Hx as [Hx _]. apply Hw2; exact Hx. }
    pose proof (NoDup_incl_length Hnd Hincl) as Hlen.
    rewrite length_app in Hlen. unfold universe in Hlen. rewrite length_seq in Hlen.
    (* |H2| >= |Q2| - |F| *)
    pose proof (count_filter_split (memb F) Q2) as Hsplit.
    assert (Hfaulty : length (filter (memb F) Q2) <= length F).
    { apply nodup_filter_len_le; [exact Hn2|].
      intros x _ Hp. unfold memb in Hp.
      destruct (in_dec Nat.eq_dec x F); [assumption|discriminate]. }
    fold H2 in Hsplit. lia.
Qed.

Corollary classic_bft_bound :
  forall f Q1 Q2 F,
    NoDup Q1 -> NoDup Q2 -> NoDup F ->
    within (3 * f + 1) Q1 -> within (3 * f + 1) Q2 ->
    length Q1 >= 2 * f + 1 -> length Q2 >= 2 * f + 1 -> length F <= f ->
    exists x, In x Q1 /\ In x Q2 /\ ~ In x F.
Proof.
  intros f Q1 Q2 F ? ? ? ? ? ? ? ?.
  eapply (quorum_intersection_honest (3 * f + 1) (2 * f + 1) f); eauto. lia.
Qed.

(* Counterexample: 3 observers, 2-of-3 quorums, one Byzantine node. *)
Theorem two_of_three_not_byzantine_safe :
  exists Q1 Q2 F : list nat,
    NoDup Q1 /\ NoDup Q2 /\ within 3 Q1 /\ within 3 Q2 /\
    length Q1 = 2 /\ length Q2 = 2 /\ length F = 1 /\
    ~ (exists x, In x Q1 /\ In x Q2 /\ ~ In x F).
Proof.
  exists [0; 1], [0; 2], [0].
  repeat split.
  - repeat constructor; simpl; intuition discriminate.
  - repeat constructor; simpl; intuition discriminate.
  - intros x Hx. simpl in *. unfold universe; simpl. intuition.
  - intros x Hx. simpl in *. unfold universe; simpl. intuition.
  - intros [x [H1 [H2 H3]]]. simpl in *.
    destruct H1 as [<-|[<-|[]]]; destruct H2 as [E|[E|[]]]; try discriminate;
      apply H3; auto.
Qed.

Print Assumptions quorum_intersection_honest.
