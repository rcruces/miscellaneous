cohenD <- function(m1,m2){
  # This function calculates the Cohen-D value between two groups
  # The value represents the effect size comparing one group to another
  # Size of each group
  n1 <- length(m1)-1
  n2 <- length(m2)-1
  # Mean difference
  md<-mean(m2)-mean(m1)
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

normalize01 <- function(Vector) {
  # Normalice function
    Vz <- (Vector+1)/2
    return(Vz)}
