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

Initialize the class `SSmallSuiteGenerator`.

``` Smalltalk
| smallSuiteGenerator |
smallSuiteGenerator := SSmallSuiteGenerator newInstance.
```

### Configuration
The first step is to define the code block that will be analyzed.

	``` Smalltalk
	smallSuiteGenerator seed: [ (SStudent name: 'Ann' with: -34.234)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ].
	```
				
Another option to configure is the fitness that will be used in genetic algorithm  to improve this value either increasing or reducing, depending on the configuration. In this case we use: `SMultiFitnessFunction` to evaluate `SMethodCoverage` and `SStatementCoverage` at the same time.

```Smalltalk
smallSuiteGenerator fitness: (SMultiFitnessFunction 
		with: SMethodCoverage; 
		with: SStatementCoverage).
```

To analyze and profile the code you have two choices: 
 * Define the class to profile the code
 * Define a regular expression of packages matching, this option means that code will be profiled in all packages that match with the regular expression
 
#### Defining the class

Following the example, in this case we use the class `SStudent`

```Smalltalk
smallSuiteGenerator profilingOnClass: SStudent. 
 ```
 
#### Defining a regular expression of package matching

```Smalltalk
smallSuiteGenerator profilingOnPackagesMatching: 'SmallSuiteGenerator-Examples'.
```

### Execution
Either using the class or regular expression execute the following code to generate the testCases with the genetic algorithm.

```Smalltalk
smallSuiteGenerator run.
```

This instruction will generate the testCases with the higher fitness of one population. You can see these testCases debugging in `smallSuiteGenerator engine logs`. Usually the last log contains the testCase with the highest fitness.
The test cases also are created by default in the class: `STestCaseGenerated` in the package `SmallSuiteGenerator-Tests-Generated`.

Additionally to the described configurations, you can configure some parameters before to generate test cases, e.g:

```Smalltalk 
smallSuiteGenerator populationSize: 30.
smallSuiteGenerator numberOfGenerations: 20. "number of testCases to generate"
smallSuiteGenerator numberOfStatements: 15. "number of statements that each testCase will have "
smallSuiteGenerator classNameOfTest: 'SStudentTest'. "class that contains the test cases"
```
