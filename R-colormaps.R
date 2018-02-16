par(mfrow=c(3,1))

# Function for saving the colormaps
save.colmap <- function(Colmap,Dir){
  Colmap<-t(col2rgb(Colmap(256)))
  Colmap<-Colmap/256
  write.csv(Colmap,file=Dir,row.names=FALSE,quote = FALSE) 
  }

# # # ############################ # # #
#           blainkbow
# # # ############################ # # #
blainkbow <- colorRampPalette(c("gray85","darkblue","midnightblue","navy","royalblue3","royalblue","skyblue3","skyblue","lightskyblue1","forestgreen","chartreuse4","olivedrab4","gold2","darkorange","red","red3"))
plot(seq(-1,1,length.out = 256),rep(1,256),pch=15,cex=30,col=blainkbow(256),ylim=c(0.95,1.05),bty='n',main="blainkbow")
abline(v=c(-0.5,0,0.5))
save.colmap(blainkbow,"/misc/ernst/rcruces/git_here/oma/matlab_colormaps/blainkbow.csv")

# # # ############################ # # #
#           blainkbow2
# # # ############################ # # #
blainkbow2 <- colorRampPalette(c("white","lightskyblue1","skyblue","skyblue3","royalblue2","forestgreen","chartreuse4","gold2","darkorange","red","red3"))
plot(seq(-1,1,length.out = 256),rep(1,256),pch=15,cex=30,col=blainkbow2(256),ylim=c(0.95,1.05),bty='n',main="blainkbow2")
abline(v=c(-0.5,0,0.5))
save.colmap(blainkbow2,"/misc/ernst/rcruces/git_here/oma/matlab_colormaps/blainkbow2.csv")

# # # ############################ # # #
#           grayula
# # # ############################ # # #
grayula <- colorRampPalette(c("gray90","royalblue","navy","royalblue4","darkgreen","forestgreen","olivedrab3","olivedrab2","gold2"))
plot(seq(0,3,length.out = 256),rep(1,256),pch=15,cex=30,col=grayula(256),ylim=c(0.95,1.05),bty='n',main="grayula")
abline(v=c(0.5,1,2,2.5))
abline(v=c(0.75,1.5,2.25),lwd=4)
save.colmap(grayula,"/misc/ernst/rcruces/git_here/oma/matlab_colormaps/grayula.csv")

# # # ############################ # # #
#           griblred
# # # ############################ # # #
griblred <- colorRampPalette(c("white","midnightblue","royalblue3","royalblue","skyblue","mediumaquamarine","gold","darkorange","red2","red4"))
plot(1:256,rep(1,256),pch=15,cex=30,col=griblred(256),ylim=c(0.95,1.05),bty='n',main="griblred")
save.colmap(griblred,"/misc/ernst/rcruces/git_here/oma/matlab_colormaps/griblred.csv")

# # # ############################ # # #
#           blured
# # # ############################ # # #
blured <- colorRampPalette(c("midnightblue","royalblue3","royalblue","skyblue","gray85","gray85","gold","darkorange","red2","red4"))
plot(1:256,rep(1,256),pch=15,cex=30,col=blured(256),ylim=c(0.95,1.05),bty='n',main="blured")
save.colmap(blured,"/misc/ernst/rcruces/git_here/oma/matlab_colormaps/blured.csv")

# # # ############################ # # #
#           Cool Jet bar
# # # ############################ # # #
surfJet <- colorRampPalette(c("midnightblue","navy","royalblue3","royalblue","skyblue","gray90","gray90","gray95","gray95","gray95","gray90","gray90","gold","darkorange","orangered","red2","red4"))
#surfJet <- colorRampPalette(c("midnightblue","navy","royalblue3","royalblue","skyblue","gray85","gray85","gold","darkorange","orangered","red2","red4"))
plot(seq(-2,2,length.out = 256),rep(1,256),pch=15,cex=30,col=surfJet(256),ylim=c(0.95,1.05),bty='n',main="surfJet")
abline(v=c(-1,0,1))
save.colmap(surfJet,"/misc/ernst/rcruces/git_here/oma/matlab_colormaps/surfJet.csv")

# # # ############################ # # #
#      High-Contrast Cool Jet bar
# # # ############################ # # #
surfJetHi <- colorRampPalette(c("skyblue","royalblue","royalblue3","navy","midnightblue","gray45","gray45","gray42","gray40","gray42","gray45","gray45","red4","red2","orangered","darkorange","gold"))
plot(seq(-2,2,length.out = 256),rep(1,256),pch=15,cex=30,col=surfJetHi(256),ylim=c(0.95,1.05),bty='n',main="surfJet")
abline(v=c(-1,0,1))
save.colmap(surfJetHi,"/misc/ernst/rcruces/git_here/oma/matlab_colormaps/surfJetHi.csv")

# # # ############################ # # #
#           Cool Jet barKaks
# # # ############################ # # #
surfJetKaks <- colorRampPalette(c("blue","royalblue3","dodgerblue2","deepskyblue","skyblue","gray90","gray90","gray95","gray95","gray95","gray95","gray90","gray90","gold","orangered","firebrick4"))
plot(seq(-2,2,length.out = 256),rep(1,256),pch=15,cex=30,col=surfJetKaks(256),ylim=c(0.95,1.05),bty='n',main="surfJet")
abline(v=c(-1,0,1))
save.colmap(surfJetKaks,"/misc/ernst/rcruces/git_here/oma/matlab_colormaps/surfJetKaks.csv")

# # # ############################ # # #
#           graypurp
# # # ############################ # # #
#graypurp<-colorRampPalette(c("gray85","slategray2","royalblue1","royalblue2","royalblue3","royalblue4","slateblue4","purple4","mediumpurple3"))
graypurp<-colorRampPalette(c("gray85","navy","royalblue3","royalblue1","mediumpurple2","mediumpurple3","purple4"))
plot(1:256,rep(1,256),pch=15,cex=30,col=graypurp(256),ylim=c(0.95,1.05),bty='n',main="graypurp")
save.colmap(graypurp,"/misc/ernst/rcruces/git_here/oma/matlab_colormaps/graypurp.csv")

# # # ############################ # # #
#           Gray to Blue
# # # ############################ # # #
grayblue<-colorRampPalette(c("gray85","slategray2","skyblue","skyblue2","royalblue","royalblue3","navy","midnightblue"))
plot(1:256,rep(1,256),pch=15,cex=30,col=grayblue(256),ylim=c(0.95,1.05),bty='n',main="grayblue")
save.colmap(grayblue,"/misc/ernst/rcruces/git_here/oma/matlab_colormaps/grayblue.csv")

# # # ############################ # # #
#           Fire Red
# # # ############################ # # #
fireRed <- colorRampPalette(c("gray90","gray85","lightgoldenrod2","gold","darkorange","orangered","red2","red4"))
plot(seq(0,3,length.out = 256),rep(1,256),pch=15,cex=30,col=fireRed(256),ylim=c(0.95,1.05),bty='n',main="fireRed")
abline(v=c(0.5,1,1.5,2))
save.colmap(fireRed,"/misc/ernst/rcruces/git_here/oma/matlab_colormaps/fireRed.csv")


