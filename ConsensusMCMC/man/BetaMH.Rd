% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BetaMH.R
\name{BetaMH}
\alias{BetaMH}
\title{MH-Algorithm for a Univariate Beta target distribution.}
\usage{
BetaMH(data, n, sigma, alpha_prior, beta_prior, s, x_0)
}
\arguments{
\item{x}{A number}

\item{y}{A number}
}
\value{
The sum of \code{x} and \code{y}
}
\description{
\code{} The BetaMH function returns the Markov chain generated by a random walk Metropolis-Hasting 
algorithm having a univariate beta distribution as target distribution.
}
\examples{
add(1, 1)
add(10, 1)
}
