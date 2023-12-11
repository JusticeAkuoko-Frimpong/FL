test_that("FL works", {
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
  summary1 = FL_local_summary(Purchase ~ age + income +income:age, data1)
  summary2 = FL_local_summary(Purchase ~ age + income + income:age, data2)

  combined_summaries = FL_combine(list(summary1, summary2))

  soln = FL(combined_summaries)

  expect_equal(soln$Estimate[1], 1.999757e+04,  tolerance = 0.00001)
  expect_equal(soln$Estimate[2], 5.000383e+02, tolerance = 0.00001)
  expect_equal(soln$Estimate[3], 5.005581e-02, tolerance = 0.00001)
  expect_equal(soln$Estimate[4], 9.909905e-05, tolerance = 0.00001)
})
