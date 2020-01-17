# SmallSuiteGenerator 

SmallSuiteGenerator is an Smalltalk tool to generate test cases automatically

[![master branch:](https://travis-ci.org/OBJECTSEMANTICS/SmallSuiteGenerator.svg?branch=master)](https://travis-ci.org/OBJECTSEMANTICS/SmallSuiteGenerator/branches)

MIT Licensed.

SmallSuiteGenerator can be used to discover bugs in the code, because it generates automatically test cases

## Installation 

### Pharo

To install the latest stable version of SmallSuiteGenerator in a Pharo image, execute the following code:

```Smalltalk
Metacello new
 baseline:'SmallSuiteGenerator';
 repository: 'github://OBJECTSEMANTICS/SmallSuiteGenerator:master/src';
 load.
```
To install the version that presents graphic results of the coverage's evolution, execute the following code:

```Smalltalk
Metacello new
 baseline:'SmallSuiteGenerator';
 repository: 'github://OBJECTSEMANTICS/SmallSuiteGenerator:master/src';
 load: #('All').
```

### VisualWorks

You can load SmallSuiteGenerator into VW image with the next steps:

- Clone or download Parcels8.3/SmallSuiteWithSpyLite directory of this project
- Load parcel SmallSuiteGenerator-Extensions.pcl

## Configuration

The first step is to define the code block that will be instrumented to get the typeInfo. Define package's regular expression pattern also.

``` Smalltalk
| typeInfo |
typeInfo := STypeInfo asTypeInfo: (
		SSTypeCollector profile:[ 
			(SSTeacher name: 'Ann' with: 50)
			nickname;
			canRegister: ((SConference price: 50) offerPrice: 50);
			idTeacher;
			yearsWorkExperience ] onPackagesMatching: 'SmallSuiteGenerator-Scenario').
```

The second step is to configure the class `STestCaseFactory`.

``` Smalltalk
STestCaseFactoryPharo new
    typeInfo: typeInfo;
    fitness: SStatementCoverage new;
    targetClassName: #SSTeacher;
    targetPackageRegex: 'SmallSuiteGenerator-Scenario';
    outputPackageName: 'SmallSuiteGenerator-Tests-Generated';
    numberOfGenerations: 20;
    numberOfStatements: 3;
    createTestCases;
    yourself.
```
				
Some other options to configure are:

* `fitness`: used in genetic algorithm to improve its value either increasing or reducing, depending on the function. In this case we use: `SStatementCoverage`, which means that our generator will try to increase the statement coverage.
* `targetClassName`: accepted represents the target class name that will be analyzed in the package.
* `targetPackagesRegex`: Regular expression of the package where the class is found.
* `outputPackageName`: Package name where the tests cases will be created.

To watch the evolution of fitness function call `visualize` method.

After to execute this script the testCases will be generated with the higher fitness of the population. In the output package name specified you can find the generated testCases. Usually the last enumerated testCases have the highests fitness.

Additionally to the described configurations, you can configure some parameters before to generate test cases, e.g:

```Smalltalk 
populationSize: 30.
```

## Install SpyLite

See documentation in [Install SpyLite](Parcels8.3/INSTALL_SPYLITE.md)
