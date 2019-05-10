Class {
	#name : #SAuxiliarTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Core'
}

{ #category : #tests }
SAuxiliarTest >> testCollectDependenciesStatementsSimple [
	| profile testCase dependenciesStatements |
	profile := SSGenerator profile: [ SFoo score: 34 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addPrimitive.
	testCase addMethod.
	testCase addConstructor.
	"dependenciesStatements := STransformValue
		collectDependenciesStatements: testCase statements."
	self assert: dependenciesStatements size equals: 2.
	self
		assertCollection: dependenciesStatements associations
		hasSameElements:
			{('_var2' -> {'_var0'}).
			('_var3' -> {'_var1'})}
]

{ #category : #tests }
SAuxiliarTest >> testConstructorInTestCase [
	| profile testCase constructor |
	profile := SSGenerator
		profile: [ (SSTeacher name: 'Ann' with: 34)
				idTeacher;
				nickname ]
		onClass: SSTeacher.
	testCase := STestCase seed: profile.
	testCase addConstructor. "_var0 := SSteacher new"
	testCase addField. "_var1 := _var0 idTeacher"
	constructor := SAuxiliar
		constructorIn: testCase
		testCaseOf: testCase statements last
		statementWithBlockCondition: SFieldStatement blockCondition.
	self assert: constructor isNotNil.
	self assert: constructor varName equals: '_var0'.
	testCase := STestCase seed: profile.
	testCase addConstructor. "_var0 := SSteacher new"
	testCase addMethod. "_var1 := _var0 nickname"
	constructor := SAuxiliar
		constructorIn: testCase
		testCaseOf: testCase statements last
		statementWithBlockCondition: SMethodStatement blockCondition.
	self assert: constructor isNotNil.
	self assert: constructor varName equals: '_var0'
]

{ #category : #tests }
SAuxiliarTest >> testConstructorInTestCaseNotFound [
	| profile testCase constructor |
	profile := SSGenerator
		profile: [ (SSTeacher name: 'Ann' with: 34)
				idTeacher;
				nickname ]
		onClass: SSTeacher.
	testCase := STestCase seed: profile.
	testCase addConstructor.	"_var0 := SSteacher new"
	testCase addField.	"_var1 := _var0 idTeacher"
	testCase statements first theClassName: 'SStudent'.	"theClassName of constructor is changed"
	constructor := SAuxiliar
		constructorIn: testCase
		testCaseOf: testCase statements last
		statementWithBlockCondition: SFieldStatement blockCondition.
	self assert: constructor isNil.
	testCase := STestCase seed: profile.
	testCase addConstructor.	"_var0 := SSteacher new"
	testCase addMethod.	"_var1 := _var0 nickname"
	testCase statements first theClassName: 'SStudent'.	"theClassName of constructor is changed"
	constructor := SAuxiliar
		constructorIn: testCase
		testCaseOf: testCase statements last
		statementWithBlockCondition: SMethodStatement blockCondition.
	self assert: constructor isNil.
	testCase := STestCase seed: profile.
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
SAuxiliarTest >> testDataStatementsNonRepeatedStatements [
	| profile testCase dataStatements dictBodyStatement referencedVarNames |
	profile := SSGenerator profile: [ SFoo score: 34 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addPrimitive.
	testCase addMethod.
	testCase addConstructor.
	"dataStatements := STransformValue dataStatements: testCase statements."
	dictBodyStatement := dataStatements first.
	referencedVarNames := dataStatements second.
	self assert: dictBodyStatement size equals: 4.
	self
		assertCollection: dictBodyStatement keys
		includesAll: {'SFoo score: 34 .' . '34.' . 'SFoo score: _var1 .'}.
	self
		assert:
			(dictBodyStatement keys
				includesAnyOf: {'_var0 score: _var1 .' . '_var0 initialize.'}).
	self
		assertCollection: dictBodyStatement values
		hasSameElements:
			{{'_var0'} asOrderedCollection.
			{'_var1'} asOrderedCollection.
			{'_var2'} asOrderedCollection.
			{'_var3'} asOrderedCollection}.
	self assert: referencedVarNames size equals: 2.
	self
		assertCollection: referencedVarNames
		hasSameElements: {'_var0' . '_var1'}
]

{ #category : #tests }
SAuxiliarTest >> testDataStatementsRepeatedStatements [
	| profile testCase dataStatements dictBodyStatement referencedVarNames |
	profile := SSGenerator profile: [ SFoo score: 34 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.	"_var0 := SFoo score: 34"
	testCase addPrimitive.	"_var1 := 34"
	testCase addMethod.	"_var2 := _var0 initialize"
	testCase addConstructor.	"_var3 := SFoo score: _var1"
	testCase addMethod.
	testCase statements last receiverVarName: '_var0'.	"_var4 := _var0 initialize"
	testCase addPrimitive.	"_var5 := 34"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var6 := SFoo score: _var5"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var7 := SFoo score: _var5"
	testCase addConstructor.
	testCase statements last args: {'_var1'}.	"_var8 := SFoo score: _var1"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var9 := SFoo score: _var5"
	testCase addPrimitive.	"_var10 := 34"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var11 := SFoo score: _var5"
	testCase addPrimitive.	"_var12 := 34"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var13 := SFoo score: _var5"
	testCase addMethod.
	testCase statements last receiverVarName: '_var7'.	"_var14 := _var7 initialize"
	"dataStatements := STransformValue dataStatements: testCase statements."
	dictBodyStatement := dataStatements first.
	referencedVarNames := dataStatements second.
	self
		assertCollection: dictBodyStatement associations
		includesAll:
			{('SFoo score: 34 .' -> {'_var0'} asOrderedCollection).
			('34.'
				-> {'_var1' . '_var5' . '_var10' . '_var12'} asOrderedCollection).
			('SFoo score: _var1 .' -> {'_var3' . '_var8'} asOrderedCollection).
			('SFoo score: _var5 .'
				->
					{'_var6' . '_var7' . '_var9' . '_var11' . '_var13'}
						asOrderedCollection)}.
	self assert: referencedVarNames size equals: 4.
	self
		assertCollection: referencedVarNames
		hasSameElements: {'_var0' . '_var1' . '_var5' . '_var7'}
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
	| profile testCase |
	profile := SSGenerator profile: [ SFoo score: 5 ] onClass: SFoo.
	testCase := STestCase seed: profile.
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
SAuxiliarTest >> testValueOfTypeInTestCase [
	| profile testCase dictionary value |
	profile := SSGenerator
		profile: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		onClass: SSTeacher.
	testCase := STestCase seed: profile.
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
		assert: ((testCase dictSubclasses at: 'String') includes: 'ByteString').
	

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
	| profile testCase dictionary value |
	profile := SSGenerator
		profile: [ SSTeacher name: 'Ann' with: 34 ]
		onClass: SSTeacher.
	testCase := STestCase seed: profile.
	dictionary := Dictionary new
		at: 'ByteString' put: {'sfoo' . 'ssteacher'};
		yourself.
	value := SAuxiliar
		valueOf: 'SSTeacher'
		typeIn: testCase
		testCaseUsing: dictionary.
	self assert: value isNil.
	profile := SSGenerator
		profile: [ SSTeacher name: 'Ann' with: 34 ]
		onClass: SSTeacher.
	testCase := STestCase seed: profile.
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
