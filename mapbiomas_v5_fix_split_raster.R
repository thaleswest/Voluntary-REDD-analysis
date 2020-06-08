"-------------------------------------------------------------------------------------------"
" CODE TO FIX CLOUD COVER AND NON-FOREST-TO-FOREST TRANSITION IN ORIGIONAL MAPBIOMAS + SPLIT"
"-------------------------------------------------------------------------------------------"
library(raster)
library(rgdal)
#Previous steps: [1] reclassification in ArcGIS; [2] raster split in ArcGIS
#Note: A test can be run based on fake rasters (STEP 0), but first make sure to comment/uncomment the right code lines!

"-------------------------------------------------------------------------------" #PART 0 Test-run rasters----
"STEP 0. Fake rasters for test run "
"-------------------------------------------------------------------------------"
# #par(mfrow=c(2,3))
# r <- raster(matrix(runif(225),15,15))
# r[ r > 0.9 ] <- NA
# r[ r > 0 & r < 0.5 ] <- 1
# r[ r > 0.5 & r < 0.8 ] <- 2
# r[ r > 0.8 & r < 0.9 ] <- 3
# r1 <- r
# #plot(r, col=c("green","red","blue"), main="3001 old")
# #setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/split2")
# #writeRaster(r, "fnf3001_1.tif", overwrite = T)
# r <- raster(matrix(runif(225),15,15))
# r[ r > 0.9 ] <- NA
# r[ r > 0 & r < 0.5 ] <- 1
# r[ r > 0.5 & r < 0.8 ] <- 2
# r[ r > 0.8 & r < 0.9 ] <- 3
# r2 <- r
# #plot(r, col=c("green","red","blue"), main="3002 old")
# setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/split2")
# writeRaster(r, "fnf3002_1.tif", overwrite = T)
# r <- raster(matrix(runif(225),15,15))
# r[ r > 0.9 ] <- NA
# r[ r > 0 & r < 0.5 ] <- 1
# r[ r > 0.5 & r < 0.8 ] <- 2
# r[ r > 0.8 & r < 0.9 ] <- 3
# r3 <- r
# #plot(r, col=c("green","red","blue"), main="3003 old")
# #setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/split2")
# #writeRaster(r, "fnf3003_1.tif", overwrite = T)
# r <- raster(matrix(runif(225),15,15))
# r[ r > 0.9 ] <- NA
# r[ r > 0 & r < 0.5 ] <- 1
# r[ r > 0.5 & r < 0.8 ] <- 2
# r[ r > 0.8 & r < 0.9 ] <- 3
# r4 <- r
# #plot(r, col=c("green","red","blue"), main="3004 old")
# #setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/split2")
# #writeRaster(r, "fnf3004_1.tif", overwrite = T)
# r <- raster(matrix(runif(225),15,15))
# r[ r > 0.9 ] <- NA
# r[ r > 0 & r < 0.5 ] <- 1
# r[ r > 0.5 & r < 0.8 ] <- 2
# r[ r > 0.8 & r < 0.9 ] <- 3
# r5 <- r
# #plot(r, col=c("green","red","blue"), main="3005 old")
# #setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/split2")
# #writeRaster(r, "fnf3005_1.tif", overwrite = T)

"-------------------------------------------------------------------------------" #PART 1 Reclassify----
"STEP 1. Reclassify ArcGIS-reclassified raster classes" #so .TIF (from ArcGIS) becomes .tif for the loops!
"-------------------------------------------------------------------------------"
# rm(list=ls()) #clear all
# setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/split/")
# #select raster names for the loop
# files = list.files(pattern="*.TIF") #select raster names for the loop
# # #reclassification matrix: from MapBiomas classes to Forest/Non-forest/Water/Cloud classes
# # rclmat <- matrix(NA,4,2) #create reclass matrix
# # rclmat[,1] <- c(0:3)
# # rclmat[1,2] <- NA #0 to "NA"
# # rclmat[2,2] <- 1  #forest
# # rclmat[3,2] <- 2  #non-forest
# # rclmat[4,2] <- 3  #water
#
# for (i in 1:length(files)) { #loop through raster bands (years 1997-2018)
#   setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/split/") #ArcGIS split rasters
#   r1 <- raster(files[[i]])
#   #r2 <- reclassify(r1, rclmat, filename='calc_tmp.grd', overwrite=TRUE)
#   setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/split2/") #new split R rasters
#   name <- strsplit(files[i], '.TIF')[[1]][1]
#   writeRaster(r1, filename = name, format='GTiff', datatype='INT1U', overwrite=TRUE)
#   #writeRaster(r2, filename = name, format='GTiff', datatype='INT1U', overwrite=TRUE)
#   print(name)
#   #file.remove(c('calc_tmp.grd', 'calc_tmp.gri'))
#   removeTmpFiles(h=0.5) #delete other potential temp files older than 1 hour
# }
#
# files = list.files(pattern="*.tif") #test
# for (i in 1:length(files)) {
#   plot(raster(files[[i]]))
#   print(raster(files[[i]]))
# }

