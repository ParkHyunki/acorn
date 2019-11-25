### T-test 사용 알고리즘
# T-test (= student T-test): 일반적으로 Independent T-test 의미
# Mann-Whitney U test ( =wilcoxen rank-sum test 순위를 매겨 순위의 합계를 갖고 평균을 추출한다, Mann-whitney-wilcoxon test, MWW)
# welch's T-test

# 비교하고자 하는 결과값이 연속변수가 아닐 경우 MWW 알고리즘 사용
# 연속변수인데 정규분포가 아닌 경우 MWW 사용(비모수적 검정 방식)
# 연속변수이고 정규분포인데 등분산이 아닌 경우 welch's T-test 사용
# 모든 전제조건 만족했을 때 T-test 사용

install.packages("moonBook")
library(moonBook)

head(acs)  #> acs dataset: 경기도에 소재한 한 대학병원에서 2년동안 내원한 관상동맥증후군 환자
str(acs)

mean.man <- mean(acs$age[acs$sex=="Male"])  #> 남성의 나이에 대한 평균
mean.woman <- mean(acs$age[acs$sex=="Female"])  #> 여성의 나이에 대한 평균

moonBook::densityplot(age ~ sex, data=acs)  #> densityplot(종속변수 ~ 독립변수, 데이터) 밀도 그래프 그리는 함수

## 정규분포 테스트(Shapiro test)
# 귀무 가설: 정규분포를 이룬다. 대립 가설: 정규분포를 이루지 않는다
shapiro.test(acs$age[acs$sex=="Male"])  #> p-value=0.2098 > 0.05 이므로 귀무가설이 참(남성의 나이에 대한 평균은 정규분포를 이룬다)
shapiro.test(acs$age[acs$sex=="Female"])  #> p-value=0.000000634 < 0.05 이므로 대립가설이 참(여성의 나이에 대한 평균은 정규분포를 이루지 않는다)

## 두 변수 중 하나라도 정규분포가 아니면 정규분포가 아니다(T-test를 쓸 수 없다)
# MWW 알고리즘 사용
# 귀무가설: 평균의 차이가 없다. 대립가설: 평균의 차이가 있다
wilcox.test(age ~ sex, data=acs)  #> p-value < 2.2e-16 < 0.05 이므로 대립가설이 참(성별에 따른 나이의 평균 차가 있다)

## 등분산 테스트
# 귀무가설: 등분산이다. 대립가설: 등분산이 아니다
var.test(age ~ sex, data=acs)  #> p-value=0.3866 > 0.05 이므로 귀무가설이 참(등분산이다)

## T-test
# 전제조건 만족 경우: 연속형 자료 + 정규분포 + 등분산
# 귀무가설: 평균차이가 없다. 대립가설: 평균 차이가 있다
t.test(age ~ sex, data=acs, var.test=T)  #> p-value<2.2e-16 < 0.05 이므로 대립가설이 참(성별에 따른 나이의 평균 차가 있다)

t.test(age ~ sex, data=acs, var.test=F)  #> 가정.등분산이 아닌 경우 var.test=F 표시(T-test와 welch's T-tset는 사용 함수 같고 속성값만 다르다)

#######################################
# 집단이 하나일 경우의 테스트: One Sample T-test
#ex> A회사의 건전지 수명이 1000시간일 때 무작위로 뽑은 10개의 건전지 수명에 대해 샘플이 모집단과 다르다고 할 수 있는가?
# 귀무가설: 모집단의 평균과 같다(다르지 않다). 대립가설(연구가설): 모집단의 평균과 다르다
a <- c(980, 1008, 968, 1032, 1012, 1002, 996, 1017, 990, 890)  #> 평균이니 변수는 연속변수
mean(a)

shapiro.test(a)  #> 정규분포 테스트. p-value=0.02061 < 0.05 이므로 대립가설 참(정규분포가 아니다)
  #> 하나의 집단이므로 NWW 사용x
  #> 충분한 데이터의 개수 확보 필요(최소 30개 이상)

a <- c(980, 1008, 968, 1032, 1012, 1002, 996, 1017, 990, 955)  #> 평균이니 변수는 연속변수
mean(a)

shapiro.test(a)  #> p-value=0.9781 > 0.05 이므로 귀무가설 참(정규분포)

t.test(a, mu=1000)  #> p-value=0.602 > 0.05 이므로 귀무가설 참: 샘플의 평균이 모집과 같다(차이가 없다)
  #> mu= 모집단의 평균

##################
# 한 집단의 시간에 따른 차이: Paired Sample T-test
#ex> 어떤 학급의 수학 평균 성적이 55점이다. 0교시 수업을 시행하고 나서 학생들의 성적을 다시 살펴보니 다음과 같았다. 성적이 올랐다고 판단할 수 있는가?
# 귀무가설: 차이가 없다. 대립가설: 차이가 있다
a <- c(58, 49, 39, 99, 32, 88, 62, 30, 55, 65, 44, 55, 57, 53, 88, 42, 39)
mean(a)

shapiro.test(a)  #> 정규분포

t.test(a, mu=55, alternative = "greater")  #> 귀무가설이 참(성적과 차이가 없다)
  #> alternative="greater"는  paired T-test

#########################################
#ex> onesample.csv 자료는 우리나라 76개의 자치도시 중에 20개만 뽑은 것이다. 모집단의 합계 출산율은 1.37812
# 귀무가설: 20개 도시의 합계 출산율이 모집단의 합계 출산율과 차이가 없다. 대립가설: 차이가 있다
mydata <- read.csv("data/onesample.csv")
mydata
mean(mydata$birth_rate)

