##### **시험? 데이터 전처리: 데이터 분석 전 다듬기(데이터 분석의 80%) -> 올바른 결과 위해서는 올바른 전처리 필요

### 순서: 데이터 탐색 - 결측치/이상치 처리(가장 중요) - Feature Engineering(기존 변수에서 새로운 변수 만든다: 파생변수)

# 데이터 탐색
#   1) 변수 확인
#     - 변수 유형: 범주형? 연속형? 문자형? 숫자형?
#     - 단변수일 경우: 평균? 최빈값? 중간값? 분포?
#     - 다변수일 경우(2개): 변수 간 관계나 차이 검정
#     - 다변수일 경우(3개 이상): 변수 간 관계 검정(통계 기법 다르다)

# 결측치(Missing Value) 처리
#   1) 결측치 제거
#   2) 다른 값으로 대체: 평균, 최빈값, 중간값
#   3) 예측값: 선형 회귀분석, 로지스틱 회귀분석 이용

# 이상치 처리
#   1) 이상치 탐색
#     - 시각적 확인: 그래프(산포도, Boxplot)
#     - 통계적 확인: 표준잔차, leverage, Cook's D, ...
#   2) 처리 방법
#     - 삭제. 대체. 리샘플링(케이스별로 분리하여 별도의 모델링 후 비교)

# Feature Engineering
#   1) Scaling: 단위 변경
#   2) Binning: 연속형 변수를 범주형 변수로 변환
#   3) Dummy: 범주형 변수를 연속형 변수로 변환 -> 머신러닝에서 주로 사용(문자인식x: 문자/factor형 데이터 숫자형으로 변환 필요)
#   4) Transform: 기존 존재하는 변수의 성질 이용해 다른 변수 만드는 방법(파생변수)


##### 실습
###ex> **시험? 변수명 바꾸기
df_raw <- data.frame(var1=c(1, 2, 3), var2=c(2, 3, 2))
df_raw

df_new1 <- df_raw

#   1) 내장함수 이용
names(df_new1) <- c("v1", "v2")  #> names()로 컬럼명 확인 후 변경
df_new1

#   2) 패키지 이용(dplyr)
library(dplyr)

df_new2 <- df_raw
df_new2 <- rename(df_new2, v2=var2, v1=var1)  #> dplyr 패키지의 rename() 통해 컬럼명 변경
df_new2

###ex> 결측치 처리
dataset1 <- read.csv("C:/Users/acorn/hghbigdata/Rwork/BasicProject/data/dataset.csv", header=T)

View(dataset1)
head(dataset1)
str(dataset1)

# 변수 설명
# resident : 1~5까지의 값을 갖는 명목변수로 거주시를 나타낸다.
# gender : 1~2까지의 값을 갖는 명목변수로 남/여를 나타낸다.
# job : 1~3까지의 값을 갖는 명목변수로 직업을 나타낸다.
# age : 양적변수(비율) : 2~69
# position : 1~5까지의 값을 갖는 명목변수(서열)로 직위를 나타낸다.
# price : 양적변수(비율) : 2.1 ~ 7.9
# survey : 만족도 조사 : 1~5 : 명목변수(서열)

y <- dataset1$price
plot(y)

attach(dataset1)  #> 메모리에 데이터 고정(dplyr와 같이 선언하지 않아도 컬럼명으로만 사용 가능)
price
detach(dataset1)  #> 메모리에 고정한 데이터 삭제
dataset1$price

#   1) price에 대한 결측치 확인
summary(price)  #> NA's에서 결측치 개수 확인 가능

#   2) 결측치 제거
sum(price, na.rm=T)  #> na.rm= 결측치 제외하고 합계 구함

price2 <- na.omit(price)  #> na.omit() 컬럼에서 결측치 제거
sum(price2)

#   3) 결측치 대체
price[1:30]

price2 <- ifelse(!is.na(price), price, 0)
price2[1:30]

price3 <- ifelse(!is.na(price), price, round(mean(price, na.rm=T), 2))
price3[1:30]

###ex> 이상치 처리
#   1) 질적 자료 이상치 확인
table(gender)  #> table() 빈도수 확인 통해 수치적으로 확인
pie(table(gender))  #> 시각적으로 확인(파이 그래프)

#   2) 질적 자료 이상치 제거
dataset1 <- subset(dataset1, gender==1 | gender==2)
table(dataset1$gender)
pie(table(dataset1$gender))

#   3) 양적 자료 이상치 확인
length(price)  #> price 전체 data 확인

