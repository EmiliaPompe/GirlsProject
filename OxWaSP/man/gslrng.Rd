\name{gslrng}
\alias{gslrng}
\title{
Random number generation
}
\description{
Generate uniform random numbers
}
\usage{
gslrng(n)
}
\arguments{
  \item{n}{The number of random numbers to generate.}
}
\details{
Generates \code{n} random numbers using GSL in C code.  The random number
generator state is automatically maintained between calls via a static C
variable.  The high quality Mersenne Twister algorithm due to Makoto Matsumoto
and Takuji Nishimura is used, with dimensionality 623.
}
\value{
Returns \code{n} random numbers between 0 and 1.
}
\references{
OxWaSP module 7 slides

Makoto Matsumoto and Takuji Nishimura, "Mersenne Twister: A 623-dimensionally equidistributed uniform pseudorandom number generator". \emph{ACM Transactions on Modeling and Computer Simulation}, Vol. 8, No. 1 (Jan. 1998), Pages 3-30
}
\author{
Louis J. M. Aslett <aslett@stats.ox.ac.uk>
}
\examples{
gslrng(5)
gslrng(20)
}
