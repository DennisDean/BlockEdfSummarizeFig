BlockEdfSummarizeFig
====================

Simple interface for summarizing the contents of a folder containing EDFs and XML files. BlockEdfSummarizeFig is part of the [Data Access and Visualization for Sleep Toolbox](https://github.com/DennisDean/DAVS-Toolbox/blob/master/README.md).

#### Applications

BlockEdfsummarizeFig was initially developed to review the contents of large number of EDF/XML files. The functional components of the tool have been integrated within batch analysis programs to serve as a pre-run check.  Applying the checks within BlockEdfSummarizeFig is the first step is performing large scale spectral analysis. See our [spectral analysis](https://github.com/DennisDean/SpectralTrainFig/blob/master/README.md) program description or our [standard operating procedure](https://github.com/DennisDean/SpectralTrainFig/blob/master/standardOperatingProcedure.md) for performing spectral analysis for additional details.

#### Quick Application Steps

Only a few simple steps are required

1. Select EDF folder
2. Select folder to write output folder
3. Set output file prefix
4. Click on 'Signal' to summarize EDF signal content
5. Click on 'EDF Check' to summarize EDF header and results of EDF check
6. Click on 'XML check' to summarize XML load check

#### Limitations

Program expects a file structure such that for every *.EDF there is an *.EDF.XML file in the same folder.

#### Acknowledgements:

Uses [dirr](http://www.mathworks.com/matlabcentral/fileexchange/8682-dirr--find-files-recursively-filtering-name--date-or-bytes-)


#### Related Links

[National Sleep Research Resource](https://sleepdata.org/)

[Authors File Exchange Downloads](http://www.mathworks.com/matlabcentral/fileexchange/authors/my_fileexchange)
