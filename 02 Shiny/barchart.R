#df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from NYC_DEATHS"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_cdt932', PASS='orcl_cdt932', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

dff <- group_by(df,CAUSE_OF_DEATH) %>% summarise(sumcount = sum(COUNT)) %>% filter(sumcount>5000) %>% arrange(CAUSE_OF_DEATH)

levels(dff$CAUSE_OF_DEATH) <- gsub(" ", "\n",levels(df$CAUSE_OF_DEATH))
levels(dff$CAUSE_OF_DEATH) <- gsub("IMMUNODEFICIENCY", "IMMUNO-\nDEFICIENCY",levels(dff$CAUSE_OF_DEATH))

medcount = median(dff$sumcount)

ggplot(dff, aes(x=(CAUSE_OF_DEATH),y=sumcount))+
  geom_bar(stat="identity")+
  geom_hline(yintercept=as.numeric(medcount), color="red") +
labs(title='Cause of Death') +
  labs(x="Cause of Death", y=paste("Count")) +
  theme(axis.text.x = element_text(size=7))