shapiro.test(mydata$birth_rate)  #> 정규분포

t.test(mydata$birth_rate, mu=1.37812)  #> 대립가설이 참이다(차이가 있다) = 표본을 잘못 추출하였다(모집단을 대표할 수 없다)

#####################################
#ex> independent.csv 자료 중 dummy 컬럼은 0은 군, 1은 시를 나타내는 컬럼이다.시와 군에 따라 합계 출산율의 차이가 있는가?
# 귀무가설: 차이가 없다. 대립가설: 차이가 있다
mydata <- read.csv("data/independent.csv")
mydata

gun.mean <- mean(mydata$birth_rate[mydata$dummy==0])
gun.mean
si.mean <- mean(mydata$birth_rate[mydata$dummy==1])
si.mean

shapiro.test(mydata$birth_rate[mydata$dummy==0])  #> 정규분포가 아니다
shapiro.test(mydata$birth_rate[mydata$dummy==1])  #> 정규분포가 아니다

wilcox.test(mydata$birth_rate ~ mydata$dummy, data=mydata)  #> 대립가설이 참이다(시와 군에 따라 합계 출산율의 차이가 있다)

##########################################################
#ex> 오토와 수동일 때 mpg의 차이
# 귀무가설: 차이가 없다. 대립가설: 차이가 있다
str(mtcars)
head(mtcars)
# 데이터셋 설명
# am: 0=오토, 1=수동

mtcars.0 <- mean(mtcars$mpg[mtcars$am==0])
mtcars.0
mtcars.1 <- mean(mtcars$mpg[mtcars$am==1])
mtcars.1

shapiro.test(mtcars$mpg[mtcars$am==0])  #> 정규분포
shapiro.test(mtcars$mpg[mtcars$am==1])  #> 정규분포

var.test(mtcars[mtcars$am==1, 1], mtcars[mtcars$am==0, 1])  #> 등분산

t.test(mtcars$mpg ~ mtcars$am, data=mtcars, var.equal=T, conf.level=0.95)
  #> 대립가설 참(오토와 수동의 연비는 차이가 있다=수동이 평균 연비가 더 좋다)

#########################################################################
#ex> pairedData.csv 자료 중 before와 after의 차이가 의미 있는가?
# 귀무가설: 차이가 없다. 대립가설: 차이가 있다
pd <- read.csv("data/pairedData.csv")
pd

before_pd <- mean(pd$before)
before_pd
after_pd <- mean(pd$After)
after_pd

# wide형 데이터를 long형 데이터로 전환: reshape 패키지의 melt (wide->long), dcast (long->wide)
library(reshape2)

melt(pd, id=("ID"), variable.name="GROUP", value.name="RESULT")

# wide형 데이터를 long형 데이터로 전환: tidyr 패키지의 gather
install.packages("tidyr")
library(tidyr)

?gather  #> melt() 기능과 유사
pd2 <- gather(pd, key="GROUP", value="RESULT", -ID)
pd2

shapiro.test(pd2$RESULT[pd2$GROUP=="before"])  #> 정규분포
shapiro.test(pd2$RESULT[pd2$GROUP=="After"])  #> 정규분포

d <- pd2$RESULT[pd2$GROUP=="before"] - pd2$RESULT[pd2$GROUP=="After"]  #> 두 검정을 한번에
shapiro.test(d)  #> 정규분포

t.test(pd2$RESULT ~ pd2$GROUP, data=pd2, paired=T)  #> 대립가설이 참(before와 After 평균의 차이는 의미가 있다)

# 그래프로 시각화
before <- subset(pd2, GROUP=="before", RESULT, drop=T)
after <- subset(pd2, GROUP=="After", RESULT, drop=T)

install.packages("PairedData")
library(PairedData)

pd3 <- paired(before, after)
plot(pd3, type="profile") + theme_bw()  #> theme_bw() 배경색을 흰색과 검은색이 섞인 색으로 변경

######################################
str(sleep)
View(sleep)

before <- subset(sleep, group==1, extra, drop=T)
after <- subset(sleep, group==2, extra, drop=T)

sleep2 <- paired(before, after)
plot(sleep2, type="profile") + theme_bw()

shapiro.test(sleep$extra[sleep$group==1] - sleep$extra[sleep$group==2])  #> 정규분포가 아니다
with(sleep, shapiro.test(extra[group==2] - extra[group==1]))  #> with() 이용해 변수명 생략

with(sleep, wilcox.test(extra[group==2] - extra[group==1]))  #> 그룹1과 그룹2의 extra 값의 차이가 있다

###########################################################
mydata <- read.csv("data/paired.csv")
head(mydata)
tail(mydata)

mydata2 <- gather(mydata, key="GROUP", value="RESULT", -c(ID, cities))
head(mydata2)

with(mydata2, shapiro.test(RESULT[GROUP=="birth_rate_2015"]))  #> 정규분포x
with(mydata2, shapiro.test(RESULT[GROUP=="birth_rate_2010"]))  #> 정규분포x

with(mydata2, t.test(RESULT[GROUP=="birth_rate_2015"] - RESULT[GROUP=="birth_rate_2010"], data=mydata2))  #> 2015 출산율과 2010 출산율 차이x
with(mydata2, wilcox.test((RESULT[GROUP=="birth_rate_2015"] - RESULT[GROUP=="birth_rate_2010"])))  #> 2015
