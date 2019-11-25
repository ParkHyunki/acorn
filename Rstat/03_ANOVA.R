###### ANOVA 전제조건: 연속변수 + 정규분포 + 등분산
# - 연속변수가 아닌 경우 Kruskal-wallis H test 알고리즘 사용
# - 정규분포가 아닌 경우 Kruskal-wallis H test 알고리즘 사용
# - 등분산이 아닌 경우 welch's anova 알고리즘 사용
# - 어떤 집단과 차이가 발생했는지 확인(사후검정) Tukey 알고리즘 사용

###### One Way ANOVA

View(acs)
# 종속변수(결과변수) = Dx(진단결과): STEMI(심근경색), NSTEMI(심근경색x), Unstable Angina(불완전한 심근경색)
#ex> LDLC에 따라서 Dx가 어떻게 나타날까
library(moonBook)

# 정규분포 확인
moonBook::densityplot(LDLC ~ Dx, data=acs)  #> moonBook 패키지의 densityplot() 통해 그래프로 확인

shapiro.test(acs$LDLC[acs$Dx=="NSTEMI"])  #> 정규분포x
shapiro.test(acs$LDLC[acs$Dx=="STEMI"])  #> 정규분포
shapiro.test(acs$LDLC[acs$Dx=="Unstable Angina"])  #> 정규분포x


out <- aov(LDLC~Dx, data=acs)  #> aov() ANOVA 함수
shapiro.test(resid(out))  #> risid() 잔차값 구하는 함수
  #> 정규분포x

# 등분산 확인
bartlett.test(LDLC~Dx, data=acs)  #> 등분산

# 정규분포, 등분산일 경우: aov() 사용
out <- aov(LDLC~Dx, data=acs)
summary(out)

# 연속변수가 아니거나, 정규분포가 아닌 경우: kruskal.test() 사용
kruskal.test(LDLC~Dx, data=acs)  # 대립가설 참: LDLC에 따라 Dx 차이는 의미가 있다
class(acs$Dx)

# 연속변수이고 정규분포인데, 등분산이 아닌 경우: oneway.test() 사용(welch's anova 알고리즘)
oneway.test(LDLC~Dx, data=acs, var.equal=F)  #> equal=F 등분산이 아니다


##### 사후 검정
# aov() 사용시 사후 검정: TukeyHSD()
TukeyHSD(out)  #> p adj >= 0.5 차이가 없다(귀무가설 참)

# Kruskal.test() 사용시 사후 검정
str(InsectSprays)  #> 사후검정용 샘플 데이터셋
View(InsectSprays)

moonBook::densityplot(count~spray, data=InsectSprays)

install.packages("userfriendlyscience") 
library(userfriendlyscience)

posthocTGH(InsectSprays$spray, y=InsectSprays$count, method="games-howell")  #> 그룹 간 차이 전체적으로 비교(차이의 의미가 있나 없나)

# oneway.test() 사용시 사후 검정
install.packages("nparcomp")
library(nparcomp)

result <- mctp(LDLC~Dx, data=acs)
summary(result)  #> p.Value 통해 그룹 간 차이 비교

###############
#ex> 품종에 따라서 Sepal.Width의 평균 차이
head(iris)

# 정규분포인가?
out <- aov(Sepal.Width ~ Species, data=iris)
shapiro.test(resid(out))  #> 귀무가설 참. 정규분포

# 등분산인가?
bartlett.test(Sepal.Width~Species, data=iris)  #> 귀무가설 참. 등분산

# ANOVA 분석
summary(out)  #> Pr(>F) < 0.05 이므로 품종에 따라 차이가 있다

# 사후검정
TukeyHSD(out)  #> 모든 종류가 차이가 있다

#############
#ex> 시군구에 따라 합계 출산율의 차이
mydata <- read.csv("C:/Users/acorn/hghbigdata/Rwork/BasicProject/stat/data/anova_one_way.csv")
mydata

# 정규분포인가
out <- aov(birth_rate ~ ad_layer, data=mydata)
shapiro.test(resid(out))  #> 정규분포가 아니다

# 등분산인가
bartlett.test(birth_rate~ad_layer, data=mydata)  #> 등분산이 아니다

# ANOVA 분석
kruskal.test(birth_rate~ad_layer, data=mydata)  #> 대립가설 참. 차이가 있다

# 사후검정
table(mydata$ad_layer)
class(mydata$ad_layer)  #> factor형이므로 posthocTGH() 사용 가능

