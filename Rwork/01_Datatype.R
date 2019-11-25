# 변수
######
goods = "냉장고"
goods


# 변수 사용시 객체 형태( . 이용하여 접근)로 사용 권장
# 모든 변수는 모든 데이터 타입 저장 가능(함수, 차트, 이미지, ...)
goods.name = "냉장고"
goods.code = 1000
goods.price = 1500000

goods.name


# 값을 대입할 때 = 대신 <- 사용
goods.name <- "냉장고"
goods.code <- 1000
goods.price <- 1500000

goods.price


# 스칼라 변수(1개의 값 갖는 벡터: 가장 기본적인 자료구조. character, numeric, ..)
class(goods.name)  #> class() 자료 타입 확인
class(goods.price)
mode(goods.name)  #> mode() 자료 타입 확인(class()와 유사)
mode(goods.code)


# 함수 도움말: help() 이용
help(sum)
?sum


# 함수의 파라미터(사용법): args() 이용
args(sum)


# 함수 예제: example() 이용
example(sum)

##################################################################################
# 데이터 타입
#############

# 1) 기본 자료형
#   숫자형: numeric
#   문자형: character
#   논리형: TRUE, FALSE, T, F
#   결측 데이터: NA, NaN

# 2) 자료형 확인: is.xxx()
#   is.numeric(), is.integer(), is.double()
#   is.logical(): 논리형
#   is.character()
#   is.data.frame(): 데이터 프레임
#   is.na(), is.nan(): 결측치
#   is.complex(): 복소수
#   is.factor(): 범주형 변수(카테고리를 가진 변수)

# 3) 자료형 변환: as.xxx()
#   확인과 동일 양식

# 4) 자료형 보기: class(), mode()

# 5) 명목형 자료형
#   순서가 없고 계산을 할 수 없는 자료형
#   factor: 카테고리별로 데이터 저장하기 위한 자료형

##################################################################################
# *자료 구조
###########

# 벡터(1차원), 매트릭스(2차원: 같은 형식 묶음), 데이터프레임(2차원: 다른 형식 묶음), 어레이(다차원: 같은 형식), 리스트(다차원: 다른 형식)

# 1) 벡터
#   - R에서 가장 기본이 되는 자료구조(스칼라 변수의 집합)
#   - 1차원 배열 데이터
#   - 변수[index]로 접근(인덱스는 1부터 시작)
#   - 동일한 자료형만 저장 가능(다른 형식의 데이터 있을 경우 자동으로 형 변환 이루어진다)
#   - 스칼라값을 벡터로 만드는 함수: c(), seq(), rep()

v <- c(1, 2, 3, 4)
class(v)

v
(v <- c(1, 2, 3, 4))  #> 변수 값 바로 출력하는 경우에는 ( )로 묶어준다

c(1:5)  #> 범위 지정: 순차적으로 값 생성
class(1:5)  #> 자동으로 벡터로 구성

class(c(1, 2, 3, "4"))  #> 문자형이 포함되었기 때문에 전체 문자형으로 벡터 구성(더 큰 범주의 데이터 형식으로 저장)
(c(1, 2, 3, 4.5))  #> 실수형으로 저장

?seq
seq(from=1, to=10, by=2)  #> 1부터 10까지 2씩 증가하며 생성  seq(1, 10, 2)

?rep
rep(1:3, 3)  #> 1부터 3까지 3번 복사하여 생성
rep(1:3, each=3)  #> 각각의 숫자들을 3번씩 반복

# 벡터를 이용한 처리
x <- c(1, 3, 5, 7)
y <- c(3, 5)

union(x, y); setdiff(x,y); intersect(x,y)  #> ; 이용해 코드 한 줄로 작성 가능

# 벡터의 컬럼명 지정(데이터 식별 용이)
age <- c(30, 35, 40)

names(age) <- c("홍길동", "임꺽정", "신돌석")
age

age <- NULL  #> 데이터 삭제
age

# 벡터의 접근
a <- c(1:50)
a[10:45]
a[10:(length(a)-5)]
a[10:length(a)-5]  #> 10:length 출력 후 앞뒤로 -5

b <- c(13, -5, 20:23, 12, -2:3)  #> 중간중간 범위 지정 가능
b
b[1]
b[c(2, 4)]  #> 2번째와 4번째 값 출력(한 개 이상의 값 표현할 때는 벡터로 표현)
b[c(4, 5:8, 7)]
b[-1]  
b[-3]  #> 해당 위치의 값 제외
b[-c(2:4)]

# factor
gender <- c("man", "woman", "woman", "man", "man")
class(gender)

