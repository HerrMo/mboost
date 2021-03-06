\name{blackboost}
\alias{blackboost}
\title{ Gradient Boosting with Regression Trees }
\description{
  Gradient boosting for optimizing arbitrary loss functions where regression
  trees are utilized as base-learners.
}
\usage{
blackboost(formula, data = list(),
           weights = NULL, na.action = na.pass,
           offset = NULL, family = Gaussian(), 
           control = boost_control(),
           oobweights = NULL,
           tree_controls = partykit::ctree_control(
               teststat = "quad",
               testtype = "Teststatistic",
               mincriterion = 0,
               minsplit = 10, 
               minbucket = 4,
               maxdepth = 2, 
               saveinfo = FALSE),
           ...)
}
\arguments{
  \item{formula}{ a symbolic description of the model to be fit. }
  \item{data}{ a data frame containing the variables in the model. }
  \item{weights}{ an optional vector of weights to be used in the fitting
    process. }
  \item{na.action}{a function which indicates what should happen when the data
    contain \code{NA}s. }
  \item{offset}{ a numeric vector to be used as offset (optional).}
  \item{family}{a \code{\link{Family}} object.}
  \item{control}{ a list of parameters controlling the algorithm. For
    more details see \code{\link{boost_control}}. }
  \item{oobweights}{ an additional vector of out-of-bag weights, which is
    used for the out-of-bag risk (i.e., if \code{boost_control(risk =
      "oobag")}). This argument is also used internally by
    \code{cvrisk}. }    
  \item{tree_controls}{ an object of class \code{"TreeControl"}, which
    can be obtained using \code{\link[partykit]{ctree_control}}. Defines
    hyper-parameters for the trees which are used as base-learners. It
    is wise to make sure to understand the consequences of altering any
    of its arguments. By default, two-way interactions (but not deeper
    trees) are fitted.}
  \item{\dots}{  additional arguments passed to \code{\link{mboost_fit}},
    including \code{weights}, \code{offset}, \code{family} and
    \code{control}. For default values see \code{\link{mboost_fit}}. }
}
\details{

  This function implements the `classical'
  gradient boosting utilizing regression trees as base-learners.
  Essentially, the same algorithm is implemented in package
  \code{\link[gbm]{gbm}}. The
  main difference is that arbitrary loss functions to be optimized
  can be specified via the \code{family} argument to \code{blackboost} whereas
  \code{\link[gbm]{gbm}} uses hard-coded loss functions.
  Moreover, the base-learners (conditional
  inference trees, see \code{\link[partykit]{ctree}}) are a little bit more flexible.

  The regression fit is a black box prediction machine and thus
  hardly interpretable.

  Partial dependency plots are not yet available; see example section for
  plotting of additive tree models.

}
\value{
  An object of class \code{mboost} with \code{\link{print}}
  and \code{\link{predict}} methods being available.
}
\references{

  Peter Buehlmann and Torsten Hothorn (2007),
  Boosting algorithms: regularization, prediction and model fitting.
  \emph{Statistical Science}, \bold{22}(4), 477--505.

  Torsten Hothorn, Kurt Hornik and Achim Zeileis (2006). Unbiased recursive
  partitioning: A conditional inference framework. \emph{Journal of
  Computational and Graphical Statistics}, \bold{15}(3), 651--674.

  Yoav Freund and Robert E. Schapire (1996),
  Experiments with a new boosting algorithm.
  In \emph{Machine Learning: Proc. Thirteenth International Conference},
  148--156.

  Jerome H. Friedman (2001),
  Greedy function approximation: A gradient boosting machine.
  \emph{The Annals of Statistics}, \bold{29}, 1189--1232.

  Greg Ridgeway (1999), The state of boosting.
  \emph{Computing Science and Statistics}, \bold{31},
  172--181.

}

\seealso{
  See \code{\link{mboost_fit}} for the generic boosting function, 
  \code{\link{glmboost}} for boosted linear models, and
  \code{\link{gamboost}} for boosted additive models. 
  
  See \code{\link{baselearners}} for possible base-learners. 
  
  See \code{\link{cvrisk}} for cross-validated stopping iteration. 
  
  Furthermore see \code{\link{boost_control}}, \code{\link{Family}} and
  \code{\link[mboost]{methods}}.
}
\examples{

### a simple two-dimensional example: cars data
cars.gb <- blackboost(dist ~ speed, data = cars,
                      control = boost_control(mstop = 50))
cars.gb

### plot fit
plot(dist ~ speed, data = cars)
lines(cars$speed, predict(cars.gb), col = "red")

\donttest{
############################################################
## Do not run this example automatically as it takes
## some time (~ 5-10 seconds depending on the system)

### set up and plot additive tree model
if (require("partykit")) {
    ctrl <- ctree_control(maxdepth = 3)
    viris <- subset(iris, Species != "setosa")
    viris$Species <- viris$Species[, drop = TRUE]
    imod <- mboost(Species ~ btree(Sepal.Length, tree_controls = ctrl) +
                             btree(Sepal.Width, tree_controls = ctrl) +
                             btree(Petal.Length, tree_controls = ctrl) +
                             btree(Petal.Width, tree_controls = ctrl),
                   data = viris, family = Binomial())[500]
    layout(matrix(1:4, ncol = 2))
    plot(imod)
}
}

}
\keyword{models}
\keyword{regression}
