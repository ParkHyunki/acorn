###### 단순 선형 회귀: 하나의 변수와 하나의 결과 도출(y = ax + b)

str(women)
women

# 그래프로 관계여부 확인
plot(weight~height, data=women)

fit <-lm(weight~height, data=women)  #> lm() 회귀분석 함수
abline(fit, col="blue")

summary(fit)  #> 키와 몸무게는 서로 관계가 있다

# 상관관계 확인
cor.test(women$weight, women$height)


# 관계 검증 전제조건
# - 정규분포인가(잔차의 정규성)?
# - 변수들간의 독립성
# - 선형성 보장
# - 등분산

plot(fit)  #> 관계검증 전제조건 확인할 수 있는 그래프
  #> QQ도: 정규성 확인(선 기준으로 점들이 가까워야 한다). scale-location: 등분산성(패턴을 가져서는 안된다). 
  #> Residuals vs Fitted: 선형성 확인. Residuals vs Leverage: 잔차의 이상치 확인(다중회귀에서 많이 사용)

par(mfrow=c(2, 2))  #> 4개의 그래프 한번에 보기 위함


###### 값 보정 위한 다항 회귀분석
fit2 <- lm(women$weight~women$height + I(women$height^2))  #> 정규성 확인에서, 2차 방정식으로
summary(fit2)

par(mfrow=c(1,1))
plot(weight~height, data=women)
lines(women$height, fitted(fit2), col="red")  #> 데이터에 맞게 선을 찾는다

par(mfrow=c(2, 2))
plot(fit2)

###### 
getwd()
setwd("C:/Users/acorn/hghbigdata/Rwork/BasicProject/stat/data")

#ex> 유치원이 많은 지역의 합계 출산율이 높은가? 합계 출산율이 유치원 수에 영향을 받는가
mydata <- read.csv("regression.csv")
str(mydata)
head(mydata)
tail(mydata)

y <- cbind(mydata$birth_rate)  #> cbind()로 데이터프레임 형식을 갖춘다
x <- cbind(mydata$kindergarten)

fit1 <- lm(y~x, data=mydata)
summary(fit1)  #> 상관성이 약하다

# 그래프 통해 전제조건 확인
par(mfrow = c(2,2))
plot(fit1)  #> 선형성과 등분산성 만족. 정규분포↓

# 정규분포 확인
shapiro.test(resid(fit1))  #> 정규분포가 아니다

# 정규성 보정
fit2 <- lm(log(y)~log(x), data=mydata)  #> log() 통해 종속과 독립변수 보정
summary(fit2)

plot(fit2)

shapiro.test(resid(fit2))  #> 정규분포를 갖는다

#########################
#########################

###### 다중 선형 회귀분석

#ex> 
state.x77
dim(state.x77)

states <- as.data.frame(state.x77[, c("Murder", "Population", "Illiteracy", "Income", "Frost")])
states

fit <- lm(Murder~Population+Illiteracy+Income+Frost, data=states)
fit <- lm(Murder~., data=states)  #> Murder를 제외한 모든 컬럼 가져온다

summary(fit)  #> 관계가 있다(설명력 0.567)

### 다중 공선성
# VIF(Variation Inflation Factor): 분산 팽창 지수. 다른 변수와의 관계를 수치로 표현. 루트.vif > 2 면 다중 공선성이 있다고 판단
install.packages("car")
library(car)

sqrt(vif(fit))  #> 각 변수별 vif값 추출. sqrt() 루트값 구하는 함수
  #> 다중 공선성이 없다

### 이상치 판단 기준
# 1. 이상치: 표준 편차가 2배 이상 크거나, -2배 이상 작은 값들 의미
# 2. 큰 지레점(High Leverage points): p(인자의 개수+절편) / n(샘플 개수)  ex. states 큰지레점 = 5/50 = 0.1 이 값보다 2배 이상 크면 요주의
# 3. 영향 관측치(Cook's D): 독립변수의 수p / (샘플 수n - 독립변수의 수k - 1)  ex.4/(50-4-1)=0.1 이 값보다 큰 값들 요주의

par(mfrow=c(1, 1))
influencePlot(fit, id=list(method="identify"))  #> 그래프로 이상치 확인
  #> 이상치: y축 0 기준으로 2와 -2의 범위 밖 관측치들은 이상치로 판단
  #> 큰 지레점: x축 0.1 기준으로 0.2 범위 밖의 데이터는 이상치로 판단
  #> 영향 관측치: 원의 지름으로 이상치 판단
  #> 그래프에서 선택 통해(finish) 이상치로 의심받는 데이터 확인 가능

### 회귀 모형의 교정
# 1. 정규성에 대한 교정
par(mfrow=c(2,2))
plot(fit)

powerTransform(states$Murder)  #> 정규성에 대한 교정값 제안받을 수 있는 함수(종속변수에 대해서)

summary(powerTransform(states$Murder))
  #> lambda(0)과 lambda(1): -2, -1, -0.5, 0, 0.5, 1, 2 으로 묶어서 계산하는 경우가 더 많다
  #> 2일 경우 y^2, 1일 경우 pass, 0.5일 경우 sqrt(y), 0일 경우 log(y), -0.5일 경우 1/sqrt(y), -1인 경우 1/y, -2인 경우 1/y^2
  #> 0.6 대신 범주의 값들 대입하는 것이 좋다(0.5)

# 2. 선형성에 대한 교정
boxTidwell(Murder ~ Population+Illiteracy, data=states)  #> 선형성에 대한 교정값 제안받을 수 있는 함수(독립변수에 대해서)

# 3. 등분선성에 대한 교정
ncvTest(fit)

par(mfrow=c(1, 1))
spreadLevelPlot(fit)  #> 등분성에 대한 교정갑 제안받을 수 있는 함수(종속변수에 대해서) + 그래프도 함께 나타남

### 회귀 분석 모형의 선택
fit1 <- lm(Murder~., data=states)
summary(fit1)  #> 다중회귀에서는 일반적인 설명계수보다는 보정된 Adjusted R-squared가 더 신뢰성이 높다

fit2 <- lm(Murder~Population+Illiteracy, data=states)
summary(fit2)  #> 변수를 뺐음에도 설명력 증가

# AIC(Akaite's An Information Criterion) 각 변수에 대한 성능 지표: 변수를 넣고 뺌 결정 참고(값이 작을수록 성능 더 좋다)
AIC(fit1, fit2)

# Stepwise Regression(Backward 모든 변수에서 하나씩 뺌, Forward 하나씩 비교하여 추가) 단계별로 적합한 모델 선택해주는 회귀분석
full.model <- lm(Murder~., data=states)
reduced.model = step(full.model, direction="backward")

summary(reduced.model)

min.model <- lm(Murder~1, data=states)  #> 최소한 한개의 변수만 갖고 사용
fwd.model <- step(min.model, direction="forward", scope=(Murder~Population+Illiteracy+Income+Frost))

summary(fwd.model)

# all subset regression 전체 조합 결과의 ACI 확인
install.packages("leaps")
library(leaps)

leap <- regsubsets(Murder~Population+Illiteracy+Income+Frost, data=states, nbest=4)

plot(leap, scale="adjr2")
