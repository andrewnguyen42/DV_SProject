#df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from NYC_DEATHS"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_cdt932', PASS='orcl_cdt932', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
#dg <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from HOMELESSPOPULATIONNYC"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_cdt932', PASS='orcl_cdt932', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

dgg <- group_by(dg,YEAR) %>% summarise(EST=sum(HOMELESSESTIMATES))
dfj <- group_by(df,YEAR) %>% summarise(COUNT=sum(COUNT)) %>% inner_join(dgg,by="YEAR")


ggplot() +
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  labs(title="NYC Death Count vs Homeless Population in NYC",y="Deaths By Any Cause",x="NYC Homeless Population Estimates",color="Year")+
  layer(data=dfj,
        mapping=aes(x=as.numeric(EST),y=as.numeric(COUNT),color=as.character(YEAR)),
        stat="identity",
        stat_params=list(),
        geom="point",
        geom_params=list(size=10),
        position=position_identity(),
        #position = position_jitter(width=0.5, height=0)
  )