library(userfriendlyscience)
posthocTGH(x=mydata$ad_layer, y=mydata$birth_rate, method="games-howell")  #> 시군구 모두 차이가 있다(시와 군 차이가 비교적 약하다)

#########################################################################
#########################################################################

###### Two Way ANOVA

#ex> 다자녀 지원 조례 채택 여부에 따른 시군구의 출산율 차이
mydata <- read.csv("C:/Users/acorn/hghbigdata/Rwork/BasicProject/stat/data/anova_two_way.csv")
mydata

# 데이터셋 설명
# multichild 다자녀 지원 조례 채택 여부

out <- aov(birth_rate ~ ad_layer + multichild + ad_layer:multichild, data=mydata)
summary(out)  #> 다자녀 지원 조례 채택과 시군구는 차이가 있다(약한 관계)

TukeyHSD(out)

###### (One Way) Repeated Measures ANOVA

#ex> 시간 경과에 따른 점수의 차이
mydata <- read.csv("C:/Users/acorn/hghbigdata/Rwork/BasicProject/stat/data/onewaySample.csv")
head(mydata)
str(mydata)

avg <- c(mean(mydata$score0), mean(mydata$score1), mean(mydata$score3), mean(mydata$score6))  #> 시점별 평균 점수
avg

# 그래프로 시간에 따른 평균 점수 변화 확인
plot(avg)  #> 음의 상관관계 나타난다
plot(avg, type="l")  #> type="l" 점을 선으로 표시
plot(avg, type="o")  #> type="o" 선에 점 표시
plot(avg, type="o", lty=2)  #> lty= 선 모양 변경
plot(avg, type="o", lty=2, col=2)  #> col= 색상 변경
plot(avg, type="o", lty=2, col=2, xlab="month", ylab="score", main="One Way Test")  #> 제목 추가

# 데이터 wide -> long형으로 변환
library(tidyr)
mydata_long <- gather(mydata, key="id", value="score")
mydata_long
mydata_long <- mydata_long[8:35, ]
mydata_long

# 정규분포 확인
out <- aov(score ~ id, data=mydata_long)
shapiro.test(resid(out))  #> 정규분포
 
# ANOVA 분석
summary(out)  #> 차이가 있다

# 사후검정
TukeyHSD(out)

# 본페르니 사후검정 방식: 시점의 개수에 다른 유의수준 범위
0.05/4  #> 유의수준 0.0125 범위에서 확인 필요

#############################################
#############################################

### 정규분포or연속변수가 아닌 경우
# t-test : MWW or wilcoxen rank sum t-test 알고리즘 사용
# paired t-test : wilcoxen sign rank t-test 알고리즘 사용
# one way repeated measures anova : friedman test 알고리즘 사용

### 등분산이 아닌 경우
# t-test : welch's t-test 알고리즘 사용
# anova : welch's anova 알고리즘 사용

##### One Way repeated measures anova

?friedman.test
RoundingTimes <-
  matrix(c(5.40, 5.50, 5.55,
           5.85, 5.70, 5.75,
           5.20, 5.60, 5.50,
           5.55, 5.50, 5.40,
           5.90, 5.85, 5.70,
           5.45, 5.55, 5.60,
           5.40, 5.40, 5.35,
           5.45, 5.50, 5.35,
           5.25, 5.15, 5.00,
           5.85, 5.80, 5.70,
           5.25, 5.20, 5.10,
           5.65, 5.55, 5.45,
           5.60, 5.35, 5.45,
           5.05, 5.00, 4.95,
           5.50, 5.50, 5.40,
           5.45, 5.55, 5.50,
           5.55, 5.55, 5.35,
           5.45, 5.50, 5.55,
           5.50, 5.45, 5.25,
           5.65, 5.60, 5.40,
           5.70, 5.65, 5.55,
           6.30, 6.30, 6.25),
         nrow = 22,
         byrow = TRUE,
         dimnames = list(1 : 22,
                         c("Round Out", "Narrow Angle", "Wide Angle")))
RoundingTimes

# wide -> long
install.packages("reshape")
library(reshape)

rt2 <- reshape::melt(RoundingTimes)
rt2

# 정규분포 확인
out <- aov(value~X2, data=rt2)
shapiro.test(resid(out))  #> 정규분포가 아니다

# 그래프로 확인
boxplot(value~X2, data=rt2)

