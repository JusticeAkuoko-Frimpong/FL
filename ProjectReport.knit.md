---
title: "FL : A Flexible Federated Learning Package for Real-World and Simulated Applications"
author: "Justice Akuoko-Frimpong, Michael Kaye, and Jonathan Ta"
date: "December 2023"
output:
  pdf_document: default
  html_document:
    df_print: paged
always_allow_html: yes
---

# Introduction 

1) general intro (JT)

# Methods

## Federated learning math theory (JA)

Federated Learning is an emerging machine learning paradigm that aims to train a collaborative model while keeping all the training data localized (Yang et al., 2022). Data communication from client devices to global servers is not necessary. Rather, the model is trained locally using the raw data on edge devices, hence improving data privacy. The local modifications are aggregated to build the final model in a shared way.\newline
In clinical settings, to maintain patient data security, federated learning still has to be implemented carefully. However, it has the potential to tackle some of the challenges we faced by approaches that require the pooling of sensitive clinical data.
Clinical data can be collected inside an institution's security safeguards for federated learning. Each individual maintains ownership of their own clinical data.
Federated learning allows teams to create bigger, more varied datasets for algorithm training, even as it becomes more difficult to retrieve sensitive patient data as a result.
By using a federated learning strategy, various healthcare facilities, research institutes, and hospitals are also encouraged to work together to create a model that might be advantageous to all of them.Here are some reasons why federated learning matters (Shastri, 2023):

\textbf{Privacy}: Federated learning allows training to happen locally, avoiding potential data breaches, in contrast to traditional approaches that send data to a central server for training.\newline
\textbf{Data security}: is ensured by sharing only summary statistics updates with the central server.\newline
\textbf{Access to heterogeneous data}: is ensured via federated learning, which makes data dispersed across many companies, places, and devices accessible. It allows for secure and private training of models on sensitive data, like financial or medical data. Additionally, models may be made more generalizable with increased data diversity.

### How does federated learning work? 
At the central server is a general baseline model. The client devices receive copies of this model, and they use the local data they produce to train the models. Individual models improve with time, becoming more tailored to the user's needs. In the next phase, secure aggregation techniques are used to exchange the updates (summary statistics) from the locally trained models with the central server's primary model. This model creates new learnings by averaging and combining various inputs.
Once the model in the central server has been re-trained with the new summary statistics, it is shared with the client devices again for the next iteration. The network diagram in the appendix illustrates the flow of federated learning approaches.


### Fitting a linear regression model
Suppose we have $k$ groups in a study. Each group has different data but identical columns. To answer a research question with a linear regression model, assume independence of the responses from individuals across the k groups. The coefficients for the regression can computed using the following user-specific summary statistics $SSX$, $SSY$, $SSXY$, and  $n$ from all $k$  groups to obtain the estimates of the coefficients using the formula:\newline
\begin{align*}
    \hat{\beta} = (\sum_{k=1}^{K} X^T_kX_k)^{-1}\times(\sum_{k=1}^{K} X^T_ky_k)
\end{align*} 
where $X_k$ is the design matrix and $Y_k$ is the response vector for the $k$-th group.To further evaluate the significance of the coefficients, standard errors of the estimated coefficients will be  calculated using the formula below, which is also in the federated learning form:\\
\begin{align*}
    \widehat{se}(\widehat{\beta}_j) = \sqrt{\widehat{\sigma}^2(X^\top X)^{-1}_{jj}}\text{, with }\widehat{\sigma}^2 = \frac{\widehat{\epsilon}^\top \widehat{\epsilon}}{n-p},
\end{align*}
where
\begin{align*}
    \widehat{\epsilon}^\top \widehat{\epsilon}=\sum_{k=1}^K y_k^\top y_k - 2\widehat \beta \sum_{k=1}^K X_k^\top y_k + \widehat\beta \left( \sum_{k=1}^K X_k^\top X_k\right)\widehat\beta
\end{align*}
P-values and t-statistics can be computed using these estimated values. After the calculation of all the coefficients and corresponding variances, we conduct a t-test to test the significance of each coefficient.



## FL Package (MK)
We created a federated learning package “FL” that is hosted on github.  This package facilitates the federated learning analysis in a modular format with 3 key functions. 
The first function (“FL_local_summary”) takes in a csv input which includes the specified data set as well as the desired regression formula.  It then runs the local server analysis with a clean output of all the summary statistics.  The local servers will then send that summary output to the central server with no additional work.  The package will facilitate this through the use of an R Shiny app (to be discussed in detail later).
The second function (“FL_combine”) is designed to be used at the central server level and combines all the summary statistics from the local servers as described earlier in the report.  The input is the exact output from "FL_local_summary". 
The third function (“FL”) runs the federated learning analysis to produce the results of the study.  The input for this function is the exact output from "the second function"FL_combine".
This seamless integration of inputs and outputs allows the FL package to run a complete federated learning analysis.


## Dataset (JT)

# Application and Results

## R shiny (JT)

## Results - proof that FL worked (MK)
Our project treated different insurance companies as the local servers and used the equation [***].  For all five local servers we ran the “FL_local_summary” function and sent only the summary statistics to the central server.  We then ran the “FL_combine” function.  Finally, we ran the “FL” function and got the results below.