plot(price)
boxplot(price)  #> 시각적으로 이상치 확인. 이상치 판단 기준 필요

summary(price)  #> 평균과 중앙값에 비해 max와 min 값이 너무 크다

dataset2 <- subset(dataset1, price>=2 & price <=8)
length(dataset2$price)

plot(dataset2$price)
boxplot(dataset2$price)
stem(dataset2$price)  #> 줄기 그래프: 텍스트 형식의 그래프(각각의 막대에 해당하는 데이터값 확인 가능)

#   ex> age의 이상치 정제(20~69)
length(age)

table(age)
summary(age)

###ex> Feature Enginearing
View(dataset2)

dataset2$resident  #> 머신러닝이면 숫자형 필요. but 보고+분석용은 문자형이 더 용이하다

dataset2$resident2[dataset2$resident ==1] <- "1.서울특별시"
dataset2$resident2[dataset2$resident ==2] <- "2.인천광역시"
dataset2$resident2[dataset2$resident ==3] <- "3.대전광역시"
dataset2$resident2[dataset2$resident ==4] <- "4.대구광역시"
dataset2$resident2[dataset2$resident ==5] <- "5.시구군"

View(dataset2)

#   1) 역코딩을 위한 코드 변경(ex.만족이 높은 값이 되도록)
table(dataset2$survey)
dataset2$survey
survey <- dataset2$survey

csurvey <- 6-survey  #> 높은 값이 만족값이 되도록 변경
csurvey

dataset2$survey <- csurvey
head(dataset2)

#   2) Binning(연속형 변수 > 범주형 변수)
#     ex> 나이 변수를 청년층/중년층/장년층으로 척도 변경
dataset2$age2[dataset2$age<=30] <- "청년층"
dataset2$age2[dataset2$age>30 & dataset2$age<=55] <- "중년층"
dataset2$age2[dataset2$age>55] <- "장년층"
View(dataset2)

#   3) Dummy(범주형 변수 > 연속형 변수)
user_data <- read.csv("C:/Users/acorn/hghbigdata/Rwork/BasicProject/data/user_data.csv", header=T)
head(user_data)

# 데이터 설명
# 거주유형: 단독주택=1, 다가주주택=2, 아파트=3, 오피스텔=4
# 직업유형: 자영업=1, 사무직=2, 서비스=3, 전문직=4, 기타=5+

table(user_data$house_type)

house_type2 <- ifelse(user_data$house_type==1 | user_data$house_type==2, 0, 1)
user_data$house_type2 <- house_type2
head(user_data, 10)

#   4) 데이터의 구조 변경(wide type, long type): melt(long 포맷으로 변경), cast(wide 포맷으로 변경)
#      reshape, reshape2, ...
library(reshape2)

str(airquality)
head(airquality)

m1 <- melt(airquality, id.vars=c("Month", "Day"))  #> Month와 Day를 아이디로 하여 데이터 구조를 long type 포맷으로 변경()
head(m1)

m2 <- melt(airquality, id.vars=c("Month", "Day"), variable.name="climate_var", value.name="climate_val")  #> 컬럼명 변경
head(m2)

dc1 <- dcast(m2, Month + Day ~ climate_var)  #> long type을 wide type으로 다시 변경. ~ 구분할 때 많이 사용. + 여러 개 지정
head(dc1)

#
data <- read.csv("C:/Users/acorn/hghbigdata/Rwork/BasicProject/data/data.csv")  #> long type data: 같은 아이디가 아래로 열거
data

wide <- dcast(data, Customer_ID ~ Date, sum)  #> 날짜 데이터를 행으로 나열
wide

long <- melt(wide, id="Customer_ID")
head(long)

#
pay_data <- read.csv("C:/Users/acorn/hghbigdata/Rwork/BasicProject/data/pay_data.csv")
head(pay_data)
str(pay_data)

# 데이터 설명
# 상품 유형: 식료품=1, 생필품=2, 의류=3, 잡화=4, 기타=5
# 지불 방법: 현금=1, 직불카드=2, 신용카드=3, 상품권=4

#     ex> user_id 기준으로 product_type을 wide하게 펼쳐보시오
wide <- dcast(pay_data, user_id ~ product_type, sum, na.rm=T)
head(wide)

#   5) 표본 추출: sample()
sample(c(1:10), 5, replace=F)  #> replace 비복원 추출(중복값x)
sample(c(10:50, 80:150, 160:190), 30)  #> 여러 개의 범위 지정하여 임의의 개수(30개) 출력
sample(c(1:10), 5, replace=T)  #> 복원추출(중복값 출력 가능)

