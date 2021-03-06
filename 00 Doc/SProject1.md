---
title: "Shiny Project 1"
output: html_document
---



# Tableau Project 2 Documentation

Note that this html file contains the combined "story" for Projects 4  and 5. The Tableau
plots in the "Data" section are from project 4, while all the R plots, as well as the 
"Blended" plots are from Project 5.

## Extract, Transform, and load:

This has been covered in our previous documentation of the same data, but I'm adding it
here anyway for the purpose of completeness.

The first step in our project was to load the data onto Oracle in a usable format.
We separated the columns into numerical and non-numerical types, using  3 versions of R\_ETL.R for each csv file. 
Our data was mostly well-behaved, so there wasn't much more to do here
```
file_path <- "./01 Data/New_York_City_Leading_Causes_of_Death.csv"

df <- read.csv(file_path, stringsAsFactors = FALSE)


# Replace "." (i.e., period) with "_" in the column names.
names(df) <- gsub("\\.+", "_", names(df))
names(df)
df <- rename(df, Game = G)



# str(df) # Uncomment this and  run just the lines to here to get column types to use for getting the list of measures.

measures <- c("Year","Count","Percent")


#measures <- NA # Do this if there are no measures.

# Get rid of special characters in each column.
# Google ASCII Table to understand the following:
for(n in names(df)) {
  df[n] <- data.frame(lapply(df[n], gsub, pattern="[^ -~]",replacement= ""))
}

dimensions <- setdiff(names(df), measures)
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern=":",replacement= ";"))
  }
}

library(lubridate)

# The following is an example of dealing with special cases like making state abbreviations be all upper case.
# df["State"] <- data.frame(lapply(df["State"], toupper))

# Get rid of all characters in measures except for numbers, the - sign, and period.dimensions
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    df[m] <- data.frame(lapply(df[m], gsub, pattern="[^--.0-9]",replacement= ""))
  }
}

write.csv(df, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")

tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
    else sql <- paste(sql, paste(m, "number(38,4)\n"))
  }
}
sql <- paste(sql, ");")
cat(sql)
```


--------------

## Getting Data
Since all the data wrangling was done with R, we retrieved the data for each plot using the same code:
```
    df1 <- eventReactive(input$clicks1, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
                                        "select * from NYC_DEATHS;"
                                        ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_cdt932', PASS='orcl_cdt932', 
                                        MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
    })
 
```

## Visualizations 
  [We created a simple scatterplot](https://internal.shinyapps.io/agent509/02Shiny/?initialWidth=1362&childId=shinyapp#shiny-tab-scatter) of death counts broken down by ethnicity over the years. No real datawrangling was necessary to generate this plot so there's not much to say about it. We have a button that's used before updating data:
```
    actionButton(inputId = "clicks1",  label = "Update Data"),
```
Here's the code for generating the plot:
```
    output$distPlot1 <- renderPlot({             
      plot <- ggplot() +
        coord_cartesian() + 
        scale_x_continuous() +
        scale_y_continuous() +
        labs(title="Death Count by Cause over Time",y="Count",x="Year",color="Ethnicity")+
        layer(data=df1(),
              mapping=aes(x=as.numeric(YEAR),y=as.numeric(COUNT),color=ETHNICITY),
              stat="identity",
              stat_params=list(),
              geom="point",
              geom_params=list(),
              position=position_identity(),
              #position = position_jitter(width=0.5, height=0)
        )
      plot
    }) 
 ```

[Next we created a barchart.](https://internal.shinyapps.io/agent509/02Shiny/?initialWidth=1362&childId=shinyapp#shiny-tab-Barchart) We used reactive with a slider bar, so that viewers can filter out causes of death with lower deaths.
and used radiobuttons to allow viewers to select median or mean for the reference line.
Here are the relevant portions from the UI and Server

UI.R:
```
              radioButtons(inputId="reference", label="Reference Line:",choices = c("Median:"=1,"Mean"=2)),
              sliderInput("mincount","Minimum Death Count",min=1,max=50000,value=5000),
 ``` 
Server.R:
```
      mincount <- reactive({input$mincount})
      dff <- group_by(df1(),CAUSE_OF_DEATH) %>% summarise(sumcount = sum(COUNT)) %>% filter(sumcount>mincount()) %>% arrange(CAUSE_OF_DEATH)
      
      levels(dff$CAUSE_OF_DEATH) <- gsub(" ", "\n",levels(df1()$CAUSE_OF_DEATH))
      levels(dff$CAUSE_OF_DEATH) <- gsub("IMMUNODEFICIENCY", "IMMUNO-\nDEFICIENCY",levels(dff$CAUSE_OF_DEATH))
      
      medcount = median(dff$sumcount)
      meancount = mean(dff$sumcount)
      
      refer <- reactive({input$reference})
      if (refer()== 1){
        reference = medcount}
      else{
        reference = meancount}
```

And the code that actually plots the data:
```
      plot <- ggplot(dff, aes(x=(CAUSE_OF_DEATH),y=sumcount))+
      geom_bar(stat="identity")+
      geom_hline(yintercept=as.numeric(reference), color="red") +
      labs(title='Death Counts by Cause') +
      labs(x="Cause of Death", y=paste("Count")) +
      theme(axis.text.x = element_text(size=7))
      plot
 ```


[The crosstab](https://internal.shinyapps.io/agent509/02Shiny/_w_2610f17b/#shiny-tab-Crosstab) uses a KPI of death count retrieved from a slider, and is computed in Server.R using this code:
```
      KPI1 <- reactive({input$KPI1})
      kpi_func <- function(count){
        if(count>KPI1()){
          kpi = "High Death Count"
        }
        else{
          kpi ="Low Death Count"
        }
        return(kpi)
      }
``` 
The relevant code for data wrangling and plotting in the Server.R:
```
      
      dff <-  group_by(df1(),CAUSE_OF_DEATH,ETHNICITY) %>% summarise(sumcount=sum(COUNT)) %>% ungroup() %>% rowwise() %>% mutate(Death_KPI=kpi_func(sumcount)) %>% group_by(CAUSE_OF_DEATH,ETHNICITY)
      
      dff$CAUSE_OF_DEATH = with(dff,factor(CAUSE_OF_DEATH, levels = rev(levels(CAUSE_OF_DEATH))))
      
      plot<-ggplot(dff, aes(ETHNICITY,CAUSE_OF_DEATH,color=Death_KPI)) + 
        theme_bw() + xlab("") + ylab("") +
        scale_size_continuous(range=c(10,30)) + 
        geom_text(aes(label=sumcount))+
        labs(title="Crosstab",x="Ethnicity")
      plot
      
    })
    return(plot)
  }) # output$distPlot
```
And from the UI.R:
```
        actionButton(inputId = "clicks1", label = "UpdateData"),
        sliderInput("KPI1", "Death Count KPI", 
                   min = 1, max = 100000,  value = 5000),
```
