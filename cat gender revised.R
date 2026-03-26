# CatGender 
# Notes about the Script :
      ### 3 Hashtags indicates a Different Chapter, typically corresponding to sections in the assignment 
      ## 2 Hashtags indicates a sub-section within the Chapter
      # 1 Hashtag shows an explanation, what results were found or explore new R-code I learned in order to help me in the assignemnt, with links

### CONTENTS WITH LINES ###

### INSTALL PACKAGES & READ SCRIPT ###
install.packages('readr')
library(readr)
install.packages('lme4')
library('lme4')
install.packages('ggplot2')
library(ggplot2)


catgender<- read_csv('C:/Users/perri/OneDrive/Documents/University Work/Year 3/ET331 - Quantitative Research/CatGenderData.csv')
View(catgender)

## OR FOR GITHUB USE:
#catgender <- read_csv('https://raw.githubusercontent.com/perrie-py/cat-word-association-sex-differences/refs/heads/main/CatGenderData.csv')

## LOG transform times (benefits mentioned in essay) #
catgender$log_looking <- log10(catgender$looking)

## mean looking times by gender 

aggregate(log_looking ~ sex, data = catgender, mean)
#Female cats show an average of 2.116078 when loaded
#Male cats show an average of 1.961036

FMean <- 2.12
MMean <- 1.96

### PARTICIPANT INFORMATION ###
# helped with visualisation of participants https://r-graph-gallery.com/218-basic-barplots-with-ggplot2.html 

table(catgender$sex, catgender$living)
demographicTable <- table(catgender$sex, catgender$living)

# SEXtable is used for the key in the visualization
SEXtable <- table(catgender$sex)

barplot(demographicTable, 
        beside = F, 
        legend.text = rownames(SEXtable),
        xlab = 'Living Condition',
        ylab = 'No. Cat Responses Given', 
        main = 'Demographic Information of Participants'
        ) 
# this table will be used in the assignment to present the distribution of participants 

# statistics of participants 
#use chi-square test because variables are categorical, comparing frequencies and i want to know if variables are related 
chisq.test(demographicTable)
# > chisq.test(demographicTable)

#Pearson's Chi-squared test with Yates' continuity correction
#data:  demographicTable
#X-squared = 0.0029452, df = 1, p-value = 0.9567

# this checks that participant matching is fine - was sex or living condition too unevenly distributed for this test? no

### VISUALISATIONS OF DATA ###

## EXPERIMENT 1, NO CONDITIONS ##

# this test does not depend on condition, it is an initial test to examine if differences exist 
ggplot(catgender, aes(x = sex, y = log_looking)) +
  geom_boxplot() +
  labs(
    x = 'Cat Sex',
    y = 'Log Transformed Looking Time'
  )

# A p-test will be conducted here to see if the data is accurate 
t.test(log_looking ~ sex, data = catgender)
# t = 2.3108 -> 
# df = 55.599
# p = 0.02458
# p is less than 0.05
# means data is significant -> this allows us to delve further into explore more niche reasons for this variation
# mean should be interpreted cautiously, but female cats looked longer than male cats by 0.155042 log units on average 
# logs are abstract, so mean value cannot be overstated in analysis 
# this test assumes one value per cat with no hierarchy, so regression model is implemented 
# using lmer based on Takagi et al

lmer(log_looking ~ sex + (1|S), data = catgender)
# accounting for individual cat differences, there is still variation
# Female cats 2.1160 as baseline, Male cats -0.1655 log units less 

## IS THERE VARIATION BETWEEN SEXES UNDER DIFFERENT CONDITIONS? ##

table(catgender$sex, catgender$cond)

switched<- subset(catgender, cond == 'switched')

catgender$log_looking <- log10(catgender$looking)

ggplot(
  subset(catgender, cond == 'switched'), 
  aes(x = sex, y = log_looking)
) +
  geom_boxplot() +
  ylim(1.2, 2.5) +
  labs(
    x= 'Cat Sex',
    y= 'Log transformed looking time in frames'
  )
lmer(log_looking ~ sex +  (1| S), data = switched)

NONswitched<- subset(catgender, cond == 'non-switched')

ggplot(
  subset(catgender, cond == 'non-switched'), 
  aes(x = sex, y= log_looking)
) +
  geom_boxplot() +
  ylim(1.2, 2.5) +
  labs (
    x= 'Cat Sex', 
    y= 'Log transformed looking time in frames'
  )

lmer(log_looking ~ sex +  (1| S), data = NONswitched)

# initially, the y-axis scales were different which opened the data to misinterpretation 
# ylim() was used with help from https://www.youtube.com/watch?v=JLjH-JymqUE 
# the y-axis should be the same under the two conditions for the ease of visual assessment 


