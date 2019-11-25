###### Power Analysis: 적정한 표본의 개수 산출(데이터 적합성 판단) -> 소수의 데이터로 분석을 해야하는 경우 주로 사용(의료 분야)
# 실험군과 대조군의 차이가 난다는 것을 입증할 수 없는 상황
#   - 표본의 개수가 적기 때문
#   - 표본의 개수는 충분하나 실제로 두 그룹 간 결과의 차이가 없는 경우
#   - Cohen의 d공식(effective size 유의미한 크기 구하는 공식)

install.packages("pwr")
#> 참고. 직접 사이트에서 소스 받기  install.packages("https://cran.rstudio.com/bin/windows/contrib/3.6/pwr_1.2-2.zip", repo=NULL, type="source")
library(pwr)

setwd("C:/Users/acorn/hghbigdata/Rwork/BasicProject/stat")

KY <- read.csv(file="C:/Users/acorn/hghbigdata/Rwork/BasicProject/stat/data/KY.csv", header=T, sep=",")
head(KY)

table(KY$group)  #> 비교를 위한 두 집단 존재(실험군, 대조군 데이터 각 20개씩)

### Cohen's d 공식 구현 통해 표본의 유효한 크기 확인
mean.1 <- mean(KY$score[KY$group==1])
mean.2 <- mean(KY$score[KY$group==2])

sd.1 <- sd(KY$score[KY$group==1])
sd.2 <- sd(KY$score[KY$group==2])

effictiveSize <- abs(mean.1-mean.2) / sqrt((sd.1^2 + sd.2^2)/2)
effictiveSize

pwr.t.test(d=effictiveSize, power=0.8, sig.level=0.05, type="two.sample", alternative="two.sided")
  #> d= 와 type= 이 중요(나머지는 테스트 위한 수치로 거의 바뀌지 않는다)
  #> type= 테스트 방식. 집단이 하나일 경우 one.sample  세 개일 경우 paired sample
  #> alternative= 가설의 오류에 대한 처리
  #> n의 값 = 표본의 유의미한 크기(17.6인데 그룹 크기 20이므로 유의미한 크기를 갖는다)

