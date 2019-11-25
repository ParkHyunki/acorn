# pearson
# spearman
# kendall

#ex> 부모의 키와 아이의 키는 관계가 있는가
install.packages("UsingR")
library(UsingR)

str(galton)
head(galton)

# 그래프 확인
plot(child~parent, data=galton)  #> 데이터값 반올림되어 나타남(데이터 중첩)
plot(jitter(child, 5) ~ jitter(parent, 5), data=galton)  #> 자연스러운 데이터 표현 위해 jitter() 사용
sunflowerplot(galton)  #> 중첩의 정도도 같이 표현

# pearson 상관분석
cor.test(galton$child, galton$parent)  #> 관계가 있다

# 단순 선형회귀 분석
out <- lm(child~parent, data=galton)
summary(out)

abline(out, col="red")  #> 그래프에 회귀선 추가


