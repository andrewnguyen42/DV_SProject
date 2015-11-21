#df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from nyc_deaths"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_cdt932', PASS='orcl_cdt932', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))


kpi_func <- function(count){
if(count>5000){
kpi = "High Death Count"
}
else{
kpi ="Low Death Count"
}
return(kpi)
}


dff <-  group_by(df,CAUSE_OF_DEATH,ETHNICITY) %>% summarise(sumcount=sum(COUNT)) %>% ungroup() %>% rowwise() %>% mutate(Death_KPI=kpi_func(sumcount)) %>% group_by(CAUSE_OF_DEATH,ETHNICITY)

dff$CAUSE_OF_DEATH = with(dff,factor(CAUSE_OF_DEATH, levels = rev(levels(CAUSE_OF_DEATH))))



ggplot(dff, aes(ETHNICITY,CAUSE_OF_DEATH,color=Death_KPI)) + 
theme_bw() + xlab("") + ylab("") +
scale_size_continuous(range=c(10,30)) + 
geom_text(aes(label=sumcount))
