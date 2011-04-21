# Copyright 2011 Matthew Simmons - free for use under the
# Creative Commons: Attribution-ShareAlike license. (CC BY-SA)
# Author: Matthew P. Simmons (mpsimmon@umich.edu)
#
# trek.R - Demonstrates basic R features with a Star Trek themed example.
#
# Remember, ? is your best friend.
# ?<command> fetches the help for <command>
# ??<string> searches for help appropriate to <string>

library(ggplot2)
# If the above causes you trouble, try uncommenting the next line.
#install.packages('ggplot2')

data(movies)
summary(movies)

# Uses a vector of logical values to subset the movies data.frame
# and create a new frame (trek.movies) with only Star Trek movies.
trek.movies <- movies[grep('star trek', movies$title, ig=T),]

# Sorts the new frame by the year of the movie, ascending.
trek.movies <- trek.movies[with(trek.movies, order(year)),]
head(trek.movies, 10)  # First 10 lines of trek.movies

# This will actually get the odd numbered Trek Films.
# Remember: R is 1 indexed, not 0 indexed.
# c is a function to concatenate values into a vector. ?c for details.
even.ones <- c(1,3,5,7,9,11)
trek.movies[even.ones,]  # The wrong ones...

# This uses R's implicit repetition to add one to all value in good.ones
even.ones <- even.ones + 1
even.ones
trek.movies[even.ones,]  # Now we're talking.

# Test whether the means of the two samples are different in a
# statistically significant manner using the Student's t-test.
# See ?t.test for help interpreting this.
t.test(trek.movies[even.ones,'rating'],
       trek.movies[-even.ones,'rating'])


# Make some convenience frames by subsetting the data further.
even.trek <- trek.movies[even.ones,]  # The even movies.
odd.trek <- trek.movies[-even.ones,]  # The odd ones...

# Don't do this in a real analysis. The t-test assumes normally
# distributed data. Uncomment the following lines to see how badly
# this violates that assumption...
##
#good.trek.ratings <- with(good.trek, rep(rating, votes))
#bad.trek.ratings <- with(bad.trek, rep(rating, votes))
#trek.ratings <- data.frame(rating=c(good.trek.ratings, bad.trek.ratings))
#trek.ratings$karma <- rep(c('good', 'bad'),
#                          c(length(good.trek.ratings),
#                            length(bad.trek.ratings)))
#qplot(rating, fill=karma, data=trek.ratings, geom="histogram",
#      position="dodge")
##
# Not normal. For purposes of demonstration only. :)
t.test(with(even.trek, rep(rating, votes)),
       with(odd.trek, rep(rating, votes)))


#
# A better, but more complicated way to do the same thing.
# The r1,...,r10 columns of even.trek and odd.trek contain the percent
# of votes at each rating level. By multiplying the number of votes by
# the percentage for each rating, we recover the original number of votes
# at a particular rating. Use 'names(even.trek)' and 'names(odd.trek)' to
# determine the column number for a particular rating.
#
# Here is an example with a for loop to accomplish this. It could probably
# be done with some form of arcane one-liner, but I haven't shown any for loops
# yet and this seemed like a good chance.
#
names(even.trek)  #Find the column numbers we want.
names(odd.trek)  #We want the columns corresponding to 'r1',...,'r10'

odd.votes <- c()  #Declare an empty vector.
for (i in 1:10) {
  # Iteratively compute the number of votes that were of rating i
  votes.i <- rep(i, sum(round((odd.trek[,i+6]/100) * odd.trek$votes)))
  # Update the votes vector with the votes for rating i.
  odd.votes <- append(odd.votes, votes.i)
}

# Second verse, same as the first...
even.votes <- c()
for (i in 1:10) {
  votes.i <- rep(i, sum(round((even.trek[,i+6]/100) * even.trek$votes)))
  even.votes <- append(even.votes, votes.i)
}

# Were much closer to the normality assumption now.
hist(even.votes)
hist(odd.votes)

# The test still comes out the same, though the difference is a bit less.
t.test(even.votes, odd.votes)

