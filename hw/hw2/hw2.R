#Connor Watson
#09/29/2018
#CS 636 -- HW 2

#Problem 1
f <- function(x){
  if (x == 1){
    2
  }
  else if(x > 1){
    5/((x-1)**2)
  }
  else{
    5/((x-1)**3)
  }
}

f(1)
f(10)
f(0.3)

#Problem 2
fib <- function(n){
  if (n == 1){
    1
  }
  else if (n == 2){
    1
  }
  else if (n > 2){
    fib(n-1) + fib(n-2)
  }
}

fib(1)
fib(2)
fib(10)
#calling fib(100) takes so much computation time

#Problem 3
merge <- function(list1, list2){
  ret <- c()
  i1 <- 1
  i2 <- 1
  i3 <- 1
  while (i1 <= length(list1) & i2 <= length(list2)){
    if (list1[i1] <= list2[i2]){
      ret[i3]<-list1[i1]
      i1 <- i1 + 1
      i3 <- i3 + 1
    }
    else if (list2[i2] <= list1[i1]){
      ret[i3]<-list2[i2]
      i2 <- i2 + 1
      i3 <- i3 + 1
    }
  }
  
  while(i1 <= length(list1)){
    ret[i3]<-list1[i1]
    i1 <- i1 + 1
    i3 <- i3 + 1
  }
  while(i2 <= length(list2)){
    ret[i3]<-list2[i2]
    i2 <- i2 + 1
    i3 <- i3 + 1
  }
  return(ret)
}

merge(seq(1, 50, by=3), seq(2, 30, by=2))

#Problem 4
partition <- function(pivot, lst){
  ret1 = c()
  ret2 = c()
  i1 = 1
  i2 = 1
  for (i in 1:length(lst)){
    if(lst[i] <= pivot){
      ret1[i1] = lst[i]
      i1 = i1 + 1
    }
    else{
      ret2[i2] = lst[i]
      i2 = i2 + 1
    }
  }
  return (list(ret1, ret2))
}

partition(50, sample(1:100, 100, replace=F))