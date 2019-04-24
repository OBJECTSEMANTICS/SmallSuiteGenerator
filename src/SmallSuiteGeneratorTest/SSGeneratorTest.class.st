Class {
	#name : #SSGeneratorTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Generator'
}

{ #category : #'generator-tests' }
SSGeneratorTest >> testConstructorGenerator [
	| profile testCase |
	profile := SSGenerator profile: [ SFoo score: 2 ] onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	self
		assert: testCase statements first printString
		equals: '_var0 := SFoo score: 2 .'
]

{ #category : #tests }
SSGeneratorTest >> testFieldGenerator [
	| profile testCase |
	profile := SSGenerator
		profile: [ (SFoo score: 2) score ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addField.
	self
		assert: testCase printString
		equals:
			'_var0 := SFoo score: 2 .
_var1 := _var0 score.
'
]

{ #category : #tests }
SSGeneratorTest >> testMergeTypes [
	| profile method |
	profile := SSGenerator
		profile: [ SFoo new
				return: Stack new;
				return: OrderedCollection new ]
		onClass: SFoo.
	method := profile >> #SFoo >> #return:.
	self assert: method returnType equals: SequenceableCollection.
	self assert: method argTypes first equals: SequenceableCollection
]

{ #category : #tests }
SSGeneratorTest >> testMethodGenerator [
	| profile testCase collectString |
	profile := SSGenerator
		profile: [ (SFoo score: 2) return: 2 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addMethod.
	collectString := testCase statements collect: #printString.
	self
		assert:
			((collectString
				includesAll: {'_var0 := SFoo score: 2 .' . '_var1 := _var0 return: 2 .'})
				or: [ (collectString
						includesAll: {'_var0 := SFoo score: 2 .' . '_var1 := _var0 initialize.'}) or: [ collectString includesAll: { '_var0 := SFoo score: 2 .' . '_var1 := _var0 score: 2 .' } ] ]).
	profile := SSGenerator
		profile: [ (SFoo score: 4) return: (SStack newStackWith: {2 . 6 . 7}) ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.
	testCase addMethod.
	collectString := testCase statements collect: #printString.
	self
		assert:
			((collectString
				includesAll:
					{'_var0 := SFoo score: 4 .' . '_var1 := _var0 return: ((SStack new) add: 7; add: 6; add: 2; yourself) .'})
				or: [ (collectString
						includesAll: {'_var0 := SFoo score: 4 .' . '_var1 := _var0 initialize.'})
						or: [ collectString
								includesAll: {'_var0 := SFoo score: 4 .' . '_var1 := _var0 score: 4 .'} ] ])
]

{ #category : #tests }
SSGeneratorTest >> testMethodGeneratorOnClass [
	| profile testCase |
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
	testCase statements
		detect: [ :stm | stm isMethod and: [ stm selector = #return: ] ]
		ifFound: [ :stm | 
			self
				assert:
					(stm args
						includesAny:
							{(STON toString:((SSTeacher name: 'Carl' with: 110) yearsWorkExperience: 5)).
							 (STON toString: (SStudent new
										name: 'Peter';
										nickname: 'peter';
										scoreStudent: 5))
							}
						) ]
		ifNone: [ self assert: true ]
]

{ #category : #tests }
SSGeneratorTest >> testMethodGeneratorOnClasses [
	| profile testCase |
	profile := SSGenerator
		profile: [ (SFoo score: 2)
				return:
					(SStudent new
						name: 'Peter';
						nickname: 'peter';
						scoreStudent: 5).
			(SFoo score: 6)
				return: ((SSTeacher name: 'Carl' with: 110) yearsWorkExperience: 5) ]
		onClasses:
			{SFoo.
			SStudent.
			SSPerson.
			SSTeacher}.
	testCase := STestCase seed: profile.
	testCase generateStatements.
	testCase statements
		detect: [ :stm | stm isMethod and: [ stm selector = #return: ] ]
		ifFound: [ :stm | 
			| statement possibleValues |
			statement := testCase statementAt: stm args first.
			possibleValues := {#SSTeacher . #SStudent}.
			self
				assert:
					(statement isConstructor
						and: [ possibleValues includesAny: {statement theClassName. statement returnTypeName} ])
						 ]
		ifNone: [ self assert: true ]
]

{ #category : #'generator-tests' }
SSGeneratorTest >> testMultipleConstructorGenerator [
	| profile testCase |
	profile := SSGenerator
		profile: [ SFoo score: 2.
			SFoo score: 5.
			SFoo score: 7 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	10 timesRepeat: [ testCase addConstructor ].
	self assert: testCase statements size equals: 10
]

{ #category : #tests }
SSGeneratorTest >> testPrimitiveGenerator [
	| profile testCase |
	profile := SSGenerator
		profile: [ SFoo score: 2 ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	self
		assert: testCase statements first printString
		equals: '_var0 := 2.'
]

{ #category : #tests }
SSGeneratorTest >> testReturnType [
	| profile |
	profile := SSGenerator
		profile: [ SFoo new score ]
		onClass: SFoo.
	self
		assert: (profile >> #SFoo >> #score) returnType equals: SmallInteger
]

{ #category : #tests }
SSGeneratorTest >> testScalars [
	| profile |
	profile := SSGenerator
		profile: [ SFoo new
				return: 1;
				return: 2 ]
		onClass: SFoo.
	self assert: profile scalars size equals: 1.
	self assert: (profile scalars at: #SmallInteger) size equals: 2
]
