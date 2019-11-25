# 난수 발생
x <- runif(1)  #> 0~1의 균일분포 중 1개 추출, rnorm() 정규분포에서 난수 발생
x


############################################################################
# 조건문
########

# 1) if문: x가 0보다 크면 절대값을 화면에 출력
if(x>0){
   print(abs(x))
}  #> 조건문: {}로 묶는다(들여쓰기 필요x)
   #> abs() 절대값 함수

if(x>0) print(abs(x))  #> 한 문장일 경우에는 한 줄로 작성 가능

# 2) if-else문: x가 0.5보다 작으면 1-x를 출력하고, 그렇지 않으면 x를 출력
if(x<0.5){
  print(1-x)
}else{
  print(x)
}  #> else는 중괄호 옆에 선언해야 한다

if(x<0.5) print(1-x) else print(x)  #> 실행할 문장이 한 문장일 경우, 한 줄로 작성 가능

ifelse(x<0.5, 1-x, x)  #> ifelse(조건, 참, 거짓) 실행할 문장이 한 문장일 경우 쓸 수 있는 함수

# 3) 다중 조건
point <- scan()

if(point>=90){
  print("A")
}else if(point>=80){
  print("B")
}else if(point>=70){
  print("C")
}else if(point>=60){
  print("D")
}else{print("F")}  #> else if


# switch(비교구문, 실행구문1, 실행구문2, ..)
a <- "중1"
switch(a, "중1"=print("14살"), "중2"=print("15살"))  #> 같다는 조건에서만 사용 가능(이상, 이하 조건 사용x)
switch(a, "중1"="14살", "중2"="15살")

b <- 3  #> 순서(인덱스)로 인식
switch(b, "14살", "15살", "16살")

avg <- 78 %/% 10  #> 10으로 나눈 정수 출력
switch(as.character(avg), "10"="A", "9"="A", "8"="B", "7"="C", "6"="D", "F")  #> 몫을 통해 학점 평가
  #> 정수형은 인덱스로 처리되기 때문에 avg를 문자로 변환

# which() 해당 값의 위치 확인
letters = c("a", "b", "c", "d", "e", "f", "g")
which(letters == "c")  #> "c"의 위치 확인

mtx <- matrix(1:16, 4, 4)
mtx

which(mtx %% 4 == 0, arr.ind=F)  #> 각각의 값을 4로 나누었을 때 나머지가 0인 값 출력
which(mtx %% 4 == 0, arr.ind=T)  #> 인덱스 사용

# any(), all()
x <- runif(5)
x

#ex> x 중에 0.9 이상이 있는가?
any(x>=0.6)  #> 하나라도 조건에 만족하는 값이 있다면 True 출력

#ex> x의 값이 모두 0.9 이하인가?
all(x<0.9)


###################################
# 반복문: for, while, repeat
########

sum <- 0
for(i in seq(1, 10)){
  sum <- sum+i
}
sum

sum <- 0
for(i in seq(1, 10)) sum <- sum+i
sum

#ex> 구구단 입력 받기
print("단을 입력")
dan <- scan()
for(i in seq(1, 9)){
  cat(dan, "x", i, "=", dan*i, "\n")
}

dan <- readline("단을 입력: ")  # 실행하면 바로 Console에서 입력 가능하도록
dan <- as.integer(dan)  #> 문자로 입력받은 값을 숫자로 변환
for(i in seq(1, 9)){
  cat(dan, "x", i, "=", dan*i, "\n")
}

# 중첩 반복문
for(i in seq(2, 9)){
  cat("\n====", i, "단====\n")
  
  for(j in seq(1, 9)){
    cat(i, "x", j, "=", i*j, "\n")
  }
}

# while
sum <- 0
cnt <- 1
while(cnt<=10){
  sum <- sum + cnt
  cnt <- cnt + 1
}
sum

# repeat : 최소 한 번 이상의 반복 보장
sum <- 0
cnt <- 1
repeat{
  sum <- sum + cnt
  cnt <- cnt + 1
  
  if(cnt>10){
    break
  }
}  #> 조건x. 중괄호에 있는 내용 무조건 반복(끝나는 조건 필요)
sum


#############################################################
# 함수
######

# 인자 없는 함수
test1 <- function(){
  x <- 10
  y <- 10
  return (x*y)
}
test1()

# 인자 있는 함수
test2 <- function(x, y){
  xx <- x
  yy <- y
  return (sum(xx, yy))
}
test2(10, 5)
test2(y=5, x=10)

# 가변인수: 인자의 형식과 개수가 정해져 있지 않은 경우
test3 <- function(...){
  args <- list(...)
  for(i in args){
    print(i)
  }
}    #> 타입이 정해져 있지 않기 때문에 list로 변환해야 한다

test3(3, 4)
test3(1, 5, 9, 20)
test3("3", "홍길동", "7")

test4 <- function(a, b, ...){
  print(a)
  print(b)
  test3(...)
}

test4(10, 20, 30, 40, 50)

# 중첩 함수
test5 <- function(x, y){
  print(x)
  
  test6 <- function(y){
    y+1
  }
  test6(y)
}

test5(10, 20)

#################################
# 기술 통계량 처리 관련 내장함수
# min(), max()
# range() 벡터를 대상으로 범위값을 구하는 함수(최대값 - 최소값)
# mean(), median()
# sum()
# sort() 벡터 데이터 정렬(단, 원본 값 변경x)
# order() 정렬된 값의 인덱스를 보여주는 함수
# rank()
# sd() 표준편차
# summary() 기초 통계값 전체 요약
# table() 빈도수
#########

getwd()
test <- read.csv("test.csv", header=T)
head(test)

summary(test)
table(test$A)  #> A 컬럼 값의 총 빈도수

# 한 번의 함수 호출로 다수의 컬럼에 대한 통계량 계산하는 기능
# 각 컬럼 단위로 빈도와 최대값/최소값 계산 함수 정의
data_proc <- function(df){
  for(idx in 1:length(df)){
    cat(idx, "번째 컬럼의 빈도분석 결과")
    print(table(df[idx]))
    cat("\n")
  }
  for(idx in 1:length(df)){
    f <- table(df[idx])
    cat(idx, "번째 컬럼의 최대/최소값 분석 결과")
    cat("max=", max(f), "min=", min(f), "\n")
  }
}

data_proc(test)

# 결측치 처리
data <- c(10, 20, 5, 4, 40, 7, NA, 6, 3, NA, 2, NA)

my_na <- function(vec){
  #> 1차: 결측치 제거하고 평균 계산
  print(mean(vec))
  print(mean(vec, na.rm=T))  #> na.rm=True 결측치 제거 옵션
  
  #> 2차: 결측치 0으로 대체하고 평균 계산
  data <- ifelse(is.na(vec), 0, vec)  #> is.na 결측치 확인 메서드
  print(mean(data))
  
  #> 3차: 결측치 평균으로 대체하고 평균 계산
  data2 <- ifelse(!is.na(vec), vec, round(mean(vec, na.rm=T), 2))  #> !is.na() 결측값이 아니라면. 
  print(mean(data2))
}

my_na(data)
