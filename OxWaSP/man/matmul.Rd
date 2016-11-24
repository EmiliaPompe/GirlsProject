\name{matmul}
\alias{matmul}
\title{
Product of matrices
}
\description{
Computes the product of matrices using optimised OpenBLAS routine
}
\usage{
matmul(A, B)
}
\arguments{
  \item{A, B}{Two matrices which are conformable.}
}
\details{
Computes the produce of two conformable matrices (number of columns of \code{A}
must equal number of rows of \code{B}).  The computation is performed using the
highly optimised OpenBLAS library.
}
\value{
Returns a matrix.
}

\references{
OxWaSP module 7 slides

Xianyi, Z., Qian, W., & Chothia, Z. (2013). OpenBLAS, version 0.2.8. URL \url{http://www.openblas.net/}. Fetched, Feb 2015.
}
\author{
Louis J. M. Aslett <aslett@stats.ox.ac.uk>
}
\examples{
A <- matrix(rnorm(5*3), 5, 3)
B <- matrix(rnorm(3*7), 3, 7)
A \%*\% B
matmul(A, B)
}
