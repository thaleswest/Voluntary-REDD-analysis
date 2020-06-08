"-----------------------------------"
"CODE FOR SYNTHETIC CONTROL ANALYSIS"
"-----------------------------------"
library("Synth") #synthetic control package

#PART 1 ------------------------------------------------------------------------------------------------------------------
rm(list=ls()) #clear all
setwd("C:/Users/WestT/Dropbox/REDD Impact/Codes for cumulative def rate matching")
redd.data <- read.csv("redd_data_synth_mapbiomas_cummulative.csv")
redd.data <- subset(redd.data, def > -999)
redd.data$ID.numeric <- as.numeric(redd.data$ID)
redd.data$ID <- as.character(redd.data$ID)

projects <- subset(redd.data, REDD == 1)
unique(projects$ID) #"875"  "963"  "977"  "981"  "1094" "1112" "1113" "1115" "1118" "1329" "1503" "1571" "1686"

#select one REDD project and delete the others and controls that should not be used
project.ID <- "1686"
project.start.date <- 2014
#redd.data <- subset(redd.data, state == "AC")
redd.data <- subset(redd.data, ind != 1 & REDD != 1 | ID == project.ID)

project.area <- subset(redd.data, REDD == 1)[1,37] #37 is project area
redd.data <- subset(redd.data, area > c(project.area*0.5) & area < c(project.area*1.5)) #subset based on size

redd.data <- subset(redd.data, for.cover > 90) #subset based on initial forest cover

unique(redd.data$ID) #ckecking data
unique(redd.data$state)
unique(redd.data$ind)

#set treatment.identifier
treatment.identifier <- subset(redd.data, REDD == 1)[1,40]

#set controls.identifier
controls <- subset(redd.data, REDD != 1 & ind != 1)
unique(controls$ID)
controls.identifier <- unique(controls$ID.numeric)  

#data preparation
dataprep.out <-
  dataprep(foo = redd.data, #data name
           predictors = c("area",
                          "for.cover",
                          "capt", 
                          "hway",
                          "slope", 
                          "soil", 
                          "town", 
                          "road") ,
           predictors.op = "mean" , #variables based on means
           time.predictors.prior = 2001:2001 , #interval used for pretreatment matching, varies by project
           special.predictors = list(
             list("def_cum" ,         2001:c(project.start.date), "mean"),
             list("def" ,             2001:c(project.start.date), "mean"),
             list("primary_for" ,   c(2001,2004,2008,2012), "mean"), #seq=time interval between measurements (4y for TerraClass)
             list("secondary_for" , c(2001,2004,2008,2012), "mean"),
             list("pasture" ,       c(2001,2004,2008,2012), "mean"),
             list("agriculture" ,   c(2001,2004,2008,2012), "mean"),
             list("urban" ,         c(2001,2004,2008,2012), "mean")
           ),
           dependent = "def_cum", #cumulative deforestation from MapBiomas
           unit.variable = "ID.numeric", #CAR polygons (or protected areas for the Surui & Rio Preto-Jacunda evaluations)
           unit.names.variable = "ID",
           time.variable = "year",
           treatment.identifier = treatment.identifier, #CAR polygon that is REDD+ project under evaluation
           controls.identifier = controls.identifier, #CAR polygons that are not REDD+ projects
           time.optimize.ssr = 2010:c(project.start.date), #interval used for matching = 2001:project start date
           time.plot = 2001:2017 #interval of entire analysis = 2001:2017
  )

#data check
dataprep.out$X1 #X1 = covariate means for the REDD+ project
dataprep.out$X0 #X0 = covariate means for the control candidates
dataprep.out$Z1 #Z1 = deforestation of REDD+ project (dependent variable)
dataprep.out$Z0 #Z0 = deforestation of control candidates


#PART 2 ------------------------------------------------------------------------------------------------------------------
#search for the synthetic control
synth.out <- synth(data.prep.obj = dataprep.out,  method = "BFGS") #BFGS = optimization method, others are Nelder-Mead and SANN (non-derivative)
# OBS: if genoud(T) is inside synth(), it becomes a two-step optimization procedure:
#      A first optimization is conducted using the genoud() optimizer from the rgenoud package that combines evolutionary algorithm methods with 
#      a derivative-based (quasi-Newton) method to solve difficult optimization problems Solutions from genoud() are then passed to optim() in the second step 

#results
gaps <- dataprep.out$Y1plot - (dataprep.out$Y0plot %*% synth.out$solution.w)
gaps[, 1] #discrepancies in deforestation between REDD+ project and its synthetic control

