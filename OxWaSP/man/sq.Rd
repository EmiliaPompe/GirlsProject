\name{sq}
\alias{sq}
\title{
Square a number
}
\description{
Take a number in, square it!
}
\usage{
sq(x)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{The scalar to be squared.}
}
\details{
Honest, all it does it square the number, but in C code!  Does not take vectors.
}
\value{
Returns the input value squared.
}
\references{
OxWaSP module 7 slides
}
\author{
Louis J. M. Aslett <aslett@stats.ox.ac.uk>
}
\examples{
sq(2)
sq(3.141592)
}
