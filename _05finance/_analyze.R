#print(fileName)
#install.packages("ggplot2")
#install.packages('gridExtra')
library(ggplot2)
library(gridExtra)

mydata <- read.csv(fileName, header=FALSE, col.names=c("Amount","Description","Date","Category"))
mydata$Date <- as.Date(mydata$Date)
mydata$Month.Name <- format(mydata$Date, format="%b")
mydata$Month.Number <- format(mydata$Date, format="%m")



for (cat in levels(mydata$Category)){
  box = ggplot(mydata[mydata$Category == cat,], aes(Month.Number, Amount, fill=Month.Number)) +
    stat_summary(fun.y = sum, geom = "bar") + scale_fill_manual(values=topo.colors(12, alpha=.7)) +
    scale_x_discrete(name="Month", breaks = mydata$Month.Number, labels = mydata$Month.Name) +
    theme(legend.position='none')

  bar = ggplot(mydata[mydata$Category == cat,], aes(Month.Number, Amount, fill=Month.Number)) +
    geom_boxplot() + theme(legend.position='none') +
    scale_x_discrete(name="Month", breaks = mydata$Month.Number, labels = mydata$Month.Name) +
      scale_fill_manual(values=topo.colors(12, alpha=.7))

  #grid.arrange(box, bar, top=cat)

  g <- arrangeGrob(box, bar, nrow=2, ncol=1)
  ggsave(filename= paste0("./_05finance/",cat,".jpg"), g, width = 4, height = 2, scale = 3.6)


}
#dev.off()
