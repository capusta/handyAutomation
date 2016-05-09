#print(fileName)
#install.packages("ggplot2")
#install.packages('gridExtra')
library(ggplot2)
library(gridExtra)

#fileName <- "troubleshooting"
#reportsFolder <- "troubleshooting"


# TODO: pass this variable from the script
dateFormat <- "%Y-%m-%d-%H-%M"

# The basic dataset
mydata <- read.csv(fileName, header=FALSE, col.names=c("Date","Description","Amount","Category"))
mydata <- mydata[mydata$Amount > 0.0, ]
mydata$Date <- as.POSIXct(mydata$Date, format=dateFormat)

# Let's break it up into various parts for parsing
mydata$Month.Name <- format(mydata$Date, format="%b")
mydata$Month.Number <- format(mydata$Date, format="%m")
mydata$hour <- as.numeric(format(mydata$Date, format="%H"))
mydata$min <- format(mydata$Date, format="%M")

# Cleanup of unnecessary field ... but maybe we can revert this if there is a need
mydata <- mydata[, !(names(mydata) %in% c("Date"))]

# Some basic plotting
for (cat in levels(mydata$Category)){ 
  jpeg(paste0(reportsFolder,cat,".jpg"), width=600)
  
  total_sum = ggplot(mydata[mydata$Category == cat,], aes(Month.Number, Amount, fill=Month.Number)) +
    theme_bw() +
    stat_summary(fun.y = sum, geom = "bar") + 
    scale_fill_manual(values=topo.colors(12, alpha=.7)) +
    scale_x_discrete(breaks = mydata$Month.Number, labels = mydata$Month.Name) +
    theme(legend.position="none", axis.text.x = element_text(angle=45), axis.title.x=element_blank())
    

  max_min = ggplot(mydata[mydata$Category == cat,], aes(Month.Number, Amount, fill=Month.Number)) +
    theme_bw() + geom_boxplot() + 
    scale_x_discrete(breaks = mydata$Month.Number, labels = mydata$Month.Name) +
    scale_fill_manual(values=topo.colors(12, alpha=.7)) +
    theme(legend.position='none', axis.text.x = element_text(angle=45), axis.title.x=element_blank())
  
  counts = ggplot(mydata[mydata$Category == cat, ], aes(hour), xlim=c(1,20)) + 
    facet_wrap(~Category) +
    geom_histogram(binwidth = 0.5, aes(y = ..density..)) + geom_density(color = 'red')
    #stat_function(fun = dnorm, color = 'red')
  
# g <- arrangeGrob(box, bar, ncol=1, nrow=2)
  grid.arrange(total_sum, max_min, counts, ncol=2, nrow=2)
  
  #ggsave(paste0(cat,".jpg"), width = 4, height = 2, scale = 3.6)
  dev.off()
}

