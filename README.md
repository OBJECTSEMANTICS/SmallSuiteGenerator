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
smallSuiteGenerator := SSmallSuiteGenerator new.
```

### Configuration
To generate test cases of code within the block you have two options:
 * Execute the code using the class
 * Execute the code using the regular expression of packages matching
 
#### Configuration with class

To generate test cases using the class you must send the block to analize and the class. In this example we send the block and the class `SStudent`

```Smalltalk
smallSuiteGenerator 
 generateTestsOf: [ (SStudent name: 'Ann' with: -34.234)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]  blockOnClass: SStudent. 
 ```
#### Configuration with regular expression of package matching

On the other hand, to generate test cases using packages you have to type the following message with the block to analize and the regular expression of the package, e.g:

```Smalltalk
smallSuiteGenerator generateTestsOf: [ (SStudent name: 'Ann@323' with: -34)
				nickname;
				idStudent;
				scoreStudent: -45.12;
				scoreStudent ]
		blockOnPackagesMatching: 'SmallSuiteExamp*'.
```

### Execution
Either using the class or regular expression execute the following code to generate the testCases: 

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
To generate assertions of each testCase execute:

```Smalltalk
smallSuiteGenerator generateAssertionsUsing: {}
```
This instruction must be executed after the generations of testCases.
If you execute the code with an empty list, by default all subClasses of SSAssertion will be considered to generate the assertions. You can modify this list. 

### Pretty Code
To generate assertions with the statements renamed, no redundant and inlined you can type the following instruction instead of the previous instruction:

```Smalltalk
smallSuiteGenerator
generateAssertionsUsing: {}
invariantsAndApplyPrettyCodeWith: {}
```

The classes to apply the refactorings at the assertions must be send in the second parameter, by default all the subclasses of SRefactoring will be considered but you can modify it.
The class which contains the generated assertions is `SSAssertionGeneratorTest`
