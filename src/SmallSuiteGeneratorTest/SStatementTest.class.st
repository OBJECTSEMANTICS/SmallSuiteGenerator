Class {
	#name : #SStatementTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Core'
}

{ #category : #tests }
SStatementTest class >> testCaseSFoo [
	| profile testCase |
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
	^ testCase
]

{ #category : #tests }
SStatementTest class >> testCaseSFooWithAbstractClassAsArgs [
	| profile testCase |
	profile := SSGenerator
		profile: [ (SFoo score: 2)
				return:
					(SStudent new
						name: 'Vania';
						nickname: 'vania';
						scoreStudent: 5).
			(SFoo score: 6)
				return: ((SSTeacher name: 'Carl' with: 110) yearsWorkExperience: 5) ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase generateStatements.
	^ testCase
]

{ #category : #tests }
SStatementTest class >> testCaseSFooWithMethods [
	| profile testCase |
	profile := SSGenerator
		profile: [ (SFoo score: 34)
				score;
				returnCollection ]
		onClass: SFoo.
	testCase := STestCase seed: profile.
	testCase addConstructor.	"_var0 := SFoo score: 34"
	testCase addPrimitive.	"_var1 := 34"
	testCase addMethod.	"_var2 := _var0 initialize or _var0 returnCollection"
	testCase addConstructor.	"_var3 := SFoo score: _var1"
	testCase addMethod.
	testCase statements last receiverVarName: '_var0'.	"_var4 := _var0 initialize or _var0 returnCollection"
	testCase addPrimitive.	"_var5 := 34"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var6 := SFoo score: _var5"
	testCase addField.
	testCase statements last receiverVarName: '_var3'.	"_var7 := _var3 score"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var8 := SFoo score: _var5"
	testCase addConstructor.
	testCase statements last args: {'_var1'}.	"_var9 := SFoo score: _var1"
	testCase addField.
	testCase statements last receiverVarName: '_var9'.	"_var10 := _var9 score"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var11 := SFoo score: _var5"
	testCase addPrimitive.	"_var12 := 34"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var13 := SFoo score: _var5"
	testCase addField.
	testCase statements last receiverVarName: '_var9'.	"_var14 := _var9 score"
	testCase addPrimitive.	"_var15 := 34"
	testCase addField.
	testCase statements last receiverVarName: '_var11'.	"_var16 := _var11 score"
	testCase addConstructor.
	testCase statements last args: {'_var5'}.	"_var17 := SFoo score: _var5"
	testCase addMethod.
	testCase statements last receiverVarName: '_var8'.	"_var18 := _var7 initialize or _var7 returnCollection"
	^ testCase
]

{ #category : #tests }
SStatementTest class >> testCaseSStack [
	| profile testCase statement |
	profile := SSGenerator
		profile: [ (SStack newStackWith: {'abcd' . 'abcdf' . '1234' . '234'})
				push: '_varVania3';
				pop;
				top ]
		onClass: SStack.
	testCase := STestCase seed: profile.
	testCase addPrimitive.
	testCase addConstructor.
	statement := testCase statements last.
	"addMethod until gets a method with args"
	[ statement isMethod and: [ statement args isNotEmpty ] ]
		whileFalse: [ testCase addMethod.
			statement := testCase statements last ].
	^ testCase
]
