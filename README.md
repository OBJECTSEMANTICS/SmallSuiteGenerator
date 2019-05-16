# SmallSuiteGenerator 

SmallSuiteGenerator is an Smalltalk tool to generate test cases automatically

[![master branch:](https://travis-ci.org/OBJECTSEMANTICS/SmallSuiteGenerator.svg?branch=master)](https://travis-ci.org/OBJECTSEMANTICS/SmallSuiteGenerator/branches)

MIT Licensed.

SmallSuiteGenerator can be used to discover bugs in the code, because it generates automatically test cases

## Installation 
You can load SmallSuiteGenerator into Pharo image executing the following code in the playground:

```Smalltalk
Metacello new
 baseline:'SmallSuiteGenerator';
 repository: 'github://OBJECTSEMANTICS/SmallSuiteGenerator:master/src';
 load.
```
## Usage

Before you have to initialize the class `SSmallSuiteGenerator`.

``` Smalltalk
| smallSuiteGenerator |
smallSuiteGenerator := SSmallSuiteGenerator new.
```

### Configuration
To generate test cases of code within the block, you have two options:
 * Execute the code using the class
 * Execute the code using the regular expression of package matching
 
#### Configuration with class

If you want generate test cases using the class, you must send the block to analize and the class. In this example we send the block and the class `SStudent`

```Smalltalk
smallSuiteGenerator 
 generateTestsOf: [ (SStudent name: 'Ann' with: -34.234)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]  blockOnClass: SStudent. 
 ```
#### Configuration with regular expression of package matching

On the other hand if you want to generate test cases using packages, you have to type the following code with the block to analize and the regular expression of the package, e.g:

```Smalltalk
smallSuiteGenerator generateTestsOf: [ (SStudent name: 'Ann@323' with: -34)
				nickname;
				idStudent;
				scoreStudent: -45.12;
				scoreStudent ]
		blockOnPackagesMatching: 'SmallSuiteExamp*'.
```

### Execution
Either using the class or regular expression you must execute the following code to generate the testCases: 

```Smalltalk
smallSuiteGenerator runGeneration.
```

This instruction will generate the testCases with the higher fitness of one population. You can see these testCases debugging in `smallSuiteGenerator engine logs`. Usually the last log contains the testCase with the highest fitness.
By other side, you can configure some parameters before to generate test cases, e.g:

```Smalltalk 
smallSuiteGenerator populationSize: 30.
smallSuiteGenerator numberOfGenerations: 20. "number of testCases to generate"
smallSuiteGenerator numberOfStatements: 15. "number of statements that each testCase will have "
```

### Generation of invariants
To generate the assertios of each testCase execute:

```Smalltalk
smallSuiteGenerator generateInvariants: {}
```
If you execute the code with an empty list, by default all the invariants of the project will be considered to generate the assertions. You can modify this list.

The class which contains the generated assertions is `SSAssertionGeneratorTest`
