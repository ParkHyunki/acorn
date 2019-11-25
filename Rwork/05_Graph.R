##### 기본 내장 그래프 
### plot()
# plot(y축 데이터, 옵션)
# plot(x축 데이터, y축 데이터, 옵션)

y <- c(1, 1, 2, 2, 3, 3, 4, 4, 5, 5)
plot(y)

x <- 1:10
y <- 1:10
plot(x, y)
plot(x, y, xlim=c(0, 20), ylim=c(0, 30), main="Graph", type="o")  #> lim 눈금선

x <- runif(100)
y <- runif(100)
plot(x, y, pch=ifelse(y>0.5, 1, 18))  #> pch 점의 모양

### barplot(), hist(), pie(), mosaicplot(), pairs(), persp(), contour(), ...

### 그래프 배열: 여러 개의 그래프 작성
head(mtcars)
?mtcars
str(mtcars)

#   1) 그래프 4개 작성
opar <- par(no.readonly=T)  #> 현재 설정 보관용: 여러 개 작성한 그래프의 설정을 초기화(그래프 하나 작성용 설정으로)하기 위함
par(mfrow=c(1, 1))  #> 다른 설정 초기화 방법

par(mfrow=(c(2, 2)))  #> 2행 2열짜리 그래프 4개 그리겠다

plot(mtcars$wt, mtcars$mpg)
plot(mtcars$wt, mtcars$disp)
hist(mtcars$wt)
boxplot(mtcars$wt)  #> 순차적으로 한 화면에 그래프 4개 작성

par(opar)  #> 설정 초기화

plot(mtcars$wt, mtcars$mpg)  #> 설정 초기화되었기 때문에 그래프 전체적으로 하나만 작성된다

#   2) 행 또는 열마다 그래프 개수 다르게 설정
?layout
layout(matrix(c(1, 2, 1, 3), 2, 2))  # 2행 2열의 크기이나 첫번째를 두 개 합침(1+1, 2, 3)

hist(mtcars$wt)
hist(mtcars$mpg)
hist(mtcars$disp)


par(mfrow=c(1, 1))

### 기본 내장 그래프들 중 특이한 그래프
#   1) arrows
x <- c(1, 3, 6, 8, 9)
y <- c(12, 56, 78, 32, 9)

plot(x, y)
arrows(3, 56, 1, 12)  #> 점의 방향 나타낸다: 시작점(3, 56), 끝점(1, 12)
text(4, 40, "이것은 샘플입니다", srt=55)  #> (4, 40) 위치에 텍스트 입력. srt= 회전각도

#   2) 꽃잎 그래프
x <- c(1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 4, 5, 6, 6, 6)
y <- c(2, 1, 4, 2, 3, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1)
plot(x, y)

z <- data.frame(x, y)
sunflowerplot(z)  #> 벡터가 아닌 데이터 프레임으로 넘겨야 한다. 산포도와 함께 두 변수(x,y)에 대한 빈도수 표현

#   3) 별 그래프
#     - 데이터의 전체적인 윤곽 확인
#     - 데이터 항목에 대한 변화의 정도 한눈에 파악

head(mtcars)

stars(mtcars[1:4], flip.labels = F, key.loc=c(13, 1.5), draw.segments = T)  
  #> 방향에 따른 강점 표현. flip.labels=F 간격 조절. key.loc=() 범례 표시=위치. draw.segments=T 나이팅게일 그래프로 표시

#   4) symbols
x <- c(1, 2, 3, 4, 5)
y <- c(2, 3, 4, 5, 6)
z <- c(10, 5, 100, 20, 10)

symbols(x, y, z)  #> 값의 크기를 원의 크기로 표현


##########################################################################################
##### ggplot2
install.packages("ggplot2")
library(ggplot2)

# 레이어로 구성
#   1단계: 배경 설정(눈금, 틀, ...)
#   2단계: 그래프 추가(점, 막대, 선, ...)
#   3단계: 설정 추가(축 범위, 범례, 색, 표식, ...)

# ggplot2 참고자료
# http://www.ggplot2-exts.org/gallery
# http://www.r-graph-gallery.com/portfolio/ggplot2-package/

#   1) 산포도
ggplot(data=mpg, aes(x=mpg$displ, y=mpg$hwy))  #> 기본 틀 준비: x축은 displ, y축은 hwy. 데이터는 이미 갖고 있다
ggplot(data=mpg, aes(x=mpg$displ, y=mpg$hwy)) + geom_point()  #> 나타낼 그래프 모양 추가
ggplot(data=mpg, aes(x=mpg$displ, y=mpg$hwy)) + geom_point() + xlim(3, 6) + ylim(10, 30)  #> x축과 y축 범위 조정 추가
ggplot(data=mpg, aes(x=mpg$displ, y=mpg$hwy)) + geom_line()
ggplot(data=mpg, aes(x=mpg$displ, y=mpg$hwy)) + geom_col()

