##### plyr , dplyr  #> python의 pandas와 기능 유사

### plyr 데이터 처리 위한 기본 패키지
install.packages("plyr")
library(plyr)

## 데이터 병합: join()
x <- data.frame(id=c(1, 2, 3, 4, 5, 6), height=c(160, 175, 176, 188, 163, 170))
y <- data.frame(id=c(5, 3, 1, 4, 2, 7), weight=c(40, 91, 70, 82, 54, 72))

xy <- join(x, y, by="id", type="left")  #> left outerjoin과 유사
xy

xy <- join(x, y, by="id", type="right")  #> right outerjoin과 유사
xy

xy <- join(x, y, by="id", type="inner")  #> innerjoin과 유사
xy

xy <- join(x, y, by="id", type="full")  #> full outerjoin과 유사
xy

## 다중 키 병합
x <- data.frame(key1=c(1, 1, 2, 2, 3), key2=c('a', 'b', 'c', 'd', 'e'),
                val=c(10, 20 , 30, 40, 50))
y <- data.frame(key1=c(3, 2, 2, 1, 1), key2=c('e', 'd', 'c', 'b', 'a'),
                val=c(500, 400 , 300, 200, 100))

xy <- join(x, y, by=c("key1", "key2"))
xy

## 기술통계량: tapply() 집단변수를 대상으로 한번에 하나의 통계치 구할 때 사용, ddply() 한번에 여러 개의 통계치 구할 때 사용
head(iris)
unique(iris$Species)  #> unique() 메서드 통해 품종 확인

tapply(iris$Sepal.Length, iris$Species, mean)  #> 품종별 꽃받침 길이에 대한 평균 확인(그룹별로 통계치 확인)
tapply(iris$Sepal.Length, iris$Species, sd)  #> 표준편차

ddply(iris, .(Species), summarise, avg=mean(Sepal.Length))  #> .(Sepices) 품종에 대한 전체 데이터 접근
                                                            #> 여러 통계치 출력하기 때문에 summarise 옵션. 변수명=구하려는 통계치
ddply(iris, .(Species), summarise, avg=mean(Sepal.Length), std=sd(Sepal.Length), max=max(Sepal.Length), min=min(Sepal.Length))

### dplyr plyr보완
install.packages("dplyr")
help(package=dplyr)

# filter() 행 추출 -> subset()
# select() 열(컬럼) 추출 -> data[, c("열 이름", "열 이름")]
# arrange() 정렬 -> order(), sort()
# mutate() 열 추가 -> transform()
# summarise() 통계치 산출 -> aggregate()
# group_by() 집단별로 나눔
# left_join() 데이터 합치기(열 기준)
# bind_rows() 데이터 합치기(행 기준)

getwd()
setwd("C:/Users/acorn/hghbigdata/Rwork/BasicProject/data")

exam <- read.csv("csv_exam.csv")
exam

## filter() 행 추출
#ex> 1반 학생들의 데이터만 추출
exam[exam$class==1, ]  #> 기본 문법
exam %>% filter(class==1)  # 체인 기법을 이용한 filter() 메서드 사용. 이미 앞의 정보를 가져왔기 때문에 다시 쓸 필요x

#ex> 2반이면서 영어 점수가 80점 이상인 학생들의 데이터만 추출
exam[exam$class==2 & exam$english>=80,]
exam %>% filter(class==2 & english>=80)

#ex> 1, 3, 5반에 해당하는 데이터만 추출
exam %>% filter(class==1 | class==3 | class==5)
exam %>% filter(class %in% c(1, 3, 5))

## select() 열 추출
#ex> 수학 점수만 추출
exam %>% select(math)

#ex> 반, 수학, 영어 데이터 추출
exam %>% select(class, math, english)

#ex> 수학점수 제외한 나머지 열만 추출
exam %>% select(-math) %>% head(10)  #> - 이용해 math 제외. head 이용해 일부만 추출

#ex> 1반 학생들의 수학점수 추출
exam %>% filter(class==1) %>% select(math)

## arrange() 정렬
exam %>% arrange(math)  #> 기본 오름차순 정렬
exam %>% arrange(desc(math))  #> desc() 이용해 내림차순 정렬
exam %>% arrange(class, math)  #> 2차 정렬

## mutate() 열 추가
exam$sum <- exam$math+exam$english+exam$science  #> 기본문법
head(exam)

exam %>%
  mutate(total=math+english+science, avg=(math+english+science)/3) %>%
  head

## summarise() 통계치 산출
exam %>% summarise(avg_math=mean(math))  #> 원하는 통계치 값만 출력

## group_by() 그룹별로 나눈 후 계산
exam %>% group_by(class) %>%
  summarise(avg_math=mean(math), sum_math=sum(math), median_math=median(math), n=n())  #> n() 전체 개수

## left_join() 열 기준 데이터 결합
test1 <- data.frame(id=c(1, 2, 3, 4, 5), midterm=c(60, 70, 80, 90, 85))
test2 <- data.frame(id=c(1, 2, 3, 4, 5), midterm=c(70, 83, 95, 55, 20))

total <- left_join(test1, test2, by="id")
total

name <- data.frame(class=c(1, 2, 3, 4, 5), teacher=c("kim", "lee", "park", "choi", "jung"))
exam_new <- left_join(exam, name, by="class")
head(exam_new, 10)

## bind_rows() 행 기준 데이터 결합
group1 <- data.frame(id=c(1, 2, 3, 4, 5), test=c(60, 70, 80, 90, 85))
group2 <- data.frame(id=c(6, 7, 8, 9, 10), test=c(100, 91, 65, 77, 83))

group_all <- bind_rows(group1, group2)
group_all


