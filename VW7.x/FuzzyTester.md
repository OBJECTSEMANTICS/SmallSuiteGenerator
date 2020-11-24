# FuzzyTester


FuzzyTester is a tool to generate tests automatically


## Installation

### From Github

You must download the files:

* [FuzzyInstaller.pcl](https://raw.githubusercontent.com/OBJECTSEMANTICS/SmallSuiteGenerator/master/VW7.x/FuzzyInstaller.pcl)
* [FuzzyInstaller.pst](https://raw.githubusercontent.com/OBJECTSEMANTICS/SmallSuiteGenerator/master/VW7.x/FuzzyInstaller.pst)


Once you have the files on your computer run the following command:


```Smalltalk
|pathParcel|
pathParcel := 'Path\Of\FuzzyInstaller.pcl'.
Parcel loadParcelFrom: pathParcel.
VWFuzzyTester install.
```

### From Folder

- Download folder [VW7.x](https://github.com/OBJECTSEMANTICS/SmallSuiteGenerator/tree/master/VW7.x) from github with all parcels.
- Load parcel: FuzzyInstaller.pcl
- Execute the following command in a workSpace:

```
VWFuzzyTester  installParcelsFrom: 'Path\Of\Folder\With\Parcels'.
```