#ex> mpg 데이터의 cty와 hwy 간의 관계 알아보고자 한다. x축은 cty, y축은 hwy로 된 산포도 작성
ggplot(data=mpg, aes(x=mpg$cty, y=mpg$hwy)) + geom_point()

#ex> 미국 지역 인구 통계를 담은 midwest 이용하여 전체 인구와 아시아인 인구 간의 관계 알아보고자 한다. x축은 전체 인구, y축은 아시아인 인구로 된 산포도 작성. 이 때 전체 인구는 50만명 이하, 아시아인 인구는 1만명 이하인 지역만 산점도에 표시
options(scipen=99)  #> 지수승을 숫자로 표시
library("dplyr")

midwest <- as.data.frame(ggplot2::midwest)
head(midwest)
str(midwest)

midwest_new <- midwest %>% filter(poptotal<=500000 | popasian<=10000)
midwest_new 

ggplot(data=midwest_new, aes(x=midwest_new$poptotal, y=midwest_new$popasian)) + geom_point()

ggplot(data=midwest, aes(x=midwest$poptotal, y=midwest$popasian)) + geom_point() + xlim(0, 500000) + ylim(0, 10000)  #> dplyr 사용x

#   2) 막대그래프
library("dplyr")

df_mpg <- mpg %>% group_by(drv) %>% summarise(mean_hwy=mean(hwy))  #> 구동방식별 고속도로 평균 연비

ggplot(data=df_mpg, aes(x=drv, y=mean_hwy)) + geom_col()  #> 두 변수의 빈도
ggplot(data=mpg, aes(x=drv)) + geom_bar()  #> 하나의 변수에 대한 빈도수
ggplot(data=mpg, aes(x=hwy)) + geom_bar()

#ex> 어떤 회사에서 생산한 suv 차종의 도시연비가 높은지 알아보려고 한다. suv 차종을 대상으로 평균 도시연비가 가장 높은 회사 5곳을 막대그래프로 표현
head(mpg)

mpg_top_cty <- mpg %>% group_by(manufacturer) %>% filter(class=="suv") %>% summarise(avg_cty=mean(cty)) %>% arrange(desc(avg_cty)) %>% head(5)
ggplot(data=mpg_top_cty, aes(x=reorder(mpg_top_cty$manufacturer, mpg_top_cty$avg_cty), y=mpg_top_cty$avg_cty)) + geom_col()
  #> reorder(x축, 정렬 기준) 통해 x축 정렬

#ex> 자동차 중에서 어떤 종류가 가장 많은지 알아보려고 한다. 자동차 종류별 빈도를 표현한 막대그래프를 그려보시오
head(mpg)

mpg_sum_class <- mpg %>% group_by(class) %>% summarise(sum_class=n())
ggplot(data=mpg_sum_class, aes(x=reorder(mpg_sum_class$class, mpg_sum_class$sum_class), y=sum_class)) + geom_col()

#   3) 선그래프
head(economics)
tail(economics)

# 데이터 설명
# psavert: 개인 저축률

ggplot(data=economics, aes(x=date, y=unemploy)) + geom_line()  #> 실업률에 대한 선그래프
ggplot(data=economics, aes(x=date, y=psavert)) + geom_line()

#   4) 상자그래프
ggplot(data=mpg, aes(drv, hwy)) + geom_boxplot()

#ex> class가 "compact", "subcompact", "suv"인 자동차의 cty가 어떻게 다른지 비교해보려고 한다. 세 차종의 cty를 나타낸 상그림을 그려보시오
table(mpg$class)

mpg_3class <- mpg %>% filter(class==c("compact", "suv", "subcompact"))
mpg_3class <- mpg %>% filter(class %in% c("compact", "suv", "subcompact"))  #> %in% 사용
ggplot(data=mpg_3class, aes(class, cty)) + geom_boxplot() 


###########################################################
### Special Graph
## 인터랙티브 그래프: 상호작용하여 움직이는 그래프(샘플 확인: https://plot.ly/ggplot2)
#   1) 산포도
install.packages("ggplot2")
library(ggplot2)
install.packages("dplyr")
library(dplyr)
install.packages("plotly")
library(plotly)

p <- ggplot(data=mpg, aes(displ, hwy, col=drv)) + geom_point()
p

ggplotly(p)

#   2) 막대그래프
p <- ggplot(data=diamonds, aes(x=cut, fill=clarity)) + geom_bar(position="dodge")  
  #> fillbar옵션으로 한 막대에 여러 정보 표현. position="dodge"로 여러 막대그래프로 나눠서 표현
p

ggplotly(p)

#   3) 시계열 그래프(dygraphs 패키지 이용)
install.packages("dygraphs")
library(dygraphs)
library(xts)

head(economics)

eco <- xts(economics$unemploy, order.by=economics$date)  #> dygraph로 그리기 위해 xts 타입으로 변환
head(eco)
class(eco)

