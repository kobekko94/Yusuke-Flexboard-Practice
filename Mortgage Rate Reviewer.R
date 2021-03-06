---
  title: "Mortgage rate viewer by @lenkiefer"
output: 
  flexdashboard::flex_dashboard:
  orientation: columns
vertical_layout: fill
social: menu
source_code: embed
---
  
  ```{r setup, include=FALSE}
library(flexdashboard)
```

### Mortgage Rates Data
### ===================================== 
  
  
  Column {data-width=500}
-----------------------------------------------------------------------
  
  ### Mortgage Rate data table
  
  ```{r}
library(tidyverse)
library(readxl)
library(flexdashboard)
library(viridis)
library(data.table)
library(plotly)
library(DT)
#load data
dt<- read_excel('data/rates.xlsx',sheet= 'rates')
dt$date<-as.Date(dt$date, format="%m/%d/%Y")
dt<-data.table(dt) 
dt<-as.data.frame(dt[order(-date),])  #sort, data tables make this easier
datatable(dt[,1:4],filter = 'top',options=list(pageLength=25,searching=F),
          colnames=c("Date","30-year Fixed Rate Mortgage (%)","15-year Fixed Rate Mortgage (%)","5/1 Adjustable Rate Mortgage (%)"),
          caption=htmltools::tags$caption(
            style = 'caption-side: top; text-align: left;',
            htmltools::strong('Weekly Average Mortgage Rates in the US'), 
            htmltools::br(),htmltools::em("Source: Freddie Mac Primary Mortgage Market Survey through Jan. 5, 2017" )))
```

Column {data-width=500 .tabset .tabset-fade}
-----------------------------------------------------------------------
  
  ### 30-year fixed mortgage rates
  
  ```{r}
g<-
  ggplot(data=subset(dt,year(date)>1890),aes(x=date,y=rate30))+geom_line(color=viridis(10)[8])+
  theme_minimal()+
  labs(x="",y="",title="30-year fixed mortgage rates (%)",
       caption="@lenkiefer Source: Freddie Mac Primary Mortgage Market Survey")+
  theme(plot.caption=element_text(hjust=0),
        plot.title=element_text(face="bold",size=10))

ggplotly(g)
```

### 15-year fixed mortgage rates

```{r}

g<-
  ggplot(data=subset(dt,year(date)>1990),aes(x=date,y=rate15))+geom_line(color=viridis(10)[4])+
  theme_minimal()+
  labs(x="",y="",title="15-year fixed mortgage rates (%)",
       caption="@lenkiefer Source: Freddie Mac Primary Mortgage Market Survey")+
  theme(plot.caption=element_text(hjust=0),
        plot.title=element_text(face="bold",size=10))

ggplotly(g)

```


### 5/1 Hybrid Adjustable Rate Mortgage Rates

```{r}

g<-
  ggplot(data=subset(dt,year(date)>=2005),aes(x=date,y=rate51))+geom_line(color=viridis(10)[5])+
  theme_minimal()+
  labs(x="",y="",title="5/1 Hybrid adjustable rate mortgage rates (%)",
       caption="@lenkiefer Source: Freddie Mac Primary Mortgage Market Survey")+
  theme(plot.caption=element_text(hjust=0),
        plot.title=element_text(face="bold",size=10))

ggplotly(g)

```

Relationship between rates
===================================== 
  
  Column
-----------------------------------------------------------------------
  
  ### 10-year Treasury Yields and Mortgage rates
  
  *Mortgage Rates and Yields* 
  
  Mortgage rates follow 10-year Treasury yields quite closely. As bond yields rise, mortgage rates tend to follow, especially the 30-year mortgage. On a week to week basis, nearly 98% of the variation in 30-year fixed mortgage rates can be explained by variation in 10-year yields.

*Simple Linear Regression of 30-year fixed mortgage rates on 10-year Treasury Yields April 2, 1971-January 5, 2017*
  
  ```{r,results='asis',}
my.out<-lm(data=dt,rate30~rate10y)
library(stargazer)
stargazer(my.out,type="html")
```

