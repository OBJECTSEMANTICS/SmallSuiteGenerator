Class {
	#name : #SAuxiliarTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Core'
}

{ #category : #tests }
SAuxiliarTest >> testConstructorInTestCase [
	| generatorInfo testCase constructor |
	generatorInfo := SGeneratorInfo
		typeInfo: ( SSGenerator
		profile: [ (SSTeacher name: 'Ann' with: 34)
				idTeacher;
				nickname ]
		onClass: SSTeacher).
	testCase := STestCase seed: generatorInfo.
	testCase addConstructor.	"_var0 := SSteacher new"
	testCase addField.	"_var1 := _var0 idTeacher"
	constructor := SAuxiliar
		constructorIn: testCase
		testCaseOf: testCase statements last
		statementWithBlockCondition: SFieldStatement blockCondition.
	self assert: constructor isNotNil.
	self assert: constructor varName equals: '_var0'.
	testCase := STestCase seed: generatorInfo.
	testCase addConstructor.	"_var0 := SSteacher new"
	testCase addMethod.	"_var1 := _var0 nickname"
	constructor := SAuxiliar
		constructorIn: testCase
		testCaseOf: testCase statements last
		statementWithBlockCondition: SMethodStatement blockCondition.
	self assert: constructor isNotNil.
	self assert: constructor varName equals: '_var0'
]

{ #category : #tests }
SAuxiliarTest >> testConstructorInTestCaseNotFound [
	| generatorInfo testCase constructor |
	generatorInfo := SGeneratorInfo
		typeInfo: ( SSGenerator
		profile: [ (SSTeacher name: 'Ann' with: 34)
				idTeacher;
				nickname ]
		onClass: SSTeacher).
	testCase := STestCase seed: generatorInfo.
	testCase addConstructor.	"_var0 := SSteacher new"
	testCase addField.	"_var1 := _var0 idTeacher"
	testCase statements first theClassName: 'SStudent'.	"theClassName of constructor is changed"
	constructor := SAuxiliar
		constructorIn: testCase
		testCaseOf: testCase statements last
		statementWithBlockCondition: SFieldStatement blockCondition.
	self assert: constructor isNil.
	testCase := STestCase seed: generatorInfo.
	testCase addConstructor.	"_var0 := SSteacher new"
	testCase addMethod.	"_var1 := _var0 nickname"
	testCase statements first theClassName: 'SStudent'.	"theClassName of constructor is changed"
	constructor := SAuxiliar
		constructorIn: testCase
		testCaseOf: testCase statements last
		statementWithBlockCondition: SMethodStatement blockCondition.
	self assert: constructor isNil.
	testCase := STestCase seed: generatorInfo.
	testCase addConstructor.	"_var0 := SSteacher new"
	testCase addMethod.	"_var1 := _var0 nickname"
	testCase statements last selector: #name.	"selector of method is changed"
	constructor := SAuxiliar
		constructorIn: testCase
		testCaseOf: testCase statements last
		statementWithBlockCondition: SMethodStatement blockCondition.
	self assert: constructor isNil
]

{ #category : #tests }
SAuxiliarTest >> testDefaultConstructor [
	| constructor |
	constructor := SAuxiliar defaultConstructor: SStack new.
	self assert: constructor theClassName equals: 'SStack'.
	self assert: constructor selector equals: 'new'.
	constructor := SAuxiliar defaultConstructor: SStudent new.
	self assert: constructor theClassName equals: 'SStudent'.
	self assert: constructor selector equals: 'new'.
	constructor := SAuxiliar defaultConstructor: OrderedCollection new.
	self assert: constructor theClassName equals: 'OrderedCollection'.
	self assert: constructor selector equals: 'new'.
	constructor := SAuxiliar defaultConstructor: Array new.
	self assert: constructor theClassName equals: 'Array'.
	self assert: constructor selector equals: 'new'.
]

{ #category : #tests }
SAuxiliarTest >> testIsVeryDeep [
	self assert: (SAuxiliar isVeryDeep: RTView new).
	self deny: (SAuxiliar isVeryDeep: 1).
	self deny: (SAuxiliar isVeryDeep: (OrderedCollection new addAll: {3. 6. 6. 7. -1. 0}; yourself)).
	self deny: (SAuxiliar isVeryDeep: RTAMItem new).
	self assert: (SAuxiliar isVeryDeep: RTViewForSpec)
]

{ #category : #tests }
SAuxiliarTest >> testPackagesClassesAndMethodsOfFilterBy [
	| profile methods generator res |
	generator := SGeneratorTestCase new.
	profile := SSGenerator
		profile: [ (SEvent price: 200)
				discount: 15;
				discount;
				price ]
		onClass: SEvent.
	methods := generator
		mutatedMethodsFrom: {SEventTest}
		mutating: {SEvent}
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	res := SAuxiliar
		packagesClassesAndMethodsOf: profile
		filterBy: methods.
	self assert: res size equals: 3.
	self
		assertCollection: res first
		hasSameElements: {#SmallSuiteGeneratorTest}.
	self assertCollection: res second hasSameElements: {#SEvent}.
	self
		assertCollection: res third
		hasSameElements:
			{(#SEvent -> #discount).
			(#SEvent -> #price).
			(#SEvent -> #discount:).
			#'SEvent class' -> #price:}
]

{ #category : #tests }
SAuxiliarTest >> testPositionToInsertAfterIndexStatement [
	| testCase methodStatement positionConstructor positionToInsert|
	testCase := SStatementTest testCaseSStack.
	methodStatement := testCase statements last.
	positionConstructor := (testCase indexOf: methodStatement receiverVarName) + 1 .
	positionToInsert := SAuxiliar positionToInsertAfter: positionConstructor indexStatementOf: testCase testCaseHaving: methodStatement args.
	self assert: positionToInsert > positionConstructor.
	self assert: positionToInsert > (testCase indexOf: methodStatement args first).
]

{ #category : #tests }
SAuxiliarTest >> testTypeNameArgsOfSelector [
	| generatorInfo testCase |
	generatorInfo := SGeneratorInfo
		typeInfo: ( SSGenerator profile: [ SFoo score: 5 ] onClass: SFoo).
	testCase := STestCase seed: generatorInfo.
	testCase addConstructor.
	self
		assertCollection:
			(SAuxiliar
				typeNameArgsOf: #score:
				selectorIn: #SFoo
				classNameUsing: testCase)
		hasSameElements: {#SmallInteger}
]

{ #category : #tests }
SAuxiliarTest >> testValidateIfNotValid [
	self assert: (SAuxiliar validate: nil ifNotValid: [ 1 ]) equals: 1.
	self assert: (SAuxiliar validate: #() ifNotValid: [ 1 ]) equals: 1.
	self
		assert: (SAuxiliar validate: #(1 2 3) ifNotValid: [ 3 ])
		equals: #(1 2 3).
	self assert: (SAuxiliar validate: (OrderedCollection new) ifNotValid: [#(1 4 5)]) equals: #(1 4 5)
]

{ #category : #tests }
SAuxiliarTest >> testValueOfTypeInTestCase [
	| generatorInfo testCase dictionary value |
	generatorInfo := SGeneratorInfo
		typeInfo: ( SSGenerator
		profile: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		onClass: SSTeacher).
	testCase := STestCase seed: generatorInfo.
	dictionary := Dictionary new
		at: 'SmallInteger' put: #(1 4 5);
		at: 'ByteString' put: {'sfoo' . 'ssteacher'};
		yourself.
	value := SAuxiliar
		valueOf: 'Integer'
		typeIn: testCase
		testCaseUsing: dictionary.
	self assert: (#(1 4 5) includes: value first).
	self assert: value second equals: #SmallInteger.
	self
		assert: ((testCase dictSubclasses at: 'Integer') includes: 'SmallInteger').
	value := SAuxiliar
		valueOf: 'String'
		typeIn: testCase
		testCaseUsing: dictionary.
	self assert: ({'sfoo' . 'ssteacher'} includes: value first).
	self assert: value second equals: #ByteString.
	self
		assert: ((testCase dictSubclasses at: 'String') includes: 'ByteString')


	"profile := SSGenerator profile: [ (SFoo score: 5) ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	self
		assertCollection:
			(SAuxiliar
				typeNameArgsOf: #score:
				selectorIn: #SFoo
				classNameUsing: testCase)
		hasSameElements: {#SmallInteger}."
]

{ #category : #tests }
SAuxiliarTest >> testValueOfTypeInTestCaseWithoutData [
	| generatorInfo testCase dictionary value |
	generatorInfo := SGeneratorInfo
		typeInfo: ( SSGenerator
		profile: [ SSTeacher name: 'Ann' with: 34 ]
		onClass: SSTeacher).
	testCase := STestCase seed: generatorInfo.
	dictionary := Dictionary new
		at: 'ByteString' put: {'sfoo' . 'ssteacher'};
		yourself.
	value := SAuxiliar
		valueOf: 'SSTeacher'
		typeIn: testCase
		testCaseUsing: dictionary.
	self assert: value isNil.
	generatorInfo := SGeneratorInfo
		typeInfo: ( SSGenerator
		profile: [ SSTeacher name: 'Ann' with: 34 ]
		onClass: SSTeacher).
	testCase := STestCase seed: generatorInfo.
	dictionary := Dictionary new
		at: 'SSTeacher' put: {SSTeacher new};
		at: 'ByteString' put: {'sfoo' . 'ssteacher'};
		yourself.
	value := SAuxiliar
		valueOf: 'SSPerson'
		typeIn: testCase
		testCaseUsing: dictionary.
	self assert: value first class superclass name equals: #SSPerson.
	self assert: value second equals: 'SSTeacher'.
	self
		assertCollection: (testCase dictSubclasses at: 'SSPerson')
		hasSameElements: {#SSTeacher . #SStudent}
]
