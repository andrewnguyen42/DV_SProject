# server.R
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)

shinyServer(function(input, output, session) {
  
  observe({
    # We'll use these multiple times, so use short var names for
    # convenience.
    c_label <- input$control_label
    updateTextInput(session, "inText",
                    label = paste("New", c_label)
    )
  })
  

    
    df1 <- eventReactive(input$clicks1, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
                                        "select * from NYC_DEATHS;"
                                        ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_cdt932', PASS='orcl_cdt932', 
                                        MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
    })
    
    
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
    
    
    output$distPlot2 <- renderPlot({
      dff <- group_by(df1(),CAUSE_OF_DEATH) %>% summarise(sumcount = sum(COUNT)) %>% filter(sumcount>5000) %>% arrange(CAUSE_OF_DEATH)
      
      levels(dff$CAUSE_OF_DEATH) <- gsub(" ", "\n",levels(df1()$CAUSE_OF_DEATH))
      levels(dff$CAUSE_OF_DEATH) <- gsub("IMMUNODEFICIENCY", "IMMUNO-\nDEFICIENCY",levels(dff$CAUSE_OF_DEATH))
      
      medcount = median(dff$sumcount)
      
      
      
      plot <- ggplot(dff, aes(x=(CAUSE_OF_DEATH),y=sumcount))+
      geom_bar(stat="identity")+
      geom_hline(yintercept=as.numeric(medcount), color="red") +
      labs(title='Cause of Death') +
      labs(x="Cause of Death", y=paste("Count")) +
      theme(axis.text.x = element_text(size=7))
      plot
    })
    # End your code here.
    return(plot)
  }) # output$distPlot