Treasury yields are also highly correlated with 15-year mortgage rates:
  
  *Simple Linear Regression of 15-year fixed mortgage rates on 10-year Treasury Yields Aug. 30, 1991-Jan, 5, 2017*
  
  ```{r,results='asis',}
my.out<-lm(data=dt,rate15~rate10y)
stargazer(my.out,type="html")
```

The correlation is lower for 5/1 Hybrdi adjustable rate mortgages:
  
  *Simple Linear Regression of 5/1 Hybrid adjustable rate mortgage rates on 10-year Treasury Yields Jan. 6, 2005-Jan. 5, 2017*
  
  ```{r,results='asis',}
my.out<-lm(data=dt,rate51~rate10y)
stargazer(my.out,type="html")
```

**Regression output formatted with stargazer:**
  
  Hlavac, Marek (2015). stargazer: Well-Formatted Regression and Summary Statistics Tables. R package version 5.2. http://CRAN.R-project.org/package=stargazer

Column {.tabset .tabset-fade}
-----------------------------------------------------------------------
  
  ### 10-year Treasury and 30-year fixed mortgage
  
  ```{r}
g<-
  ggplot(data=subset(dt,year(date)>=2005),aes(x=rate10y,y=rate30,label=date))+geom_point(color=viridis(10)[8],alpha=0.82)+stat_smooth(method="lm",linetype=2,color="black",fill=NA)+
  #geom_line(linetype=2,aes(y=rate15),color=viridis(10)[4])+
  theme_minimal()+
  labs(x="10-year Constant Maturity Treasury Yield (%)",y="30-year Fixed Mortgage Rate (%)",title="10-year Treasury Yields and Mortgage Rates",
       caption="@lenkiefer Source: Freddie Mac Primary Mortgage Market Survey, Federal Reserve H.15")+
  theme(plot.caption=element_text(hjust=0),
        plot.title=element_text(face="bold",size=10))

ggplotly(g)

```

### 10-year Treasury and 15-year fixed mortgage

```{r}
g<-
  ggplot(data=subset(dt,year(date)>=2005),aes(x=rate10y,y=rate15,label=date))+geom_point(color=viridis(10)[4],alpha=0.82)+stat_smooth(method="lm",linetype=2,color="black",fill=NA)+
  #geom_line(linetype=2,aes(y=rate15),color=viridis(10)[4])+
  theme_minimal()+
  labs(x="10-year Constant Maturity Treasury Yield (%)",y="15-year Fixed Mortgage Rate (%)",title="10-year Treasury Yields and Mortgage Rates",
       caption="@lenkiefer Source: Freddie Mac Primary Mortgage Market Survey, Federal Reserve H.15")+
  theme(plot.caption=element_text(hjust=0),
        plot.title=element_text(face="bold",size=10))

ggplotly(g)

```

### 10-year Treasury and 5/1 Hybrid ARM

```{r}
g<-
  ggplot(data=subset(dt,year(date)>=2005),aes(x=rate10y,y=rate51,label=date))+geom_point(color=viridis(10)[5],alpha=0.82)+stat_smooth(method="lm",linetype=2,color="black",fill=NA)+
  #geom_line(linetype=2,aes(y=rate15),color=viridis(10)[4])+
  theme_minimal()+
  labs(x="10-year Constant Maturity Treasury Yield (%)",y="5/1 Hybrid Adjustable Rate Mortgage Rate (%)",title="10-year Treasury Yields and Mortgage Rates",
       caption="@lenkiefer Source: Freddie Mac Primary Mortgage Market Survey, Federal Reserve H.15")+
  theme(plot.caption=element_text(hjust=0),
        plot.title=element_text(face="bold",size=10))

ggplotly(g)
```

Data notes
===================================== 
  
  *Originally posted at [lenkiefer.com](http://lenkiefer.com/).*
  
  Mortgage rate data from Freddie Mac Primary Mortgage Market Survey through January 5, 2017: http://www.freddiemac.com/pmms/pmms_archives.html.

Treasury yields downloaded from St. Louis Federal Reserve Economic Database (FRED) https://fred.stlouisfed.org/ on January 8, 2017. 

Treasury yields are for week ending on Fridays, aligned with mortgage rates reported on Thursdays of the same week.
