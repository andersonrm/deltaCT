birds<-read.csv('https://raw.githubusercontent.com/collnell/lab-demo/master/bird_by_fg.csv')
head(birds)

birds1<-birds %>% 
  group_by(DIVERSITY) %>%
  select(IN,OM) %>%
  mutate(meanIN=mean(IN),meanOM=mean(OM)) %>%
  ungroup() %>%
  mutate(GmeanIN=mean(IN),GmeanOM=mean(OM))

ggplot(birds1, aes(IN,OM,color=DIVERSITY)) +
  geom_point(aes(x=GmeanIN,y=GmeanOM),size=4,color="gray50") +
  geom_segment(aes(
    x=GmeanIN, y=GmeanOM, xend=IN, yend=OM),
    color="gray50",lty=2) +
  geom_point() +
  geom_point(aes(x=meanIN,y=meanOM),size=4) +
  geom_segment(aes(x=meanIN, y=meanOM, xend=IN, yend=OM))


euc_dist<-vegdist(sqrt(birds[,-c(1:2)]),method="bray")
euc_distM<-vegdist(sqrt(birds[birds$DIVERSITY=="M",-c(1:2)]),method="bray")
euc_distP<-vegdist(sqrt(birds[birds$DIVERSITY=="P",-c(1:2)]),method="bray")

SSR<-sum(euc_distM^2)/12+sum(euc_distP^2)/20
SST<-sum(euc_dist^2)/32

Fstat<-(SST-SSR)/(SSR/30)

sum(euc_dist[1:12]^2)


perm.sampdist<-replicate(5000,{
  
  randbirds<-birds
  randbirds$DIVERSITY<-sample(birds$DIVERSITY)
  
  euc_dist<-vegdist(sqrt(birds[,-c(1:2)]),method="bray")
  euc_distM<-vegdist(sqrt(birds[birds$DIVERSITY=="M",-c(1:2)]),method="bray")
  euc_distP<-vegdist(sqrt(birds[birds$DIVERSITY=="P",-c(1:2)]),method="bray")
  
  SSR<-sum(euc_distM^2)/12+sum(euc_distP^2)/20
  SST<-sum(euc_dist^2)/32
  
  (SST-SSR)/(SSR/30)
} )

mean(perm.sampdist>Fstat)


permmod <- adonis2(euc_dist~DIVERSITY,data=birds, method="bray")

permmod
