library(Rserve)
library(ggplot2)

drawHistogram <- function(numArray) {
  filename <- tempfile("plot", fileext = ".png")

  # Switch on PNG device
  png(filename)

  # Draw a histogram
  img <- ggplot(NULL, aes(x=numArray)) + geom_histogram(breaks=seq(0,48) , fill="white", colour="black") + xlab("Lottery Number") + ylab("Count")
  ggsave(filename, img)

  # Switch off device
  dev.off()

  # obtain image binary array
  image <- readBin(filename, "raw", .Machine$integer.max)

  # Remove temp file
  unlink(filename)

  return(image)
}

drawEventDiagram <- function(numMatrix) {
  filename <- tempfile("plot", fileext = ".png")

  # Switch on PNG device
  png(filename)

  # Convert the matrix to a corresponding data frame
  df <- data.frame(x = rep(1:dim(numMatrix)[1], each = 6), y = as.vector(t(as.matrix(numMatrix))))

  # Draw a histogram
  img <- ggplot(df, aes(x, y)) + geom_point(pch = "=") + xlab("Time") + ylab("Lottery Number")
  ggsave(filename, img)

  # Switch off device
  dev.off()

  # obtain image binary array
  image <- readBin(filename, "raw", .Machine$integer.max)

  # Remove temp file
  unlink(filename)

  return(image)
}

predictByRandom <- function() {
  return(sort(sample(1:49, 6, replace = FALSE)))
}

predictByHighFreq <- function(numMatrix) {
  t <- sort(table(numMatrix), decreasing = TRUE)

  i <- 1
  c <- 0
  n <- NULL
  v <- c()

  repeat {

    temp <- as.vector(t)[i]
    name <- names(t)[i]

    if (is.null(n)) {
      c <- c + 1
      n <- temp
    } else if (!is.null(temp) & !is.na(temp)) {
      if (n > temp) {
        c <- c + 1
        n <- temp
      }
    } else {
      break
    }

    if (c > 6) {
      break
    }

    v <- c(v, name)
    i <- i + 1

    if (i > 48) {
      break
    }
  }

  v <- strtoi(v)
  return(sort(sample(v, 6, replace = FALSE)))
}

predictByLowFreq <- function(numMatrix) {
  t <- sort(table(numMatrix), decreasing = FALSE)

  i <- 1
  c <- 0
  n <- NULL
  v <- c()

  repeat {
    temp <- as.vector(t)[i]
    name <- names(t)[i]

    if (is.null(n)) {
      c <- c + 1
      n <- temp
    } else if (!is.null(temp) & !is.na(temp)) {
     if (n < temp) {
        c <- c + 1
        n <- temp
      }
    } else {
      break
    }

    if (c > 6) {
      break
    }

    v <- c(v, name)
    i <- i + 1

    if (i > 48) {
      break
    }
  }

  v <- strtoi(v)
  return(sort(sample(v, 6, replace = FALSE)))
}


run.Rserve()
