"
SGAEngineExample contains some examples to validate correct project functionality 
"
Class {
	#name : #SGAEngineExample,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #'examples - onClass' }
SGAEngineExample >> exampleSSTeacherOnClassWithSMethodCoverage [
	| engine classFitness |
	classFitness := SMethodCoverage.
	engine := self
		runOnClass: SSTeacher
		withBlock: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		andFitness: classFitness.
	self
		assert:
			(engine logs first fittestTestCase fitness
				at: classFitness functionName) >= 20.	"20 = (1/5) * 100"
	self
		assert:
			(engine logs last fittestTestCase fitness
				at: classFitness functionName)
		equals: 80.	"80 = (4/5) * 100"
	engine clean
]

{ #category : #'examples - onClass' }
SGAEngineExample >> exampleSSTeacherOnClassWithSStatementCoverage [
	| engine classFitness |
	classFitness := SStatementCoverage.
	engine := self
		runOnClass: SSTeacher
		withBlock: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		andFitness: classFitness.
	self
		assert:
			(engine logs last fittestTestCase fitness
				at: classFitness functionName) >= 37.5.	"37.5 = (3/8) * 100"
	self
		assert:
			(engine logs last fittestTestCase fitness
				at: classFitness functionName) >= 87.5.	"87.5 = (7/8) * 100"
	engine clean
]

{ #category : #'examples - onPackages' }
SGAEngineExample >> exampleSSTeacherOnPackageWithSMethodCoverage [
	| engine classFitness |
	classFitness := SMethodCoverage.
	engine := self
		runOnPackagesMatching: 'SmallSuiteGenerator-Examples'
		withBlock: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		andFitness: classFitness.
	self
		assert:
			(engine logs first fittestTestCase fitness
				at: classFitness functionName)
				<=
					(engine logs last fittestTestCase fitness
						at: classFitness functionName).
	engine clean
]

{ #category : #'examples - onPackages' }
SGAEngineExample >> exampleSSTeacherOnPackageWithSStatementCoverage [
	| engine classFitness |
	classFitness := SStatementCoverage.
	engine := self
		runOnPackagesMatching: 'SmallSuiteGenerator-Examples'
		withBlock: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		andFitness: classFitness.
	self
		assert:
			(engine logs first fittestTestCase fitness
				at: classFitness functionName)
				<=
					(engine logs last fittestTestCase fitness
						at: classFitness functionName).
	engine clean
]

{ #category : #'examples - onClass' }
SGAEngineExample >> exampleSStackOnClassWithSMethodCoverage [
	| engine classFitness |
	classFitness := SMethodCoverage.
	engine := self
		runOnClass: SStack
		withBlock: [ (SStack
				newStackWith:
				#(2 4 6 1))
				push: 8;
				pop;
				top ]
		andFitness: classFitness.
	self
		assert:
			(engine logs first fittestTestCase fitness
				at: classFitness functionName) >= 14.28.	"14.28 = (1/7) * 100 round: 2"
	self
		assert:
			(engine logs last fittestTestCase fitness
				at: classFitness functionName) >= 57.14.	"57.14 = (4/7) * 100 round: 2"
	engine clean
]

{ #category : #'examples - onClass' }
SGAEngineExample >> exampleSStackOnClassWithSStatementCoverage [
	| engine classFitness |
	classFitness := SStatementCoverage.
	engine := self
		runOnClass: SStack
		withBlock: [ (SStack newStackWith: #(2  4  6  1))
				push: 8;
				pop;
				top ]
		andFitness: classFitness.
	self
		assert:
			(engine logs first fittestTestCase fitness
				at: classFitness functionName) >= 21.05.	"21.05 = (4/19) * 100 round: 2"
	self
		assert:
			(engine logs last fittestTestCase fitness
				at: classFitness functionName) >= 73.68.	"73.68 = (14/19) * 100 round: 2"
	engine clean
]

{ #category : #'examples - onPackages' }
SGAEngineExample >> exampleSStackOnPackageWithSMethodCoverage [
	| engine classFitness |
	classFitness := SMethodCoverage.
	engine := self
		runOnPackagesMatching: 'SmallSuiteGenerator-Examples'
		withBlock: [ (SStack newStackWith: #(2 4 6 1))
				push: 8;
				pop;
				top ]
		andFitness: classFitness.
	self
		assert:
			(engine logs first fittestTestCase fitness
				at: classFitness functionName)
				<=
					(engine logs last fittestTestCase fitness
						at: classFitness functionName).
	engine clean
]

{ #category : #'examples - onPackages' }
SGAEngineExample >> exampleSStackOnPackageWithSStatementCoverage [
	| engine classFitness |
	classFitness := SMethodCoverage.
	engine := self
		runOnPackagesMatching: 'SmallSuiteGenerator-Examples'
		withBlock: [ (SStack newStackWith: #(2 4 6 1))
				push: 8;
				pop;
				top ]
		andFitness: classFitness.
	self
		assert:
			(engine logs first fittestTestCase fitness
				at: classFitness functionName)
				<=
					(engine logs last fittestTestCase fitness
						at: classFitness functionName).
	engine clean
]

{ #category : #'examples - onClass' }
SGAEngineExample >> exampleSStudentOnClassWithSMethodCoverage [
	| engine classFitness |
	classFitness := SMethodCoverage.
	engine := self
		runOnClass: SStudent
		withBlock: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		andFitness: classFitness.
	self
		assert:
			(engine logs first fittestTestCase fitness
				at: classFitness functionName) >= 20.
	self
		assert:
			(engine logs last fittestTestCase fitness
				at: classFitness functionName)
		equals: 100.
	engine clean
]

{ #category : #'examples - onClass' }
SGAEngineExample >> exampleSStudentOnClassWithSStatementCoverage [
	| engine classFitness |
	classFitness := SStatementCoverage.
	engine := self
		runOnClass: SStudent
		withBlock: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		andFitness: classFitness.
	self
		assert:
			(engine logs first fittestTestCase fitness
				at: classFitness functionName) >= 37.5.
	self
		assert:
			(engine logs last fittestTestCase fitness
				at: classFitness functionName)
		equals: 100.
	engine clean
]

{ #category : #'examples - onPackages' }
SGAEngineExample >> exampleSStudentOnPackageWithSMethodCoverage [
	| engine classFitness |
	classFitness := SMethodCoverage.
	engine := self
		runOnPackagesMatching: 'SmallSuiteGenerator-Scenario2'
		withBlock: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		andFitness: classFitness.
	self
		assert:
			(engine logs first fittestTestCase fitness
				at: classFitness functionName)
				<=
					(engine logs last fittestTestCase fitness
						at: classFitness functionName).
	engine clean
]

{ #category : #'examples - onPackages' }
SGAEngineExample >> exampleSStudentOnPackageWithSStatementCoverage [
	| engine classFitness |
	classFitness := SStatementCoverage.
	engine := self
		runOnPackagesMatching: 'SmallSuiteGenerator-Scenario2'
		withBlock: [ (SStudent name: 'Ann' with: 34)
				nickname;
				idStudent;
				scoreStudent: 45;
				scoreStudent ]
		andFitness: classFitness.
	self
		assert:
			(engine logs first fittestTestCase fitness
				at: classFitness functionName)
				<=
					(engine logs last fittestTestCase fitness
						at: classFitness functionName).
	engine clean
]

{ #category : #actions }
SGAEngineExample >> runOnClass: aClass withBlock: aBlock andFitness: aClassFitness [
	| engine |
	engine := SGAEngine new.
	engine
		populationSize: 30;
		numberOfStatements: 15;
		blockToExecute: aBlock;
		targetClassName: aClass name.
	engine
		typeInfo:
			(STypeInfo
				asTypeInfo: (SSTypeCollector profile: engine blockToExecute forClassNamed: aClass name));
		fitness: aClassFitness;
		targetClassName: aClass name;
		numberOfGenerations: 15;
		run.
	^ engine
]

{ #category : #actions }
SGAEngineExample >> runOnPackagesMatching: regex withBlock: aBlock andFitness: aClassFitness [
	| engine |
	engine := SGAEngine new.
	engine
		populationSize: 30;
		numberOfStatements: 15;
		blockToExecute: aBlock.
	engine
		typeInfo:
			(STypeInfo asTypeInfo: (SSTypeCollector
				profile: engine blockToExecute
				onPackagesMatching: regex));
		fitness: aClassFitness;
		numberOfGenerations: 15;
		run.
	^ engine
]
