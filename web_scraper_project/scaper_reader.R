content <- read.csv("genomebiology.txt", header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, 
                    comment.char = "", check.names=FALSE, na.strings = "NA")
nrow(content)
ncol(content)
colnames(content)