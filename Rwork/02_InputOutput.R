# 키보드 입력 : scan() 벡터 단위로 입력, edit() 데이터프레임으로 입력
#############

# 숫자 입력
a <- scan()  #> 밑의  Consle에서 입력. 공백 입력하면 입력 종료
a
class(a)  #> 외부입력을 했음에도 숫자형으로 인식

# 문자 입력
b <- scan(what="")  #> what=character() 해야 문자 입력 가능(기본은 숫자만 입력)
b
class(b)

df <- data.frame()
df <- edit(df)
df

##################
# read.table : 특별한 형식이 없는 파일 읽어올 때
############

getwd()  #> 현재 위치 확인
setwd("C:/Users/acorn/hghbigdata/Rwork/BasicProject/data")  #> 기본 경로 지정

student <- read.table("student.txt")  
student
names(student) <- c("번호", "이름", "키", "몸무게")  #> 파일의 컬럼에 이름 부여
student

student1 <- read.table(file="student1.txt", header=T)  #> header=T 통해 제목을 가져온다(첫번째 행은 제목이다)
student1

student1 <- read.table(file.choose(), header=T)  #> file.choose() 파일 직접 선택 가능하도록 다이얼로그 띄운다
student1

student2 <- read.table(file="student2.txt", header=T, sep=";")  #> sep= 구분자 지정
student2

student3 <- read.table(file="student3.txt", header=T, sep="", na.strings=c("-", "+", "&"))  #> 결측치 표시(표현 통일: NA)
student3

####################
# read.xlsx : 엑셀 파일 불러오기
# 패키지 설치 필요(기본적으로 Java가 설치되어 있어야 한다+path설정(JAVA_HOME : 자바 설치 경로))
#############

install.packages("xlsx")

library(rJava)
library(xlsx)

studentx <- read.xlsx(file.choose(), sheetIndex=1, encoding="UTF-8")
studentx

##################
# read.csv
##########


##################
# 웹문서 읽어오기
# 패키지 설치 필요
#########

install.packages("httr")
install.packages("XML")

library(httr)
library(XML)

url <- "http://ssti.org/blog/useful-stats-capita-personal-income-state-2010-2015"
get_url <- GET(url)  #> 웹페이지 전체의 정보 가져온다
get_url

html_content <- readHTMLTable(rawToChar(get_url$content), stringsAsFactors=F)  
  #> readHTMLTable() 테이블에 해당하는 모든 것 읽어온다(원하는 테이블과 가장 가까운 상위 태그 지정)
  #> rawToChar() 문자형으로 변환하여 불러와야 한다
  #> stringsAsFactors=F 외부 데이터 불러올 때 factor 형식으로 불러오지 않는다(기본=factor)
html_content
str(html_content)  #> 요약정보 확인

df = as.data.frame(html_content)  #> 데이터프레임화
df
class(df)

#####################################################################################################

# 화면 출력 : 변수명, (문장), cat() 서로 다른 형식을 한번에 출력, print() 같은 형식만 출력 가능
###########

x <- 10
y <- 20
z <- x*y

z

(z <- x*y)

cat("x*y의 결과는", z, "입니다")  #> 문자+숫자 출력

print(z)  # 숫자만 출력
print(x*y)

##########
# sink()
#####

getwd()

data()  #> R에서 제공하는 샘플들 확인
?data

data(iris)
head(iris)  #> 상위 6개 출력

sink("iris.txt")  #> 선언 후 작업하는 모든 내용 파일로 저장(화면 출력x)
head(iris)
tail(iris)
str(iris)
sink()  #> 재선언: sink 작업 종료

head(iris)

##########
# write.table(), write.csv() : 저장
########

studentx <- read.xlsx(file.choose(), sheetIndex=1, encoding="UTF-8")
studentx
class(studentx)

write.table(studentx, "stud1.txt")  #> 일반 파일로 저장
write.table(studentx, "stud2.txt", row.names = F)  #> row.names=F 행 이름(인덱스) 생략
write.table(studentx, "stud3.txt", row.names = F, quote=F)  #> quote=F 쌍따옴표 생략

write.csv(studentx, "stud5.csv", row.names=F, quote=F)  #> csv파일로 저장( ,로 구분)

##############
# write.xlsx()
# xlsx 패키지 설치 필요
########

library("xlsx")
write.xlsx(studentx, "stud4.xlsx")  #> 엑셀 파일로 저장

##############
# save(), load() : rda 파일(2진 파일-대량의 파일 빠른 속도로 처리 가능)을 처리할 때 주로 사용
#######

save(studentx, file="stud6.rda")  #> 2진 파일로 저장

rm(studentx)  #> 메모리상에서 studentx 삭제
studentx

load("stud6.rda")  #> save에 사용했던 변수에 그대로 불러온다
studentx