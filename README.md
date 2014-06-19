SpectralTrainFig
================

#### Overview
SpectralTrainFig is a graphical user interface that allows a user to select a folder of EDF/XML files to process. The GUI is configured to apply spectral analysis to the electroencephlography signal (EEG). The default spectral analysis parameters include 10x4 second sub-epochs with a 50% tukey window. Alternatively the user can set the spectral analysis parameters to the ones used for the SHHS study (6x5 second with Hanning window). The user can adjust the artifact detection thresholds, which are preset to reccomended values.  SpectralTrainFig is a user friendly approach to the SpectralAnalysisClass function which provides access to 56 parameters (artifact detection, spectral analysis, and figure configurations). The output includes EXCEL and PowerPoint summaries which are configured by user defined settings and specified spectral bands. Detail epoch by epoch and subject summaries are provided for both NREM and REM states.  

#### Technical Overview
The functional component of the GUI is implemented as a single class, which builds on the abilityhData Access and Visaulization (DAVS) Toolbox  data loading function. Ease of use,  to integrate within the research environment and computational speed guided the development. The Class format inclu

### Parameters

##### Description
*Analysis Description*. Enter a brief analysis description.

*Output File Prefix*. Enter a prefix, which will be used to start each file written by the program.

*Data Folder*. Select a folder containing EDF and XML files
Results Folder. Select a folder to write program generated file to.

##### Analysis Parameters
*Analysis Signals*. Enter signal labels that are to be analyzed as a cell string (ex. {'C3', 'C2', 'C3-A1'}. The signal labels are written in the EDF file.  Use your favorite EDF utility to determine the signal labels.  You can use [SignalRasterViewerFig]{} to list the signal labels and to view the signals.

*Reference Signals*. Enter teh labels of the reference signals as a cell string (ex. {'A1', 'M1', 'M2'}).

*Reference Methods*.  Select one of three approaches to referening the signal.  
-  Single reference Signal. Enter a single signal label as cell string (ex. {M1}).  The reference signal is subsracted from each analysis signal. Entering a null cell string is interpreted as no referencing is to be applied (ex. {})). 
-  Reference for each analysis signal. Enter a reference for each signal as a cell string (ex. {'M1','M1','M2','M3'}). A signal label can be used multiple time.
-  Average of reference signals.  The average of the signals listed in the cell array is substracted from each analysis signals.

*Spectral Settings*
-    Default.  The default settings are 10/4 second sub-epochs with a 50% tukey window. A 30 second scoring window is assumed.
-    SHHS.  The settings used for the Sleep Heart Health Study can be selected. The settins are 6x5 second sub-epochs with a hanning window.  A 30 second scoring window is applied.

*Artifact Detection*
-    Delta (0.6-4.6 Hz). Set the multiplicative threshold for the delta band, which defaults to 2.5
-    Beta (40-60 Hz). Set the multiplicative thresold for the beta band, which defaults to 2.0

*Monitor Id*. Select the monitor to display the figures created during processing.

*Start*. Select the file Id to start. The option is provided in order to trouble shoot a failed fun. Review the autogenerated file lists to identify files or review the error message.

##### GUI Funciton Button
*Close All*. Closes all open figures

*About*. Displays graphical user interface description and copyright notice.

*Set Bands*. Load an Excel file with a list of spectral bands to analyze/report on.  Examples of the Excel spreadsheet can be found in the release section.

*Bands*. Start batch processing. Compute and report band summaries by subject and create a summary across subjects.

*Go (min)*. Reccomended batch processing option.  Visual (PPT) and numeric (XLS) summaries are created across subjects.  Visual summary allows for a rapid review of all subjects.

*Go (all)*.  Detail visual (PPT) and numeric (XLS) summaries by subject and across subjects.

*Compute Coherence*. Select check box to compute coherence between each pair of analysis signals.  Warning: the number of signal pair increases rapidly as the number of analysis signals grow. 

#### MATLAB APP
See the release section for the MATLAB App and sample data. The MATLAB APP is a great way to get started with spectral analysis of sleep studies. Installing the APP version of SignalRasterView is a quick way to review an EDF content to determine the signal labels.  

#### Requirements
The memory and hard disk requirements are dependent on the size and number of sleep studies to be analyzed. The program can run on a laptop with 8 Gb of RAM.  The preferred configurtion for a large number of studies is 16-32 Gb of RAM.   