#####ex> 실습1
install.packages("ggplot2")
library(ggplot2)

str(ggplot2::mpg)  #> :: 샘플 데이터 접근
class(ggplot2::mpg)

mpg <- as.data.frame(ggplot2::mpg)  #> 쉽게 다루기 위해 데이터 전체 data.frame화
class(mpg)
head(mpg)

### 1. 데이터 파악
head(mpg)
tail(mpg)
names(mpg)  #> 컬럼 이름 확인(특성 파악)
class(mpg)
dim(mpg)  #> 총 데이터 개수와 컬럼 개수
str(mpg)  #> 전체 데이터 요약정보
View(mpg)  #> 별도의 스크립트에 엑셀처럼 출력

### 2. 기초 통계량
# mean(), median(), var(), sd(), max(), min(), quantile() 사분위수, summary()

### 3. 기본 시각화
boxplot(mpg$displ)
hist(mpg$displ)
plot(mpg$displ)  #> 산포도

#ex> 배기량(displ)이 4 이하인 차량 추출
mpg %>% filter(displ<=4)

filter(mpg, displ<=4)
select(filter(mpg, displ<=4), model, displ, year)  #> select() 이용해 원하는 컬럼만 선택하여 추출

#ex> 통합연비 파생변수 만들고, 통합연비로 내림차순 정렬 후, 3개의 행만 출력(통합연비total = 도시연비cty + 고속도로연비hwy)
mpg %>% mutate(total=cty+hwy) %>% arrange(desc(total)) %>% head(3)

mpg$total <- (mpg$cty + mpg$hwy)/2

#ex> 회사별로 "suv" 자동차의 도시 및 고속도로 통합연비 평균을 구해 내림차순 정렬 후, 1위~5위 출력
mpg %>% group_by(manufacturer)%>% filter(class=="suv") %>% mutate(total=(cty+hwy)/2) %>% arrange(desc(total)) %>% head(5)

#ex> 어떤 회사 자동차의 고속도로 연비가 가장 높은지 알아보려고 한다. hwy 평균이 가장 높은 회사 3곳 출력
mpg %>% group_by(manufacturer) %>% summarise(hwy_avg=mean(hwy)) %>% arrange(desc(hwy_avg)) %>% head(3)

#ex> 어떤 회사에서 compact(경차) 차종을 가장 많이 생산하는지 알아보려고 한다. 각 회사별 "compact" 차종 수를 내림차순으로 정렬하여 출력
mpg %>% group_by(manufacturer) %>% filter(class=="compact") %>% summarise(sum_compact=n()) %>% arrange(desc(sum_compact))

#ex> 연료별 가격을 구해서 새로운 데이터프레임(fuel) 만든 후 기존 데이터프레임에 병합하여 출력
#    (c:CNG=2.35, d:Dise=2.38, e:ethanol=2.11, p:Premium=2.76, r:Regular=2.22)
unique(mpg$fl)  #> fl 종류 확인

fuel <- data.frame(fl=c("c", "d", "e", "p", "r"), fl_price=c(2.35, 2.38, 2.11, 2.76, 2.22), stringsAsFactors=F)  #> 문자열 그대로 불러온다
fuel

mpg_fuel <- left_join(mpg, fuel, by="fl")
mpg_fuel

#ex> 연비의 기준치를 통해 합격(pass)/불합격(fail)을 부여하는 파생변수 test 생성. 이 때 기준은 20
mpg_test <- mpg %>% mutate(total=(cty+hwy)/2)
mpg_test

mpg_test_result <- mpg_test %>% mutate(test=ifelse(total>=20, "pass", "fail"))
mpg_test_result

mpg$test <- ifelse(mpg$total>=20, "pass", "fail")  #> mpg에 total 컬럼 있는 경우
mpg

#ex> test에 대해 합격과 불합격 받은 자동차의 수량
table(mpg$test)

#ex> 통합연비 등급을 A, B, C 세 등급으로 나누는 파생변수 grade 추가(30이상이면 A, 20이상이면 B, 20미만이면 C로 분류)
mpg$grade <- ifelse(mpg$total>=30, "A", ifelse(mpg$total>=20, "B", "C"))
table(mpg$grade)
head(mpg)


#####ex> **시험? 실습2. 미국 동북중부 437개 지역의 인구 통계 정보를 담은 데이터
midwest <- as.data.frame(ggplot2::midwest)
head(midwest)
str(midwest)

#ex> 전체 인구 대비 미성년 인구(전체인구poptotal - 성인인구popadults) 백분율을 파생변수 ratio_child 로 추가
midwest <- midwest %>% mutate(ratio_child=(poptotal-popadults)/poptotal*100)
midwest

#ex> 미성년 인구 백분율이 가장 높은 상위 5개 지역 출력
midwest %>% arrange(desc(ratio_child)) %>% select(county, state, ratio_child) %>% head(5)

#ex> 분류표의 기준에 따라 미성년 비율 등급 변수 grade 를 추가하고, 각 등급에 몇 개의 지역이 있는지 확인
#    미성년 인구 백분율 등급이 40이상이면 "large", 30이상이면 "middle", 그렇지 않으면 "small"
midwest$grade <- ifelse(midwest$ratio_child>=40, "large", ifelse(midwest$ratio_child>=30, "middle", "small"))
midwest %>% select(ratio_child, grade) %>% head()

#ex> 전체 인구 대비 아시아인 인구 백분율을 파생변수 ratio_asian 로 추가하고, 하위 10개 지역의 state, county, 아시아인 인구 백분율 출력
midwest$ratio_asian <- (midwest$poptotal-midwest$popasian)/midwest$poptotal*100
midwest %>% arrange(ratio_asian) %>% select(state, county, ratio_asian) %>% head(10)
