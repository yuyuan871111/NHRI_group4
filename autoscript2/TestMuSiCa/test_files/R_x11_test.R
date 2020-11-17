x = 1:5
y = x^2
#plot(x,y)
library(ggplot2)
library(Cairo)
df <- data.frame(X=c(x),Y=c(y))
CairoPNG("/home/u1397281/12.Group_study/NHRI_group4/TestMuSiCa/results/myplot.png")
ggplot(data=df,aes(X,Y))+geom_point()
dev.off()

