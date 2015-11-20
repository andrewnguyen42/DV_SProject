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
                                        "select * from NBAREGULARSEASONTOTALS;"
                                        ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_cdt932', PASS='orcl_cdt932', 
                                        MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
    })
    
    output$distPlot1 <- renderPlot({             
      plot <- ggplot(df1(), aes(x=FG)) + 
        coord_cartesian() + 
        scale_x_discrete() +
        scale_y_continuous() +
        labs(title=isolate(input$title)) +
        labs(x=paste("Year"), y=paste("PTS")) +
        geom_histogram()
        #geom_point(aes(x=year), size=4)
      plot
    }) 
    
    # End your code here.
    return(plot)
  }) # output$distPlot