#   6) 훈련용 데이터와 테스트용 데이터
#      훈련용과 테스트용 비율을 7:3
head(iris)

idx <- sample(1:nrow(iris), nrow(iris)*0.7)  #> nrow 행의 개수
str(idx)
training <- iris[idx,]
str(training)
head(training, 10)

testing <- iris[-idx,]  #> 훈련용 데이터를 제외한 나머지 데이터를 테스트용 데이터로 사용
head(testing)

#   7) 적합도 검정
#      K-folding cross validation
install.packages("cvTools")
library(cvTools)

name <- c("a", "b", "c", "d", "e", "f")
score <- c(90, 85, 60, 99, 100, 55)

df <- data.frame(Name=name, Score=score)
df

cross <- cvFolds(n=6, K=3, R=1, type="random")
    #> n: 관찰의 수 또는 데이터의 크기
    #> K: K겹 교차 검증
    #> R: 반복 횟수
cross

cross$which
cross$subsets

cross$subsets[cross$which==1, 1]  #> 4번째d와 3번째c 데이터가 첫번째 훈련에서의 검정용 데이터. 나머지는 테스트용 데이터
cross$subsets[cross$which==2, 1]  #> 6번째f와 5번째e 데이터가 두번째 훈련에서의 검정용 데이터. 나머지는 테스트용 데이터
cross$subsets[cross$which==3, 1]  #> 1번째a와 2번째b 데이터가 세번째 훈련에서의 검정용 데이터. 나머지는 테스트용 데이터

for(kfold in c(1:3)){
  data_idx <- cross$subsets[cross$which == kfold, 1]  #> 1은 반복횟수(R)
  cat("K=", kfold, "검정데이터\n")
  print(df[data_idx, ])
  
  cat("훈련 데이터\n")
  print(df[-data_idx, ])
}  
    #> K-fold 과정 시각화 코드

######################################################
##### MySQL 연동

# MySQL에 데이터베이스 및 테이블 준비

# CREATE DATABASE rtest;
# use rtest;
# CREATE TABLE tblScore(
#   id    int not null primary key,
#   class int(2) not null,
#   mat   int(3) default 0,
#   eng   int(3) default 0,
#   sci   int(3) default 0);

# insert into tblScore values(1, 1, 80, 70, 60);
# insert into tblScore values(2, 1, 88, 75, 60);
# insert into tblScore values(3, 2, 80, 50, 60);
# insert into tblScore values(4, 3, 83, 70, 62);
# insert into tblScore values(5, 5, 80, 70, 40);

install.packages("rJava")
install.packages("DBI")
install.packages("RMySQL")

#> update.packages() 패키지 최신 정보 업데이트

library(RMySQL)

#   1) DB 연결
conn <- dbConnect(MySQL(), dbname="rtest", user="root", password="1111", host="127.0.0.1")
conn

#   2) 테이블 목록 확인
print(dbListTables(conn))

#   3) 전체 레코드 조회
result <- dbGetQuery(conn, "select count(*) from tblscore")  #> select문 통해 조회 결과 얻는다. count(*) 통해 전체 갯수 확인
result

result <- dbGetQuery(conn, "select * from tblscore")  #> select문 통해 조회 결과 얻는다
result
class(result)

#   4) 테이블의 필드 목록
dbListFields(conn, "tblScore")

#   5) DML
dbSendQuery(conn, "delete from tblscore")

#   6) 파일로부터 데이터를 읽어들여 DB에 저장
score <- read.csv("C:/Users/acorn/hghbigdata/Rwork/BasicProject/data/score.csv", header=T)
score

dbSendQuery(conn, "drop table tblscore")
print(dbListTables(conn))

dbWriteTable(conn, "tblScore", score, overwrite=T, row.names=F)  #> dbwriteTable() 테이블 만드는 메서드. 읽어온 데이터 그대로 테이블 만든다
result <- dbGetQuery(conn, "select * from tblscore")
result

dbDisconnect(conn)  #> DB 접속 종료


##### sqldf(R+SQL)
detach("package:RMySQL", unload=T)  #> sqldf와 충돌하기 때문에 library(RMySQL) 제거

install.packages("sqldf")
library(sqldf)

head(iris)

sqldf("select * from iris limit 6")  # 변수명이 테이블명
sqldf("select * from iris order by Species limit 10")
sqldf("select sum('Sepal.Length') from iris")
sqldf('select max("Sepal.Length") from iris')
sqldf('select distinct Species from iris')

### 종별로 개수를 조회
sqldf('select Species, count(*) from iris group by Species')
