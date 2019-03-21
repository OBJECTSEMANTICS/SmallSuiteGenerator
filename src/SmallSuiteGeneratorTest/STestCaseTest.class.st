Class {
	#name : #STestCaseTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Mutation'
}

{ #category : #'mutation-change' }
STestCaseTest >> testChangeConstructor [
	| profile testCase |
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase change.
	self deny: testCase statements first args equals: #('2').
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 3.56 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase change.
	self deny: testCase statements first args equals: #('3.56').
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: $a ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase change.
	self deny: testCase statements first args equals: #('$a').
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: true ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase change.
	self assert: testCase statements first args equals: #('false').
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 'hello' ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase change.
	self deny: testCase statements first args equals: #('hello').
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: #(1 4 5) ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase change.
	self assert: testCase statements first args equals: #('#(1 4 5 )')
]

{ #category : #'mutation-change' }
STestCaseTest >> testChangeField [
	| profile testCase oldStatement |
	SStatement reset.
	profile := SSGenerator
		profile: [ (SSPerson name: 'Ann' with: 34)
				name;
				nickname;
				id ]
		onClass: SSPerson.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addField.
	oldStatement := testCase statements second deepCopy.
	testCase change: '_var1'.	"change the fieldStatement"
	testCase statements second fieldName = #id
		ifTrue: [ self
				assert: testCase statements second fieldName
				equals: oldStatement fieldName ]
		ifFalse: [ self
				deny: testCase statements second fieldName
				equals: oldStatement fieldName.
			self
				assert: oldStatement returnTypeName
				equals: testCase statements second returnTypeName ]
]

{ #category : #'mutation-change' }
STestCaseTest >> testChangeMethod [
	| profile testCase oldStatement currentStatement |
	SStatement reset.
	profile := SSGenerator
		profile: [ (SSPerson name: 'Ann' with: 34)
				age: 34;
				identifier;
				nickname: 'Ann34';
				fullIdentifier ]
		onClass: SSPerson.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addMethod.
	testCase addMethod.
	testCase addMethod.
	oldStatement := testCase statements allButFirst shuffle anyOne
		deepCopy.
	testCase change: oldStatement varName.	"change the methodStatement"
	currentStatement := testCase statements second.
	oldStatement selector = currentStatement selector
		ifTrue: [ oldStatement args
				ifNotEmpty: [ self deny: oldStatement args equals: currentStatement args ] ]
		ifFalse: [ self deny: oldStatement selector equals: currentStatement selector ]
]

{ #category : #'mutation-change' }
STestCaseTest >> testChangePrimitive [
	| profile testCase |
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase change.
	self deny: testCase statements first value equals: '2'.
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 3.56 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase change.
	self deny: testCase statements first value equals: '3.56'.
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: $a ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase change.
	self deny: testCase statements first value equals: '$a'.
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: true ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase change.
	self assert: testCase statements first value equals: 'false'.
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 'hello' ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase change.
	self deny: testCase statements first value equals: 'hello'.
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: #(1 4 5) ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase change.
	self assert: testCase statements first value equals: '#(1 4 5 )'
]

{ #category : #'mutation-insert' }
STestCaseTest >> testInsertMethodCall [
	| profile testCase position |
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) return: 3 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	self assert: testCase insertMethodCall equals: -1.
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) return: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	self assert: testCase insertMethodCall equals: -1.
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) score ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addField.
	self assert: testCase insertMethodCall equals: -1.
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2)
				score;
				return: 3 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addMethod.
	position := testCase insertMethodCall.
	self assert: testCase statements size equals: 4.
	self assert: (testCase statements at: position) isMethod
]

{ #category : #'mutation-insert' }
STestCaseTest >> testInsertParameter [
	| profile testCase position |
	"if is primitive, parameter is not added"
	"parameter is added if any statement has args"
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.	
	testCase insertParameter.
	self assert: testCase statements size equals: 1.
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	position := testCase insertParameter.
	position > 0
		ifTrue: [ self
				assert:
					((testCase statements select: #isConstructor) first args
						includes: (testCase statements at: position) varName) ].
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addField.
	position := testCase insertParameter.
	position > 0
		ifTrue: [ self
				assert:
					((testCase statements select: #isConstructor) first args
						includes: (testCase statements at: position) varName) ].
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addMethod.
	position := testCase insertParameter.
	position > 0
		ifTrue: [ self
				assert:
					((OrderedCollection new
						addAll: (testCase statements select: #isConstructor thenCollect: #args) first;
						addAll: (testCase statements select: #isMethod thenCollect: #args) first;
						yourself) includes: (testCase statements at: position) varName) ]
]

{ #category : #'mutation-insert' }
STestCaseTest >> testInsertRandomCall [
	| profile testCase stm position |
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	self assert: testCase insertRandomCall equals: -1.
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	position := testCase insertRandomCall.
	self assert: testCase statements size equals: 3.
	self assert: (testCase statements at: position) isConstructor.
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) score ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addField.
	position := testCase insertRandomCall.
	self assert: testCase statements size equals: 4.
	stm := testCase statements at: position.
	self assert: (stm isConstructor or: [ stm isField ]).
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) return: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addMethod.
	position := testCase insertRandomCall.
	self assert: testCase statements size equals: 4.
	stm := testCase statements at: position.
	self assert: (stm isConstructor or: [ stm isMethod ])
]

{ #category : #mutation }
STestCaseTest >> testMutateConstructor [
	| profile testCase |
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase remove.
	self assert: testCase statements isEmpty.
]

{ #category : #mutation }
STestCaseTest >> testMutatePrimitive [
	| profile testCase |
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase remove.
	self assert: testCase statements isEmpty.
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2)
				return: 3;
				return: 18 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase
		addPrimitive;
		addPrimitive;
		addPrimitive;
		addPrimitive;
		addPrimitive.
	testCase change.
	self assert: testCase statements first value isLiteral
]

{ #category : #'mutation-remove' }
STestCaseTest >> testRemove [
	"| profile testCase |
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2)
				return: 2;
				score ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase generateStatements.
	testCase remove"
]

{ #category : #'mutation-remove' }
STestCaseTest >> testRemoveConstructor [
	| profile testCase |
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase remove.
	self assert: testCase statements isEmpty.
]

{ #category : #'mutation-remove' }
STestCaseTest >> testRemoveField [
	| profile testCase |
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) score ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addField.
	testCase remove: '_var1'.	"remove the fieldStatement"
	self assert: testCase statements size equals: 1.
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) score ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addField.
	testCase remove: '_var0'.	"remove the constructorStatement"
	self
		assertCollection: (testCase statements collect: #varName)
		includesAll: #('_var1' '_var2')
]

{ #category : #'mutation-remove' }
STestCaseTest >> testRemoveMethod [
	| profile testCase |
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) return: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addMethod.
	testCase remove: '_var1'.	"remove the methodStatement"
	self assert: testCase statements size equals: 1.
	self assert: testCase statements first isConstructor.
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) return: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addMethod.
	testCase remove: '_var0'. "remove the constructorStatement"
	self
		assertCollection: (testCase statements collect: #varName)
		includesAll: #('_var1' '_var2')
]

{ #category : #'mutation-remove' }
STestCaseTest >> testRemovePrimitive [
	| profile testCase |
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase remove.
	self assert: testCase statements isEmpty
]
