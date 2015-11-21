#df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from NYC_DEATHS"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_cdt932', PASS='orcl_cdt932', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))


ggplot() +
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  labs(title="Death Count by Cause over Time",y="Count",x="Year",color="Ethnicity")+
  layer(data=df,
        mapping=aes(x=as.numeric(YEAR),y=as.numeric(COUNT),color=ETHNICITY),
        stat="identity",
        stat_params=list(),
        geom="point",
        geom_params=list(),
        position=position_identity(),
        #position = position_jitter(width=0.5, height=0)
  )