#result table
synth.tables <- synth.tab(dataprep.res = dataprep.out, synth.res = synth.out)
#OBS: synth.tables has many comparison stats
names(synth.tables)
synth.tables$tab.pred #pre-treatment stats (Sample Mean = mean of control candidates)
write.csv(synth.tables$tab.pred, file = "Agrocortex_matching_results.csv")

subset(synth.tables$tab.w, w.weights != 0) #% contribution from the control candidates used to construct the synthetic control
write.csv(subset(synth.tables$tab.w, w.weights != 0), file = "Agrocortex_controls_used.csv")

#plot pre- & post-deforestation trends
path.plot(synth.res = synth.out,
          dataprep.res = dataprep.out,
          Ylab = "Deforestation (ha)",
          Xlab = "Year",
          #Ylim = c(-10,60),
          Legend = c("Agrocortex project","Synthetic control"),
          Legend.position = "topleft")
line.placement <- -5
abline(v=project.start.date, lty="dotted",lwd=2)
arrows(c(project.start.date-1.5), line.placement, c(project.start.date-0.5), line.placement, col="black",length=.1)
text(c(project.start.date-3.8), line.placement, "Project start date",cex=0.75)

#save results for ggplot
ggplot.data <- as.data.frame(dataprep.out$Y1plot)
ggplot.data[,2] <- dataprep.out$Y0plot %*% synth.out$solution.w
ggplot.data[,3] <- "Agrocortex"
colnames(ggplot.data) <- c("project.def", "synth.def", "project")
write.csv(ggplot.data, "ggplot_Agrocortex_main.csv")

controls.used <- subset(synth.tables$tab.w, w.weights != 0)[,2]
data.cf <- subset(redd.data, ID == controls.used[1])
for (i in 2:length(controls.used)) {
  temp <- subset(redd.data, ID == controls.used[i])
  data.cf <- rbind(data.cf, temp)
}
data.cf <- data.cf[,c(3,17,39)]
data.cf[0,]
w <- subset(synth.tables$tab.w, w.weights != 0)
data.cf$weight <- w[match(with(data.cf, ID), with(w, unit.names)),]$w.weights
data.cf$w.def <- data.cf$def_cum * data.cf$weight
write.csv(ggplot.data, "ggplot_Agrocortex_conf_inter.csv")

#plot gap between REDD+ project and synthetic control deforestation
gaps.plot(synth.res = synth.out,
          dataprep.res = dataprep.out,
          Ylab = "Gap in deforestation (ha)",
          Xlab = "Year",
          Ylim = c(-250,150),
          Main = NA)
line.placement <- 120
abline(v=project.start.date, lty="dotted",lwd=2)
arrows(c(project.start.date-1.5), line.placement, c(project.start.date-0.5), line.placement, col="black",length=.1)
text(c(project.start.date-3.8), line.placement, "Project start date",cex=0.75)

project_gap <- gaps #save main gaps for the placebo plot


#PART 3 ------------------------------------------------------------------------------------------------------------------
#placebo test
setwd("C:/Users/WestT/Dropbox/REDD Impact/Codes for cumulative def rate matching")
redd.data <- read.csv("redd_data_synth_mapbiomas_cummulative.csv")
redd.data <- subset(redd.data, def > -999)
redd.data$ID.numeric <- as.numeric(redd.data$ID)
redd.data$ID <- as.character(redd.data$ID)
projects <- subset(redd.data, REDD == 1)
unique(projects$ID) #"875"  "963"  "977"  "981"  "1094" "1112" "1113" "1115" "1118" "1329" "1503" "1571" "1686"
#select one REDD project and delete the others and controls that should not be used
project.ID <- "1686"
project.start.date <- 2014
redd.data <- subset(redd.data, ind != 1 & REDD != 1 | ID == project.ID)
project.area <- subset(redd.data, REDD == 1)[1,37] #37 is project area
redd.data <- subset(redd.data, area > c(project.area*0.50) & area < c(project.area*1.5)) #subset based on size
redd.data <- subset(redd.data, for.cover > 90) #subset based on initial forest cover
redd.data <- subset(redd.data, ID != project.ID)
unique(redd.data$ID)
unique(redd.data$state)
unique(redd.data$ind)
#set treatment.identifier
treatment.identifier <- subset(redd.data, REDD == 1)[1,40]
#set controls.identifier
controls <- subset(redd.data, REDD != 1 & ind != 1)
unique(controls$ID)
controls.identifier <- unique(controls$ID.numeric)  

# run placebo test
areas <- unique(redd.data$ID) #list of all polygons in the data (REDD+ project + controls)

