#' @title distances to coordDF
#' @description Takes a distance matrix and converts it into a coordinate tibble. D2C requires that the first three nodes of the distance matrix are not co-linear.
#' @param distances A \code{n}x\code{n matrix} where first row is not column headers.
#' Each cell represents the distance from the row index node to the column index node.
#' 
D2C <- function(distances){
  nodeCount <- dim(distances)[1] # Calculate the number of nodes
  xMat <- matrix(0, ncol = 2, nrow = nodeCount) # Guesses are stored in xMat as (x,y) pairs
  xMat[2,1] <- distances[1,2] # First point is left as (0,0), second point is on x-axis
  c <- distances[1,2] # c leg for triangle combination with first and second nodes
  for(i in 3:nodeCount){
    a <- distances[2,i] # a leg of first triangle
    b <- distances[1,i] # b leg of first triangle
    theta <- acos((b^2 + c^2 - a^2) / (2 * b * c)) # angle of first triangle
    x <- b * cos(theta) # x value
    y <- b * sin(theta) # positive y value
    d1 <- abs(distances[3, i] - sqrt((x - distances[3, 1])^2 + (y - distances[3, 2])^2)) # distance to point 3 vs true if y is positive
    d2 <- abs(distances[3, i] - sqrt((x - distances[3, 1])^2 + (y + distances[3, 2])^2)) # distance to point 3 vs true if y is negative
    if(i > 3 && (d2 < d1)){
      xMat[i,] <- c(x, -y) # if d2 < d1, then the y value must be negative
    } else {
      xMat[i,] <- c(x, y)
    }
  }
  return(xMat)
}
