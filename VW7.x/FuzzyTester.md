# FuzzyTester


FuzzyTester is a tool to generate tests automatically


## Installation


You must download the files:

* [FuzzyInstaller.pcl](https://raw.githubusercontent.com/OBJECTSEMANTICS/SmallSuiteGenerator/master/VW7.x/FuzzyInstaller.pcl)
* [FuzzyInstaller.pst](https://raw.githubusercontent.com/OBJECTSEMANTICS/SmallSuiteGenerator/master/VW7.x/FuzzyInstaller.pst)


Once you have the files on your computer run the following command:


```Smalltalk
|pathParcel|
pathParcel := 'Path/Of/FuzzyInstaller.pcl'
Parcel loadParcelFrom: pathParcel.
VWFuzzyTester install.
```