redd.data$ID
ID.2 <- as.data.frame(matrix(NA,length(unique(redd.data$ID)),1))
ID.2$ID <- unique(redd.data$ID)
ID.2$ID.2 <- 1:length(ID.2$ID)
ID.2 <- ID.2[,-1]
redd.data$ID.2 <- ID.2[match(with(redd.data, ID), with(ID.2, ID)),]$ID.2

#results 
store <- matrix(NA,length(2001:2017),length(unique(redd.data$ID)))
colnames(store) <- unique(redd.data$ID)

for(iter in 1:length(ID.2$ID.2)) #loop to run placebos for each CAR polygon without REDD+ project
{
  
  dataprep.out <-
    dataprep(foo = redd.data, #data name
             predictors = c("area",
                            "for.cover",
                            "capt", 
                            "hway",
                            "slope", 
                            "soil", 
                            "town", 
                            "road") ,
             predictors.op = "mean" , #variables based on means
             time.predictors.prior = 2001:2001 , #interval used for pretreatment matching, varies by project
             special.predictors = list(
               list("def_cum" ,         2001:c(project.start.date), "mean"),
               list("def" ,             2001:c(project.start.date), "mean"),
               list("primary_for" ,   c(2001,2004,2008,2012), "mean"), #seq=time interval between measurements (4y for TerraClass)
               list("secondary_for" , c(2001,2004,2008,2012), "mean"),
               list("pasture" ,       c(2001,2004,2008,2012), "mean"),
               list("urban" ,         c(2001,2004,2008,2012), "mean")
             ),
             dependent = "def_cum", #cumulative eforestation from MapBiomas
             unit.variable = "ID.2", #CAR polygons (or protected areas for the Surui & Rio Preto-Jacunda evaluations)
             unit.names.variable = "ID",
             time.variable = "year",
             treatment.identifier = iter, #CAR polygon that is REDD+ project under evaluation
             controls.identifier = c(1:length(ID.2$ID.2))[-iter],
             time.optimize.ssr = 2001:c(project.start.date), #interval used for matching = 2001:project start date
             time.plot = 2001:2017 #interval of entire analysis = 2001:2017
    )
  
  #search for the synthetic control
  synth.out <- synth(data.prep.obj = dataprep.out,  method = "BFGS")
  
  #store gaps
  store[,iter] <- dataprep.out$Y1plot - (dataprep.out$Y0plot %*% synth.out$solution.w)
} #finish loop

#prepate plot figure
data <- cbind(store, project_gap)
colnames(data)[ncol(data)] <- project.ID
rownames(data) <- 2001:2017 #1955:1997
#set bounds in gaps data
gap.start     <- 1
gap.end       <- nrow(data)
years         <- 2001:2017 #1955:1997
gap.end.pre  <- which(rownames(data)==as.character(project.start.date))

#MSPE Pre-Treatment
mse <- apply(data[ gap.start:gap.end.pre,]^2,2,mean)
redd.data.mse <- as.numeric(mse[ncol(data)]) #column of REDD project
#exclude placebos with MSPE 5 times higher than the project's pre-treatment MSPE
data <- data[,mse < 5*redd.data.mse]

#plot
plot(years, data[gap.start:gap.end,which(colnames(data)==project.ID)],
     #ylim=c(-70,70),
     xlab="year",
     #xlim=c(2001,2017),
     ylab="Gap in deforestation (ha)",
     type="l",lwd=2,col="black",
     xaxs="i",yaxs="i")
#add lines for control states
for (i in 1:ncol(data)) { lines(years,data[gap.start:gap.end,i],col="gray") }
#add Basque Line
lines(years,data[gap.start:gap.end,which(colnames(data)==project.ID)],lwd=2,col="black")
#add grid
abline(v=project.start.date, lty="dotted",lwd=2)
abline(h=0,lty="dashed",lwd=2)
legend("topleft",legend=c("Agrocortex project","Placebo areas"),
       lty=c(1,1),col=c("black","gray"),lwd=c(2,1),cex=.8)
line.placement <- -55
arrows(c(project.start.date-1.5), line.placement, c(project.start.date-0.5), line.placement, col="black",length=.1)
text(c(project.start.date-3.8), line.placement, "Project start date",cex=0.75)

#data for placebo ggplot
require(reshape2)
ggplot.data.2 <- as.data.frame(data)
ggplot.data.2$year <- 2001:2017
ggplot.data.2 <- melt(ggplot.data.2, "year")
colnames(ggplot.data.2) <- c("year","ID","def.gap")
ggplot.data.2$REDD <- ifelse(ggplot.data.2$ID == project.ID, 1, 0)
ggplot.data.2$project <- "Agrocortex"
write.csv(ggplot.data.2, "ggplot_Agrocortex_placebo.csv")
