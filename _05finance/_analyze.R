#print(fileName)
#install.packages("ggplot2")
#install.packages('gridExtra')
library(ggplot2)
library(gridExtra)


#fileName <- "troubleshooting"
#reportsFolder <- "troubleshooting"

mydata <- read.csv(fileName, header=FALSE, col.names=c("Date","Description","Amount","Category"))
mydata$Date <- as.Date(mydata$Date)
mydata$Month.Name <- format(mydata$Date, format="%b")
mydata$Month.Number <- format(mydata$Date, format="%m")



for (cat in levels(mydata$Category)){
  jpeg(paste0(reportsFolder,cat,".jpg"))
  
  box = ggplot(mydata[mydata$Category == cat,], aes(Month.Number, Amount, fill=Month.Number)) +
    stat_summary(fun.y = sum, geom = "bar") + scale_fill_manual(values=topo.colors(12, alpha=.7)) +
    scale_x_discrete(name="Month", breaks = mydata$Month.Number, labels = mydata$Month.Name) +
    theme(legend.position='none')

  bar = ggplot(mydata[mydata$Category == cat,], aes(Month.Number, Amount, fill=Month.Number)) +
    geom_boxplot() + theme(legend.position='none') +
    scale_x_discrete(name="Month", breaks = mydata$Month.Number, labels = mydata$Month.Name) +
      scale_fill_manual(values=topo.colors(12, alpha=.7))

  #g <- arrangeGrob(box, bar, ncol=1, nrow=2)
  grid.arrange(box, bar, top=cat, ncol=1, nrow=2)
  
  #ggsave(paste0(,cat,".jpg"), g, width = 4, height = 2, scale = 3.6)
  dev.off()
}

