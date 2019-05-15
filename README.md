# SmallSuiteGenerator 

SmallSuiteGenerator is an Smalltalk tool to generate test cases automatically

[![master branch:](https://travis-ci.org/OBJECTSEMANTICS/SmallSuiteGenerator.svg?branch=master)](https://travis-ci.org/OBJECTSEMANTICS/SmallSuiteGenerator/branches)

MIT Licensed.

SmallSuiteGenerator can be used to discover bugs in the code, because it generates automatically test cases

## Installation 
You can load SmallSuiteGenerator into Pharo image typing this instruction in the playground:

```Smalltalk
Metacello new
 baseline:'SmallSuiteGenerator';
 repository: 'github://OBJECTSEMANTICS/SmallSuiteGenerator:master/src';
 load.
```
## Usage

### Configuration
To generate test cases of a piece of code, you have two options:
 * Execute the code using the class
 * Execute the code using the regex of package matching
 
First you have to initialize the class `SSmallSuiteGenerator`.
``` | smallSuiteGenerator |
smallSuiteGenerator := SSmallSuiteGenerator new.
```
If you want generate test cases using the class, you must type this instruction with the block to analize and the class

``` smallSuiteGenerator 
 generateTestsOf: [ (SStudent name: 'Ann' with: -34.234)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]  blockOnClass: SStudent. 
 ```
But if you want to generate test cases using the package, you must type this instruction with the block and the regex of the package:

```
smallSuiteGenerator generateTestsOf: [ (SStudent name: 'Ann@323' with: -34)
				nickname;
				idStudent;
				scoreStudent: -45.12;
				scoreStudent ]
		blockOnPackagesMatching: 'SmallSuiteExamp*'.
```

To generate the testCase with the statements that have higher fitness, you must type: 

```
smallSuiteGenerator runGeneration.
```

This instruction will generate the testCases with the higher fitness, and to generate the asserts of this test cases you must type: 

```
smallSuiteGenerator generateInvariants: {}
```

By default if you type this instruction with a empty list, all invariants will be used to analyze the code.