plot(gender)  #> plot() 그래프 그리기 위한 함수. gender는 현재 그래프를 그릴 수 없는 형식(factor 통해 가능한 형식으로 전환 가능)

ngender <- as.factor(gender)
ngender  #> 자동으로 카테고리별로 묶어준다
class(ngender)

table(ngender)  #> table() 카테고리별 빈도 확인(factor타입으로 변경했기 때문)
is.factor(ngender)

plot(ngender)

?factor
ogender = factor(gender, levels=c("woman", "man"), ordered=T)  #> factor 만들기
ogender
plot(ogender)


# 2) 매트릭스(Matrix)
#   - 행과 열의 2차원 배열
#   - 동일한 데이터 타입만 저장 가능
#   - 생성 함수: matrix(), rbind(), cbind()

m <- matrix(c(1:5))  #> 열 기준으로 매트릭스 생성
m

m <- matrix(c(1:11), nrow=3)  #> nrow 옵션으로 행의 개수 지정
m

m <- matrix(c(1:11), nrow=3, byrow=T)  #> 행 기준으로 매트릭스 생성
m

class(m)  #> 객체 타입 표시
mode(m)  #> 데이터형식 표시

# 행과 열 합쳐 매트릭스 생성
x1 <- c(3, 4, 50:52)
x2 <- c(30, 5, 6:8, 8, 7)

mr <- rbind(x1, x2)  #> 두 벡터를 행 기준으로 합침
mr
class(mr)

mc <- cbind(x1, x2)  #> 열 기준으로 합침
mc

# 접근
mr[1,]  #> 행 접근. 위치 지정하지 않으면 모든 범위 출력
mr[,4]  #> 열 접근
mr[2, 3]
mr[2, 2:5]

# 처리 함수
x <- matrix(c(1:9), nrow=3, ncol=3)
x

length(x); ncol(x); nrow(x)

?apply
apply(x, MARGIN = 1, FUN = max)  #> 각 행에서 가장 큰 값 추출
apply(x, MARGIN = 2, FUN = max)  #> 각 열에서 가장 큰 값 추출
apply(x, MARGIN = 2, FUN = min)
apply(x, MARGIN = 1, FUN = mean)

# 이름 지정
colnames(x) <- c("one", "two", "three")
x


# 3) 데이터프레임(data.frame)
#   - 데이터베이스의 테이블과 유사
#   - R에서 가장 많이 사용하는 구조
#   - 컬럼 단위로 서로 다른 데이터 타입 사용 가능
#   - 생성 함수: data.frame(), read.table(), read.csv(), ...

# 벡터 이용하여 데이터프레임 생성
no <- c(1, 2, 3)
name <- c("hong", "lee", "kim")
pay <- c(150, 250, 300)

vemp = data.frame(No=no, Name=name, Payment=pay)  #> 컬럼명과 함께 데이터프레임 생성
vemp
class(vemp)

# 매트릭스 이용하여 데이터프레임 생성
m <- matrix(c(1, "hong", 150, 2, "lee", 250, 3, "kim", 300), 3, by=T)
m
memp <- data.frame(m)
memp
class(memp)

# 외부 파일 이용하여 데이터프레임 생성
txtemp <- read.table("C:/Users/acorn/hghbigdata/Rwork/BasicProject/data/emp.txt", header=T, sep="")
txtemp

getwd()  #> 현재 작업 위치 확인
setwd("C:/Users/acorn/hghbigdata/Rwork/BasicProject/data/")  #> 작업 경로 변경
getwd()

txtemp <- read.table("emp.txt", header=T, sep="")
txtemp
class(txtemp)

csvemp <- read.csv("emp.csv", header=T)
csvemp
class(csvemp)

csvemp2 <- read.csv("emp2.csv", header=F, col.names=c("사번", "이름", "급여"))  #> 제목을 만들어서 불러오기
csvemp2

# 접근
csvemp2$사번  #> 열 접근
class(csvemp2$사번)  #> 하나의 컬럼 = 벡터

csvemp2[,1]
class(csvemp2[,1])

csvemp2[2, 3]
csvemp2[1,]
class(csvemp2[c(1, 3), 2])  #> 외부파일로 불러온 데이터프레임의 문자열은 factor형으로 변환된다
csvemp2[-1, -2]

# 처리함수
str(csvemp)  #> str() 데이터 요약 정보 확인

csvemp <- read.csv("emp.csv", header=T, stringsAsFactors=F)  #> 외부 데이터 불러올 때 문자형을 factor로 변환하지 않고 그대로 불러온다
str(csvemp)

summary(csvemp)  #> 컬럼별 기초통계에 대한 수치 요약 확인