# friedman test
friedman.test(RoundingTimes)  #> 차이가 있다

# 사후검정: https://www.r-statistics.com/2010/02/post-hoc-analysis-for-friedmans-test-r-code/
friedman.test.with.post.hoc <- function(formu, data, to.print.friedman = T, to.post.hoc.if.signif = T,  to.plot.parallel = T, to.plot.boxplot = T, signif.P = .05, color.blocks.in.cor.plot = T, jitter.Y.in.cor.plot =F)
{
  # formu is a formula of the shape: 	Y ~ X | block
  # data is a long data.frame with three columns:    [[ Y (numeric), X (factor), block (factor) ]]
  
  # Note: This function doesn't handle NA's! In case of NA in Y in one of the blocks, then that entire block should be removed.
  
  
  # Loading needed packages
  if(!require(coin))
  {
    print("You are missing the package 'coin', we will now try to install it...")
    install.packages("coin")
    library(coin)
  }
  
  if(!require(multcomp))
  {
    print("You are missing the package 'multcomp', we will now try to install it...")
    install.packages("multcomp")
    library(multcomp)
  }
  
  if(!require(colorspace))
  {
    print("You are missing the package 'colorspace', we will now try to install it...")
    install.packages("colorspace")
    library(colorspace)
  }
  
  
  # get the names out of the formula
  formu.names <- all.vars(formu)
  Y.name <- formu.names[1]
  X.name <- formu.names[2]
  block.name <- formu.names[3]
  
  if(dim(data)[2] >3) data <- data[,c(Y.name,X.name,block.name)]	# In case we have a "data" data frame with more then the three columns we need. This code will clean it from them...
  
  # Note: the function doesn't handle NA's. In case of NA in one of the block T outcomes, that entire block should be removed.
  
  # stopping in case there is NA in the Y vector
  if(sum(is.na(data[,Y.name])) > 0) stop("Function stopped: This function doesn't handle NA's. In case of NA in Y in one of the blocks, then that entire block should be removed.")
  
  # make sure that the number of factors goes with the actual values present in the data:
  data[,X.name ] <- factor(data[,X.name ])
  data[,block.name ] <- factor(data[,block.name ])
  number.of.X.levels <- length(levels(data[,X.name ]))
  if(number.of.X.levels == 2) { warning(paste("'",X.name,"'", "has only two levels. Consider using paired wilcox.test instead of friedman test"))}
  
  # making the object that will hold the friedman test and the other.
  the.sym.test <- symmetry_test(formu, data = data,	### all pairwise comparisons
                                teststat = "max",
                                xtrafo = function(Y.data) { trafo( Y.data, factor_trafo = function(x) { model.matrix(~ x - 1) %*% t(contrMat(table(x), "Tukey")) } ) },
                                ytrafo = function(Y.data){ trafo(Y.data, numeric_trafo = rank, block = data[,block.name] ) }
  )
  # if(to.print.friedman) { print(the.sym.test) }
  
  
  if(to.post.hoc.if.signif)
  {
    if(pvalue(the.sym.test) < signif.P)
    {
      # the post hoc test
      The.post.hoc.P.values <- pvalue(the.sym.test, method = "single-step")	# this is the post hoc of the friedman test
      
      
      # plotting
      if(to.plot.parallel & to.plot.boxplot)	par(mfrow = c(1,2)) # if we are plotting two plots, let's make sure we'll be able to see both
      
      if(to.plot.parallel)
      {
        X.names <- levels(data[, X.name])
        X.for.plot <- seq_along(X.names)
        plot.xlim <- c(.7 , length(X.for.plot)+.3)	# adding some spacing from both sides of the plot
        
        if(color.blocks.in.cor.plot)
        {
          blocks.col <- rainbow_hcl(length(levels(data[,block.name])))
        } else {
          blocks.col <- 1 # black
        }
        
        data2 <- data
        if(jitter.Y.in.cor.plot) {
          data2[,Y.name] <- jitter(data2[,Y.name])
          par.cor.plot.text <- "Parallel coordinates plot (with Jitter)"
        } else {
          par.cor.plot.text <- "Parallel coordinates plot"
        }
        
        # adding a Parallel coordinates plot
        matplot(as.matrix(reshape(data2,  idvar=X.name, timevar=block.name,
                                  direction="wide")[,-1])  ,
                type = "l",  lty = 1, axes = FALSE, ylab = Y.name,
                xlim = plot.xlim,
                col = blocks.col,
                main = par.cor.plot.text)
        axis(1, at = X.for.plot , labels = X.names) # plot X axis
        axis(2) # plot Y axis
        points(tapply(data[,Y.name], data[,X.name], median) ~ X.for.plot, col = "red",pch = 4, cex = 2, lwd = 5)
      }
      
      if(to.plot.boxplot)
      {
        # first we create a function to create a new Y, by substracting different combinations of X levels from each other.
        subtract.a.from.b <- function(a.b , the.data)
        {
          the.data[,a.b[2]] - the.data[,a.b[1]]
        }
        
        temp.wide <- reshape(data,  idvar=X.name, timevar=block.name,
                             direction="wide") 	#[,-1]
        wide.data <- as.matrix(t(temp.wide[,-1]))
        colnames(wide.data) <- temp.wide[,1]
        
        Y.b.minus.a.combos <- apply(with(data,combn(levels(data[,X.name]), 2)), 2, subtract.a.from.b, the.data =wide.data)
        names.b.minus.a.combos <- apply(with(data,combn(levels(data[,X.name]), 2)), 2, function(a.b) {paste(a.b[2],a.b[1],sep=" - ")})
        
        the.ylim <- range(Y.b.minus.a.combos)
        the.ylim[2] <- the.ylim[2] + max(sd(Y.b.minus.a.combos))	# adding some space for the labels
        is.signif.color <- ifelse(The.post.hoc.P.values < .05 , "green", "grey")
        
        boxplot(Y.b.minus.a.combos,
                names = names.b.minus.a.combos ,
                col = is.signif.color,
                main = "Boxplots (of the differences)",
                ylim = the.ylim
        )
        legend("topright", legend = paste(names.b.minus.a.combos, rep(" ; PostHoc P.value:", number.of.X.levels),round(The.post.hoc.P.values,5)) , fill =  is.signif.color )
        abline(h = 0, col = "blue")
        
      }
      
      list.to.return <- list(Friedman.Test = the.sym.test, PostHoc.Test = The.post.hoc.P.values)
      if(to.print.friedman) {print(list.to.return)}
      return(list.to.return)
      
    }	else {
      print("The results where not significant, There is no need for a post hoc test")
      return(the.sym.test)
    }
  }
  
  # Original credit (for linking online, to the package that performs the post hoc test) goes to "David Winsemius", see:
  # http://tolstoy.newcastle.edu.au/R/e8/help/09/10/1416.html
}

