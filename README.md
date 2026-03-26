# Cat Word-Object Association: A Sex Differences Reanalysis
### Reanalysis of Takagi et al. (2024) using Linear Mixed-Effects Modelling

A statistical reanalysis of Takagi et al. (2024), investigating whether 
cat sex predicts looking-time behaviour in a word-object association 
switching-task paradigm. Sex was recorded only as a demographic variable 
in the original study — this reanalysis treats it as a between-participant 
factor.

## Background

Takagi et al. (2024) demonstrated that cats form rapid word-object 
associations, evidenced by increased looking time when word-image pairings 
are violated. This reanalysis extends the original study by examining 
whether sex differences in attentional engagement - observed in comparable 
animal cognition literature — are present in the data.

## Hypotheses

- Female cats were hypothesised to exhibit longer looking times than males 
  across all conditions, consistent with Scandurra et al. (2018) and 
  Müller et al. (2011)
- Baseline sex differences in habituation were examined to distinguish 
  pre-existing attentional tendencies from condition-driven effects

## Data

Reanalysis of publicly available data from:
> Takagi, S. et al. (2024). *Cats learn the names of their friend cats 
> in their daily lives.* Scientific Reports.

31 cats (20 male, 11 female) across café and domestic living environments.

## Method

- Log-transformed looking times to improve normality and reduce outlier 
  influence
- Chi-squared test confirming sex was evenly distributed across living 
  environments (p = 0.957)
- Independent samples t-test for overall sex comparison (t = 2.311, 
  p = 0.025)
- Linear mixed-effects modelling (`lme4`) replicating Takagi et al.'s 
  methodology, with sex as fixed effect and individual cat as random effect
- Conditions analysed separately (switched, non-switched) and against 
  habituation baseline

## Key Findings

- Female cats exhibited longer log-transformed looking times than males 
  across all phases
- Baseline differences during habituation (F = 0.50, M = 0.02 log units) 
  suggest pre-existing attentional differences independent of experimental 
  manipulation
- High residual variance in test phases (SD = 0.19–0.21) indicates 
  confounding variables beyond the manipulated stimuli, limiting 
  interpretation

## Tools

`R` `lme4` `ggplot2` `linear mixed-effects modelling` 
`psycholinguistics` `animal cognition`

## Status
Work in progress — code will be added upon project completion.
