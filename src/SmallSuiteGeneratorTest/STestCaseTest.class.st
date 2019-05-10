Class {
	#name : #STestCaseTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Core'
}

{ #category : #'as yet unclassified' }
STestCaseTest class >> generateTestCase: aBlock with: aClass [
	| profile testCase |
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
			(self generateTestCase: [ SFoo score: 34 ] with: SFoo)
				generateStatements;
		add:
			(self generateTestCase: [ (SFoo score: 2) score ] with: SFoo)
				generateStatements;
		add:
			(self generateTestCase: [ (SFoo score: 2) return: 2 ] with: SFoo)
				generateStatements;
		add:
			(self
				generateTestCase: [ (SStudent name: 'Ann' with: 34)
						name;
						nickname;
						id ]
				with: SStudent) generateStatements;
		add:
			(self
				generateTestCase: [ (SStudent name: 'Ann' with: 34)
						age: 34;
						identifier;
						nickname: 'Ann34';
						fullIdentifier ]
				with: SStudent) generateStatements;
		add:
			(self
				generateTestCase: [ SStudent name: 'Peter'.
					SStudent name: 'Ann' with: 2 ]
				with: SStudent) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
STestCaseTest class >> listTestCaseRTAMItem [
	| list |
	list := OrderedCollection new.
	list
		add:
			((self
				generateTestCase: [ RTAMItem basicNew
						itemName: 'Bonus Card';
						color: Color lightCyan ]
				with: RTAMItem) generateStatements);
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
STestCaseTest class >> listTestCaseSStudent [
	| list |
	list := OrderedCollection new.
	list
		add:
			(self generateTestCase: [ SFoo score: 34 ] with: SFoo)
				generateStatements;
		add:
			(self generateTestCase: [ (SFoo score: 2) score ] with: SFoo)
				generateStatements;
		add:
			(self
				generateTestCase: [ (SFoo score: 2) return: 2 ]
				with: SFoo) generateStatements.
	^ list
]

{ #category : #'as yet unclassified' }
STestCaseTest >> argsInclude: varNames filteringBy: selector and: aTestCase [
	| selectedStatements |
	selectedStatements := aTestCase statements select: selector.
	selectedStatements detect: [ :aStm | aStm args includesAnyOf: varNames ]
	ifFound: [ ^ true ]
	ifNone: [ ^ false ].
	"^ (aTestCase statements select: selector thenCollect: #args) includes: varNames"
]

{ #category : #'mutation-change' }
STestCaseTest >> assertChange: listTestCase [
	| testCase varNames statementsOld |
	testCase := listTestCase shuffle anyOne.
	statementsOld := Dictionary new.
	testCase statements
		do:
			[ :aStm | statementsOld at: aStm varName put: aStm returnTypeName ].
	varNames := testCase change.
	varNames
		ifNotNil: [ varNames
				do: [ :varName | 
					self
						assert: (testCase statementAt: varName) returnTypeName
						equals: (statementsOld at: varName) ] ]
]

{ #category : #'mutation-insert' }
STestCaseTest >> assertInsertParameter: listTestCase [
	| testCase varNames |
	testCase := listTestCase shuffle anyOne.
	varNames := testCase insert: #insertParameterUsing:.
	varNames
		ifNotNil: [ self
				assert:
					((self argsInclude: varNames filteringBy: #isConstructor and: testCase)
						or: [ self argsInclude: varNames filteringBy: #isMethod and: testCase ]) ].
]

{ #category : #'mutation-remove' }
STestCaseTest >> assertRemove: listTestCase [
	| testCase removedVarNames |
	testCase := listTestCase shuffle anyOne.
	removedVarNames := testCase remove.
	(removedVarNames isNotNil and: [ removedVarNames isNotEmpty ])
		ifFalse: [ self assert: false ]
		ifTrue: [
			self assert: testCase hasValidDependencies.
			 "| varNames referencedArgs |
			varNames := testCase varNames.
			referencedArgs := OrderedCollection new.
			testCase statements
				select: [ :aStm | aStm isConstructor or: [ aStm isMethod ] ]
				thenDo: [ :aStm | referencedArgs addAll: aStm args ].
			removedVarNames
				do: [ :varName | 
					self deny: (varNames includes: varName).
					self deny: (referencedArgs includes: varName) ]" ]
]

{ #category : #'mutation-change' }
STestCaseTest >> testChangeConstructor [
	| profile testCase |
	profile := SSGenerator profile: [ SFoo score: 2 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase change.
	self deny: testCase statements first args equals: #(2).
	profile := SSGenerator profile: [ SFoo score: 3.56 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase change.
	self deny: testCase statements first args equals: #(3.56).
	profile := SSGenerator profile: [ SFoo score: $a ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase change.
	self deny: testCase statements first args equals: {$a}.
	profile := SSGenerator profile: [ SFoo score: true ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase change.
	self assert: testCase statements first args equals: #(false).
	profile := SSGenerator profile: [ SFoo score: 'hello' ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase change.
	self deny: testCase statements first args equals: #('hello').
	profile := SSGenerator
		profile: [ SFoo score: #(1 4 5) ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase change.
	self assert: testCase statements first args equals: {#(1 4 5)}
]

{ #category : #'mutation-change' }
STestCaseTest >> testChangeField [
	| profile testCase oldStatement |
	profile := SSGenerator
		profile: [ (SSTeacher name: 'Ann' with: 34)
				name;
				nickname;
				yearsWorkExperience;
				idTeacher;
				id ]
		onClass: SSTeacher.
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
	profile := SSGenerator
		profile: [ (SStudent name: 'Ann' with: 34)
				age: 34;
				identifier;
				nickname: 'Ann34';
				fullIdentifier ]
		onClass: SStudent.
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
STestCaseTest >> testChangeMethodWithArgsOfAbstractClass [
	| profile testCase oldStatement currentStatement |
	profile := SSGenerator
		profile: [ (SFoo score: 2)
				return:
					(SStudent new
						name: 'Peter';
						nickname: 'peter';
						scoreStudent: 5).
			(SFoo score: 6)
				return: ((SSTeacher name: 'Carl' with: 110) yearsWorkExperience: 5) ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase generateStatements.
	oldStatement := testCase statements
		detect: [ :stm | stm isMethod and: [ stm selector = #return: ] ]
		ifFound: [ :stm | stm deepCopy ]
		ifNone: [ ^ self assert: true ].
	testCase change: oldStatement varName.	"change the methodStatement"
	currentStatement := testCase statementAt: oldStatement varName.
	self denyCollection: currentStatement args equals: oldStatement args.
	self assert: testCase hasValidDependencies.
	self
		assert: testCase hasUniqueStatements 
]

{ #category : #'mutation-change' }
STestCaseTest >> testChangePrimitive [
	| profile testCase |
	profile := SSGenerator profile: [ SFoo score: 2 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase change.
	self deny: testCase statements first value equals: 2.
	profile := SSGenerator profile: [ SFoo score: 3.56 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase change.
	self deny: testCase statements first value equals: 3.56.
	profile := SSGenerator profile: [ SFoo score: $a ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase change.
	self deny: testCase statements first value equals: $a.
	profile := SSGenerator profile: [ SFoo score: true ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase change.
	self assert: testCase statements first value equals: false.
	profile := SSGenerator profile: [ SFoo score: 'hello' ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase change.
	self deny: testCase statements first value equals: 'hello'.
	profile := SSGenerator
		profile: [ SFoo score: #(1 4 5) ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase change.
	self assert: testCase statements first value equals: #(1 4 5)
]

{ #category : #'mutation-change' }
STestCaseTest >> testChangeRoassal [
	self assertChange: self class listTestCaseRTAMItem.
	self
		assertChange: self class listTestCaseRTBorderAttachPoint.
	self assertChange: self class listTestCaseRTBox.
	self assertChange: self class listTestCaseRTDirectedLine.
	self assertChange: self class listTestCaseRTLineSegment
]

{ #category : #'mutation-change' }
STestCaseTest >> testChangeWithTwoConstructor [
	| profile testCase oldSelector |
	profile := SSGenerator
		profile: [ SStack newStack.
			SStack newStackWith: { 1. 5. 7. 8 } ]
		onClass: SStack.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	oldSelector := testCase statements first selector.
	testCase change.
	self deny: testCase statements first selector equals: oldSelector
]

{ #category : #'mutation-insert' }
STestCaseTest >> testInsertMethodCall [
	| profile testCase varNames stm |
	profile := SSGenerator
		profile: [ (SFoo score: 2) return: 3 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	self assert: (testCase insert: #insertMethodCallUsing:) equals: nil.
	profile := SSGenerator
		profile: [ (SFoo score: 2) return: 2 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	self assert: (testCase insert: #insertMethodCallUsing:) equals: nil.
	profile := SSGenerator
		profile: [ (SFoo score: 2) score ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addField.
	self assert: (testCase insert: #insertMethodCallUsing:) equals: nil.
	profile := SSGenerator
		profile: [ (SFoo score: 2)
				score;
				return: 3 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addMethod.
	varNames := testCase insert: #insertMethodCallUsing:.
	self assert: testCase statements size > 3.
	stm := testCase statementAt: varNames last.
	self assert: (stm isMethod or: [ stm isConstructor ]).
	profile := SSGenerator
		profile: [ (SFoo score: 2)
				score;
				return: 3 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addMethod.
	testCase addMethod.
	varNames := testCase insert: #insertMethodCallUsing:.
	self assert: testCase statements size > 4.
	self assert: testCase hasValidDependencies.
]

{ #category : #'mutation-insert' }
STestCaseTest >> testInsertParameter [
	| profile testCase varNames |
	"if is primitive, parameter is not added"
	"parameter is added if any statement has args"
	profile := SSGenerator profile: [ SFoo score: 2 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase insert: #insertParameterUsing:.
	self assert: testCase statements size equals: 1.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	varNames := testCase insert: #insertParameterUsing:.
	varNames
		ifNotNil: [ self
				assert:
					((testCase statements select: #isConstructor) first args
						includes: varNames first).
			self assert: testCase hasValidDependencies.
			self assert: testCase hasUniqueStatements  ].
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addField.
	varNames := testCase insert: #insertParameterUsing:.
	varNames
		ifNotNil: [ self
				assert:
					((testCase statements select: #isConstructor) first args
						includes: varNames first).
			self assert: testCase hasValidDependencies.
			self assert: testCase hasUniqueStatements  ].
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addMethod.
	varNames := testCase insert: #insertParameterUsing:.
	varNames
		ifNotNil: [ self
				assert:
					((OrderedCollection new
						addAll: (testCase statements select: #isConstructor thenCollect: #args) first;
						addAll: (testCase statements select: #isMethod thenCollect: #args) first;
						yourself) includes: varNames first).
			self assert: testCase hasValidDependencies.
			self assert: testCase hasUniqueStatements  ].
	profile := SSGenerator
		profile: [ (SStack newStackWith: {2 . 4 . 6 . 1})
				push: 8;
				pop;
				top ]
		onClass: SStack.
	testCase := STestCase seed: profile.
	testCase generateStatements.
	testCase insert: #insertParameterUsing:.
	self assert: testCase hasValidDependencies.
	self assert: testCase hasUniqueStatements 
]

{ #category : #'mutation-insert' }
STestCaseTest >> testInsertParameterRoassal [
	self assertInsertParameter: self class listTestCaseRTAMItem.
	self
		assertInsertParameter: self class listTestCaseRTBorderAttachPoint.
	self assertInsertParameter: self class listTestCaseRTBox.
	self assertInsertParameter: self class listTestCaseRTDirectedLine.
	self assertInsertParameter: self class listTestCaseRTLineSegment
]

{ #category : #'mutation-insert' }
STestCaseTest >> testInsertRandomCall [
	| profile testCase stm varNames |
	profile := SSGenerator
		profile: [ SFoo score: 2 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	self assert: (testCase insert: #insertRandomCallUsing:)isNil.
	profile := SSGenerator
		profile: [ SFoo score: 2 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	varNames := (testCase insert: #insertRandomCallUsing:).
	self assert: testCase statements size > 2.
	self assertCollection: varNames equals: {'_var2' . '_var3'}.
	profile := SSGenerator
		profile: [ (SFoo score: 2) score ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addField.
	varNames := testCase insert: #insertRandomCallUsing:.
	self assert: testCase statements size > 3.
	self assert: (varNames includesAny: {'_var3' . '_var4'}).
	"self assert: (testCase statementAt: '_var3') isPrimitive."
	stm := testCase statementAt: varNames last.
	self assert: (stm isField or: [ stm isConstructor ]).
	"stm := testCase statementAt: varNames.
	self assert: (stm isConstructor or: [ stm isField ])."
	profile := SSGenerator
		profile: [ (SFoo score: 2) return: 2 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	testCase addMethod.
	varNames := testCase insert: #insertRandomCallUsing:.
	self assert: testCase statements size > 3.
	self assert: (varNames includesAny: {'_var3' . '_var4'}).
	stm := testCase statementAt: varNames last.
	self assert: (stm isConstructor or: [ stm isMethod ])
]

{ #category : #'mutation-remove' }
STestCaseTest >> testRemoveConstructor [
	| profile testCase |
	profile := SSGenerator
		profile: [ SFoo score: 2 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase remove.
	self assert: testCase statements isEmpty.
	profile := SSGenerator
		profile: [ SFoo score: 2 ]
		onClass: SFoo.
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
	profile := SSGenerator
		profile: [ (SFoo score: 2) score ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addField.
	varNamesDeleted := testCase remove: '_var1'.	"remove the fieldStatement"
	self assertCollection: varNamesDeleted equals: {'_var1'}.
	self assert: testCase statements size equals: 1.
	profile := SSGenerator
		profile: [ (SFoo score: 2) score ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addField.
	varNamesDeleted := testCase remove: '_var0'.	"remove the constructorStatement"
	self assertCollection: varNamesDeleted equals: {'_var0'}.
	self
		assertCollection: (testCase statements collect: #varName)
		hasSameElements: #('_var2' '_var1').
	statement := testCase statements first.
	self
		assert: (statement isConstructor and: [ statement varName = '_var2' ]).
	self assert: testCase statements last receiverVarName equals: '_var2'.
	self assert: testCase hasValidDependencies.
]

{ #category : #'mutation-remove' }
STestCaseTest >> testRemoveMethod [
	| profile testCase varNamesDeleted statement referencedVarName |
	profile := SSGenerator
		profile: [ (SFoo score: 2) return: 2 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addMethod.
	varNamesDeleted := testCase remove: '_var1'.	"remove the methodStatement"
	self assert: testCase statements size equals: 1.
	self assertCollection: varNamesDeleted equals: {'_var1'}.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addMethod.
	varNamesDeleted := testCase remove: '_var0'.	"remove the constructorStatement"
	self assertCollection: varNamesDeleted equals: {'_var0'}.
	self
		assertCollection: (testCase statements collect: #varName)
		includesAll: #('_var1' '_var2').
	statement := testCase statements first.
	self
		assert: (statement isConstructor and: [ statement varName = '_var2' ]).
	self assert: testCase statements last receiverVarName equals: '_var2'.
	self assert: testCase hasValidDependencies.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addConstructor.
	testCase addMethod.	"_var2"
	referencedVarName := (testCase statementAt: '_var2') receiverVarName.
	varNamesDeleted := testCase remove: referencedVarName.	"remove the constructorStatement"
	self assertCollection: varNamesDeleted equals: {referencedVarName}.
	self
		assert: (testCase statementAt: '_var2') receiverVarName
		equals: '_var3'.
	self assert: testCase hasValidDependencies
]

{ #category : #'mutation-remove' }
STestCaseTest >> testRemovePrimitive [
	| profile testCase |
	profile := SSGenerator
		profile: [ SFoo score: 2 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase remove.
	self assert: testCase statements isEmpty
]

{ #category : #'mutation-remove' }
STestCaseTest >> testRemoveRoassal [
	self assertRemove: self class listTestCaseRTAMItem.
	self assertRemove: self class listTestCaseRTBorderAttachPoint.
	self assertRemove: self class listTestCaseRTBox.
	self assertRemove: self class listTestCaseRTDirectedLine.
	self assertRemove: self class listTestCaseRTLineSegment
]
