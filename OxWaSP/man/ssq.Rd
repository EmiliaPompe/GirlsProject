\name{ssq}
\alias{ssq_naive}
\alias{ssq_naive_restrict}
\alias{ssq_naive_restrict_omp}
\alias{ssq_ispc}
\alias{ssq_SIMD}
\alias{ssq_SIMD_omp}
\title{
Sum of difference and sum of squared difference
}
\description{
Computes the sum of the differences and squared differences of vector inputs naively, with restrict, with OpenMP and using CPU vector instructions
}
\usage{
ssq_naive(x, y)
ssq_naive_restrict(x, y)
ssq_naive_restrict_omp(x, y)
ssq_ispc(x, y)
ssq_SIMD(x, y)
ssq_SIMD_omp(x, y)
}
\arguments{
  \item{x, y}{Two vectors of the same length.}
}
\details{
Computes and returns 
\deqn{\sum_{i=1}^n (x_i-y_i)}{\sum (x_i-y_i)}
and
\deqn{\sum_{i=1}^n (x_i-y_i)^2}{\sum (x_i-y_i)^2}
using different high performance techniques, such as the AVX vector units of the CPU.
}
\value{
Returns a list containing two items:
  \itemize{
    \item{\code{sum_X_Y} holding the sum of the differences}
    \item{\code{sumSq_X_Y} holding the sum of the squared differences}
  }
}

\references{
OxWaSP module 7 slides

Pharr, M., & Mark, W. R. (2012). ispc: A SPMD compiler for high-performance CPU programming. In \emph{Innovative Parallel Computing (InPar), 2012} (pp. 1-13). IEEE.
}
\author{
Louis J. M. Aslett <aslett@stats.ox.ac.uk>
}
\examples{
\dontrun{
ssq_naive(1:1000, 1000:1)
ssq_naive_restrict(1:1000, 1000:1)
ssq_naive_restrict_omp(1:1000, 1000:1)
ssq_ispc(1:1000, 1000:1)
ssq_SIMD(1:1000, 1000:1) # THIS WILL CRASH ... DO YOU KNOW WHY?
ssq_SIMD_omp(1:1000, 1000:1) # THIS WILL CRASH ... DO YOU KNOW WHY?
}
}
