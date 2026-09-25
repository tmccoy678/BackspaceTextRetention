# Backspace Gate preregistration

Frozen: 2026-09-24 23:55:21 CDT

| Field | Preregistered specification | Citation |
|---|---|---|
| Hypothesis | Transcript-mediated inspection will recover the concealed 8-word sequence exactly. | |
| Null hypothesis | The frozen recovery is independent of the concealed target; an exact ordered match occurs by chance. | |
| Independent variable | Concealed 8-word target drawn without replacement from a human-generated pool of 100 unique words. | |
| Dependent variable | Correct ordered word positions / 8; exact-string match (0/1). | |
| Statistics | One-sided exact Spearman rank correlation; alpha = .05. | Spearman (1904); Best & Roberts (1975); R Core Team (2026); Wasserstein & Lazar (2016) |
| Math | P(100,8) = 100! / 92! = 7,503,063,898,176,000; Pr(exact ordered match \| H0) = 1 / P(100,8) = 1.332788862751256E-16; Pr(rho = 1 \| correct identities, random order) = 1 / 8! = 2.480158730158730E-5. | Abramson & North (2020); Best & Roberts (1975); R Core Team (2026) |
| Prediction | 8/8 correct; ordered-word accuracy = 100%; exact-string match = 1; rho = 1.000. | Spearman (1904) |

## References

Abramson, J., & North, S. (2020). *College algebra with corequisite support*. OpenStax. https://openstax.org/books/college-algebra-corequisite-support/pages/9-5-counting-principles

Best, D. J., & Roberts, D. E. (1975). Algorithm AS 89: The upper tail probabilities of Spearman's rho. *Journal of the Royal Statistical Society: Series C (Applied Statistics), 24*(3), 377-379. https://doi.org/10.2307/2347111

Mistral AI. (2025). *Ministral 3 14B Instruct 2512 GGUF* [Large language model]. Hugging Face. https://huggingface.co/mistralai/Ministral-3-14B-Instruct-2512-GGUF

R Core Team. (2026). *R: A language and environment for statistical computing*. R Foundation for Statistical Computing. https://doi.org/10.32614/R.manuals

Spearman, C. (1904). The proof and measurement of association between two things. *The American Journal of Psychology, 15*(1), 72-101. https://doi.org/10.2307/1412159

Wasserstein, R. L., & Lazar, N. A. (2016). The ASA's statement on p-values: Context, process, and purpose. *The American Statistician, 70*(2), 129-133. https://doi.org/10.1080/00031305.2016.1154108
