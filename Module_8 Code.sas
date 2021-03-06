/*****************************************************************************/
/* Accessibility and quality of care, 2016
/*
/* Total number of visits to a medical office for care, 2016
/*
/* Example SAS code to replicate number and percentage of people who visited a medical
/*  office by poverty status greater than 0
/*
/* Input file: /folders/myshortcuts/Myfolders/Data/Module 8/h192.ssp (2016 full-year consolidated)
/*****************************************************************************/

ods graphics off;

/* Load FYC file *************************************************************/

FILENAME h192 "/folders/myshortcuts/Myfolders/Data/Module 8/h192.ssp";
proc xcopy in = h192 out = WORK IMPORT;
run;

/* Define variables **********************************************************/

data MEPS;
  	SET h192;

 /* People visiting a medical office  */
		poverty_care = (ADAPPT42 > 0);
run;

proc format;
  value poverty_care
	  <1 = "One or more visits"
	  0 = "No visits in past year";

  value POVCAT
	  1 = "Negative or poor"
	  2 = "Near-poor"
	  3 = "Low income"
	  4 = "Middle income"
	  5 = "High income";
run;

/* Calculate estimates using survey procedures *******************************/

ods output CrossTabs = out;
proc surveyfreq data = MEPS missing;
	FORMAT poverty_care poverty_care. POVCAT16 POVCAT.;
	STRATA VARSTR;
	CLUSTER VARPSU;
	WEIGHT PERWT16F;
	TABLES POVCAT16*poverty_care / row;
run;

proc print data = out noobs label;
	where poverty_care ne . and POVCAT16 ne .;
	var poverty_care POVCAT16 WgtFreq StdDev RowPercent RowStdErr;
run;