dygraph(eco)
dygraph(eco) %>% dyRangeSelector()  #> 그래프 아래에 구간 제어판 표시

#   - 여러 값 동시에 표현
eco_a <- xts(economics$psavert, order.by=economics$date)
eco_b <- xts(economics$unemploy/1000, order.by=economics$date)

eco2 <- cbind(eco_a, eco_b)  #> cbind() 컬럼 기준으로 합치는 메서드
colnames(eco2) <- c("psavert", "unemploy")  #> 컬럼명 지정
head(eco2)

dygraph(eco2)

### 지도 그래프(단계 구분도: Choropleth Map)
# 지도 작성 위한 준비
install.packages("ggiraphExtra")
library(ggiraphExtra)

head(USArrests)
str(USArrests)

library(tibble)  #> data_frame을 좀더 빠르게 쓸 수 있다(data_frame과 같은 포맷)

crime <- rownames_to_column(USArrests, var="state")  #> 행 이름을 컬럼으로 바꿔준다(지도그래프 표현 위해 인덱스명을 컬럼명으로 바꿔야 한다)
head(crime)
str(crime)  #> factor형일 경우 바꿔야 한다

crime$state <- tolower(crime$state)  #> tolower() 이용해 state 컬럼의 값 모두 소문자로
head(crime)

install.packages("maps")  #> 지도 그리는 패키지 설치

states_map <- map_data("state")  #> ggplot 내 메서드. 지도 형식에 맞게 변환(위도, 경도의 값 가져온다)
head(states_map)
str(states_map)

packageurl <- "https://cran.r-project.org/bin/windows/contrib/3.5/mapproj_1.2.6.zip"
install.packages(packageurl, repos=NULL, type="source")    
  #> 필요 라이브러리 직접 다운받기 위함. 서버에 직접 연결하여 필요한 패키지 다운: mapproj 패키지 설치 위함

# 지도 작성
ggChoropleth(data=crime, aes(fill=Murder, map_id=state), map=states_map, interactive=T)

## 대한민국 지도
install.packages("devtools")  #> 다른 사이트의 패키지 자동 설치 가능

devtools::install_github("cardiomoon/kormaps2014")  #> github에 있는 패키지들 다운 가능 (아이디/?)
library(kormaps2014)

str(changeCode(kormap1))
str(changeCode(korpop1))  #> changeCode() 문자 코드 맞추기 위한 함수(utf-8을 한글 문자로 변환)
? changeCode

korpop1 <- rename(korpop1, pop=총인구_명, name=행정구역별_읍면동)

ggChoropleth(data=korpop1, aes(fill=pop, map_id=code, tooltip=name, map=kormap1, interactive=T))  #> tooltip= 풍선도움말

str(changeCode(tbc))
ggChoropleth(data=tbc, aes(fill=NewPts, map_id=code, tooltip=name, map=kormap1, interactive=T))

### 워드 클라우드
install.packages("rJava")
install.packages("memoise")
install.packages("KoNLP")  #> 한글처리 위한 패키지
library(KoNLP)

# 사전 설정
useNIADic()

# 데이터 불러오기
txt <- readLines("C:/Users/acorn/hghbigdata/Rwork/BasicProject/data/hiphop.txt")
head(txt)
class(txt)

# 특수문자 제거
library(stringr)  #> 문자열 처리 패키지
txt <- str_replace_all(txt, "\\W", " ")  #> 문자와 숫자 형태소 분리 위함

# 명사 추출
extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다")  #> extractNoun() 명사 추출 함수

nouns <- extractNoun(txt)
class(nouns)  #> 리스트 형식
nouns[1:10]

wordcount <- table(unlist(nouns))  #> 리스트가 아닌 벡터로 넘겨야 한다
wordcount[1:10]

df_word <- as.data.frame(wordcount, stringsAsFactors = F)  #> 워드클라우드는 데이터프레임 형식을 갖는다
tail(df_word)

# 변수명 수정
df_word <- rename(df_word, word=Var1, freq=Freq)

# 두 글자 이상의 단어만 추출
df_word <- filter(df_word, nchar(word)>=2)  #> nchar() 단어 개수 확인
tail(df_word)

# 빈도수 상위 20개의 단어들
top20 <- df_word %>% arrange(desc(freq)) %>% head(20)
top20

# wordcloud로 출력
install.packages("wordcloud")
library(wordcloud)
library(RColorBrewer)

# 색상 선택
pal <- brewer.pal(8, "Dark2")

# 난수 고정
set.seed(1234)

# 워드클라우드 출력
wordcloud(words=df_word$word, freq=df_word$freq, min.freq=2, max.freq=200, random.order=F, colors=pal, scale=c(4, 0.3))  
  #> random.order=F 자주 등장하는 단어 가운데로(T: 순서 상관없이 배열)
