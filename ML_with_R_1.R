# open data and read
origData = read.csv2('/home/torsh/R/data/801210364_T_ONTIME.csv', sep = ",", header = TRUE, stringsAsFactors = FALSE, )

# number of rows:
nrow(origData)

# reduce data to include only the large airports
airports = c('ATL', 'LAX', 'ORD', 'DFW', 'JFK', 'SFO', 'CLT', 'LAS', 'PHX')

# select statement
origData = subset(origData, DEST %in% airports & ORIGIN %in% airports)

# fewer number of rows:
nrow(origData)

# show only the 2 1st columns of data
head(origData, 2)

# show only the 2 last columns of data
tail(origData, 2)

# remove the unwanted column
origData$X = NULL

# check if it is emoved
head(origData, 2)

# correlate columns to see if they are identical. (output: 1: yes, 0: no.)
cor(origData[c("ORIGIN_AIRPORT_SEQ_ID", "ORIGIN_AIRPORT_ID")])

# correlate columns to see if they are identical. (output: 1: yes, 0: no.)
cor(origData[c("DEST_AIRPORT_SEQ_ID", "DEST_AIRPORT_ID")])

# drop these columns
origData$ORIGIN_AIRPORT_SEQ_ID = NULL
origData$DEST_AIRPORT_SEQ_ID = NULL

# correlated string columns, see if they are not matching (',' means : filter only by rows):
mismatched = origData[origData$CARRIER != origData$UNIQUE_CARRIER,]
nrow(mismatched)

# drop Unique_carrier
origData$UNIQUE_CARRIER = NULL

# check the data frame now
head(origData,2)

# filtering rows for NA , "" and assign the filtered data to new variable:
onTimeData = origData[!is.na(origData$ARR_DEL15) & origData$ARR_DEL15 !="", ]
#this part is experimental:
#& !is.na(origData$DEP_DEL15) !="" & origData$DEP_DEL15 !="",]

# check data again
nrow(origData)
nrow(onTimeData)

# change data type from string to integer: by checking the data types of onTimeDatas in Global Environment windows
onTimeData$DISTANCE = as.integer(onTimeData$DISTANCE)
onTimeData$CANCELLED = as.integer(onTimeData$CANCELLED)
onTimeData$DIVERTED = as.integer(onTimeData$DIVERTED)

# change data type from string to factor since we have few values (corresponding to levels)
onTimeData$ARR_DEL15 = as.factor(onTimeData$ARR_DEL15)
onTimeData$DEP_DEL15 = as.factor(onTimeData$DEP_DEL15)

onTimeData$DEST_AIRPORT_ID = as.factor(onTimeData$DEST_AIRPORT_ID)
onTimeData$ORIGIN_AIRPORT_ID = as.factor(onTimeData$ORIGIN_AIRPORT_ID)
onTimeData$DAY_OF_WEEK = as.factor(onTimeData$DAY_OF_WEEK)
onTimeData$DEST = as.factor(onTimeData$DEST)
onTimeData$ORIGIN = as.factor(onTimeData$ORIGIN)
onTimeData$DEP_TIME_BLK = as.factor(onTimeData$DEP_TIME_BLK)
onTimeData$CARRIER = as.factor(onTimeData$CARRIER)

# how many delays are there:
tapply(onTimeData$ARR_DEL15, onTimeData$ARR_DEL15, length)
# claculate delays ( parameters calculated above) in %
6460 / ( 25664+6460 )


# using tapply function to figure out how many time 15 min delay are true / false
# it returns 6460 number of True (1) delays, 25664 False(0) delays
tapply(onTimeData$ARR_DEL15, onTimeData$ARR_DEL15, length)
# 6460 / (25664 + 6460) = 0.2010 (about 20% delays) =>> 20% is significant enough to use for a prediction model
# how are we ended into this result?
# At this stage review and track and improve data processing steps by more iterations is needed.
