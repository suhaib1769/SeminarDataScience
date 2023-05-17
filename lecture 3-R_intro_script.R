#---
# "CS4125 Seminar Research Methodology for Data Science"
#subtitle: "Lecture 3 - Introduction into R"
#author: "Willem-Paul Brinkman"
#date: "2 Feburary 2019"
#---



# R environment, libraries, and data files

#Set the path to working directory so R can find data files. Note that Apple uses /, whereas Window uses \\. Below is working directory I use on my computer, so you have to change this to make it work for your computer.

#setwd("~/surfdrive/Teaching/own teaching/IN4125 - Seminar Research Methodology for Data Science/2019/Lectures/lecture 3")



## Packages and libraries


library(Rcmdr) #for MacOS make sure to run an updated version of XQuartz
library(foreign)


## Opening files


Lec3 <- read.spss("dataset0_example.sav", use.value.labels=TRUE, to.data.frame=TRUE)
write.csv(Lec3, "Lec3.csv")
Lec3a<-read.csv("Lec3.csv", header = TRUE)


# Data manipulation


metallicaNames <- c("Lars", "James","Jason", "Kirk")
print(metallicaNames)


metallicaNames<-metallicaNames[metallicaNames != "Jason"]
metallicaNames


metallicaNames<-c(metallicaNames, "Rob")
metallicaNames

metallicaAges<-c(47,47,48,46)
metallica<-data.frame(Name = metallicaNames, Age = metallicaAges)
metallica

metallica$Age



metallica$ChildAge<-c(12,12,4,6)
names(metallica)

metallica<-list(metallicaNames,metallicaAges)
metallica

metallica<-cbind(metallicaNames,metallicaAges)
metallica


metallica[2,2]
metallica[,2] # gets column 2, in this case etallicaAges
metallica[2,] # gets row 2, in this case all information from James
metallica[,] # gets all columns and rows


metallica<-data.frame(Name = metallicaNames, Age = metallicaAges)
metallica$ChildAge<-c(12,12,4,6)
metallica$fatherhoodAge<-metallica$Age-metallica$ChildAge
metallica


name<-c("Ben","Martin", "Andy","Paul", "Graham", "Carina", "Karina", "Doug", "Mark", "Zoe")
birth_date<-as.Date(c("1977-07-03","1969-05-4", "1973-06-21", "1970-07-16", 
"1949-10-10", "1983-11-05", "1987-10-08", "1989-09-16", 
"1973-05-20", "1984-11-12"))
job<-c(1,1,1,1,1,2,2,2,2,2)


job<-factor(job, levels = c(1:2), labels = c("Lecturer","Student"))
levels(job)


friends<-c(5,2,0,4,1,10,12,15,12,17)
alcohol<-c(10,15,20,5,30,25,20,16,17,18)
income<-c(20000,40000,35000,22000,50000,50000,100,3000,10000,10)
neurotic<-c(10,17,14,13,21,7,13,9,14,13)
lectureData<-data.frame(name,birth_date,job,friends,alcohol,income,neurotic)
lectureData




##Selecting 

subset2 <- subset(lectureData, neurotic >15 | friends > 15)
subset2


subset3 <- subset(lectureData, neurotic >15 | friends > 15, select = c(name,job))
subset3


##Example Rescaling


Lec3$incomecat[Lec3$income < 15000] <- "low"
Lec3$incomecat[Lec3$income >= 15000 & Lec3$income < 30000] <- "middle"
Lec3$incomecat[Lec3$income >= 30000] <- "high"


#Explorative data analysis

##Stem-and-leaf plot, histogram and density plots


stem(Lec3$income) #Stemplot (stem-and-leaf plot)
hist(Lec3$income, xlab="income") #histrogram
d <-density(Lec3$income) #density plot
plot(d)



library(sm)
sm.density.compare(Lec3$income, Lec3$broadban, xlab = "income") 
title(main="Income by broadband internet")
legend('topright', legend=levels(Lec3$broadban), col=c('red', 'blue'), lty=1:2, cex=0.8,
       title="Broadband", text.font=4, bg='lightblue') 


##Boxplot

boxplot(Lec3$income) 
boxplot(income  ~ children, data=Lec3, main="Income",
        xlab="Number of Childeren", ylab="Income in Dollars") 


##Scatterplot


plot(hoursint ~ hourstv, data = Lec3, 
     main="Scatterplot between hours internet use and watching TV")
library(car)
scatterplot(hoursint ~ hourstv, data = Lec3, 
            main="Scatterplot with extra features") 



library(ggplot2)
hp <- ggplot(Lec3, aes(x= hoursint, y = hourstv)) + 
  geom_point(shape=1) +
  geom_smooth(method=lm) +
  labs(title="Weekly hours spent on tv set against internet by Broadband and local Network")
hp + facet_grid(network ~ broadban)



#Functions

#taken from http://www.statmethods.net/management/userfunctions.html  

mysummary <- function(x,npar=TRUE,print=TRUE) {
  if (!npar) {
    center <- mean(x); spread <- sd(x)
  } else {
    center <- median(x); spread <- mad(x)
  }
  if (print & !npar) {
    cat("Mean=", center, "\n", "SD=", spread, "\n")
  } else if (print & npar) {
    cat("Median=", center, "\n", "MAD=", spread, "\n")
  }
  result <- list(center=center,spread=spread)
  return(result)
}



d<-mysummary(Lec3$income)



d<-mysummary(Lec3$income, FALSE)



d<-mysummary(Lec3$income, FALSE, FALSE)
d

