library(rvest)
library(stringr)

site1<-"https://shanghai.anjuke.com/sale/"
site2<-"/p"
site3<-"-t9/#filtersort"
district<-c('pudong','minhang','baoshan','xuhui','songjiang','jiading','jingan','putuo',
            'yangpu','hongkou','changning','huangpu','qingpu','fengxian','jinshan',
            'chongming')
dat<-data.frame()
convert1<-function(x){ if(identical(x,character(0)))  ' '  else x }
convert2<-function(x){ if(identical(x,character(0)))  NA_character_  else x }
for(d in 1:length(district)) 
  {site4<-paste0(site1,district[d],site2)
  for(page in 1:50)
    {site<-paste0(site4,page,site3)
    web<-read_html(site,encoding = 'utf-8')
    link<-html_nodes(web,'div.house-title a') %>% html_attr('href')
    for(house in 1:length(link))
    {
      web2<-read_html(link[house])
      #房源描述以及房价信息
      title<-html_nodes(web2,'.long-title') %>% html_text() %>% convert2() %>% str_trim()
      URL<-link[house]
      sellingpoint<-html_nodes(web2,'.js-house-explain span') %>% html_text() 
      %>% convert2()
      opinion<-html_nodes(web2,'.good-character') %>% html_text() %>% convert1()
      unitprice<-html_nodes(web2,'.houseInfo-detail-item:nth-child(3) .houseInfo-content') 
      %>% html_text() %>% convert2() %>% str_extract('\\d+') %>% as.numeric()
      
      #建筑因素
      area<-html_nodes(web2,'.houseInfo-detail-item:nth-child(5) .houseInfo-content') 
            %>% html_text() %>% convert2() %>% str_sub(end=-4) %>% as.numeric()
      year<-html_nodes(web2,'.houseInfo-detail-item:nth-child(7) .houseInfo-content') 
            %>% html_text() %>% convert2() %>% str_extract('\\d+') %>% as.numeric()
      year<-2019-year
      direction<-html_nodes(web2,'.houseInfo-detail-item:nth-child(8) .houseInfo-content') 
                 %>% html_text() %>% convert2()
                
      decoration<-html_nodes(web2,'.houseInfo-detail-item:nth-child(12) .houseInfo-content') 
                  %>% html_text() %>% convert2()
                 
      category<-html_nodes(web2,'.houseInfo-detail-item:nth-child(10) .houseInfo-content') 
                %>% html_text()%>% convert2()
      room<-html_nodes(web2,'.houseInfo-detail-item:nth-child(2) .houseInfo-content') 
            %>% html_text() %>% convert2()
            
      bedroom<-str_sub(room,str_locate(room,"室")[1,1]-1,str_locate(room,"室")[1,1]-1) 
               %>% as.numeric()
      hall<-str_sub(room,str_locate(room,"厅")[1,1]-1,str_locate(room,"厅")[1,1]-1) 
            %>% as.numeric()
      lavatory<-str_sub(room,str_locate(room,"卫")[1,1]-1,str_locate(room,"卫")[1,1]-1) 
                %>% as.numeric()
      storeyinfo<-html_nodes(web2,'.houseInfo-detail-item:nth-child(11) .houseInfo-content') 
                  %>% html_text() %>% convert2()
                 
      storey<-str_extract(storeyinfo,'低层|中层|高层')
      totalstorey<-str_extract(storeyinfo,'\\d+') %>% as.numeric()
      elevator<-html_nodes(web2,'.houseInfo-detail-item:nth-child(14) .houseInfo-content') 
                %>% html_text() %>% convert2()
                
      property<-html_nodes(web2,'.houseInfo-detail-item:nth-child(16) .houseInfo-content') 
                %>% html_text()%>% convert2()
                
      
      #邻里因素
      community<-html_nodes(web2,'.houseInfo-content > a') %>% html_text() %>% convert2()
      far<-html_nodes(web2,'.commap-info-intro:nth-child(4)') %>% html_text() %>% convert2() 
           %>% str_extract('\\d\\.\\d') %>% as.numeric()
      parkinglot<-html_nodes(web2,'.commap-info-intro:nth-child(5)') %>% html_text() 
                  %>% convert2() %>% str_extract('\\d+')%>% as.numeric()
                 
      greening<-html_nodes(web2,'.commap-info-intro:nth-child(6)') %>% html_text() 
                %>% convert2() %>% str_extract('\\d+') %>% as.numeric()/100
      fee<-html_nodes(web2,'.no-border-rg') %>% html_text()%>%convert2() 
           %>% str_extract('\\d+\\.[0-9][0-9]') %>% as.numeric()
           
      #区位因素
      admdist<-html_nodes(web2,'.loc-text a:nth-child(1)') %>% html_text() %>% convert2()
      secdist<-html_nodes(web2,'.loc-text a+ a') %>% html_text() %>% convert2()
      address<-html_nodes(web2,'.loc-text') %>% html_text()%>%convert2() %>% str_split('\\n')
      address<-address[[1]][3] %>% str_trim()
        
      dat<-rbind(dat,data.frame(title,URL,unitprice,area,year,direction,decoration,category,
                                bedroom,hall,lavatory,storey,totalstorey,elevator,property,
                                community,far,parkinglot,greening,fee,admdist,secdist,
                                address,sellingpoint,opinion))
    }
  }
  write.csv(dat,paste0('C:\\Users\\Liu\\Desktop\\毕业论文\\',district[d],'.csv'),
            row.names = FALSE)
  dat<-data.frame()
}




