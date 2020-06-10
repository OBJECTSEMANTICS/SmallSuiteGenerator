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
To install the version that presents graphic results of evolution coverage, execute the following code:

```Smalltalk
Metacello new
 baseline:'SmallSuiteGenerator';
 repository: 'github://OBJECTSEMANTICS/SmallSuiteGenerator:master/src';
 load: #('All').
```

### VisualWorks

See documentation in [Install FuzzyTester](VW7.x/FuzzyTester.md)

## Configuration

The first step is to define the code block that will be instrumented to get the typeInfo. Define package's regular expression pattern also.

``` Smalltalk
| typeInfo aBlock |
aBlock := [ 
			(SSTeacher name: 'Ann' with: 50)
			nickname;
			canRegister: ((SConference price: 50) offerPrice: 50);
			idTeacher;
			yearsWorkExperience ].
typeInfo := STypeInfo asTypeInfo: (
		SSTypeCollector profile: aBlock onPackagesMatching: 'SmallSuiteGenerator-Scenario').
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
    seedBlock: aBlock;
    populationSize: 10;
    createTestCases;
    yourself.
```
				
Some other options to configure are:

* `fitness`: used in genetic algorithm to improve its value either increasing or reducing, depending on the function. In this case we use: `SStatementCoverage`, which means that our generator will try to increase the statement coverage.
* `targetClassName`: accepted represents the target class name that will be analyzed in the package.
* `targetPackagesRegex`: Regular expression of the package where the class is found.
* `outputPackageName`: Package name where the tests cases will be created.

After to execute this script the testCases will be generated with the higher fitness of the population. In the output package name specified you can find the generated testCases. Usually the last enumerated testCases have the highests fitness.

To watch the evolution of fitness function call `visualize` method and to see more details about generation evolution call `generationEvolutionCanvas` method. On the other hand, you can see these graphics automatically doing a click on Evolution and GenerationEvolution tab, respectively.

**Hint:** The methods to visualize only are available if you install the version with graphics, specified before.

### Advanced settings

All these settings should be done before generate test cases

- Change population size.

```Smalltalk 
populationSize: 30.
```

- Sometimes the number variables is limited, to fix this problem you can change the default generations testing with variables by using a dictionary.

```Smalltalk 
asDict: true.
```

## Install SpyLite

See documentation in [Install SpyLite](Parcels8.3/INSTALL_SPYLITE.md)