df <- data.frame(x=c(1:5), y=seq(2, 10, 2), z=c("a", "b", "c", "d", "e"))
df

apply(df[,c(1, 2)], 2, sum)  #> x열과 y열의 열 기준 합계
?apply

x1 <- subset(df, y>=6)  #> subset(data, 조건) 전체 데이터 중 일부분만 추출하여 별도의 데이터프레임 구성
x1

xyand <- subset(df, x>=2 & y<=6)
xyand

# 병합 merge()
height <- data.frame(id=c(1, 2), h=c(180, 175))
weight <- data.frame(id=c(1, 2), w=c(80, 85))

user <- merge(height, weight, by.x="id", by.y="id")  #> 같은 컬럼이면 by="id"
user


# 4) 어레이(array)
#   - 행, 열, 면의 3차원 이상 배열 형태의 객체 생성
#   - 생성함수: array()
#   - 같은 형식의 자료형만 묶어서 사용

vec <- c(1:12)
arr <- array(vec, c(3, 2, 2))  #> 순서: 행, 열, 면
arr

arr[,,2]  #> 두번째 면에 접근
arr[2, 2, 1]  #> 2행, 2열, 1면의 값인 5에 접근
arr[2, 1, 2]


# 5) 리스트(list)
#   - 다른 형식의 자료형도 묶어서 사용
#   - *key와 value가 한 쌍(python에서의 dict와 유사)
#   - 생성함수: list()
#   - 처리함수: unlist(), lapply(), sapply(), ...

a <- 1
x1 <- data.frame(var1=c(1:3), var2=c("a", "b", "c"))
x2 <- matrix(c(1:12), ncol=2)
x3 <- array(c(1:20), dim=c(2, 5, 2))

x4 <- list(f1=a, f2=x1, f3=x2, f4=x3)
x4

x4$f1

# 일차원 리스트
list1 <- list("lee", "이순신", 95)
list1  #> 다른 형식의 데이터들을 1차원으로 묶을 수 있다
class(list1)

# 처리함수
un <- unlist(list1)
un  #> 리스트 해제(벡터로)
class(un)  #> 전체 자료형이 character로 변환(가장 많은 자료형으로 전체 통일)

list2 <- list(id="lee", name="이순신", age=95)
list2
list2$id
list2[[1]]  #> 키 없을 경우 접근

# lapply(), sapply()  인자값으로 벡터 사용 가능
a <- list(c(1:5))
a
b <- list(6:10)  #> 생략해도 생성 가능(정확한 표현x)
b

c <- lapply(c(a, b), max)  #> 리스트로 출력
c
class(c)

d <- sapply(c(a, b), max)  #> 벡터로 출력
d
class(d)

e <- apply(c(a, b), max)  #> 인자값으로 matrix나 array로 값을 넘겨야 한다(벡터x)
e

##################################################################################
# 날짜형
########

a <- "19/09/15"
class(a)

b <- as.Date(a, "%y/%m/%d")
class(b)
b

Sys.time()  #> 현재 날짜+시간
Sys.Date()  #> 현재 날짜

##############################
# 문자열
########

# 문자열 처리 패키지 : stringr -> R 기본 기능x. 설치 필요
install.packages("stringr")  #> 설치 경로 확인: C:\Users\acorn\Documents\R\win-library\3.4
                             #> 삭제: remove.packages("패키지명")
                             #> 설치 패키지 불러오기: library(패키지명) 패키지 없을 경우 에러, require(패키지명) 패키지 없을 경우 경고
library(stringr)

str1 <- c("홍길동35이순신45유관순25")
str_extract(str1, "[1-9]{2}")  #> extract() 정규표현식과 매칭되는 값 중 첫번째 값 불러온다
str_extract_all(str1, "[1-9]{2}")  #> extract_all() 매칭 값 전체 불러온다
str_extract(str1, "\\d{2}")

str2 <- c("hongkd105leess1002you25강감찬2005")
str_extract_all(str2, "[a-z]{3}")  #> 세 자리 문자 추출
str_extract_all(str2, "[a-z]{3,}")  #> 세 자리 이상 문자 추출
str_extract_all(str2, "[a-zA-Z]{3,5}")  #> 세 자리에서 5자리 문자 추출
str_extract_all(str2, "[가-힣]{3,5}")  #> 3자리~5자리 한글 문자 추출
str_extract_all(str2, "[^a-z]")  #> 소문자 제외한 나머지 추출

str_length(str2)  #> 문자열 길이

str_locate(str2, "강감찬")  #> 문자열 위치

str_c(str2, "유비55")  # 문자열 추가

str3 <- c("hongkd105,leess1002,you25,강감찬2005")
str_split(str3, ",")
