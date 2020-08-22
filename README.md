# Real Estate Appraisal Model Based on Random Forest Algorithm——A Case Study of Shanghai Second-hand House Market

<div align="center" >
<img src="https://github.com/lyc1005/Real-Estate-Appraisal-Model-Based-on-Random-Forest-Algorithm/blob/master/image/shanghai.jpeg">
</div>

With the continuous development of China's economy and the increasing affluence of the people, the residential and investment needs of residential real estate are constantly rising, driving up housing prices tremendously. However, the supply of urban land is limited, resulting in people gradually turning their attention to the second-hand housing market. In first-tier cities, the second- hand housing transactions are less restricted by the government than the first-hand housing transactions, therefore better characterizing the market. The rising demand of second-hand housing is consistent with the demand of the real estate appraisal. No matter from the perspective of real estate transfer, lease, mortgage, or in terms of the property insurance, real estate tax, land acquisition and house demolition compensation, real estate appraisal is an indispensable process. However, many subjective factors exist in the three traditional methods of real estate valuation: Cost Approach, Income Approach and Market Comparison Approach. This implementation process over-relies on the appraisers’ experience, which is very likely to cause the deviation between the estimated price and the actual price. Furthermore, it is hugely time-consuming and costs a lot of manpower. With the emergence of computer science and machine learning, many scholars have gradually introduced quantitative methods to real estate appraisal and achieved good results. 

Taking the Hedonic Pricing Theory as the theoretical framework, this paper analyzes the influential factors of the second-hand housing price from the aspects of Structure, Neighborhoods and Location. Based on this, the paper establishes the characteristic variable index system to build the appraisal model. The web crawler is used to crawl the Shanghai second-hand residential listing data on Anjuke website, and the text mining technique is used to extract the hidden information in descriptive variables, which expands the variables in location factors. Through exploratory analysis on the original data and cleaning of the data, I make them structured data suitable for modeling. 

In the modeling stage, the paper applies the Random Forest algorithm to construct the real estate appraisal model, and then adjusts the model's hyper-parameters to optimize the model's prediction ability. In addition, this paper also compares the random forest model with the traditional multiple linear regression model. Empirical results show that random forest model can significantly improve the accuracy of the appraisal result. In the end, the paper presents some limitations of this research and puts forward the prospect for future study.


## Data

[Anjuke](Anjuke.com) is a famous online real estate marketplace in China. It serves over 40,000 real estate agents and 10 million unique visitors a month. Thus I choose its website to scrape the data.

<img src="https://github.com/lyc1005/Real-Estate-Appraisal-Model-Based-on-Random-Forest-Algorithm/blob/master/image/example.png">


## Method

### Web Crawler

In order to obtain the structured infomation from Anjuke website's HTML, I programmed a web crawler using rvest package and stringr package in R.

```
Anjuke scrawler.R
```

### Text Mining

Since Anjuke didn't provide location features in HTML and location infomation generally have a large impact on the value of real estate, I creatively utilized text mining technique to extract 4 binary features (subway, school area, business area, hospital/park facility) from textual variables (title, core selling point, expert comments)

```
data preprocessing.R
```

### Random Forest

Due to its non-parametric characteristic, fast training speed on large dataset, interpretibility, robustness to outliers, flexibility of training on both continuous and categorical attributes, Random Forest is applied to train the appraisal model.

```
RF model.R
```

## EDA

<img src="https://github.com/lyc1005/Real-Estate-Appraisal-Model-Based-on-Random-Forest-Algorithm/blob/master/image/wordcloud.png" width=600 height=400>

Word cloud generated from textual features

<img src="https://github.com/lyc1005/Real-Estate-Appraisal-Model-Based-on-Random-Forest-Algorithm/blob/master/image/district.png" width=450 height=300>

Average unit price for each district of Shanghai

<img src="https://github.com/lyc1005/Real-Estate-Appraisal-Model-Based-on-Random-Forest-Algorithm/blob/master/image/sub-district.png" width=450 height=300>

Top 10 sub-districts with highest average unit price

<img src="https://github.com/lyc1005/Real-Estate-Appraisal-Model-Based-on-Random-Forest-Algorithm/blob/master/image/price_distribution.png" width=450 height=300>

Density plot of price distribution in Shanghai


## Results

<img src="https://github.com/lyc1005/Real-Estate-Appraisal-Model-Based-on-Random-Forest-Algorithm/blob/master/image/mtry.png" width=450 height=260>

Tuning the number of candidate features when spliting a tree (mtry)

<img src="https://github.com/lyc1005/Real-Estate-Appraisal-Model-Based-on-Random-Forest-Algorithm/blob/master/image/ntree.png" width=450 height=260>

Tuning the total number of trees in the forest (ntree)

mtry=18 and ntree=400 are seen to be the optimal hyperparameter choice.

<img src="https://github.com/lyc1005/Real-Estate-Appraisal-Model-Based-on-Random-Forest-Algorithm/blob/master/image/result.png" width=450 height=150>

Random Forest model result on 4 metrics (R^2, RMSE, MAE, MRE) with comparison to Linear Regresion model result. The result show random forest gain a huge edge over traditional regression method.

<img src="https://github.com/lyc1005/Real-Estate-Appraisal-Model-Based-on-Random-Forest-Algorithm/blob/master/image/importance.png" width=700 height=300>

Feature importance generated by RF
