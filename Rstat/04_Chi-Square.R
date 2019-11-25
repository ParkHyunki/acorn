##### Chi-Square Test : 명목변수 다루는 검정 방법. 비율 검정

#ex>                         숙취가 있는 경우    숙취가 없는 경우
# 술을 마신 사람                    30                  70
# 술을 마시지 않은 사람             4 **?               96  
  #> Fisher's Exact Test 사용

# 데이터의 수가 충분할 경우(각 쉘의 데이터가 전체 데이터의 20% 이상일 때)에는 카이제곱 사용, 
# 충분하지 않은 경우에는 Fisher's Exact Test 사용

#ex>                         숙취가 있는 경우    숙취가 없는 경우   숙취가 약간 있는 경우
# 술을 마신 사람                    30                  70                  100
# 술을 마시지 않은 사람             4                   96                  1000
  #> 6개의 쉘 중 5보다 작은 값이 1개밖에 없으므로 카이제곱 쓸 수 있다

##### 실제 비율의 차이가 있는지 검정(분류에 의미가 있는 경우) : Cochran-Amitage trend test (prop.trend.test())
# x, number of events(사건이 발생한 숫자)
# n, number of trials(시도 횟수)

###ex> 자동차의 실린더 수와 변속기의 관계 확인하고자 한다
head(mtcars)

table(mtcars$cyl, mtcars$am)

# 가독성 위한 테이블 전처리
mtcars$tm <- ifelse(mtcars$am==0, "automatic", "manual")
result <- table(mtcars$cyl, mtcars$tm)

addmargins(result)  #> addmargins() 행과 열에 대한 합계 출력

# 검정  
chisq.test((result))  #> 5보다 작은 값이 6개이므로 카이제곱 사용시 결과 부정확
fisher.test(result)  #> 관계가 있다


###ex> 현재 흡연자, 과거 흡연자, 비흡연자와 고혈압(HBP)이 서로 연관되어 있는가
library(moonBook)
str(acs)

table(acs$HBP, acs$smoking)

# 가독성 위해 컬럼 순서 변경
acs$smoking <- factor(acs$smoking, levels=c("Never", "Ex-smoker", "Smoker"))
result <- table(acs$HBP, acs$smoking)
result

# 고혈압 발생한 사람 숫자(x: 사건 발생 숫자)
result[2,]

# 전체 인원(n, 시도 횟수)
colSums(result)

# 검정
prop.trend.test(result[2,], colSums(result))  #> 연관이 있다

###ex> 시군구별로 다자녀 지원 조례 채택 여부 관계 확인
mydata <- read.csv("C:/Users/acorn/hghbigdata/Rwork/BasicProject/stat/data/anova_two_way.csv")
head(mydata)
tail(mydata)
str(mydata)

result <- table(mydata$ad_layer, mydata$multichild)
result

chisq.test(result)  #> 관계가 없다(정확x)
fisher.test(result)  #> 관계가 없다


