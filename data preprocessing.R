library(moments)

district<-c('pudong','minhang','baoshan','xuhui','songjiang','jiading','jingan','putuo',
            'yangpu','hongkou','changning','huangpu','qingpu','fengxian','jinshan',
            'chongming')
documents<-paste0(district,'.csv')
DAT<-data.frame()
for (i in 1:16)
{DAT<-rbind(DAT,read.csv(documents[i],header = T))}
which(is.na(DAT$title))->row
DAT[row,]->wrong
DAT[-row,]->DAT
unique(DAT[-2])->DAT

#文本挖掘
library(jiebaR)
library(stringr)
library(wordcloud2)

title<-paste(DAT$title)
sellingpoint<-paste(DAT$sellingpoint)
opinion<-paste(DAT$opinion)
info<-paste(title,sellingpoint,opinion)
cutter<-worker()
segwords<-segment(info,cutter)
segwords<-gsub("[0-9a-zA-Z]+?","",segwords)
segwords<-str_trim(segwords)
table(segwords)->wordfre
sort(wordfre,decreasing = TRUE)->wordfre
head(wordfre,200)->wordfre2
wordcloud2(wordfre2,size=4,shape='circle',fontFamily="楷体",color='black',
           backgroundColor='white')

#属性补充
subway<-str_detect(title,'号线|地铁|轨')|str_detect(sellingpoint,'号线|地铁|轨')|
                   str_detect(opinion,'地铁|号线|轨')
school<-str_detect(title,'学|校|幼儿园|附小|附中|读')|
                   str_detect(sellingpoint,'学|校|幼儿园|附小|附中|读')|
                   str_detect(opinion,'学|校|幼儿园|附小|附中|读')
business<-str_detect(title,'商|市场|超市|菜场|万达|家乐福|百联|联华|购物')|
          str_detect(sellingpoint,'商|市场|超市|菜场|万达|家乐福|百联|联华|购物')|
          str_detect(opinion,'商|市场|超市|菜场|万达|家乐福|百联|联华|购物')
amenity<-str_detect(title,'公园|广场|医院|滨江|苏州河|佘山|河畔|滨江')|
         str_detect(sellingpoint,'公园|广场|医院|滨江|苏州河|佘山|河畔|滨江')|
         str_detect(opinion,'公园|广场|医院|滨江|苏州河|佘山|河畔|滨江')

cbind(DAT[c(-1,-2,-8,-22,-23,-27)],subway,school,business,amenity)->dataset
Amelia::missmap(dataset,y.labels=F,y.at=F,main=NA,col = c("black", "grey"))
apply(is.na(dataset),2,sum)
apply(is.na(dataset),2,sum)/nrow(dataset)
write.csv(dataset,'C:\\Users\\Liu\\Desktop\\毕业论文\\上海二手住宅数据.csv',
          row.names = FALSE)

#EDA
hist(dataset$unitprice,col='white',freq = F,breaks=seq(from=0,to=290000,by=5000),
     xlab='Price',ylab='Density')
lines(density(dataset$unitprice) ,col='blue',lwd=1.5)
mean(dataset$unitprice)
sd(dataset$unitprice)
skewness(dataset$unitprice)
kurtosis(dataset$unitprice)