"-------------------------------------------------------------------------------" #PART 2 Resolution----
"STEP 2. Decrease raster resolution with GDAL (not used)"
"-------------------------------------------------------------------------------"
# rm(list=ls()) #clear all
# require(gdalUtils)
# setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Reclassified/")
# files = list.files(pattern="*.tif") #select raster names for the loop
# files
# for (i in 1:length(files)) {
#   setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Reclassified/")
#   r1 <- raster(files[[i]])
#   writeRaster(r1, f <- tempfile(fileext = '.tif'), datatype = 'INT1U')
#   r2 <- gdalwarp(f, f2 <- tempfile(fileext = '.tif'), r ='mode', tr=res(r1)*2, output_Raster = TRUE)
#   setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Resampled/")
#  writeRaster(r2, filename = paste(files[[i]]), format='GTiff', datatype='INT1U', overwrite=TRUE)
#   print(files[i])
#   rm(r1, r2, f, f2)
#   #temp_files <- list.files("C:\\Users\\Thales\\AppData\\Local\\Temp", full.names = T)
#   #file.remove(temp_files)
# }

"-------------------------------------------------------------------------------" #PART 3 Replace cloud----
"STEP 3. Replace cloud pixels"
"-------------------------------------------------------------------------------"
rm(list=ls()) #clear all
#ignore "_5" and "_11" tiles because they have no data
names <- c("*_1.tif","*_2.tif","*_3.tif","*_4.tif","*_6.tif","*_7.tif","*_8.tif","*_9.tif","*_10.tif",
           "*_12.tif","*_13.tif","*_14.tif","*_15.tif","*_16.tif")#,"*_17.tif","*_18.tif","*_19.tif",
           #"*_20.tif","*_21.tif","*_22.tif","*_23.tif","*_24.tif","*_25.tif","*_26.tif","*_27.tif","*_28.tif")

