FILENAME CSV "/home/u63246706/Datasets/ChatGPT.csv";
PROC IMPORT DATAFILE=CSV
		    OUT=Cgpt
		    DBMS=CSV
		    REPLACE;
RUN;
PROC PRINT DATA=Cgpt;
RUN;

Data Cgpt;
set Cgpt;
if user_verified= 'False' then _user_verified = 0;
else if user_verified= 'True' then _user_verified = 1;
drop user_verified;
run;


/*** LogReg for the survived variable with all the ind. variables ***/
Proc logistic data=Cgpt;
model survived (event='1')= positive_prob neutral_prob negative_prob topic_business topic_cybersecurity topic_ecommerce topic_economics topic_education
 topic_engineering topic_health topic_investment topic_literature topic_other topic_productivity topic_realestate topic_renewableenergy topic_safety topic_technology
 topic_tennis topic_weatherupdate topic_environment _user_verified followersCount friendsCount retweetCount likeCount power_value/rsquare;
run;


/*** LogReg for survived variable with all topics ind. variables ***/
Proc logistic data=Cgpt;
model survived (event='1')= topic_business topic_cybersecurity topic_ecommerce topic_economics topic_education
 topic_engineering topic_health topic_investment topic_literature topic_other topic_productivity topic_realestate topic_renewableenergy topic_safety topic_technology
 topic_tennis topic_weatherupdate topic_environment/rsquare;
run;

/*** LogReg for survived variable with metadata ind. variables ***/
Proc logistic data=Cgpt;
model survived (event='1')= _user_verified followersCount friendsCount retweetCount likeCount power_value/rsquare;
run;


/*** User Verified LogReg with all topics ind. variables ***/
proc logistic data=Cgpt;
model _user_verified (event='1') = topic_business topic_cybersecurity topic_ecommerce topic_economics topic_education
 topic_engineering topic_health topic_investment topic_literature topic_other topic_productivity topic_realestate topic_renewableenergy topic_safety topic_technology
 topic_tennis topic_weatherupdate topic_environment/rsquare;
run;


/*** LinReg for survived with all the ind. variables ***/
proc reg data=Cgpt;
model survived = positive_prob neutral_prob negative_prob topic_business topic_cybersecurity 
				topic_ecommerce topic_economics topic_education topic_engineering topic_health 
				topic_investment topic_literature topic_other topic_productivity topic_realestate 
				topic_renewableenergy topic_safety topic_technology topic_tennis topic_weatherupdate 
				topic_environment _user_verified followersCount friendsCount retweetCount likeCount 
				power_value/vif;
run;


/*** LinReg for survived with meta data ind. variables that explain majority of the variance
in the PCA ***/
proc reg data=Cgpt;
model survived = _user_verified followersCount friendsCount/vif;
run;


/*** Like Count and LinReg with other meta metrics with high variance according to PCA + survived ***/
proc reg data=Cgpt;
model likeCount = _user_verified followersCount friendsCount survived/vif;
run;


/*** Like Count LinReg with the Sentiment Analysis variables ***/
proc reg data=Cgpt;
model likeCount = positive_prob neutral_prob negative_prob/vif;
run;


/*** PCA princomp with all ind. variables ***/
proc princomp data = Cgpt;
var positive_prob neutral_prob negative_prob topic_business topic_cybersecurity 
	topic_ecommerce topic_economics topic_education topic_engineering topic_health 
	topic_investment topic_literature topic_other topic_productivity topic_realestate 
	topic_renewableenergy topic_safety topic_technology topic_tennis topic_weatherupdate 
	topic_environment _user_verified followersCount friendsCount retweetCount likeCount 
	power_value;
run;


/*** PCA princomp with meta data ind. variables ***/
proc princomp data = Cgpt;
var _user_verified followersCount friendsCount retweetCount likeCount;
run;


/*** PCA princomp with Sentiment Analysis variables ***/
proc princomp data = Cgpt;
var positive_prob neutral_prob negative_prob;
run;


/*** PCA princomp with all topics variables ***/
proc princomp data = Cgpt;
var topic_business topic_cybersecurity topic_ecommerce topic_economics topic_education
 topic_engineering topic_health topic_investment topic_literature topic_other topic_productivity topic_realestate topic_renewableenergy topic_safety topic_technology
 topic_tennis topic_weatherupdate topic_environment;
run;
