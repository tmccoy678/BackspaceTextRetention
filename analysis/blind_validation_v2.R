args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) {
  stop("usage: Rscript analysis/blind_validation_v2.R RESULTS_CSV OUTPUT_DIR")
}

results <- read.csv(args[[1]], stringsAsFactors = FALSE, check.names = FALSE)
output_dir <- args[[2]]
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

successes <- sum(results$exact_recovery == 1)
trials <- nrow(results)
test <- binom.test(successes, trials, p = 0.5, alternative = "two.sided",
                   conf.level = 0.95)

summary <- data.frame(
  metric = c(
    "fixtures_exact",
    "fixtures_total",
    "observed_exact_rate",
    "clopper_pearson_95_lower",
    "clopper_pearson_95_upper",
    "null_rate_used_by_binom_test",
    "two_sided_binomial_p_value",
    "character_matches_descriptive",
    "character_positions_descriptive",
    "erase_counts_exact",
    "erase_counts_total"
  ),
  value = c(
    successes,
    trials,
    successes / trials,
    unname(test$conf.int[[1]]),
    unname(test$conf.int[[2]]),
    0.5,
    test$p.value,
    sum(results$character_matches),
    sum(results$target_length),
    sum(results$erase_exact == 1),
    trials
  ),
  note = c(
    "Primary exact-string endpoint",
    "Procedurally blinded fixtures",
    "Observed proportion; not a universal error rate",
    "Exact two-sided interval",
    "Exact two-sided interval",
    "Illustrative equal-success null, declared post-generation",
    "Not a t test; limited by n=10 and fixture dependence assumptions",
    "Descriptive only; character positions are clustered within fixtures",
    "Descriptive only; character positions are clustered within fixtures",
    "Exact triplet-count endpoint",
    "Procedurally blinded fixtures"
  ),
  stringsAsFactors = FALSE
)

write.csv(summary, file.path(output_dir, "r-summary.csv"), row.names = FALSE,
          quote = TRUE)

sink(file.path(output_dir, "r-binom-test.txt"))
cat("BACKSPACE GATE BLIND VALIDATION V2 — R CROSS-CHECK\n\n")
print(test)
cat("\nCharacter-level agreement is descriptive because positions are clustered.\n")
cat("A t test is not appropriate for binary exact-match outcomes.\n")
sink()

