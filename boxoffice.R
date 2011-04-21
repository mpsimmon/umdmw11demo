# Copyright 2011 Matthew Simmons - free for use under the
# Creative Commons: Attribution-ShareAlike license. (CC BY-SA)
# Author: Matthew P. Simmons (mpsimmon@umich.edu)
#
# boxoffice.R - Demonstrate aggregation and plotting with user provided data.
#
# Remember, ? is your best friend.
# ?<command> fetches the help for <command>
# ??<string> searches for help appropriate to <string>

# boxoffice.tsv.gz - Dataset from boxofficemojo.com
# Available at: http://goo.gl/GB4gQ
# Has a header row, is tab delimited and has format of:
#   <row.number>\t<date.string>\t<daily.gross>\t<title.string>\n
#   daily gross is in USD
#   Dates range from 2002-01-01 -> 2010-12-31
box.office <- read.delim('boxoffice.tsv.gz', head=T, sep="\t")

#Get a feel for what the data has to offer.
head(box.office)
summary(box.office)

# Use tapply to get the mean box office revenue per day.
# tapply splits the frame into groups by the second argument and applies
#   the function specified in the third argument to the data specified in the
#   first argument. ?tapply does a better job of explaining. :)
# with(<frame>, <operation>) performs <operation> in the context of <frame>.
# The next line is equivalent to:
# bo.daily <- tapply(box.office$daily, box.office$date, mean)
#   *notice: yet another form of subscripting is shown above.
# see: ?with and ?tapply for details.
bo.daily <- with(box.office, tapply(daily, date, mean))

# Convert the named vector returned from tapply into a data frame.
# Define the 'daily' column to be the values returned from tapply, and
#   define the 'date' column to be the group the aggregated values come from.
# Also, convert the string date values to actual POSIX (time) objects.
# see: ?POSIXt for details on the POSIXt, POSIXct, and POSIXlt classes.
bo.daily <- data.frame(daily=bo.daily,
                       date=as.POSIXct(rownames(bo.daily)))

# Writes an 800 x 600 png to the current directory.
png('bo_plot_1.png', width=800, height=600)
qplot(date, daily, data=bo.daily, geom="line")  #?qplot for more details
graphics.off()  #Close the device and write the file.

head(box.office)
# Same conversion as mentioned above, just doing it to the source data.
box.office$date <- as.POSIXct(box.office$date)

# One nice feature of the POSIXt classes is that they define a special method
# for binning the values by a specific duration of time (using cut).
# I use that here to create a factor (a multi-level categorical variable)
# that groups the daily revenues by week.
# see: ?cut.POSIXt and ?factor for details.
box.office$week <- cut(box.office$date, 'week')

# This is essentially the same as the use of tapply above, just with weeks.
bo.weekly <- with(box.office, tapply(daily, week, mean))
bo.weekly <- data.frame(weekly=bo.weekly,
                        date=as.POSIXct(rownames(bo.weekly)))

# The same as the previous plot.
png('bo_plot_2.png', width=800, height=600)
qplot(date, weekly, data=bo.weekly, geom="line")
graphics.off()

# There are other ways to group than with tapply.
# Hadley Wickham's plyr package (had.co.nz/plyr) is a great alternative.
# There is a good tutorial on it here:
#   http://had.co.nz/plyr/09-user/
