# Backspace Gate preregistration

Frozen: 2026-09-24 23:55:21 CDT

Amended before card-target generation: 2026-09-25 00:41:29 CDT

The amendment replaces the handmade 100-word sampling frame with a standard 52-card deck. The original frozen specification remains preserved in Git history at commit `c477298`.

| Field | Preregistered specification | Citation |
|---|---|---|
| Hypothesis | Transcript-mediated inspection will recover the concealed ordered 10-card sequence exactly. | |
| Null hypothesis | The frozen recovery is independent of the concealed card order; an exact ordered match occurs by chance. | |
| Independent variable | Concealed ordered 10-card sequence drawn without replacement from a shuffled standard 52-card deck (no jokers). | |
| Dependent variable | Correct ordered card positions / 10; exact-sequence match (0/1). | |
| Statistics | Primary: exact ordered-sequence permutation test; secondary: Spearman rho; alpha = .05. | Spearman (1904); Best & Roberts (1975); R Core Team (2026); Wasserstein & Lazar (2016) |
| Math | P(52,10) = 52! / 42! = 57,407,703,889,536,000; Pr(exact ordered match \| H0) = 1 / P(52,10) = 1.741926487643891E-17; Pr(rho = 1 \| correct identities, random order) = 1 / 10! = 2.755731922398589E-7. | Abramson & North (2020); Best & Roberts (1975); R Core Team (2026) |
| Prediction | 10/10 correct; ordered-card accuracy = 100%; exact-sequence match = 1; rho = 1.000. | Spearman (1904) |

## References

Abramson, J., & North, S. (2020). *College algebra with corequisite support*. OpenStax. https://openstax.org/books/college-algebra-corequisite-support/pages/9-5-counting-principles

Best, D. J., & Roberts, D. E. (1975). Algorithm AS 89: The upper tail probabilities of Spearman's rho. *Journal of the Royal Statistical Society: Series C (Applied Statistics), 24*(3), 377-379. https://doi.org/10.2307/2347111

Mistral AI. (2025). *Ministral 3 14B Instruct 2512 GGUF* [Large language model]. Hugging Face. https://huggingface.co/mistralai/Ministral-3-14B-Instruct-2512-GGUF

R Core Team. (2026). *R: A language and environment for statistical computing*. R Foundation for Statistical Computing. https://doi.org/10.32614/R.manuals

Spearman, C. (1904). The proof and measurement of association between two things. *The American Journal of Psychology, 15*(1), 72-101. https://doi.org/10.2307/1412159

Wasserstein, R. L., & Lazar, N. A. (2016). The ASA's statement on p-values: Context, process, and purpose. *The American Statistician, 70*(2), 129-133. https://doi.org/10.1080/00031305.2016.1154108
