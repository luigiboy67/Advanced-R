#2.1
Quiz 

# 1. Given the following data frame, how do I create a new column called “3” that contains the sum of 1 and 2? You may only use $, not [[. What makes 1, 2, and 3 challenging as variable names? 

df <- data.frame(runif(3), runif(3))
names(df) <- c(1, 2)

# 2. In the following code, how much memory does y occupy?

x <- runif(1e6)
y <- list(x, x, x)

# 3. On which line does a get copied in the following example?

a <- c(1, 5, 3, 2)
b <- a
b[[1]] <- 10

library(lobstr)

x <- c(1, 2, 3)
y <- x

# ^ It’s creating an object, a vector of values, c(1, 2, 3).
# And it’s binding that object to a name, x.
# with y, you just get another binding to the existing object

obj_addr(x)
#> [1] "0x7fe11b31b1e8"
obj_addr(y)
#> [1] "0x7fe11b31b1e8"

# with a unique identifier, you can refer to an object independent of its bindings

# be mindful that the identifiers change everytime you restart R

# 2.2.1

# syntactic names must consist of letters, digits, . and _. Can't start with digits or _

# can't use reserved words like function or TRUE

# an object is non-syntactic if it breaks these rules

_abc <- 1
#> Error: unexpected input in "_"

if <- 10
#> Error: unexpected assignment in "if <-"

# you can override theres errors with backticks

`_abc` <- 1
`_abc`
#> [1] 1

`if` <- 10
`if`
#> [1] 10

# 2.2.2

# 1. Explain the relationship between a, b, c and d in the following code:

a <- 1:10
b <- a
c <- b
d <- 1:10

# we are assigning the object to a. we bind the existing object a to b as well as b to c. we are assign the the same object to d. But they all refer to the existing object

# 2. The following code accesses the mean function in multiple ways. Do they all point to the same underlying function object? Verify this with lobstr::obj_addr().

mean
base::mean
get("mean")
evalq(mean)
match.fun("mean")

obj_addr(mean)
obj_addr(base::mean)
obj_addr(get("mean"))
obj_addr(evalq(mean))
obj_addr(match.fun("mean"))

# yes, they all point to the same underlying function object.

# 3. By default, base R data import functions, like read.csv(), will automatically convert non-syntactic names to syntactic ones. Why might this be problematic? What option allows you to suppress this behaviour?

#it might cause some confusion with possible reserved words or break the syntatctic rules. you could use back ticks or even options within the read.csv function

# 4. What rules does make.names() use to convert non-syntactic names into syntactic ones?

#has three arguments: names, unique and allow_. names takes a character vector to be coerced to syntactically valid names, coerced to character if necessary. unique is a logical. if TRUE, resulting elements are unique. allow_ is also logical

# 5. I slightly simplified the rules that govern syntactic names. Why is .123e1 not a syntactic name? Read ?make.names for the full details.

#must consists of letters, numbers and the dot or underline character

# 2.3

x <- c(1, 2, 3)
y <- x

y[[3]] <- 4
x
#> [1] 1 2 3

# While the value associated with y changed, the original object did not. Instead, R created a new object, 0xcd2, a copy of 0x74b with one value changed, then rebound y to that object.

#That behavior is called copy-on-modify

# 2.3.1 

# You can see when an object gets copied with the help of base::tracemem()

x <- c(1, 2, 3)
cat(tracemem(x), "\n")
#> <0x7f80c0e0ffc8> 

# tracemem() will print a message telling you which object was copied, its new address, and the sequence of calls that led to the copy:
y <- x
y[[3]] <- 4L
#> tracemem[0x7f80c0e0ffc8 -> 0x7f80c4427f40]: 

y[[3]] <- 5L

untracemem(x)

# tracemem() will print a message telling you which object was copied, its new address, and the sequence of calls that led to the copy

# untracemem() is the opposite of tracemem(); it turns tracing off.

# 2.3.2

f <- function(a) {
  a
}

x <- c(1, 2, 3)
cat(tracemem(x), "\n")
#> <0x7fe1121693a8>

z <- f(x)
# there's no copy here!

untracemem(x)

# 2.3.3
l1 <- list(1, 2, 3)