# CodeBook

## tidyData.csv

The following variables are in this dataset:

* **subject**: an identifier for the subject who carried out the experiment. It has a range from 1 to 30.
                Each subject is between 19-48 years of age and performed six activities wearing a smartphone
                on the waist.
* **activity**: a label describing the type of activity the subject did. Can be one of the following values:
                WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
* **signal**: the type of signal measured:
                The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc and tGyro. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc and tGravityAcc) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
                Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk and tBodyGyroJerk). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
                Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc, fBodyAccJerk, fBodyGyro, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 
* **axis**: the axis in three dimensional space the measurement is for, either "X", "Y" or "Z".
* **mean**: The mean of these values for this observation.
* **std**: The std deviation of these values for this observation.
* **type**: either "train" or "test". marks whether this value originally came from the "test" dataset or
            the "train" dataset.

## tidyAverages.csv

* **subject**: See **subject** above in tidyData.csv.
* **activity**: See **activity** above in tidyData.csv.
* **signal**: See **signal** above in tidyData.csv.
* **axis**: See **axis** above in tidyData.csv.
* **averageMean**: The average value of every mean for the associated subject, activity, signal and axis.
* **averageStd**: The average value of every std deviation for the associated subject, activity, signal
                    and axis.

