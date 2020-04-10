cohenD <- function(m1,m2){
  # This function calculates the Cohen-D value between two groups
  # The value represents the effect size comparing one group to another
  # Size of each group
  n1 <- length(m1)-1
  n2 <- length(m2)-1
  # Mean difference
  md<-mean(m1)-mean(m2)
  # Pooled variace
  sigma<-sqrt(( n1*var(m1)+n2*var(m2) )/( n1+n2 ))
  D<-md/sigma
  return(D)
}

Zscore<- function(m1,m2){
  # This function creates a z-score vector (Z) based on the mean of a different group 
  # Mean of the group 1
  m1 <- as.numeric(m1)
  m2 <- as.numeric(m2)
  m <- mean(m1)
  #Standart deviation of the group 1
  Sd<-sd(m1)
  # Z-score
  Z<-(m2 - m)/Sd
  return(Z)
}

# Normalize a vector from 0 to 1
normalize01 <- function(Vector) {
  # Normalice function
    Vz <- (Vector+1)/2
    return(Vz)}

# Scale a vector between data
scaleBetween <- function(X,a,b) {
  Fx <- ((b-a)*(X-min(X))/(max(X)-min(X)))+a
  return(Fx)}

# Slope calculation
slope <- function(x1,x2,y1,y2) {
  m <- (y2-y1)/(x2-x1)
  return(m)
}

per.change <- function(New, Old) {
  # Percentage Change: Divide by the Old Value
  P <- (New-Old)/abs(Old) * 100
  return(P)
}

per.diff <- function(New, Old) {
  # Percentage Difference: Divide by the Average of The Two Values
  P <- abs((New-Old)/(New+Old)/2)*100
  return(P)
}

# Function that optimizes the color distribution
optim.color <- function(Data,Colors) {
  #       Data: Is the matrix of data to plot
  #       Colors: Vector of colors we want to use
  # 
  mtx <- as.matrix(Data)
  # Following code limits the lowest and highest color to 5%, and 95% of your range, respectively
  quantile.range <- quantile(mtx, probs = seq(0, 1, 0.01))
  palette.breaks <- seq(quantile.range["5%"], quantile.range["95%"], 0.1)
  # Find optimal divergent color palette (or set own)
  color.function <- colorRampPalette(Colors)
  color.palette  <- color.function(length(palette.breaks) - 1)
  # Returns a list with the color map and the optimal number of color breaks
  return(list(color.palette=as.vector(color.palette),palette.breaks=as.vector(palette.breaks)))
}