ggplot(catgender, aes(x = cond, y = log_looking, fill = sex)) +
  geom_boxplot() +
  ylim(1.2, 2.5) +
  labs (
    x= 'Cat Sex', 
    y= 'Log transformed looking time in frames', 
    fill = 'Condition'
  )




## HABITUATION DATA ANALYSED + VISUALISED ##

Exp1Habituation<-read.csv('https://raw.githubusercontent.com/ClayBeckner/DataPlayground/refs/heads/master/Supplement3.Exp1Habituation.Update.csv')
View(Exp1Habituation)
View(demographics)

#merge data to show sex and + habituation, combining sex and habituation
demographics$lookingLog <- NULL
# make a new table which combines information from 2 tables - help from Clay's email
HabituationWithDemographics <- merge(Exp1Habituation, demographics)
View(HabituationWithDemographics)


## LOG transform times (benefits mentioned in essay) #
HabituationWithDemographics$looking <- log10(HabituationWithDemographics$looking + 1)
# + 1 was added, so that the log didn't appear as -INF - this would mean I was unable to run the statistical tests
# this changed it to NaN -> which can be ignored in statistical tests 
table(HabituationWithDemographics$sex, HabituationWithDemographics$catID)

## mean looking times by gender 

aggregate(looking ~ sex, data = HabituationWithDemographics, mean)
table(HabituationWithDemographics$sex, HabituationWithDemographics$looking)
# this table was a test to check it loaded efficiently


# below, this density plot shows the usual distribution of all participants
# I wanted a more transparent colour for easier comparison, and I found this on https://stackoverflow.com/questions/23772608/fill-density-curves-with-transparent-color
# on here, it said alpha 0.4 can help
ggplot(HabituationWithDemographics, aes(x=looking, fill = sex))+ 
  geom_density(alpha = 0.4) +
  labs(
    x = 'Looking Time', 
    y = 'Density', 
    fill = 'sex'
  ) 

# Ideally, it would have been good to do a density plot for male and female cats
# this data was unavailable, so instead I am plotting the average log looking time onto the bar
# geom_vline adds a vertical line, discovered with #https://www.rdocumentation.org/packages/ggplot2/versions/0.9.1/topics/geom_vline

ggplot(HabituationWithDemographics, aes(x=looking, fill = sex))+
  geom_density(alpha=0.4) +
  labs(
    x = 'Looking Time', 
    y = 'Density', 
    fill = 'sex'
  ) +
  geom_vline(xintercept = FMean, colour = 'hotpink') +
  geom_vline(xintercept = MMean, colour = 'darkblue')

# i didn't want to compare both conditions with the density plot
# I tried to use colours that were easily visible to one another, female is represented by pink and male is represented by blue 

## COMPARE SWITCHED CONDITION TO HABITUATION ##

View(switched)

aggregate(log_looking ~ sex, data = switched, mean)

switchedfemalemean = 2.14
switchedmalemean = 2.02

NONswitchedfemalemean = 2.10
NONswitchedmalemean = 1.89

ggplot(HabituationWithDemographics, aes(x=looking, fill = sex))+
  geom_density(alpha=0.4) +
  geom_vline(xintercept = NONswitchedfemalemean, colour = 'hotpink') +
  geom_vline(xintercept = NONswitchedmalemean, colour = 'darkblue') +
  geom_vline(xintercept = switchedfemalemean, colour = 'pink') +
  geom_vline(xintercept = switchedmalemean, colour = 'royalblue') +
  labs(x = 'Log-transformed looking time')

### STATISTICAL TESTS ###
# averages and p-values which were relevant were examined throughout 
# now i am focusing specifically on using lme4 for linear mixed effects models https://www.geeksforgeeks.org/r-machine-learning/linear-mixed-effects-models-lme-in-r/
# this matches Takagi et al's methodology
# includes fixed effects - traditional coefficient describing average effect of predictor (geedsforgeeks)
# random effects - accounts for individual variation 
# my fixed effect is looking time, my random effect is variations in sex
# some of the following code is listed above, but also compiled here for ease of comparison

# general comparison of experiment 1 disregarding condition 
lmer(log_looking ~ sex + (1|S), data = catgender)

# comparison between sexes using switched condition
lmer(log_looking ~ sex +  (1| S), data = switched)

# comparison between sexes using non-switched condition

lmer(log_looking ~ sex +  (1| S), data = NONswitched)

# comparison of habituation trial 

lmer(looking ~ sex + (1| catID), data = HabituationWithDemographics)