for (j in 1:length(names)) { #each name in the list is a raster tile
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/split2/")
  files = list.files(pattern=names[j]) #select raster names for the loop
  #order needs to decrease here:
  files <- sort(files, decreasing = T)
  #OBS: the names will be the same, but the rasters will be overwritten and corrected for cloud
  for (i in 1:c(length(files)-1)) {
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/split2/")
    r1 <- raster(files[[i]]) #e.g. 2018
    r2 <- raster(files[[i+1]]) #e.g. 2017
    r3 <- overlay(r2, r1, fun = function(x, y) {
      x[ is.na(x) ] <- y[ is.na(x) ]; return(x) }, filename='over_tmp.grd', overwrite=TRUE) #replace NA in 2017 with value from 2018
    name <- strsplit(files[[i+1]], '.tif')[[1]][1]
    writeRaster(r3, filename = name, format='GTiff', datatype='INT1U', overwrite=TRUE) #overwrite fixed raster to be used in the next loop
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Cloud_1")
    name <- strsplit(name, 'fnf')[[1]][2]
    writeRaster(r3, filename = paste('cloud', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE) #for back up if needed
    print(name)
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/split2/")
    rm(r1, r2, r3)
    file.remove(c('over_tmp.grd', 'over_tmp.gri'))
  }
}
# setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Cloud_1") #plot test fake rasters
# plot(raster("cloud_3003_1.tif"), col=c("green","red","blue"), main = "3003 cloud1")
# plot(raster("cloud_3004_1.tif"), col=c("green","red","blue"), main = "3004 cloud1")


"-------------------------------------------------------------------------------" #PART 4 Apply cloud mask----
"STEP 4. Apply cloud mask based on the !!!second-to-last!!! mapped year"
"-------------------------------------------------------------------------------"
rm(list=ls()) #clear all
#ignore "_5" and "_11" tiles because they have no data
names <- c("*_1.tif","*_2.tif","*_3.tif","*_4.tif","*_6.tif","*_7.tif","*_8.tif","*_9.tif","*_10.tif",
           "*_12.tif","*_13.tif","*_14.tif","*_15.tif","*_16.tif")#,"*_17.tif","*_18.tif","*_19.tif",
           #"*_20.tif","*_21.tif","*_22.tif","*_23.tif","*_24.tif","*_25.tif","*_26.tif","*_27.tif","*_28.tif")
#final year tiles for the cloud mask
mask_tiles <- c("cloud_2017_1.tif","cloud_2017_2.tif","cloud_2017_3.tif","cloud_2017_4.tif","cloud_2017_6.tif","cloud_2017_7.tif",
                "cloud_2017_8.tif","cloud_2017_9.tif","cloud_2017_10.tif","cloud_2017_12.tif","cloud_2017_13.tif","cloud_2017_14.tif",
                "cloud_2017_15.tif","cloud_2017_16.tif")#,"cloud_2017_17.tif","cloud_2017_18.tif","cloud_2017_19.tif","cloud_2017_20.tif",
                #"cloud_2017_21.tif","cloud_2017_22.tif","cloud_2017_23.tif","cloud_2017_24.tif","cloud_2017_25.tif","cloud_2017_26.tif",
                #"cloud_2017_27.tif","cloud_2017_28.tif")
#mask_tiles <- c("cloud_3004_1.tif") #for fake rasters test

for (j in 1:length(names)) { #each name in the list is a raster tile
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Cloud_1")
  cloud_mask <- raster(mask_tiles[j]) #create a cloud mask based on the last mapped year and tile
  cloud_mask <- calc(cloud_mask, fun=function(x){ x[ !is.na(x) ] <- 0; return(x)}, filename='app1_tmp.grd', overwrite=TRUE)
  cloud_mask <- calc(cloud_mask, fun=function(x){ x[ is.na(x) ] <- 100; return(x)}, filename='app2_tmp.grd', overwrite=TRUE)

  #order is irrelevant here:
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Cloud_1")
  files = list.files(pattern=names[j]) #select raster names for the loop
  for (i in 1:c(length(files)-1)) {
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Cloud_1")
    r1 <- raster(files[[i]])
    #apply the cloud mask
    r2 <- overlay(r1, cloud_mask, fun=function(x,y) {return(x+y)}, filename='over1_tmp.grd', overwrite=TRUE)
    r2 <- calc(r2, fun=function(x){ x[ x > 99 ] <- NA; return(x)}, filename='over2_tmp.grd', overwrite=TRUE)
    name <- strsplit(files[[i]], 'cloud_')[[1]][2]
    name <- strsplit(name, '.tif')
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Cloud_2")
    writeRaster(r2, filename = paste('cloud2', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE) #for back up if needed
    print(name)
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Cloud_1")
    rm(r1, r2)
    file.remove(c('over1_tmp.grd','over1_tmp.gri','over2_tmp.grd','over2_tmp.gri')) #remove temp files created
  }
  rm(cloud_mask)
  file.remove(c('app1_tmp.grd','app1_tmp.gri','app2_tmp.grd','app2_tmp.gri')) #remove mask temp files created
}

for (j in 1:length(names)) { #each name in the list is a raster tile of the last mapped year
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Cloud_1")
  r <- raster(mask_tiles[j]) #reload the cloud mask based on the last mapped year and tile
  name <- strsplit(mask_tiles[j], 'cloud_')[[1]][2]
  name <- strsplit(name, '.tif')
  #save the cloud mask to the Cloud_2 folder to be used in the next steps
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Cloud_2")
  writeRaster(r, filename = paste('cloud2', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE)
  print(name)
  rm(r)
}
# par(mfrow=c(2,3)) #plot test fake rasters
# setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Cloud_1")
# plot(raster("cloud_3001_1.tif"), col=c("green","red","blue"), main = "3001 cloud1")
# plot(raster("cloud_3002_1.tif"), col=c("green","red","blue"), main = "3002 cloud1")
# plot(raster("cloud_3003_1.tif"), col=c("green","red","blue"), main = "3003 cloud1")
# setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Cloud_2")
# plot(raster("cloud2_3001_1.tif"), col=c("green","red","blue"), main = "3001 cloud2")
# plot(raster("cloud2_3002_1.tif"), col=c("green","red","blue"), main = "3002 cloud2")
# plot(raster("cloud2_3003_1.tif"), col=c("green","red","blue"), main = "3003 cloud2")


"-------------------------------------------------------------------------------" #PART 5 Replace water 1999->LAST----
"STEP 5. Fix water transition: from 1997 to last mapped year"
"-------------------------------------------------------------------------------"
# setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Cloud_2") #plot test fake rasters
# plot(raster("cloud2_3001_1.tif"), col=c("green","red","blue"), main = "3001 cloud2")
# plot(raster("cloud2_3002_1.tif"), col=c("green","red","blue"), main = "3002 cloud2")
# plot(raster("cloud2_3003_1.tif"), col=c("green","red","blue"), main = "3003 cloud2")
rm(list=ls()) #clear all
#ignore "_5" and "_11" tiles because they have no data
names <- c("*_1.tif","*_2.tif","*_3.tif","*_4.tif","*_6.tif","*_7.tif","*_8.tif","*_9.tif","*_10.tif",
           "*_12.tif","*_13.tif","*_14.tif","*_15.tif","*_16.tif")#,"*_17.tif","*_18.tif","*_19.tif",
           #"*_20.tif","*_21.tif","*_22.tif","*_23.tif","*_24.tif","*_25.tif","*_26.tif","*_27.tif","*_28.tif")

for (j in 1:length(names)) { #each name in the list is a raster tile
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Cloud_2") #copy the 1999 map to the Water_1 folder
  #order needs to increase here:
  files = list.files(pattern=names[j]) #select raster names for the loop
  r <- raster(files[1])
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_1") #save first year to Water_1 folder for the water mask loop
  name <- strsplit(files[1], 'cloud2_')[[1]][2]
  name <- strsplit(name, '.tif')
  writeRaster(r, filename = paste('water', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE)
  rm(r)

    #OBS: the names will be the same, but the rasters will be overwritten and corrected for water fluctuation for the next loop
    for (i in 1:c(length(files)-1)) {
      setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Cloud_2")
      r1 <- raster(files[[i]])
      r2 <- raster(files[[i+1]])
      r3 <- overlay(r2, r1, fun = function(x, y) {
        x[x != 3 & y == 3] <- 3; x}, filename='over_tmp.grd', overwrite=TRUE) #1 = forest, 3 = water
      name <- strsplit(files[[i+1]], 'cloud2_')[[1]][2]
      name <- strsplit(name, '.tif')
      writeRaster(r3, filename = paste('cloud2', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE) #overwrite fixed raster to be used in the next loop
      setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_1")
      writeRaster(r3, filename = paste('water', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE) #for back up if needed
      print(name)
      setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Cloud_2")
      rm(r1, r2, r3)
      file.remove(c('over_tmp.grd', 'over_tmp.gri'))
    }
  removeTmpFiles(h=1) #delete other potential temp files older than 1 hour
}
# setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_1") #plot test fake rasters
# plot(raster("water_3001_1.tif"), col=c("green","red","blue"), main = "3001 water1")
# plot(raster("water_3002_1.tif"), col=c("green","red","blue"), main = "3002 water1")
# plot(raster("water_3003_1.tif"), col=c("green","red","blue"), main = "3003 water1")

"-------------------------------------------------------------------------------" #PART 6 Apply water mask----
"STEP 6. Apply water mask based on the last mapped year"
"-------------------------------------------------------------------------------"
# par(mfrow=c(2,3)) #plot test fake rasters
# setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_1")
# plot(raster("water_3002_1.tif"), col=c("green","red","blue"), main = "3002 water1")
# plot(raster("water_3003_1.tif"), col=c("green","red","blue"), main = "3003 water1")
# plot(raster("water_3004_1.tif"), col=c("green","red","blue"), main = "3004 water1")
rm(list=ls()) #clear all
#ignore "_5" and "_11" tiles because they have no data
names <- c("*_1.tif","*_2.tif","*_3.tif","*_4.tif","*_6.tif","*_7.tif","*_8.tif","*_9.tif","*_10.tif",
           "*_12.tif","*_13.tif","*_14.tif","*_15.tif","*_16.tif","*_17.tif","*_18.tif","*_19.tif")#,
           #"*_20.tif","*_21.tif","*_22.tif","*_23.tif","*_24.tif","*_25.tif","*_26.tif","*_27.tif","*_28.tif")
#final year tiles for the cloud mask
mask_tiles <- c("water_2017_1.tif","water_2017_2.tif","water_2017_3.tif","water_2017_4.tif","water_2017_6.tif",
                "water_2017_7.tif","water_2017_8.tif","water_2017_9.tif","water_2017_10.tif","water_2017_12.tif",
                "water_2017_13.tif","water_2017_14.tif","water_2017_15.tif","water_2017_16.tif","water_2017_17.tif",
                "water_2017_18.tif","water_2017_19.tif")#,"water_2017_20.tif","water_2017_21.tif","water_2017_22.tif",
                #"water_2017_23.tif","water_2017_24.tif","water_2017_25.tif","water_2017_26.tif","water_2017_27.tif",
                #"water_2017_28.tif")
#mask_tiles <- c("water_3004_1.tif") #for fake rasters test

for (j in 1:length(names)) { #each name in the list is a raster tile
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_1")
  #order is irrelevant here:
  water_mask <- raster(mask_tiles[j]) #create a water mask based on the last mapped year and tile
  water_mask <- calc(water_mask, fun=function(x){ x[ x != 3 ] <- 0; return(x)}, filename='app1_tmp.grd', overwrite=TRUE)
  water_mask <- calc(water_mask, fun=function(x){ x[ x == 3 ] <- 100; return(x)}, filename='app2_tmp.grd', overwrite=TRUE)

  #order is irrelevant here:
  files = list.files(pattern=names[j]) #select raster names for the loop
  for (i in 1:c(length(files)-1)) {
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_1")
    r1 <- raster(files[[i]])
    #apply the water mask
    r2 <- overlay(r1, water_mask, fun=function(x,y) {return(x+y)}, filename='over1_tmp.grd')
    r2 <- calc(r2, fun=function(x){ x[ x > 99 ] <- 3; return(x)}, filename='over2_tmp.grd', overwrite=TRUE)
    name <- strsplit(files[[i]], 'water_')[[1]][2]
    name <- strsplit(name, '.tif')
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_2")
    writeRaster(r2, filename = paste('water2', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE) #for back up if needed
    print(name)
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_1")
    rm(r1, r2)
    file.remove(c('over1_tmp.grd','over1_tmp.gri','over2_tmp.grd','over2_tmp.gri')) #remove temp files created
    removeTmpFiles(0.5)
  }

  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_1")
  rm(water_mask)
  file.remove(c('app1_tmp.grd','app1_tmp.gri','app2_tmp.grd','app2_tmp.gri')) #remove mask temp files created
}

for (j in 1:length(names)) { #each name in the list is a raster tile of the last mapped year
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_1")
  r <- raster(mask_tiles[j]) #reload the cloud mask based on the last mapped year and tile
  name <- strsplit(mask_tiles[j], 'water_')[[1]][2]
  name <- strsplit(name, '.tif')
  #save the cloud mask to the Cloud_2 folder to be used in the next steps
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_2")
  writeRaster(r, filename = paste('water2', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE)
  print(name)
  rm(r)
}
# setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_2") #plot test fake rasters
# plot(raster("water2_3002_1.tif"), col=c("green","red","blue"), main = "3002 water2")
# plot(raster("water2_3003_1.tif"), col=c("green","red","blue"), main = "3003 water2")
# plot(raster("water2_3004_1.tif"), col=c("green","red","blue"), main = "3004 water2")


"-------------------------------------------------------------------------------" #PART 7 Fix misdeforestation----
"STEP 7. Fix Forest-to-Deforestation-to-Forest transition"
"-------------------------------------------------------------------------------"
# par(mfrow=c(2,4)) #plot test fake rasters
# setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_2")
# plot(raster("water2_3001_1.tif"), col=c("green","red","blue"), main = "3001 water2")
# plot(raster("water2_3002_1.tif"), col=c("green","red","blue"), main = "3002 water2")
# plot(raster("water2_3003_1.tif"), col=c("green","red","blue"), main = "3003 water2")
# plot(raster("water2_3004_1.tif"), col=c("green","red","blue"), main = "3004 water2")
rm(list=ls()) #clear all
#copy the lastest mapped year (ignored in the previous steps) to help with the filtering: 
setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/split2")
tiles_last_y = list.files(pattern="2018") #last year
for (j in 1:length(tiles_last_y)) { #each name in the list is a raster tile of the first and last mapped year
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/split2")
  r <- raster(tiles_last_y[j])
  name <- strsplit(tiles_last_y[j], 'fnf')[[1]][2]
  name <- strsplit(name, '.tif')
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_2")
  writeRaster(r, filename = paste('water2', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE)
  print(name)
  rm(r)
}

#ignore "_5" and "_11" tiles because they have no data
names <- c("*_1.tif","*_2.tif","*_3.tif","*_4.tif","*_6.tif","*_7.tif","*_8.tif","*_9.tif","*_10.tif",
           "*_12.tif","*_13.tif","*_14.tif","*_15.tif","*_16.tif","*_17.tif","*_18.tif","*_19.tif")#,
#"*_20.tif","*_21.tif","*_22.tif","*_23.tif","*_24.tif","*_25.tif","*_26.tif","*_27.tif","*_28.tif")

for (j in 1:length(names)) { #each name in the list is a raster tile
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/water_2") #copy the first and last mapped years to the Fix_1 folder
  #order needs to increase here:
  files = list.files(pattern=names[j]) #select raster names for the loop

####### R1-R2-R3-R4 FILTER ####### this will cascade into the R1-R2-R3 filter!
  for (i in 1:c(length(files)-3)) {
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_2")
    r1 <- raster(files[[i]])
    r2 <- raster(files[[i+1]])
    r3 <- raster(files[[i+2]])
    r4 <- raster(files[[i+3]])
    r5 <- overlay(r1, r2, r3, r4, fun = function(x, y, z, w) {
      y[ x == 1 & y == 2 & z == 2 & w == 1 ] <- 1; y}, filename='over_tmp.grd', overwrite=TRUE) #1 = forest, 2 = non-forest
    name <- strsplit(files[[i+1]], 'water2_')[[1]][2]
    name <- strsplit(name, '.tif')
    #OBS: the names will be the same, but the rasters will be overwritten and corrected for misdeforestation in the next loop #
    writeRaster(r5, filename = paste('water2', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE) #overwrite fixed raster to be used in the next loop
    print(paste("R1-R4 FILTER", name, sep = ": "))
    rm(r1, r2, r3, r4, r5)
    file.remove(c('over_tmp.grd', 'over_tmp.gri'))
  }

# } #plot test fake rasters
# plot(raster("water2_3001_1.tif"), col=c("green","red","blue"), main = "3001 water2")
# plot(raster("water2_3002_1.tif"), col=c("green","red","blue"), main = "3002 water2")
# plot(raster("water2_3003_1.tif"), col=c("green","red","blue"), main = "3003 water2")
# plot(raster("water2_3004_1.tif"), col=c("green","red","blue"), main = "3004 water2")

####### R1-R2-R3 FILTER #######
  #OBS: the names will be the same, but the rasters will be overwritten and corrected for misdeforestation in the next loop
  for (i in 1:c(length(files)-2)) {
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_2")
    r1 <- raster(files[[i]])   #e.g. 2000
    r2 <- raster(files[[i+1]]) #e.g. 2001
    r3 <- raster(files[[i+2]]) #e.g. 2002
    r4 <- overlay(r1, r2, r3, fun = function(x, y, z) {
      y[x == 1 & y == 2 & z == 1] <- 1; y}, filename='over_tmp.grd', overwrite=TRUE) #1 = forest, 2 = non-forest
    name <- strsplit(files[[i+1]], 'water2_')[[1]][2]
    name <- strsplit(name, '.tif')
    writeRaster(r4, filename = paste('water2', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE) #overwrite fixed raster to be used in the next loop
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Fix_1") 
    writeRaster(r4, filename = paste('fix1', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE) #for back up if needed
    print(paste("R1-R3 FILTER", name, sep = ": "))
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_2")
    rm(r1, r2, r3, r4)
    file.remove(c('over_tmp.grd', 'over_tmp.gri'))
  }
}

#safe the first and last year tiles to the Fix_1 folder
setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_2")
# tiles_first_y = list.files(pattern="3001") #plot test fake rasters
# tiles_last_y = list.files(pattern="3004")
tiles_first_y = list.files(pattern="1997") #first year
tiles_last_y = list.files(pattern="2018") #last year

for (j in 1:length(names)) { #each name in the list is a raster tile of the first and last mapped year
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_2")
  r <- raster(tiles_first_y[j])
  name <- strsplit(tiles_first_y[j], 'water2_')[[1]][2]
  name <- strsplit(name, '.tif')
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Fix_1")
  writeRaster(r, filename = paste('fix1', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE)
  print(name)
  rm(r)
  
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Water_2")
  r <- raster(tiles_last_y[j])
  name <- strsplit(tiles_last_y[j], 'water2_')[[1]][2]
  name <- strsplit(name, '.tif')
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Fix_1")
  writeRaster(r, filename = paste('fix1', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE)
  print(name)
  rm(r)
}
# setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Fix_1") #plot test fake rasters
# plot(raster("fix1_3001_1.tif"), col=c("green","red","blue"), main = "3001 fix1")
# plot(raster("fix1_3002_1.tif"), col=c("green","red","blue"), main = "3002 fix1")
# plot(raster("fix1_3003_1.tif"), col=c("green","red","blue"), main = "3003 fix1")
# plot(raster("fix1_3004_1.tif"), col=c("green","red","blue"), main = "3004 fix1")


"-------------------------------------------------------------------------------" #PART 8 Remove reforestation----
"STEP 8. Remove reforestation transition"
"-------------------------------------------------------------------------------"
# setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Fix_1") #plot test fake rasters
# plot(raster("fix1_3001_1.tif"), col=c("green","red","blue"), main = "3001 fix1")
# plot(raster("fix1_3002_1.tif"), col=c("green","red","blue"), main = "3002 fix1")
# plot(raster("fix1_3003_1.tif"), col=c("green","red","blue"), main = "3003 fix1")
# plot(raster("fix1_3004_1.tif"), col=c("green","red","blue"), main = "3004 fix1")

rm(list=ls()) #clear all
#ignore "_5" and "_11" tiles because they have no data
names <- c("*_1.tif","*_2.tif","*_3.tif","*_4.tif","*_6.tif","*_7.tif","*_8.tif","*_9.tif","*_10.tif",
           "*_12.tif","*_13.tif","*_14.tif","*_15.tif","*_16.tif","*_17.tif","*_18.tif","*_19.tif")#,
           #"*_20.tif","*_21.tif","*_22.tif","*_23.tif","*_24.tif","*_25.tif","*_26.tif","*_27.tif","*_28.tif")

for (j in 1:length(names)) { #each name in the list is a raster tile
  setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Fix_1") #copy the first and last mapped years to the Fix_1 folder
  #order needs to increase here:
  files = list.files(pattern=names[j]) #select raster names for the loop
  #OBS: the names will be the same, but the rasters will be overwritten and corrected for misdeforestation in the next loop
  for (i in 1:c(length(files)-1)) {
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Fix_1")
    r1 <- raster(files[[i]]) #e.g. 1997
    r2 <- raster(files[[i+1]]) #e.g. 1998
    r3 <- overlay(r2, r1, fun = function(x, y) { #the file order is odd but it works
      x[x == 1 & y == 2] <- 2; x}, filename='over_tmp.grd', overwrite=TRUE) #1 = forest, 2 = non-forest
    name <- strsplit(files[[i+1]], 'fix1_')[[1]][2]
    name <- strsplit(name, '.tif')
    writeRaster(r3, filename = paste('fix1', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE) #overwrite fixed raster to be used in the next loop
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Fix_2")
    writeRaster(r3, filename = paste('fix2', name, sep = '_'), format='GTiff', datatype='INT1U', overwrite=TRUE) #for back up if needed
    print(name)
    setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Fix_1")
    rm(r1, r2, r3)
    file.remove(c('over_tmp.grd', 'over_tmp.gri'))
  }
}
# setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Fix_2") #plot test fake rasters
# plot(raster("fix2_3002_1.tif"), col=c("green","red","blue"), main = "3002 fix2")
# plot(raster("fix2_3003_1.tif"), col=c("green","red","blue"), main = "3003 fix2")
# plot(raster("fix2_3004_1.tif"), col=c("green","red","blue"), main = "3004 fix2")


"-------------------------------------------------------------------------------" #PART 9 Annual deforestation----
"STEP 9. Calculate annual deforestation"
"-------------------------------------------------------------------------------"
rm(list=ls()) #clear all
#ignore _5" and "_11"tiles because they have no data
names <- c("*_1.tif","*_2.tif","*_3.tif","*_4.tif","*_6.tif","*_7.tif","*_8.tif","*_9.tif","*_10.tif",
           "*_12.tif","*_13.tif","*_14.tif","*_15.tif","*_16.tif","*_17.tif","*_18.tif","*_19.tif")#,
           #"*_20.tif","*_21.tif","*_22.tif","*_23.tif","*_24.tif","*_25.tif","*_26.tif","*_27.tif","*_28.tif")

setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/Fix_2")

def <- as.data.frame(matrix(NA, 0, 4))
colnames(def) <- c("value","count","year","tile") 

#loop to compute pixel frequencies
for (j in 1:length(names)) { #each name in the list is a raster tile
  files = list.files(pattern=names[j]) #select raster names for the loop

  for (i in 1:length(files)) {
    temp <- as.data.frame(freq(raster(files[[i]])))
    #starts in 1999?
    temp$year <- 1997 + i
    name <- strsplit(names[j], '.tif')[[1]][1]
    name <- strsplit(name, '*_')[[1]][2]
    temp$tile <- name
    def <- rbind(def, temp)
    #starts in 1999?
    print(paste(c(1997 + i), name, sep = ": Tile "))
  }
}

setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/")
#write.csv(def, "mapbiomas_v4_def_1.csv")

"-------------------------------------------------------------------------------" #PART 9 Annual deforestation----
"STEP 10. Annual deforestation plot"
"-------------------------------------------------------------------------------"
require(plyr)
require(Hmisc)
setwd("C:/Users/WestT/OneDrive - scion/Desktop/Mapbiomas_4.1/")
#def <- read.csv("mapbiomas_v4_def_1.csv")
def <- read.csv("mapbiomas_v4_def_1.csv")#read.csv("mapbiomas_v4_def_2.csv")
def$year <- def$year + 1
#def <- rbind(def, def2)
def <- subset(def, value == 1)
def <- ddply(.data=def, .(year), .fun=summarise, count = sum(count, na.rm=T))
def$lag <- Lag(def$count, 1)
def$def <- def$lag - def$count

require(ggplot2)
ggplot(subset(def, year > 1999 & year <= 2017), aes(x=year, y=def*0.0009)) + geom_line() + #theme_bw() +
  labs(y = expression("Deforestation (km"^2*")"), x ="Year") +
  scale_x_continuous(breaks = c(2000,2002,2004,2006,2008,2010,2012,2014,2016))

# setwd("C:/Users/Thales/Desktop/Mapbiomas")
# #write.csv(def, "def_mapbiomas_v4.csv")
# write.csv(def, "def_mapbiomas_v4_nofilter.csv")
# 
# setwd("C:/Users/Thales/Desktop/Mapbiomas")
# v4 <- read.csv("def_mapbiomas_v4.csv")
# v4 <- v4[,-c(1,3,4)]
# v4$source <- "MapBiomas v.4: filter"
# colnames(v4) <- c("year", "def", "source")
# v4$def <- v4$def * 0.0625
# 
# v4_nofilter <- read.csv("def_mapbiomas_v4_nofilter.csv")
# v4_nofilter <- v4_nofilter[,-c(1,3,4)]
# v4_nofilter$source <- "MapBiomas v.4: no filter"
# colnames(v4_nofilter) <- c("year", "def", "source")
# v4_nofilter$def <- v4_nofilter$def * 0.0625
# d <- rbind(v4, v4_nofilter)
# 
# setwd("C:/Users/Thales/Dropbox/REDD Impact")
# v3 <- read.csv("MapBiomas_vs_PRODES.csv")
# colnames(v3) <- c("year", "def", "source")
# 
# d <- rbind(v3, v4)
# 
# 
"-------------------------------------------------------------------------------" #PART 10 Municipality numbers----
"STEP 12. Calculate the  area of forest in each municipality and each year"
"-------------------------------------------------------------------------------"
# rm(list=ls()) #clear all
# require(raster)
# #setwd("F:/Data/Forest cover datasets/MapBiomas/Colection 3 - Amazonia stack 1985-2017/Final/Municipalities")
# setwd("//cifs5200/USER/WestT/Documents/Desktop/Mapbiomas")
# munic <- raster("munic2")
# #writeRaster(munic, filename = "munic.tiff")
# #freq(munic)
#
# setwd("//cifs5200/USER/WestT/Documents/Desktop/Mapbiomas/Final_2/")
# files = list.files(pattern="*.tif") #select raster names for the loop
#
# r <- raster(files[1]) #structure for the loop
# r[ r != 1 ] <- 0
# res <- as.data.frame(zonal(r, munic, fun=sum, na.rm=T))
#
# for (i in 2:length(files)){
#   r <- raster(files[[i]])
#   r[ r != 1 ] <- 0
#   res[,c(i+1)] <- zonal(r, munic, fun=sum, na.rm=T)[,2]
# }
# colnames(res) <- c("munic",1997:2017)
#
# 4182443.05 #km2 Amazon biome area
# 0.06109761 #conversion factor
# 0.0625 #or this one
#
# #copy municipality code
# res$code <- levels(munic)[[1]][,3]
#
# #setwd("F:/Data/Forest cover datasets/MapBiomas/Colection 3 - Amazonia stack 1985-2017")
# write.csv(res, file = "jill_new_mapbiomas_munic.csv")

"-------------------------------------------------------------------------------" #PART 11 Results summary----
"STEP 12. Summary of results"
"-------------------------------------------------------------------------------"
#
# rm(list=ls()) #clear all
# require(reshape)
# require(plyr)
# #setwd("C:/Users/Thales/Desktop/Mapbiomas")
# setwd("F:/Data/Forest cover datasets/MapBiomas/Colection 3 - Amazonia stack 1985-2017/")
# res <- read.csv("forest_cover_results.csv")
# res <- res[,-1]
# res$munic <- as.factor(res$munic)
# data <- melt(res, id=c("munic"))
# colnames(data) <- c("munci", "year", "forest_pixel")
# data$forest_km2 <- data$forest_pixel * 0.06109761 #from pixel to km2
# data2 <- ddply(.data=data, .(year),.fun=summarise, forest = sum(forest_km2 , na.rm=T))
#
# require(DataCombine) #package to create lagged variable
# def <- slide(data2, Var = "forest", slideBy = -1)
# def$def <- (def[,2] - def[,3]) * -1
# plot(def$year, def$def)
#
# write.csv(data, file = "forest_cover_munic_km2.csv")
