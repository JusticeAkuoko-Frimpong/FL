# FL
[![R-CMD-check](https://github.com/JusticeAkuoko-Frimpong/Regress/workflows/R-CMD-check/badge.svg)](https://github.com/JusticeAkuoko-Frimpong/FL/actions)
<!-- badges: start -->
  [![Codecov test coverage](https://codecov.io/gh/JusticeAkuoko-Frimpong/FL/branch/main/graph/badge.svg)](https://app.codecov.io/gh/JusticeAkuoko-Frimpong/FL?branch=main)
  <!-- badges: end -->

 
The goal of the FL package is to provide functions implement federated learning procedures.
## Description
The FL package provides comprehensive functions to implement federated learning procedures. The package is designed to be user-friendly.It provides functions to compute local summaries of servers, a different function to combine these summaries and a final function to fit a linear regression mdoel. It provides estimates of the regression coefficients, standard errors, t values, p values.

## Getting Started

### Installing
You can install the `FL` package using the `devtools` package:
```r
# Install devtools if not already installed
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
```
Install the development version from [GitHub](https://github.com/) with:
```r
# Install Regress from GitHub
devtools::install_github("JusticeAkuoko-Frimpong/FL")
```
### Example
Using a simulated data. Suppose we are interested in fitting a model to study the effects of age, income and their interaction on the amounts used in purchasing items. First we simlulate two datasets, assuming we have two local servers.
```r
library(FL)
set.seed(42)  # For reproducibility
# Simulating dataset1
age1 = rnorm(100, mean = 50, sd = 10)  # simulating age
income1 = rnorm(100, mean = 50000, sd = 10000)  # simulating income
noise1 = rnorm(100, 0, 1)  # some noise
Purchase1 = 20000 + 500*age1 + 0.05*income1 + 10*age1*income1/100000 + noise1  # creating a relationship for Purchase
data1 = data.frame(age = age1, income = income1, Purchase = Purchase1)

# Simulating dataset2 in a similar way
age2 = rnorm(100, mean = 50, sd = 10)
income2 = rnorm(100, mean = 50000, sd = 10000)
noise2 = rnorm(100, 0, 1) 
Purchase2 = 20000 + 500*age2 + 0.05*income2 + 10*age2*income2/100000 + noise2
data2 = data.frame(age = age2, income = income2, Purchase = Purchase2)
```
Now, we compute the individual summaries with 'FL_local_summary' function and combine the local summaries using the 'FL_combine' function.
```r
summary1 = FL_local_summary(Purchase ~ age + income +income:age, data1)
summary2 = FL_local_summary(Purchase ~ age + income + income:age, data2)
combined_summaries = FL_combine(list(summary1, summary2))
```
Finally, we use the combine summaries to estimate and fit our model.
```r
soln = FL(combined_summaries)
print(soln)
```
These will return a dataframe of the estimates of the regression coefficients, standard errors, t values, p values.

### Loading the dataset
This project includes a healthcare dataset which was simulated by Kaggle.  Additionally, that dataset has been split into insurance company specific datsets to run the federated learning analysis.  The below code with load each dataset included in this package
```r
data(healthcare_dataset)
data(Aetna)
data(Medicare)
data(Cigna)
data(Blue.cross)
data(UnitedHealthcare)
```

# Working with the R shiny App
The R Shiny App is also located on Github; JusticeAkuoko-Frimpong/FL. The R Shiny App inputs needs to be a "csv" file so to test this app;

1. You will need to download the "csv" data files which is also located in this repository in the CSV Data folder.

2. Download Shiny.R from the repository.

3. Run the Shiny.R script. This will open up the shiny app.

4. Click "Browse..." and select the csv file you want to upload.

The app gives an output of the summary statistics from the dataset needed for fitting the models in the central server.


## Authors
Justice Akuoko-Frimpong <jakuokof@umich.edu>
Jonathan Ta <jdta@umich.edu>
Michael Kaye <kayemic@umich.edu>

