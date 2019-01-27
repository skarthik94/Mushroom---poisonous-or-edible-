# Mushroom---poisonous-or-edible-
Introduction

Mushrooms are a common food that is regularly consumed but not all mushrooms are edible. It is estimated that there are 5.1 million different species of mushrooms. Of the known species:
•	20% are poisonous
•	1% are deadly
•	1% are psychoactive
•	78% are non-toxic

The objective of this project was to create a model that would accurately be able to predict whether a mushroom is edible or poisonous. In addition to that I wanted to find out which physical characteristics of a mushroom would indicate most clearly whether a mushroom is edible or poisonous. This is a binary classification problem. I wanted to compare the performances of different algorithms on the same data.


Methods

The dataset was found on Kaggle and was originally on the UCI Machine Learning Repository. It has 8124 observations and 23 columns. Out of the 23 columns, one of is the feature ‘class’ which is the target variable. There are two levels in the target variable namely ‘e’ for edible and ‘p’ for poisonous. Deadly and psychoactive mushrooms also get lumped in with ‘p’. There is a nearly even split between poisonous and edible mushrooms (52/48) hence, no oversampling is needed. The data is very clean; there is no missing data. All the variables are categorical.

The variables are:
•	class (edible=e, poisonous=p)
•	cap-shape (bell=b, conical=c, convex=x, flat=f, knobbed=k, sunken=s)
•	cap-surface (fibrous=f, grooves=g, scaly=y, smooth=s)
•	cap-color (brown=n, buff=b, cinnamon=c, gray=g, green=r, pink=p, purple=u, red=e, white=w, yellow=y)
•	bruises (bruises=t, no=f)
•	odor (almond=a, anise=l, creosote=c, fishy=y, foul=f, musty=m, none=n, pungent=p, spicy=s)
•	gill-attachment (attached=a, descending=d, free=f, notched=n)
•	gill-spacing (close=c, crowded=w, distant=d)
•	gill-size (broad=b, narrow=n)
•	gill-color (black=k, brown=n, buff=b, chocolate=h, gray=g, green=r, orange=o, pink=p, purple=u, red=e, white=w, yellow=y)
•	stalk-shape (enlarging=e, tapering=t) 
•	stalk-root (bulbous=b, club=c, cup=u, equal=e, rhizomorphs=z, rooted=r, missing=?)
•	stalk-surface-above-ring (fibrous=f, scaly=y, silky=k, smooth=s)
•	stalk-surface-below-ring (fibrous=f, scaly=y, silky=k, smooth=s)
•	stalk-color-above-ring (brown=n, buff=b, cinnamon=c, gray=g, orange=o, pink=p, red=e, white=w, yellow=y)
•	stalk-color-below-ring (brown=n, buff=b, cinnamon=c, gray=g, orange=o, pink=p, red=e, white=w, yellow=y)
•	veil-type (partial=p, universal=u)
•	veil-color (brown=n, orange=o, white=w, yellow=y)
•	ring-number (none=n, one=o, two=t)
•	ring-type (cobwebby=c, evanescent=e, flaring=f, large=l, none=n, pendant=p, sheathing=s, zone=z)
•	spore-print-color (black=k, brown=n, buff=b, chocolate=h, green=r, orange=o, purple=u, white=w, yellow=y)
•	population (abundant=a, clustered=c, numerous=n, scattered=s, several=v, solitary=y)
•	habitat (grasses=g, leaves=l, meadows=m, paths=p, urban=u, waste=w, woods=d)

The first thing I did was to check correlation using the Goodman and Kruskal’s Tau test. “gill-attachment” and “stalk-shape” had a very low correlation to “class” hence I removed them. The variable “odor” had a 0.943 correlation to “class”. It will be very important to the model. No other variables were prominent.
After this by inspecting the occurrence of each level within each variable, I was able to eliminate “veil-type” as all the observations had the value of this as “partial”.
My next step was to use the variable importance in randomForest to see what variables were important to the model and further use that information for variable selection.

Based on this graph, I decided to use only the first 5 variables, namely “odor”, “spore.print.color”, “gill.color”, “gill.size” and “ring.type” in the models. It can be seen that “odor” is by far the most important variable. I also noted that the model had a 0% OOB error.

In addition to this particular dataframe, I made another dataframe with dummy variables of every level of every variable that is still left so I could create a model using neural networks.

The algorithms I used are randomForest, neural networks and XGboost. 

Results and Discussion

The first model I tried to use was randomForest. Given the tree structure of the algorithm and my dataset having all categorical variables, I thought this would be a very good fit. Without any tuning and using the default mtry value (sqrt(number of features) = sqrt(5) ≃ 2), I got a 0.02% OOB error. After tuning using the tuneRF function that is within the same library (mtry = 4), I got a 0% OOB error.

I then ran a neural network with 2 hidden layers of 5 and 2 neurons respectively. Instead of using a testing and training set, I decided to do a 10-fold cross validation. There was a 0% error with this.

The last model I ran was XGboost. By tuning it and checking the test error using 5 fold cross validation (using the in-library xgb.cv() function, I got a 0% error.

Given that by merely passing all the data before data preparation I was able to get a 0% OOB error, it is not surprising that after preparing the data further the 0% error remained so across different algorithms. This is largely due to the variable “odor” (correlation to “class” was seen to be 0.943) and that all of the selected variables had levels that tended completely or partially to a particular class. For “odor”, given that there’s an odor, you can definitively say whether a mushroom is edible or not. If there’s no odor, it’s generally edible (96%) but that’s not certain. 

odor	almond	anise	creosote	fishy	foul	musty	none	pungent	spicy
edible or poisonous	all edible	all edible	all poisonous	all poisonous	all poisonous	all poisonous	96% edible	all poisonous	all poisonous

For “spore.print.color”, “gill.color”, “gill.size” and “stalk.surface.above.ring” every level tends to be completely or at least tend to edible or poisonous. These variables theoretically could help classify a mushroom in case there is a no odor. This is what has happened in the models.

Even though the models were all completely accurate, the size of the dataset (8124) compared to the actual estimated number of species (5.1 million) might render these models useless when used to check species outside of the dataset.


Conclusions

The models were all 100% accurate based on the dataset but whether or not they would work on the larger population of mushrooms is to be seen. We do not have the data for this readily available.
The odor of the mushroom was found to be the most important identifier to whether a mushroom is edible or poisonous. Mushrooms without an odor are largely edible but other characteristics can be used to confirm or refute this.
