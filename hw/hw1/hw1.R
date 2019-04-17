#Connor Watson
#09/15/2018
#CS 636 -- HW 1

#Exercise 1.20)
data(islands)
sort(islands, decreasing=T)[0:7]

#Exercise 1.21)
library(UsingR)
data(primes)

length(primes[primes>1 & primes<100])
#There are 25 prime numbers in the range 1:100

length(primes[primes>100 & primes<1000])
#There are 143 prime numbers in the range 100:1000

#Exercise 1.22)
primes[-1]
#This returns the entire list of prime numbers EXCEPT the 2 at location 1
#Negative index omits that value

n = length(primes)
primes[-n]
#This returns the entire list of prime numbers EXCEPT the 2003 at location 304 
#because 304 is the length of primes. Negative index omits that value

differences <- primes[-1] - primes[-n]
#This takes primes (without pos1) and primes (without posn) and takes the differences
#between each vector. This gives a hint to twin primes because the difference from
#one prime to the next should be 2.
twin_primes = differences[differences==2]
length(twin_primes) #61 twin primes

#Exercise 1.23)
data(treering)
length(treering) #7980 observations

sorted_treering <- sort(treering)
smallest_largest <- c(sorted_treering[[1]],sorted_treering[[7980]])
#smallest = 0.000 and largest = 1.908

length(sorted_treering[sorted_treering > 1.5])
#There are 219 values greater than 1.5

#Exercise 1.24)
data("mandms")
mandms
#Peanut Butter is missing the orange color

#kid minis and Almond both have equal distribution of colors
#16.667

#milk chocolate has brown color with 30 distribution 
#greater than all the other colors

#Exercise 1.25)
data(nym.2002)

nrow(nym.2002)
#This returns the num rows in the data frame
time_column <- nym.2002[,"time"]
length(!is.na(time_column) & time_column[time_column > 0])
#This confirms the number of not NA times in the column
#There are 1000 times in the column time

min(nym.2002[,"time"])
#min (fastest) time is 147.3333 minutes
147.3333 / 60 #2 hours
.455555 * 60 #27.3333 minutes

max(nym.2002[,"time"])
#max (slowest) time is 566.7833 minutes
566.7833 / 60 #9 hours
60 * .446388 #26.78328 minutes

#Exercise 1.26)
sorted_rivers <- sort(rivers)
smallest_longest <- c(sorted_rivers[[1]], sorted_rivers[[length(sorted_rivers)]])
#smallest is 135 and longest is 3710

#Exercise 1.27)
data("uspop")
names(uspop) <- seq(from = 1790, to=1970, by=10)
diffs <- diff(uspop,lag=1,differences=1)
max(diffs) #28 is the maximum difference between decades
#Generally speaking, the population should increase with each decade because there 
#are increasingly more people, and this reasonably means the differences in population
#should also be increasing over time. This is not always the case, for example from
#1930 to 1940, the population increase was much smaller because of World War 2, but
#from 1940 to 1950 it increased again because the war was ending.