install.packages("coin")

friedman.test.with.post.hoc(value~X2 | X1, rt2)  #> wide angle-round out 때문에 차이가 있다는 결과가 나온다

0.05/3  #> 유의수준 0.016

#########################
#########################

###### Two Way repeated measures anova

#ex> 집단별 시간 경과에 따른 점수 차이
mydata <- read.csv("C:/Users/acorn/hghbigdata/Rwork/BasicProject/stat/data/10_rmanova.csv")
head(mydata)
str(mydata)

# wide -> long
ac1 <- reshape(mydata, direction = "long", varying = 3:6, sep="")
ac1

ac2 <- reshape2::melt(mydata, id=c("group", "id"), variable.names="time", value.name="month", measure.vars=c("month0", "month1", "month3", "month6"))
ac2  #> time이 문자로 나와 후에 전처리 다시 필요할 수 있다

# 그래프 확인(시각화)
?interaction.plot

class(ac1$group)

ac1$group <- factor(ac1$group)  #> interaction.plot 사용 위해 factor형으로 변환
ac1$id <- factor(ac1$id)
ac1$time <- factor(ac1$time)
str(ac1)

interaction.plot(ac1$time, ac1$group, ac1$month)

# anova 분석
out <- aov(month ~ group * time + Error(id), data=ac1)
summary(out)  #> 차이가 있다

# 사후검정
ac1_0 <- ac1[ac1$time==0,]
ac1_0
ac1_1 <- ac1[ac1$time==1,]
ac1_3 <- ac1[ac1$time==3,]
ac1_6 <- ac1[ac1$time==6,]

0.05/6  #> 그룹에 따른 타임 조합 4C2=6. 유의수준 0.008

t.test(month~group, data=ac1_0)  #> 하나씩 t.test로 검정. 차이 없다
t.test(month~group, data=ac1_1)  #> 차이 있다
t.test(month~group, data=ac1_3)  #> 차이 있다
t.test(month~group, data=ac1_6)  #> 차이 있다
