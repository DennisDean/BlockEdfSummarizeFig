BlockEdfSummarizeFig
====================

Interface for summarizing the contents of a folder containing EDFs and XML files. 

#### Questions
Please post questions at https://sleepdata.org/forum

#### Applications

BlockEdfSummarizeFig is a data checking tool and can assist in the preparation for signal analysis projects. The tools is designed to work with sleep study data available by the [National Sleep Research Resource](https://sleepdata.org/about). Sleep study files includ signals (EDF file) and technican scored annotations (XML file). EDF and XML checking are included to insure the files are accessible prior to analyis. The ability to list signal labels and sampling rates provide a way to check contents prior to large scale signal processing projects.

The functional components of the tool have been integrated within batch analysis programs to serve as a pre-run check.  Applying the checks within BlockEdfSummarizeFig is the first step in performing large scale [spectral analysis](http://en.wikipedia.org/wiki/Spectral_estimation). See our [spectral analysis](https://github.com/DennisDean/SpectralTrainFig/blob/master/README.md) program description or our [standard operating procedure](https://github.com/DennisDean/SpectralTrainFig/blob/master/standardOperatingProcedure.md) for performing spectral analysis for additional details.

BlockEdfSummarizeFig is part of the [Data Access and Visualization for Sleep Toolbox](https://github.com/DennisDean/DAVS-Toolbox/blob/master/README.md).

#### Quick Application Steps

Only a few simple steps are required

1. Select EDF folder
2. Select the XML folder
2. Select folder to write generated files
3. Set output file prefix
4. Click on 'Signal' to summarize EDF signal content
5. Click on 'EDF Check' to summarize EDF header and results of EDF check
6. Click on 'XML check' to summarize XML load check
7. Click on 'Signal' to list signal labels for each sleep file
8. Click on 'Signal Label Summary' to list the signal labels and counts within the dataset
9. Click on 'Signal Plus' after entering one or more signal labels {'C3','C4'} to list signal sampling rates
10. Click on 'Segment File List' after entering a signal label {'C3'} to generate a seperate file for each sampling rate.

#### Limitations

This version removes the limitation that the file structure is organized such that for every *.EDF there is an *.EDF.XML file in the same folder. The XML files are assumed to be written in the compumedics format.

#### Acknowledgements:

Uses [dirr](http://www.mathworks.com/matlabcentral/fileexchange/8682-dirr--find-files-recursively-filtering-name--date-or-bytes-)


#### Related Links

[National Sleep Research Resource (https://sleepdata.org/)](https://sleepdata.org/)

[Author's File Exchange Downloads (http://www.mathworks.com/matlabcentral/fileexchange/authors/my_fileexchange)](http://www.mathworks.com/matlabcentral/fileexchange/authors/my_fileexchange)

[Data Access and Visualization for Sleep Toolbox(https://github.com/DennisDean/DAVS-Toolbox/blob/master/README.md)](https://github.com/DennisDean/DAVS-Toolbox/blob/master/README.md)

[SpectralTrainFig (http://www.mathworks.com/matlabcentral/fileexchange/49852-spectraltrainfig)](http://www.mathworks.com/matlabcentral/fileexchange/49852-spectraltrainfig)


