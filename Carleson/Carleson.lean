import Carleson.Proposition1

open MeasureTheory Measure NNReal Metric Complex Set Function BigOperators
open scoped ENNReal
noncomputable section
local macro_rules | `($x ^ $y) => `(HPow.hPow $x $y) -- Porting note: See issue lean4#2220

/- The constant used in theorem1_1 -/
def C1_1 (A : ℝ) (τ q : ℝ) : ℝ := sorry

lemma C1_1_pos (A : ℝ) (τ q : ℝ) : C1_1 A τ q > 0 := sorry

/- The constant used in equation (2.2) -/
def Ce2_2 (A : ℝ) (τ q : ℝ) : ℝ := sorry

lemma Ce2_2_pos (A : ℝ) (τ q : ℝ) : Ce2_2 A τ q > 0 := sorry

/- The constant used in equation (3.1) -/
def Ce3_1 (A : ℝ) (τ q : ℝ) : ℝ := sorry

lemma Ce3_1_pos (A : ℝ) (τ q : ℝ) : Ce3_1 A τ q > 0 := sorry

section

variable {X : Type*} {A : ℝ} [MetricSpace X] [IsSpaceOfHomogeneousType X A] [Inhabited X]
variable {τ q q' : ℝ} {C : ℝ}
variable {𝓠 : Set C(X, ℂ)} [IsCompatible 𝓠] [IsCancellative τ 𝓠]
variable {F G : Set X}
variable (K : X → X → ℂ) [IsCZKernel τ K]

def D1_1 (A : ℝ) (τ q : ℝ) : ℝ := sorry

lemma two_lt_D1_1 (A : ℝ) (τ q : ℝ) : 2 < D1_1 A τ q := sorry

lemma D1_1_pos (A : ℝ) (τ q : ℝ) : D1_1 A τ q > 0 := zero_lt_two.trans (two_lt_D1_1 A τ q)

def Cψ1_1 (A : ℝ) (τ q : ℝ) : ℝ≥0 := sorry

lemma Cψ1_1_pos (A : ℝ) (τ : ℝ) : Cψ2_1 A τ C > 0 := sorry

/- extra variables not in theorem 1.1. -/
variable {D : ℝ} {ψ : ℝ → ℝ} {s : ℤ} {x y : X}

/- the one or two numbers `s` where `ψ (D ^ s * x)` is possibly nonzero -/
variable (D) in def nonzeroS (x : ℝ) : Finset ℤ :=
  Finset.Icc ⌈- (Real.log (4 * x) / Real.log D + 1)⌉ ⌊- Real.log (2 * x) / Real.log D⌋


variable
    (hD : D > D1_1 A τ q)
    (hψ : LipschitzWith (Cψ1_1 A τ q) ψ)
    (h2ψ : support ψ ⊆ Icc (4 * D)⁻¹ 2⁻¹)
    (h3ψ : ∀ x > 0, ∑ s in nonzeroS D x, ψ (D ^ s * x) = 1)

lemma mem_Icc_of_ψ_ne_zero {x : ℝ} (h : ψ (D ^ s * x) ≠ 0) :
    s ∈ nonzeroS D x := by sorry

variable (D ψ s) in
def Ks (x y : X) : ℂ := K x y * ψ (D ^ s * dist x y)

lemma sum_Ks (h : 0 < dist x y) : ∑ s in nonzeroS D (dist x y), Ks K D ψ s x y = K x y := by
  simp_rw [Ks, ← Finset.mul_sum]
  norm_cast
  rw [h3ψ _ h]
  norm_cast
  rw [mul_one]

/- (No need to take the supremum over the assumption `σ < σ'`.) -/
lemma equation3_1 (f : X → ℂ) :
    CarlesonOperator K 𝓠 f x ≤ Ce3_1 A τ q * maximalFunction f x +
    ⨆ (Q ∈ 𝓠) (σ : ℤ) (σ' : ℤ),
    ‖∑ s in Finset.Icc σ σ', ∫ y, Ks K D ψ s x y * f y * exp (I * (Q y - Q x))‖₊ := by
  rw [CarlesonOperator]
  apply Real.iSup_le
  intro (Q : C(X,ℂ))
  apply Real.iSup_le
  intro hQ
  apply Real.iSup_le
  intro r
  apply Real.iSup_le
  intro R
  apply Real.iSup_le
  intro hrR
  let σ : ℤ := ⌊Real.log r / Real.log 2⌋
  let σ' : ℤ := ⌊Real.log R / Real.log 2⌋
  trans Ce3_1 A τ q * maximalFunction f x +
    ‖∑ s in Finset.Icc σ σ', ∫ y, Ks K D ψ s x y * f y * exp (I * (Q y - Q x))‖
  rw [← sub_le_iff_le_add]
  simp_rw [mul_sub, Complex.exp_sub, mul_div, integral_div, ← Finset.sum_div,
    norm_div]
  lift Q x to ℝ with qx
  · sorry
  simp only [mul_comm I qx, norm_exp_ofReal_mul_I, div_one]
  /- use h3ψ here to rewrite the RHS -/
  apply (norm_sub_norm_le _ _).trans
  rw [← integral_finset_sum]
  all_goals sorry
  -- swap
  -- · gcongr
  --   refine (le_ciSup _ Q).trans ?_
  --   sorry

  /- Proof should be straightward from the definition of maximalFunction and conditions on `𝓠`.
  We have to approximate `Q` by an indicator function.
  2^σ ≈ r, 2^σ' ≈ R
  There is a small difference in integration domain, and for that we use the estimate IsCZKernel.norm_le_vol_inv


  -/

variable (C F G) in
/- G₀-tilde in the paper -/
def G₀' : Set X :=
  { x : X | maximalFunction (F.indicator (1 : X → ℂ)) x > C * volume.real F / volume.real G }

/- estimation of the volume of G₀' -/
lemma volume_G₀'_pos (hC : C1_1 A τ q < C) : volume.real (G₀' C F G) ≤ volume.real G / 4 := sorry

/- estimate first term (what does this mean exactly?) -/

/- for the second term, get Qtilde, σ, σ' as `MeasureTheory.SimpleFunc`.
Lars' argument:
* We can make the suprema countable, and then only consider a finite initial
segment. -/

/- define smin, smax -/

/- Lemma 3.1: obtain a Grid structure. Proof: [Chr90, Thm 11]. Taken by Joe Trate -/

/- Lemma 3.2: estimate local oscillation -/

/- Lemma 3.3: obtain tile structure -/

/- finish proof of equation (2.2) -/

theorem equation2_2
    (hA : 1 < A) (hτ : τ ∈ Ioo 0 1) (hq : q ∈ Ioc 1 2) (hqq' : q.IsConjugateExponent q')
    (hF : MeasurableSet F) (hG : MeasurableSet G)
    (h2F : volume F ∈ Ioo 0 ∞) (h2G : volume G ∈ Ioo 0 ∞)
    (hT : NormBoundedBy (ANCZOperatorLp 2 K) 1) :
    ∃ G', volume G' ≤ volume G / 2 ∧
    ‖∫ x in G \ G', CarlesonOperator K 𝓠 (indicator F 1) x‖₊ ≤
    Ce2_2 A τ q * (volume.real G) ^ (1 / q') * (volume.real F) ^ (1 / q) := by
  sorry

/- to prove theorem 1.1 from (2.2): bootstrapping argument, recursing over excised sets.
(section 2). -/

/- Theorem 1.1, written using constant C1_1 -/
theorem theorem1_1C
    (hA : 1 < A) (hτ : τ ∈ Ioo 0 1) (hq : q ∈ Ioc 1 2) (hqq' : q.IsConjugateExponent q')
    (hF : MeasurableSet F) (hG : MeasurableSet G)
    -- (h2F : volume F ∈ Ioo 0 ∞) (h2G : volume G ∈ Ioo 0 ∞)
    (hT : NormBoundedBy (ANCZOperatorLp 2 K) 1) :
    ‖∫ x in G, CarlesonOperator K 𝓠 (indicator F 1) x‖₊ ≤
    C1_1 A τ q * (volume.real G) ^ (1 / q') * (volume.real F) ^ (1 / q) := by
  sorry

/- Specialize this to get the usual version of Carleson's theorem,
by taking `X = ℝ`, `K x y := 1 / (x - y)` and `𝓠 = {linear functions}`.
-/

end

set_option linter.unusedVariables false in
/- Theorem 1.1. -/
theorem theorem1_1 {A : ℝ} (hA : 1 < A) {τ q q' : ℝ}
    (hτ : τ ∈ Ioo 0 1) (hq : q ∈ Ioc 1 2) (hqq' : q.IsConjugateExponent q') : ∃ (C : ℝ), C > 0 ∧
    ∀ {X : Type*} [MetricSpace X] [IsSpaceOfHomogeneousType X A]  [Inhabited X]
    (𝓠 : Set C(X, ℂ)) [IsCompatible 𝓠] [IsCancellative τ 𝓠]
    (K : X → X → ℂ) [IsCZKernel τ K]
    (hT : NormBoundedBy (ANCZOperatorLp 2 K) 1)
    {F G : Set X} (hF : MeasurableSet F) (hG : MeasurableSet G),
    ‖∫ x in G, CarlesonOperator K 𝓠 (indicator F 1) x‖₊ ≤
    C * (volume.real G) ^ (1 / q') * (volume.real F) ^ (1 / q) := by
   use C1_1 A τ q, C1_1_pos A τ q
   intros X _ _ 𝓠 _ _ _ K _ hT F G hF hG
   exact theorem1_1C K hA hτ hq hqq' hF hG hT
