Class {
	#name : #SSAssertionGeneratorTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Assertion'
}

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test0 [
| _var0 _var1 _var2 _var3 _var4 _var5 _var6 _var7 _var8 _var9 |
_var0 := 'Customer Relationship'.
_var1 := RTAMItem new.
_var2 := 'France'.
_var3 := _var1 itemName: _var0.
_var4 := _var1 initialize.
_var5 := 'France'.
_var6 := RTAMItem new.
_var7 := _var6 column: _var0.
_var8 := _var6
	color:
		(Color
			r: 0.8
			g: 1.0
			b: 0.6
			alpha: 1.0).
_var9 := _var1 row: _var5.
self assert: _var0 size equals: 21.
self
	assert: (_var0 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var0 className equals: 'ByteString'.
self assert: _var0 equals: 'Customer Relationship'.
self assert: _var0 asString equals: 'Customer Relationship'.
self assert: _var1 className equals: 'RTAMItem'.
self assert: _var2 size equals: 6.
self
	assert: (_var2 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var2 className equals: 'ByteString'.
self assert: _var2 equals: 'France'.
self assert: _var2 asString equals: 'France'.
self assert: _var3 className equals: 'RTAMItem'.
self assert: _var4 className equals: 'RTAMItem'.
self assert: _var5 size equals: 6.
self
	assert: (_var5 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var5 className equals: 'ByteString'.
self assert: _var5 equals: 'France'.
self assert: _var5 asString equals: 'France'.
self assert: _var6 className equals: 'RTAMItem'.
self assert: _var7 className equals: 'RTAMItem'.
self assert: _var8 className equals: 'RTAMItem'.
self assert: _var9 className equals: 'RTAMItem'
]

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test1 [
| _var0 _var1 _var2 _var3 _var10 _var4 _var5 _var6 _var7 _var8 _var9 |
_var0 := 'Bonus Card'.
_var1 := RTAMItem new.
_var2 := _var1 itemName: _var0.
_var3 := 'Bonus Card'.
_var10 := 'Bonus Card'.
_var4 := _var1 row: _var10.
_var5 := 'France'.
_var6 := RTAMItem new.
_var7 := _var1 column: _var0.
_var8 := _var1
	color:
		(Color
			r: 0.8
			g: 1.0
			b: 0.6
			alpha: 1.0).
_var9 := _var1 row: _var5.
self assert: _var0 size equals: 10.
self
	assert: (_var0 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var0 className equals: 'ByteString'.
self assert: _var0 equals: 'Bonus Card'.
self assert: _var0 asString equals: 'Bonus Card'.
self assert: _var1 className equals: 'RTAMItem'.
self assert: _var2 className equals: 'RTAMItem'.
self assert: _var3 size equals: 10.
self
	assert: (_var3 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var3 className equals: 'ByteString'.
self assert: _var3 equals: 'Bonus Card'.
self assert: _var3 asString equals: 'Bonus Card'.
self assert: _var10 size equals: 10.
self
	assert: (_var10 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var10 className equals: 'ByteString'.
self assert: _var10 equals: 'Bonus Card'.
self assert: _var10 asString equals: 'Bonus Card'.
self assert: _var4 className equals: 'RTAMItem'.
self assert: _var5 size equals: 6.
self
	assert: (_var5 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var5 className equals: 'ByteString'.
self assert: _var5 equals: 'France'.
self assert: _var5 asString equals: 'France'.
self assert: _var6 className equals: 'RTAMItem'.
self assert: _var7 className equals: 'RTAMItem'.
self assert: _var8 className equals: 'RTAMItem'.
self assert: _var9 className equals: 'RTAMItem'
]

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test10 [
| _var0 _var5 _var2 _var3 _var4 _var6 _var7 _var1 _var8 _var9 _var10 _var11 _var12 _var13 _var14 _var15 |
_var0 := RTBox new.
_var5 := _var0 borderStyle.
_var2 := RTBox new.
_var3 := _var0 borderStyle.
_var4 := _var0 borderStyle.
_var6 := RTBox new.
_var7 := RTBox new.
_var1 := RTBox new.
_var8 := RTBox new.
_var9 := _var0 borderStyle.
_var10 := RTBox new.
_var11 := _var0 borderStyle.
_var12 := RTBox new.
_var13 := _var0 borderStyle.
_var14 := _var0 borderStyle.
_var15 := RTBox new.
self assert: _var0 className equals: 'RTBox'.
self assert: _var5 className equals: 'RTBorderStyle'.
self assert: _var2 className equals: 'RTBox'.
self assert: _var3 className equals: 'RTBorderStyle'.
self assert: _var4 className equals: 'RTBorderStyle'.
self assert: _var6 className equals: 'RTBox'.
self assert: _var7 className equals: 'RTBox'.
self assert: _var1 className equals: 'RTBox'.
self assert: _var8 className equals: 'RTBox'.
self assert: _var9 className equals: 'RTBorderStyle'.
self assert: _var10 className equals: 'RTBox'.
self assert: _var11 className equals: 'RTBorderStyle'.
self assert: _var12 className equals: 'RTBox'.
self assert: _var13 className equals: 'RTBorderStyle'.
self assert: _var14 className equals: 'RTBorderStyle'.
self assert: _var15 className equals: 'RTBox'
]

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test11 [
| _var0 _var14 _var16 _var1 _var2 _var3 _var4 _var5 _var6 _var7 _var8 _var9 |
_var0 := RTBox new.
_var14 := _var0 borderStyle.
_var16 := _var0 borderStyle.
_var1 := _var0 borderStyle.
_var2 := _var0 borderStyle.
_var3 := RTBox new.
_var4 := _var0 borderStyle.
_var5 := _var0 borderStyle.
_var6 := RTBox new.
_var7 := _var0 borderStyle.
_var8 := _var0 borderStyle.
_var9 := _var0 borderStyle.
self assert: _var0 className equals: 'RTBox'.
self assert: _var14 className equals: 'RTBorderStyle'.
self assert: _var16 className equals: 'RTBorderStyle'.
self assert: _var1 className equals: 'RTBorderStyle'.
self assert: _var2 className equals: 'RTBorderStyle'.
self assert: _var3 className equals: 'RTBox'.
self assert: _var4 className equals: 'RTBorderStyle'.
self assert: _var5 className equals: 'RTBorderStyle'.
self assert: _var6 className equals: 'RTBox'.
self assert: _var7 className equals: 'RTBorderStyle'.
self assert: _var8 className equals: 'RTBorderStyle'.
self assert: _var9 className equals: 'RTBorderStyle'
]

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test12 [
| _var0 _var18 _var2 _var3 _var4 _var1 _var5 _var6 _var15 _var7 _var8 _var9 _var10 _var11 _var12 _var13 _var14 |
_var0 := RTBox new.
_var18 := _var0 borderStyle.
_var2 := RTBox new.
_var3 := _var0 borderStyle.
_var4 := _var0 borderStyle.
_var1 := _var0 borderStyle.
_var5 := RTBox new.
_var6 := RTBox new.
_var15 := _var0 borderStyle.
_var7 := RTBox new.
_var8 := RTBox new.
_var9 := _var0 borderStyle.
_var10 := _var0 borderStyle.
_var11 := _var0 borderStyle.
_var12 := RTBox new.
_var13 := _var0 borderStyle.
_var14 := _var0 borderStyle.
self assert: _var0 className equals: 'RTBox'.
self assert: _var18 className equals: 'RTBorderStyle'.
self assert: _var2 className equals: 'RTBox'.
self assert: _var3 className equals: 'RTBorderStyle'.
self assert: _var4 className equals: 'RTBorderStyle'.
self assert: _var1 className equals: 'RTBorderStyle'.
self assert: _var5 className equals: 'RTBox'.
self assert: _var6 className equals: 'RTBox'.
self assert: _var15 className equals: 'RTBorderStyle'.
self assert: _var7 className equals: 'RTBox'.
self assert: _var8 className equals: 'RTBox'.
self assert: _var9 className equals: 'RTBorderStyle'.
self assert: _var10 className equals: 'RTBorderStyle'.
self assert: _var11 className equals: 'RTBorderStyle'.
self assert: _var12 className equals: 'RTBox'.
self assert: _var13 className equals: 'RTBorderStyle'.
self assert: _var14 className equals: 'RTBorderStyle'
]

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test13 [
| _var0 _var18 _var2 _var3 _var4 _var1 _var5 _var6 _var7 _var8 _var12 _var9 _var10 _var11 _var13 _var14 _var15 |
_var0 := RTBox new.
_var18 := _var0 borderStyle.
_var2 := RTBox new.
_var3 := _var0 borderStyle.
_var4 := _var0 borderStyle.
_var1 := _var0 borderStyle.
_var5 := RTBox new.
_var6 := RTBox new.
_var7 := _var0 borderStyle.
_var8 := RTBox new.
_var12 := _var0 borderStyle.
_var9 := RTBox new.
_var10 := _var0 borderStyle.
_var11 := _var0 borderStyle.
_var13 := RTBox new.
_var14 := _var0 borderStyle.
_var15 := _var0 borderStyle.
self assert: _var0 className equals: 'RTBox'.
self assert: _var18 className equals: 'RTBorderStyle'.
self assert: _var2 className equals: 'RTBox'.
self assert: _var3 className equals: 'RTBorderStyle'.
self assert: _var4 className equals: 'RTBorderStyle'.
self assert: _var1 className equals: 'RTBorderStyle'.
self assert: _var5 className equals: 'RTBox'.
self assert: _var6 className equals: 'RTBox'.
self assert: _var7 className equals: 'RTBorderStyle'.
self assert: _var8 className equals: 'RTBox'.
self assert: _var12 className equals: 'RTBorderStyle'.
self assert: _var9 className equals: 'RTBox'.
self assert: _var10 className equals: 'RTBorderStyle'.
self assert: _var11 className equals: 'RTBorderStyle'.
self assert: _var13 className equals: 'RTBox'.
self assert: _var14 className equals: 'RTBorderStyle'.
self assert: _var15 className equals: 'RTBorderStyle'
]

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test14 [
| _var0 _var1 _var2 _var3 _var4 _var17 _var5 _var6 _var7 _var8 _var9 _var10 _var11 _var12 _var13 _var14 _var15 |
_var0 := RTBox new.
_var1 := _var0 borderStyle.
_var2 := _var0 borderStyle.
_var3 := _var0 borderStyle.
_var4 := RTBox new.
_var17 := RTBox new.
_var5 := RTBox new.
_var6 := RTBox new.
_var7 := RTBox new.
_var8 := RTBox new.
_var9 := RTBox new.
_var10 := _var0 borderStyle.
_var11 := _var0 borderStyle.
_var12 := RTBox new.
_var13 := _var0 borderStyle.
_var14 := _var0 borderStyle.
_var15 := _var0 borderStyle.
self assert: _var0 className equals: 'RTBox'.
self assert: _var1 className equals: 'RTBorderStyle'.
self assert: _var2 className equals: 'RTBorderStyle'.
self assert: _var3 className equals: 'RTBorderStyle'.
self assert: _var4 className equals: 'RTBox'.
self assert: _var17 className equals: 'RTBox'.
self assert: _var5 className equals: 'RTBox'.
self assert: _var6 className equals: 'RTBox'.
self assert: _var7 className equals: 'RTBox'.
self assert: _var8 className equals: 'RTBox'.
self assert: _var9 className equals: 'RTBox'.
self assert: _var10 className equals: 'RTBorderStyle'.
self assert: _var11 className equals: 'RTBorderStyle'.
self assert: _var12 className equals: 'RTBox'.
self assert: _var13 className equals: 'RTBorderStyle'.
self assert: _var14 className equals: 'RTBorderStyle'.
self assert: _var15 className equals: 'RTBorderStyle'
]

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test2 [
| _var1 _var10 _var2 _var11 _var3 _var12 _var4 _var5 _var6 _var13 _var7 _var0 _var8 _var9 _var14 |
_var1 := 'Bonus Card'.
_var10 := RTAMItem new.
_var2 := _var10 column: _var1.
_var11 := RTAMItem new.
_var3 := _var11 column: _var1.
_var12 := RTAMItem new.
_var4 := _var12 row: _var1.
_var5 := 'France'.
_var6 := RTAMItem new.
_var13 := RTAMItem new.
_var7 := _var13 column: _var5.
_var0 := _var10 row: _var5.
_var8 := _var10
	color:
		(Color
			r: 0.8
			g: 1.0
			b: 0.6
			alpha: 1.0).
_var9 := 'Bonus Card'.
_var14 := _var10 itemName: _var1.
self assert: _var1 size equals: 10.
self
	assert: (_var1 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var1 className equals: 'ByteString'.
self assert: _var1 equals: 'Bonus Card'.
self assert: _var1 asString equals: 'Bonus Card'.
self assert: _var10 className equals: 'RTAMItem'.
self assert: _var2 className equals: 'RTAMItem'.
self assert: _var11 className equals: 'RTAMItem'.
self assert: _var3 className equals: 'RTAMItem'.
self assert: _var12 className equals: 'RTAMItem'.
self assert: _var4 className equals: 'RTAMItem'.
self assert: _var5 size equals: 6.
self
	assert: (_var5 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var5 className equals: 'ByteString'.
self assert: _var5 equals: 'France'.
self assert: _var5 asString equals: 'France'.
self assert: _var6 className equals: 'RTAMItem'.
self assert: _var13 className equals: 'RTAMItem'.
self assert: _var7 className equals: 'RTAMItem'.
self assert: _var0 className equals: 'RTAMItem'.
self assert: _var8 className equals: 'RTAMItem'.
self assert: _var9 size equals: 10.
self
	assert: (_var9 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var9 className equals: 'ByteString'.
self assert: _var9 equals: 'Bonus Card'.
self assert: _var9 asString equals: 'Bonus Card'.
self assert: _var14 className equals: 'RTAMItem'
]

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test3 [
| _var0 _var1 _var2 _var3 _var4 _var5 _var6 _var7 _var8 _var9 _var10 _var11 _var12 _var13 |
_var0 := RTAMItem new.
_var1 := _var0 column: 'Customer Relationship'.
_var2 := RTAMItem new.
_var3 := _var0 column: 'Bonus Card'.
_var4 := RTAMItem new.
_var5 := _var0 row: 'Bonus Card'.
_var6 := 'France'.
_var7 := RTAMItem new.
_var8 := RTAMItem new.
_var9 := _var0 column: _var6.
_var10 := _var0 row: _var6.
_var11 := _var0
	color:
		(Color
			r: 0.8
			g: 1.0
			b: 0.6
			alpha: 1.0).
_var12 := 'Bonus Card'.
_var13 := _var0 itemName: _var12.
self assert: _var0 className equals: 'RTAMItem'.
self assert: _var1 className equals: 'RTAMItem'.
self assert: _var2 className equals: 'RTAMItem'.
self assert: _var3 className equals: 'RTAMItem'.
self assert: _var4 className equals: 'RTAMItem'.
self assert: _var5 className equals: 'RTAMItem'.
self assert: _var6 size equals: 6.
self
	assert: (_var6 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var6 className equals: 'ByteString'.
self assert: _var6 equals: 'France'.
self assert: _var6 asString equals: 'France'.
self assert: _var7 className equals: 'RTAMItem'.
self assert: _var8 className equals: 'RTAMItem'.
self assert: _var9 className equals: 'RTAMItem'.
self assert: _var10 className equals: 'RTAMItem'.
self assert: _var11 className equals: 'RTAMItem'.
self assert: _var12 size equals: 10.
self
	assert: (_var12 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var12 className equals: 'ByteString'.
self assert: _var12 equals: 'Bonus Card'.
self assert: _var12 asString equals: 'Bonus Card'.
self assert: _var13 className equals: 'RTAMItem'
]

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test4 [
| _var0 _var17 _var12 _var2 _var13 _var18 _var1 _var3 _var4 _var5 _var6 _var7 _var8 _var9 _var10 _var11 _var14 _var15 _var16 |
_var0 := 'Bonus Card'.
_var17 := 'Bonus Card'.
_var12 := RTAMItem new.
_var2 := _var12 itemName: _var17.
_var13 := RTAMItem new.
_var18 := RTAMItem new.
_var1 := _var12 column: 'France'.
_var3 := RTAMItem new.
_var4 := _var12 column: '''6Franc.'''.
_var5 := _var12 row: 'France'.
_var6 := 'France'.
_var7 := RTAMItem new.
_var8 := '''ZBonus CarS'''.
_var9 := _var12
	color:
		(Color
			r: 0.8
			g: 1.0
			b: 0.6
			alpha: 1.0).
_var10 := 'Bonus Card'.
_var11 := 'France'.
_var14 := RTAMItem new.
_var15 := _var12 itemName: _var8.
_var16 := _var12 itemName: _var11.
self assert: _var0 size equals: 10.
self
	assert: (_var0 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var0 className equals: 'ByteString'.
self assert: _var0 equals: 'Bonus Card'.
self assert: _var0 asString equals: 'Bonus Card'.
self assert: _var17 size equals: 10.
self
	assert: (_var17 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var17 className equals: 'ByteString'.
self assert: _var17 equals: 'Bonus Card'.
self assert: _var17 asString equals: 'Bonus Card'.
self assert: _var12 className equals: 'RTAMItem'.
self assert: _var2 className equals: 'RTAMItem'.
self assert: _var13 className equals: 'RTAMItem'.
self assert: _var18 className equals: 'RTAMItem'.
self assert: _var1 className equals: 'RTAMItem'.
self assert: _var3 className equals: 'RTAMItem'.
self assert: _var4 className equals: 'RTAMItem'.
self assert: _var5 className equals: 'RTAMItem'.
self assert: _var6 size equals: 6.
self
	assert: (_var6 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var6 className equals: 'ByteString'.
self assert: _var6 equals: 'France'.
self assert: _var6 asString equals: 'France'.
self assert: _var7 className equals: 'RTAMItem'.
self
	assert: (_var8 allButFirst anySatisfy: [ :element | element = $' ]).
self assert: _var8 size equals: 13.
self
	assert: (_var8 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var8 className equals: 'ByteString'.
self assert: _var8 equals: '''ZBonus CarS'''.
self assert: _var8 asString equals: '''ZBonus CarS'''.
self assert: _var9 className equals: 'RTAMItem'.
self assert: _var10 size equals: 10.
self
	assert: (_var10 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var10 className equals: 'ByteString'.
self assert: _var10 equals: 'Bonus Card'.
self assert: _var10 asString equals: 'Bonus Card'.
self assert: _var11 size equals: 6.
self
	assert: (_var11 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var11 className equals: 'ByteString'.
self assert: _var11 equals: 'France'.
self assert: _var11 asString equals: 'France'.
self assert: _var14 className equals: 'RTAMItem'.
self assert: _var15 className equals: 'RTAMItem'.
self assert: _var16 className equals: 'RTAMItem'
]

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test5 [
| _var10 _var1 _var0 _var2 _var3 _var4 _var5 _var6 _var7 _var8 _var9 _var11 _var12 _var13 _var14 _var15 _var16 _var17 _var18 |
_var10 := RTAMItem new.
_var1 := _var10 row: 'Bonus Card'.
_var0 := '''fFrancO'''.
_var2 := RTAMItem new.
_var3 := _var10 column: 'Customer Relationship'.
_var4 := RTAMItem new.
_var5 := _var10 row: 'Bonus Card'.
_var6 := 'France'.
_var7 := 'France'.
_var8 := _var10 column: _var0.
_var9 := 'France'.
_var11 := 'France'.
_var12 := 'France'.
_var13 := RTAMItem new.
_var14 := _var10 column: _var0.
_var15 := _var10 row: _var9.
_var16 := _var10
	color:
		(Color
			r: 0.8
			g: 1.0
			b: 0.6
			alpha: 1.0).
_var17 := 'Bonus Card'.
_var18 := _var10 itemName: _var17.
self assert: _var10 className equals: 'RTAMItem'.
self assert: _var1 className equals: 'RTAMItem'.
self
	assert: (_var0 allButFirst anySatisfy: [ :element | element = $' ]).
self assert: _var0 size equals: 9.
self
	assert: (_var0 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var0 className equals: 'ByteString'.
self assert: _var0 equals: '''fFrancO'''.
self assert: _var0 asString equals: '''fFrancO'''.
self assert: _var2 className equals: 'RTAMItem'.
self assert: _var3 className equals: 'RTAMItem'.
self assert: _var4 className equals: 'RTAMItem'.
self assert: _var5 className equals: 'RTAMItem'.
self assert: _var6 size equals: 6.
self
	assert: (_var6 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var6 className equals: 'ByteString'.
self assert: _var6 equals: 'France'.
self assert: _var6 asString equals: 'France'.
self assert: _var7 size equals: 6.
self
	assert: (_var7 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var7 className equals: 'ByteString'.
self assert: _var7 equals: 'France'.
self assert: _var7 asString equals: 'France'.
self assert: _var8 className equals: 'RTAMItem'.
self assert: _var9 size equals: 6.
self
	assert: (_var9 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var9 className equals: 'ByteString'.
self assert: _var9 equals: 'France'.
self assert: _var9 asString equals: 'France'.
self assert: _var11 size equals: 6.
self
	assert: (_var11 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var11 className equals: 'ByteString'.
self assert: _var11 equals: 'France'.
self assert: _var11 asString equals: 'France'.
self assert: _var12 size equals: 6.
self
	assert: (_var12 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var12 className equals: 'ByteString'.
self assert: _var12 equals: 'France'.
self assert: _var12 asString equals: 'France'.
self assert: _var13 className equals: 'RTAMItem'.
self assert: _var14 className equals: 'RTAMItem'.
self assert: _var15 className equals: 'RTAMItem'.
self assert: _var16 className equals: 'RTAMItem'.
self assert: _var17 size equals: 10.
self
	assert: (_var17 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var17 className equals: 'ByteString'.
self assert: _var17 equals: 'Bonus Card'.
self assert: _var17 asString equals: 'Bonus Card'.
self assert: _var18 className equals: 'RTAMItem'
]

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test6 [
| _var0 _var1 _var2 _var3 _var15 _var5 _var4 _var6 _var7 _var8 _var9 _var10 _var11 _var12 _var13 _var14 _var16 _var17 |
_var0 := 'Bonus Card'.
_var1 := RTAMItem new.
_var2 := _var1 itemName: _var0.
_var3 := _var1 column: _var0.
_var15 := 'Bonus Card'.
_var5 := _var1 row: _var0.
_var4 := _var1 itemName: _var15.
_var6 := _var1 column: 'France'.
_var7 := RTAMItem new.
_var8 := _var1 row: 'France'.
_var9 := _var1 itemName: _var0.
_var10 := '''Bonus CarM'''.
_var11 := 'Customer Relationship'.
_var12 := RTAMItem new.
_var13 := 'France'.
_var14 := 'Bonus Card'.
_var16 := _var1 itemName: _var0.
_var17 := _var1
	color:
		(Color
			r: 0.8
			g: 1.0
			b: 0.6
			alpha: 1.0).
self assert: _var0 size equals: 10.
self
	assert: (_var0 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var0 className equals: 'ByteString'.
self assert: _var0 equals: 'Bonus Card'.
self assert: _var0 asString equals: 'Bonus Card'.
self assert: _var1 className equals: 'RTAMItem'.
self assert: _var2 className equals: 'RTAMItem'.
self assert: _var3 className equals: 'RTAMItem'.
self assert: _var15 size equals: 10.
self
	assert: (_var15 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var15 className equals: 'ByteString'.
self assert: _var15 equals: 'Bonus Card'.
self assert: _var15 asString equals: 'Bonus Card'.
self assert: _var5 className equals: 'RTAMItem'.
self assert: _var4 className equals: 'RTAMItem'.
self assert: _var6 className equals: 'RTAMItem'.
self assert: _var7 className equals: 'RTAMItem'.
self assert: _var8 className equals: 'RTAMItem'.
self assert: _var9 className equals: 'RTAMItem'.
self
	assert: (_var10 allButFirst anySatisfy: [ :element | element = $' ]).
self assert: _var10 size equals: 13.
self
	assert: (_var10 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var10 className equals: 'ByteString'.
self assert: _var10 equals: '''Bonus CarM'''.
self assert: _var10 asString equals: '''Bonus CarM'''.
self assert: _var11 size equals: 21.
self
	assert: (_var11 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var11 className equals: 'ByteString'.
self assert: _var11 equals: 'Customer Relationship'.
self assert: _var11 asString equals: 'Customer Relationship'.
self assert: _var12 className equals: 'RTAMItem'.
self assert: _var13 size equals: 6.
self
	assert: (_var13 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var13 className equals: 'ByteString'.
self assert: _var13 equals: 'France'.
self assert: _var13 asString equals: 'France'.
self assert: _var14 size equals: 10.
self
	assert: (_var14 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var14 className equals: 'ByteString'.
self assert: _var14 equals: 'Bonus Card'.
self assert: _var14 asString equals: 'Bonus Card'.
self assert: _var16 className equals: 'RTAMItem'.
self assert: _var17 className equals: 'RTAMItem'
]

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test7 [
| _var0 _var1 _var2 _var3 _var15 _var5 _var4 _var6 _var7 _var8 _var9 _var10 _var11 _var12 _var13 _var14 _var16 _var17 |
_var0 := 'Bonus Card'.
_var1 := RTAMItem new.
_var2 := _var1 itemName: _var0.
_var3 := _var1 column: _var0.
_var15 := 'Bonus Card'.
_var5 := _var1 row: _var0.
_var4 := RTAMItem new.
_var6 := _var1 row: 'Customer Relationship'.
_var7 := 'France'.
_var8 := 'France'.
_var9 := 'France'.
_var10 := 'France'.
_var11 := _var1 itemName: _var7.
_var12 := RTAMItem new.
_var13 := 'France'.
_var14 := _var1 column: _var9.
_var16 := _var1
	color:
		(Color
			r: 0.8
			g: 1.0
			b: 0.6
			alpha: 1.0).
_var17 := _var1 row: _var10.
self assert: _var0 size equals: 10.
self
	assert: (_var0 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var0 className equals: 'ByteString'.
self assert: _var0 equals: 'Bonus Card'.
self assert: _var0 asString equals: 'Bonus Card'.
self assert: _var1 className equals: 'RTAMItem'.
self assert: _var2 className equals: 'RTAMItem'.
self assert: _var3 className equals: 'RTAMItem'.
self assert: _var15 size equals: 10.
self
	assert: (_var15 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var15 className equals: 'ByteString'.
self assert: _var15 equals: 'Bonus Card'.
self assert: _var15 asString equals: 'Bonus Card'.
self assert: _var5 className equals: 'RTAMItem'.
self assert: _var4 className equals: 'RTAMItem'.
self assert: _var6 className equals: 'RTAMItem'.
self assert: _var7 size equals: 6.
self
	assert: (_var7 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var7 className equals: 'ByteString'.
self assert: _var7 equals: 'France'.
self assert: _var7 asString equals: 'France'.
self assert: _var8 size equals: 6.
self
	assert: (_var8 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var8 className equals: 'ByteString'.
self assert: _var8 equals: 'France'.
self assert: _var8 asString equals: 'France'.
self assert: _var9 size equals: 6.
self
	assert: (_var9 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var9 className equals: 'ByteString'.
self assert: _var9 equals: 'France'.
self assert: _var9 asString equals: 'France'.
self assert: _var10 size equals: 6.
self
	assert: (_var10 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var10 className equals: 'ByteString'.
self assert: _var10 equals: 'France'.
self assert: _var10 asString equals: 'France'.
self assert: _var11 className equals: 'RTAMItem'.
self assert: _var12 className equals: 'RTAMItem'.
self assert: _var13 size equals: 6.
self
	assert: (_var13 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var13 className equals: 'ByteString'.
self assert: _var13 equals: 'France'.
self assert: _var13 asString equals: 'France'.
self assert: _var14 className equals: 'RTAMItem'.
self assert: _var16 className equals: 'RTAMItem'.
self assert: _var17 className equals: 'RTAMItem'
]

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test8 [
| _var20 _var1 _var2 _var3 _var4 _var5 _var6 _var22 _var0 _var7 _var8 _var9 _var10 _var11 _var18 _var12 _var19 _var13 _var14 _var15 _var16 _var17 |
_var20 := 'France'.
_var1 := RTAMItem new.
_var2 := _var1 column: 'Customer Relationship'.
_var3 := RTAMItem new.
_var4 := _var1 column: 'France'.
_var5 := RTAMItem new.
_var6 := RTAMItem new.
_var22 := 'Customer Relationship'.
_var0 := 'Bonus Card'.
_var7 := _var1 column: '''6Franc.'''.
_var8 := _var1 row: 'France'.
_var9 := 'France'.
_var10 := 'Customer Relationship'.
_var11 := 'Customer Relationship'.
_var18 := 'France'.
_var12 := RTAMItem new.
_var19 := _var1 itemName: _var0.
_var13 := _var1 column: _var11.
_var14 := _var1 itemName: _var18.
_var15 := 'Customer Relationship'.
_var16 := _var1
	color:
		(Color
			r: 0.8
			g: 1.0
			b: 0.6
			alpha: 1.0).
_var17 := _var1 row: _var9.
self assert: _var20 size equals: 6.
self
	assert: (_var20 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var20 className equals: 'ByteString'.
self assert: _var20 equals: 'France'.
self assert: _var20 asString equals: 'France'.
self assert: _var1 className equals: 'RTAMItem'.
self assert: _var2 className equals: 'RTAMItem'.
self assert: _var3 className equals: 'RTAMItem'.
self assert: _var4 className equals: 'RTAMItem'.
self assert: _var5 className equals: 'RTAMItem'.
self assert: _var6 className equals: 'RTAMItem'.
self assert: _var22 size equals: 21.
self
	assert: (_var22 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var22 className equals: 'ByteString'.
self assert: _var22 equals: 'Customer Relationship'.
self assert: _var22 asString equals: 'Customer Relationship'.
self assert: _var0 size equals: 10.
self
	assert: (_var0 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var0 className equals: 'ByteString'.
self assert: _var0 equals: 'Bonus Card'.
self assert: _var0 asString equals: 'Bonus Card'.
self assert: _var7 className equals: 'RTAMItem'.
self assert: _var8 className equals: 'RTAMItem'.
self assert: _var9 size equals: 6.
self
	assert: (_var9 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var9 className equals: 'ByteString'.
self assert: _var9 equals: 'France'.
self assert: _var9 asString equals: 'France'.
self assert: _var10 size equals: 21.
self
	assert: (_var10 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var10 className equals: 'ByteString'.
self assert: _var10 equals: 'Customer Relationship'.
self assert: _var10 asString equals: 'Customer Relationship'.
self assert: _var11 size equals: 21.
self
	assert: (_var11 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var11 className equals: 'ByteString'.
self assert: _var11 equals: 'Customer Relationship'.
self assert: _var11 asString equals: 'Customer Relationship'.
self assert: _var18 size equals: 6.
self
	assert: (_var18 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var18 className equals: 'ByteString'.
self assert: _var18 equals: 'France'.
self assert: _var18 asString equals: 'France'.
self assert: _var12 className equals: 'RTAMItem'.
self assert: _var19 className equals: 'RTAMItem'.
self assert: _var13 className equals: 'RTAMItem'.
self assert: _var14 className equals: 'RTAMItem'.
self assert: _var15 size equals: 21.
self
	assert: (_var15 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var15 className equals: 'ByteString'.
self assert: _var15 equals: 'Customer Relationship'.
self assert: _var15 asString equals: 'Customer Relationship'.
self assert: _var16 className equals: 'RTAMItem'.
self assert: _var17 className equals: 'RTAMItem'
]

{ #category : #'as yet unclassified' }
SSAssertionGeneratorTest >> test9 [
| _var10 _var0 _var1 _var2 _var3 _var4 _var5 _var6 _var7 _var8 _var9 _var11 _var12 _var13 _var14 _var15 _var16 _var17 _var18 |
_var10 := RTAMItem new.
_var0 := RTAMItem new.
_var1 := _var10 itemName: 'France'.
_var2 := _var10 column: 'Customer Relationship'.
_var3 := RTAMItem new.
_var4 := _var10 column: 'France'.
_var5 := RTAMItem new.
_var6 := _var10 row: 'Customer Relationship'.
_var7 := 'France'.
_var8 := 'France'.
_var9 := 'Customer Relationship'.
_var11 := RTAMItem new.
_var12 := _var10 itemName: _var9.
_var13 := _var10 itemName: _var7.
_var14 := RTAMItem new.
_var15 := '''RBonus Carg'''.
_var16 := _var10 column: _var9.
_var17 := _var10
	color:
		(Color
			r: 0.8
			g: 1.0
			b: 0.6
			alpha: 1.0).
_var18 := _var10 row: _var7.
self assert: _var10 className equals: 'RTAMItem'.
self assert: _var0 className equals: 'RTAMItem'.
self assert: _var1 className equals: 'RTAMItem'.
self assert: _var2 className equals: 'RTAMItem'.
self assert: _var3 className equals: 'RTAMItem'.
self assert: _var4 className equals: 'RTAMItem'.
self assert: _var5 className equals: 'RTAMItem'.
self assert: _var6 className equals: 'RTAMItem'.
self assert: _var7 size equals: 6.
self
	assert: (_var7 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var7 className equals: 'ByteString'.
self assert: _var7 equals: 'France'.
self assert: _var7 asString equals: 'France'.
self assert: _var8 size equals: 6.
self
	assert: (_var8 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var8 className equals: 'ByteString'.
self assert: _var8 equals: 'France'.
self assert: _var8 asString equals: 'France'.
self assert: _var9 size equals: 21.
self
	assert: (_var9 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var9 className equals: 'ByteString'.
self assert: _var9 equals: 'Customer Relationship'.
self assert: _var9 asString equals: 'Customer Relationship'.
self assert: _var11 className equals: 'RTAMItem'.
self assert: _var12 className equals: 'RTAMItem'.
self assert: _var13 className equals: 'RTAMItem'.
self assert: _var14 className equals: 'RTAMItem'.
self
	assert: (_var15 allButFirst anySatisfy: [ :element | element = $' ]).
self assert: _var15 size equals: 13.
self
	assert: (_var15 allSatisfy: [ :element | element className = 'Character' ]).
self assert: _var15 className equals: 'ByteString'.
self assert: _var15 equals: '''RBonus Carg'''.
self assert: _var15 asString equals: '''RBonus Carg'''.
self assert: _var16 className equals: 'RTAMItem'.
self assert: _var17 className equals: 'RTAMItem'.
self assert: _var18 className equals: 'RTAMItem'
]
