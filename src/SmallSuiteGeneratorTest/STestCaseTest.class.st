Class {
	#name : #STestCaseTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Mutation'
}

{ #category : #'as yet unclassified' }
STestCaseTest class >> generateTestCase: aBlock with: aClass [
	| profile testCase |
	SStatement reset.
	profile := SSGenerator profile: aBlock onClass: aClass.
	testCase := STestCase seed: profile.
	^ testCase
]

{ #category : #'as yet unclassified' }
STestCaseTest class >> listTestCase [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self generateTestCase: [ SStudent score: 34 ] with: SStudent)
				generateStatements;
		add:
			(self generateTestCase: [ (SStudent score: 2) score ] with: SStudent)
				generateStatements;
		add:
			(self
				generateTestCase: [ (SStudent score: 2) return: 2 ]
				with: SStudent) generateStatements;
		add:
			(self
				generateTestCase: [ (SSPerson name: 'Ann' with: 34)
						name;
						nickname;
						id ]
				with: SSPerson) generateStatements;
		add:
			(self
				generateTestCase: [ (SSPerson name: 'Ann' with: 34)
						age: 34;
						identifier;
						nickname: 'Ann34';
						fullIdentifier ]
				with: SSPerson) generateStatements;
		add:
			(self
				generateTestCase: [ SSPerson name: 'Peter'.
					SSPerson name: 'Ann' with: 2 ]
				with: SSPerson) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
STestCaseTest class >> listTestCaseRTAMItem [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestCase: [ RTAMItem basicNew
						itemName: 'Bonus Card';
						color: Color lightCyan ]
				with: RTAMItem) generateStatements;
		add:
			(self
				generateTestCase: [ RTAMItem basicNew
						itemName: 'Contract Management';
						row: 'Australia';
						column: 'Corporate Services';
						color: Color red ]
				with: RTAMItem) generateStatements;
		add:
			(self
				generateTestCase: [ RTAMItem basicNew
						itemName: 'Bonus Card';
						row: 'France';
						column: 'Customer Relationship';
						color: Color lightGreen ]
				with: RTAMItem) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
STestCaseTest class >> listTestCaseRTBorderAttachPoint [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestCase: [ (RTBorderAttachPoint instance) offset: 4  ]
				with: RTBorderAttachPoint) generateStatements;
		add:
			(self
				generateTestCase: [ (RTBorderAttachPoint instance) offset: 19  ]
				with: RTBorderAttachPoint) generateStatements;
		add:
			(self
				generateTestCase: [ (RTBorderAttachPoint instance) offset: 4  ]
				with: RTBorderAttachPoint) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
STestCaseTest class >> listTestCaseRTBox [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestCase: [ RTBox instance
						defaultWidth;
						borderStyle ]
				with: RTBox) generateStatements;
		add:
			(self
				generateTestCase: [ RTBox instance
						borderStyle ]
				with: RTBox) generateStatements;
		add:
			(self
				generateTestCase: [ RTBox instance
						defaultWidth;
						height;
						borderStyle ]
				with: RTBox) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
STestCaseTest class >> listTestCaseRTDirectedLine [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestCase: [ RTDirectedLine instance offset: 6.5 ]
				with: RTDirectedLine) generateStatements;
		add:
			(self
				generateTestCase: [ RTDirectedLine instance pointsFrom: 1 @ 3 To: 3 @ 5 ]
				with: RTDirectedLine) generateStatements;
		add:
			(self
				generateTestCase: [ RTDirectedLine instance
						offset: 56; offset: 2.4 ]
				with: RTDirectedLine) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
STestCaseTest class >> listTestCaseRTLineSegment [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self
				generateTestCase: [ RTLineSegment from: 1 @ 2 to: 3 @ 4 ]
				with: RTLineSegment) generateStatements;
		add:
			(self
				generateTestCase: [ (RTLineSegment from: 2 @ 6 to: 5 @ 8)
						from;
						to;
						a;
						b;
						c ]
				with: RTLineSegment) generateStatements;
		add:
			(self
				generateTestCase: [ (RTLineSegment from: 4 @ 9 to: 5 @ 18)
						angleInDeg;
						angleInRad;
						cotan;
						bottom ]
				with: RTLineSegment) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
STestCaseTest class >> listTestCaseStudent [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self generateTestCase: [ SStudent score: 34 ] with: SStudent)
				generateStatements;
		add:
			(self generateTestCase: [ (SStudent score: 2) score ] with: SStudent)
				generateStatements;
		add:
			(self
				generateTestCase: [ (SStudent score: 2) return: 2 ]
				with: SStudent) generateStatements.
	^ list
]

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

{ #category : #'mutation-change' }
STestCaseTest >> testChangeWithTwoConstructor [
	| profile testCase oldSelector |
	SStatement reset.
	profile := SSGenerator
		profile: [ SSPerson name: 'Peter'.
			SSPerson name: 'Ann' with: 2 ]
		onClass: SSPerson.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	oldSelector := testCase statements first selector.
	testCase change.
	self deny: testCase statements first selector equals: oldSelector
]

{ #category : #crossover }
STestCaseTest >> testCrossOverToRTAMItem [
	| listTestCase offSprings offSpring1 offSpring2 |
	listTestCase := self class listTestCaseRTAMItem shuffle.
	self halt." error because RTAMItem does not have factoryMethods"
	offSprings := listTestCase first crossOverWith: listTestCase second.
	offSpring1 := offSprings first.
	offSpring2 := offSprings second.
	self assert: offSpring1 class equals: STestCase.
	self
		assert:
			(offSpring1 statements size - offSpring2 statements size) abs
				<=
					(listTestCase first statements size
						- listTestCase second statements size) abs
]

{ #category : #crossover }
STestCaseTest >> testCrossOverToRTBorderAttachPoint [
	| listTestCase offSprings offSpring1 offSpring2 |
	listTestCase := self class listTestCaseRTBorderAttachPoint shuffle.
	"self halt."	"error because the metaClassSpy does not have factoryMethods"
	offSprings := listTestCase first crossOverWith: listTestCase second.
	offSpring1 := offSprings first.
	offSpring2 := offSprings second.
	self assert: offSpring1 class equals: STestCase.
	self
		assert:
			(offSpring1 statements size - offSpring2 statements size) abs
				<=
					(listTestCase first statements size
						- listTestCase second statements size) abs
]

{ #category : #crossover }
STestCaseTest >> testCrossOverToRTBox [
	| listTestCase offSprings offSpring1 offSpring2 |
	listTestCase := self class listTestCaseRTBox shuffle.
	offSprings := listTestCase first crossOverWith: listTestCase second.
	offSpring1 := offSprings first.
	offSpring2 := offSprings second.
	self assert: offSpring1 class equals: STestCase.
	self
		assert:
			(offSpring1 statements size - offSpring2 statements size) abs
				<=
					(listTestCase first statements size
						- listTestCase second statements size) abs
]

{ #category : #crossover }
STestCaseTest >> testCrossOverToRTDirectedLine [
	| listTestCase offSprings offSpring1 offSpring2 |
	listTestCase := self class listTestCaseRTDirectedLine shuffle.
	offSprings := listTestCase first crossOverWith: listTestCase second.
	offSpring1 := offSprings first.
	offSpring2 := offSprings second.
	self assert: offSpring1 class equals: STestCase.
	self
		assert:
			(offSpring1 statements size - offSpring2 statements size) abs
				<=
					(listTestCase first statements size
						- listTestCase second statements size) abs
]

{ #category : #crossover }
STestCaseTest >> testCrossOverToRTLineSegment [
	| listTestCase offSprings offSpring1 offSpring2 |
	listTestCase := self class listTestCaseRTLineSegment shuffle.
	offSprings := listTestCase first crossOverWith: listTestCase second.
	offSpring1 := offSprings first.
	offSpring2 := offSprings second.
	self assert: offSpring1 class equals: STestCase.
	self
		assert:
			(offSpring1 statements size - offSpring2 statements size) abs
				<=
					(listTestCase first statements size
						- listTestCase second statements size) abs.
	self assert: offSpring1 hasValidDependencies.
	self assert: offSpring2 hasValidDependencies
]

{ #category : #crossover }
STestCaseTest >> testCrossOverToSStudent [
	| listTestCase offSprings offSpring1 offSpring2 |
	listTestCase := self class listTestCaseStudent shuffle.
	offSprings := listTestCase first crossOverWith: listTestCase second.
	offSpring1 := offSprings first.
	offSpring2 := offSprings second.
	self assert: offSpring1 class equals: STestCase.
	self
		assert:
			(offSpring1 statements size - offSpring2 statements size) abs
				<=
					(listTestCase first statements size
						- listTestCase second statements size) abs.
	
]

{ #category : #'mutation-insert' }
STestCaseTest >> testInsertMethodCall [
	| profile testCase varNames stm |
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) return: 3 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	self assert: testCase insertMethodCall equals: nil.
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) return: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	self assert: testCase insertMethodCall equals: nil.
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) score ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addField.
	self assert: testCase insertMethodCall equals: nil.
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
	varNames := testCase insertMethodCall.
	self assert: testCase statements size > 3.
	stm := testCase statementAt: varNames last.
	self assert: (stm isMethod or: [ stm isConstructor ])
]

{ #category : #'mutation-insert' }
STestCaseTest >> testInsertParameter [
	| profile testCase varNames |
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
	varNames := testCase insertParameter.
	varNames ifNotNil: [ self
				assert:
					((testCase statements select: #isConstructor) first args
						includes: varNames first) ].
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addField.
	varNames := testCase insertParameter.
	varNames ifNotNil: [ self
				assert:
					((testCase statements select: #isConstructor) first args
						includes: varNames first) ].
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addMethod.
	varNames := testCase insertParameter.
	varNames ifNotNil: [ self
				assert:
					((OrderedCollection new
						addAll: (testCase statements select: #isConstructor thenCollect: #args) first;
						addAll: (testCase statements select: #isMethod thenCollect: #args) first;
						yourself) includes: varNames first) ]
]

{ #category : #'mutation-insert' }
STestCaseTest >> testInsertRandomCall [
	| profile testCase stm varNames |
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	self assert: testCase insertRandomCall isNil.
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	varNames := testCase insertRandomCall.
	self assert: testCase statements size equals: 4.
	self assertCollection: varNames equals: {'_var2' . '_var3'}.
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) score ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addField.
	varNames := testCase insertRandomCall.
	self assert: testCase statements size > 3.
	self assert: (varNames includesAny: {'_var3' . '_var4'}).
	"self assert: (testCase statementAt: '_var3') isPrimitive."
	stm := testCase statementAt: varNames last.
	self assert: (stm isField or: [ stm isConstructor ]).
	"stm := testCase statementAt: varNames.
	self assert: (stm isConstructor or: [ stm isField ])."
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) return: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addMethod.
	varNames := testCase insertRandomCall.
	self assert: testCase statements size > 3.
	self assert: (varNames includesAny: {'_var3' . '_var4'}).
	stm := testCase statementAt: varNames last.
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
	SStatement reset.
	profile := SSGenerator
		profile: [ SStudent score: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	self assert: (testCase statements last args includes: '_var0').
	testCase remove: '_var0'.
	self assert: testCase statements size equals: 1.
	self deny: (testCase statements last args includes: '_var0')
]

{ #category : #'mutation-remove' }
STestCaseTest >> testRemoveField [
	| profile testCase varNamesDeleted statement |
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) score ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addField.
	varNamesDeleted := testCase remove: '_var1'.	"remove the fieldStatement"
	self assertCollection: varNamesDeleted equals: {'_var1'}.
	self assert: testCase statements size equals: 1.
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) score ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addField.
	varNamesDeleted := testCase remove: '_var0'.	"remove the constructorStatement"
	self assertCollection: varNamesDeleted equals: {'_var0'}.
	self
		assertCollection: (testCase statements collect: #varName)
		hasSameElements: #('_var2' '_var1').
	statement := testCase statements first.
	self assert: (statement isConstructor and: [statement varName = '_var2']).
	self assert: testCase statements last receiverVarName equals: '_var2'
]

{ #category : #'mutation-remove' }
STestCaseTest >> testRemoveMethod [
	| profile testCase varNamesDeleted statement |
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) return: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addMethod.
	varNamesDeleted := testCase remove: '_var1'.	"remove the methodStatement"
	self assert: testCase statements size equals: 1.
	self assertCollection: varNamesDeleted equals: {'_var1'}.
	SStatement reset.
	profile := SSGenerator
		profile: [ (SStudent score: 2) return: 2 ]
		onClass: SStudent.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addMethod.
	varNamesDeleted := testCase remove: '_var0'.	"remove the constructorStatement"
	self assertCollection: varNamesDeleted equals: {'_var0'}.
	self
		assertCollection: (testCase statements collect: #varName)
		includesAll: #('_var1' '_var2').
	statement := testCase statements first.
	self assert: (statement isConstructor and: [ statement varName = '_var2' ]).
	self assert: testCase statements last receiverVarName equals: '_var2'
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
