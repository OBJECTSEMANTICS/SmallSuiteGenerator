<?xml version="1.0"?>

<st-source>
<time-stamp>From VisualWorks®, 7.4 of December 5, 2005 on May 28, 2020 at 10:55:31 am</time-stamp>
<!-- Package SmallSuiteGenerator-Extensions* -->


<component-property>
<name>SmallSuiteGenerator-Extensions</name> <type>package</type>
<property>packageName</property> <value>'SmallSuiteGenerator-Extensions'</value>
</component-property>

<class>
<name>OrderedDictionary</name>
<environment>Smalltalk</environment>
<super>Core.Collection</super>
<private>false</private>
<indexed-type>objects</indexed-type>
<inst-vars>dictionary orderedKeys </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category></category>
<attributes>
<package>SmallSuiteGenerator-Extensions</package>
</attributes>
</class>

<comment>
<class-id>OrderedDictionary</class-id>
<body>Missing comment</body>
</comment>
































<methods>
<class-id>OrderedDictionary class</class-id> <category>instance creation</category>

<body package="SmallSuiteGenerator-Extensions" selector="new">new

	^super new initialize</body>

<body package="SmallSuiteGenerator-Extensions" selector="newFrom:">newFrom: t1 

	| t2 |
	t2 := self new.
	t1 associationsDo: [:t3 | t2 at: t3 key put: t3 value].
	^t2</body>
</methods>


<methods>
<class-id>OrderedDictionary</class-id> <category>testing</category>

<body package="SmallSuiteGenerator-Extensions" selector="isDictionary">isDictionary

	^true</body>
</methods>

<methods>
<class-id>OrderedDictionary</class-id> <category>initialize-release</category>

<body package="SmallSuiteGenerator-Extensions" selector="initialize">initialize

	dictionary := Dictionary new: 10.
	orderedKeys := Array new: 10.
	^self</body>
</methods>

<methods>
<class-id>OrderedDictionary</class-id> <category>adding</category>

<body package="SmallSuiteGenerator-Extensions" selector="addAll:">addAll: t1 

	t1 associationsDo: [:t2 | self add: t2].
	^t1</body>

<body package="SmallSuiteGenerator-Extensions" selector="add:">add: t1 

	| t2 |
	t2 := dictionary size.
	dictionary add: t1.
	dictionary size &gt; t2
		ifTrue: 
			[orderedKeys size &gt; t2 ifFalse: [self growOrderedKeys].
			orderedKeys at: t2 + 1 put: t1 key].
	^t1</body>
</methods>

<methods>
<class-id>OrderedDictionary</class-id> <category>accessing</category>

<body package="SmallSuiteGenerator-Extensions" selector="size">size

	^dictionary size</body>

<body package="SmallSuiteGenerator-Extensions" selector="keysDo:">keysDo: t1 

	| t2 t3 |
	t2 := 1.
	t3 := self size.
	[t2 &lt;= t3]
		whileTrue: 
			[t1 value: (orderedKeys at: t2).
			t2 := t2 + 1].
	^self</body>

<body package="SmallSuiteGenerator-Extensions" selector="keys">keys

	^orderedKeys copyFrom: 1 to: self size</body>

<body package="SmallSuiteGenerator-Extensions" selector="encodeAsJSONDataUsing:">encodeAsJSONDataUsing: t1 

	| t2 |
	t1 beginObject.
	t2 := 0.
	(orderedKeys reject: #isNil)
		do: 
			[:t3 | 
			| t4 |
			t2 := t2 + 1.
			t4 := dictionary at: t3.
			t2 &gt; 1 ifTrue: [t1 emitComma].
			t1 encodeKey: t3 value: t4].
	t1 endObject.
	^self</body>

<body package="SmallSuiteGenerator-Extensions" selector="at:ifAbsentPut:">at: t1 ifAbsentPut: t2 

	^self at: t1 ifAbsent: [self at: t1 put: t2 value]</body>

<body package="SmallSuiteGenerator-Extensions" selector="at:ifAbsent:">at: t1 ifAbsent: t2 

	^dictionary at: t1 ifAbsent: t2</body>

<body package="SmallSuiteGenerator-Extensions" selector="associationsDo:">associationsDo: t1 

	self keysDo: [:t2 | t1 value: (self associationAt: t2)].
	^self</body>

<body package="SmallSuiteGenerator-Extensions" selector="associations">associations

	| t1 t2 |
	t2 := Array new: self size.
	t1 := 1.
	self
		associationsDo: 
			[:t3 | 
			t2 at: t1 put: t3.
			t1 := t1 + 1].
	^t2</body>

<body package="SmallSuiteGenerator-Extensions" selector="associationAt:">associationAt: t1 

	^dictionary associationAt: t1</body>

<body package="SmallSuiteGenerator-Extensions" selector="at:">at: t1 

	^dictionary at: t1</body>

<body package="SmallSuiteGenerator-Extensions" selector="includesKey:">includesKey: t1 

	^dictionary includesKey: t1</body>

<body package="SmallSuiteGenerator-Extensions" selector="at:put:">at: t1 put: t2 

	| t3 |
	t3 := dictionary size.
	dictionary at: t1 put: t2.
	dictionary size &gt; t3
		ifTrue: 
			[orderedKeys size &gt; t3 ifFalse: [self growOrderedKeys].
			orderedKeys at: t3 + 1 put: t1].
	^t2</body>

<body package="SmallSuiteGenerator-Extensions" selector="growOrderedKeys">growOrderedKeys

	orderedKeys := (Array new: ((orderedKeys size * 1.5) asInteger max: 10))
				replaceFrom: 1
				to: orderedKeys size
				with: orderedKeys
				startingAt: 1.
	^self</body>

<body package="SmallSuiteGenerator-Extensions" selector="values">values

	^self associations collect: [:t1 | t1 value]</body>

<body package="SmallSuiteGenerator-Extensions" selector="do:">do: t1 

	self valuesDo: t1.
	^self</body>

<body package="SmallSuiteGenerator-Extensions" selector="at:ifPresent:">at: t1 ifPresent: t2 

	^dictionary at: t1 ifPresent: t2</body>
</methods>

<methods>
<class-id>OrderedDictionary</class-id> <category>comparing</category>

<body package="SmallSuiteGenerator-Extensions" selector="=">= t1 


	self == t1 ifTrue: [^true].
	(self species == t1 species and: [self size = t1 size])
		ifFalse: [^false].
	dictionary associationsDo: [:t2 | (t1 at: t2 key ifAbsent: [^false])
			= t2 value
			ifTrue: [nil]
			ifFalse: [^false]].
	^true</body>

<body package="SmallSuiteGenerator-Extensions" selector="hash">hash

	^dictionary hash</body>
</methods>

<methods>
<class-id>OrderedDictionary</class-id> <category>enumerating</category>

<body package="SmallSuiteGenerator-Extensions" selector="keysAndValuesDo:">keysAndValuesDo: t1 

	self keysDo: [:t2 | t1 value: t2 value: (self at: t2)].
	^self</body>

<body package="SmallSuiteGenerator-Extensions" selector="valuesDo:">valuesDo: t1 

	self keysDo: [:t2 | t1 value: (self at: t2)].
	^self</body>

<body package="SmallSuiteGenerator-Extensions" selector="collect:">collect: t1 

	^self species newFrom: (self associations collect: [:t2 | t2 key -&gt; (t1 value: t2 value)])</body>
</methods>


<methods>
<class-id>Core.Object</class-id> <category>testing</category>

<body package="SmallSuiteGenerator-Extensions" selector="className">className

	^self class name asString</body>

<body package="SmallSuiteGenerator-Extensions" selector="isDeprecated">isDeprecated

	^false</body>

<body package="SmallSuiteGenerator-Extensions" selector="storeOn:">storeOn: t1 

	| t2 t3 t4 t5 |
	SmallSuiteGenerator.SPlatform reduceLevel.
	t1 nextPut: $(.
	self class isVariable
		ifTrue: [t1 nextPutAll: '(' , self class name , ' basicNew: '; store: self basicSize; nextPutAll: ') ']
		ifFalse: [t1 nextPutAll: self class name , ' basicNew'].
	SmallSuiteGenerator.SPlatform levelToPrint &lt; 0
		ifFalse: 
			[t2 := 1.
			t3 := self class instSize.
			[t2 &lt;= t3]
				whileTrue: 
					[t1 nextPutAll: ' instVarAt: '; store: t2; nextPutAll: ' put: '; store: (self instVarAt: t2); nextPut: $;.
					t2 := t2 + 1].
			t4 := 1.
			t5 := self basicSize.
			[t4 &lt;= t5]
				whileTrue: 
					[t1 nextPutAll: ' basicAt: '; store: t4; nextPutAll: ' put: '; store: (self basicAt: t4); nextPut: $;.
					t4 := t4 + 1]].
	t1 nextPutAll: ' yourself)'.
	^self</body>

<body package="SmallSuiteGenerator-Extensions" selector="mutateToChange">mutateToChange

	^self</body>
</methods>

<methods>
<class-id>Core.Object</class-id> <category>printing</category>

<body package="SmallSuiteGenerator-Extensions" selector="isBlock">isBlock

	^false</body>
</methods>

<methods>
<class-id>Core.Object</class-id> <category>class initialization</category>

<body package="SmallSuiteGenerator-Extensions" selector="perform:withEnoughArguments:">perform: t1 withEnoughArguments: t2 

	| t3 t4 |
	t3 := t1 numArgs.
	t2 size == t3 ifTrue: [^self perform: t1 withArguments: t2 asArray].
	(t4 := Array new: t3)
		replaceFrom: 1
		to: (t2 size min: t4 size)
		with: t2
		startingAt: 1.
	^self perform: t1 withArguments: t4</body>
</methods>

<methods>
<class-id>Core.Object</class-id> <category>event accessing</category>

<body package="SmallSuiteGenerator-Extensions" selector="isNotNil">isNotNil

	^true</body>
</methods>

<methods>
<class-id>Core.Object</class-id> <category>comparing</category>

<body package="SmallSuiteGenerator-Extensions" selector="asLink">asLink

	^LinkValue value: self</body>
</methods>

<methods>
<class-id>Core.Object</class-id> <category>controlling</category>

<body package="SmallSuiteGenerator-Extensions" selector="assert:description:">assert: t1 description: t2 
	t1 value ifFalse: [self error: t2].
	^self</body>
</methods>


<methods>
<class-id>Core.Time</class-id> <category>TimeServicesApp(dbonly)</category>

<body package="SmallSuiteGenerator-Extensions" selector="initialize">initialize

	hours := minutes := seconds := 0.
	^self</body>
</methods>


<methods>
<class-id>Core.Number</class-id> <category>testing</category>

<body package="SmallSuiteGenerator-Extensions" selector="mutateToChange">mutateToChange
	^ (self perform: (SmallSuiteGenerator.SPlatform randomGenerator selectAtRandom: #(#+ #- #*))  with: (SmallSuiteGenerator.SPlatform randomGenerator selectAtRandom: (1 to: 100) asArray) )
		perform: (SmallSuiteGenerator.SPlatform randomGenerator selectAtRandom: #(#+ #-))
		with: 1 </body>
</methods>


<methods>
<class-id>Core.UndefinedObject</class-id> <category>dependents collection</category>

<body package="SmallSuiteGenerator-Extensions" selector="isNotNil">isNotNil

	^false</body>
</methods>


<methods>
<class-id>Kernel.CompiledMethod</class-id> <category>accessing</category>

<body package="SmallSuiteGenerator-Extensions" selector="isReturnField">isReturnField

	| t1 t2 |
	(t2 := (Refactory.Browser.RBParser parseMethod: self getSource) body statements) ifEmpty: [^false].
	((t1 := t2 first) isKindOf: Refactory.Browser.RBReturnNode)
		ifTrue: 
			[(t1 value isKindOf: Refactory.Browser.RBVariableNode)
				ifTrue: [^self mclass instVarNames includes: t1 value token value].
			^false].
	^false</body>
</methods>

<methods>
<class-id>Kernel.CompiledMethod</class-id> <category>testing</category>

<body package="SmallSuiteGenerator-Extensions" selector="ast">ast
	^ Refactory.Browser.RBParser parseMethod: self getSource </body>

<body package="SmallSuiteGenerator-Extensions" selector="isAbstract">isAbstract

	| t1 t2 |
	t1 := Refactory.Browser.RBParser parseMethod: self getSource.
	t2 := SmallSuiteGenerator.SVisitorNodes new.
	t1 acceptVisitor: t2.
	^t2 isAbstract</body>
</methods>


<methods>
<class-id>Core.Random</class-id> <category>private</category>

<body package="SmallSuiteGenerator-Extensions" selector="nextInt:">nextInt: t1 

	t1 strictlyPositive ifFalse: [self error: 'Range must be positive'].
	t1 asFloat isInfinity ifTrue: [^(self next asFraction * t1) truncated + 1].
	^(self next * t1) truncated + 1</body>
</methods>

<methods>
<class-id>Core.Random</class-id> <category>accessing</category>

<body package="SmallSuiteGenerator-Extensions" selector="seed:">seed: aSmallInteger
	"Initialize the first random number."
	
	seed := aSmallInteger</body>
</methods>


<methods>
<class-id>Refactory.Browser.RBVariableNode</class-id> <category>accessing</category>

<body package="SmallSuiteGenerator-Extensions" selector="token">token

	^token</body>
</methods>


<methods>
<class-id>Core.Behavior</class-id> <category>accessing method dictionary</category>

<body package="SmallSuiteGenerator-Extensions" selector="allSelectorsBelow:">allSelectorsBelow: t1

	| t2 |
	t2 := IdentitySet new.
	self withAllSuperclasses
		do: 
			[:t3 | 
			t3 = t1 ifTrue: [^t2].
			t3 selectors do: [:t4 | t2 add: t4]].
	^t2</body>
</methods>

<methods>
<class-id>Core.Behavior</class-id> <category>creating method dictionary</category>

<body package="SmallSuiteGenerator-Extensions" selector="isAbstract">isAbstract

	^false</body>
</methods>


<methods>
<class-id>Core.Boolean</class-id> <category>testing</category>

<body package="SmallSuiteGenerator-Extensions" selector="mutateToChange">mutateToChange 

	^self not</body>
</methods>


<methods>
<class-id>Kernel.BlockClosure</class-id> <category>printing</category>

<body package="SmallSuiteGenerator-Extensions" selector="isBlock">isBlock
	^ true</body>
</methods>

<methods>
<class-id>Kernel.BlockClosure</class-id> <category>evaluating</category>

<body package="SmallSuiteGenerator-Extensions" selector="cull:cull:">cull: t1 cull: t2 

	self numArgs &lt; 2 ifTrue: [^self cull: t1].
	^self value: t1 value: t2</body>
</methods>


<methods>
<class-id>Core.Collection</class-id> <category>copying</category>

<body package="SmallSuiteGenerator-Extensions" selector="allButFirst">allButFirst

	^self copyFrom: 2 to: self size</body>

<body package="SmallSuiteGenerator-Extensions" selector="sort:">sort: aBlock
	| orderedColl |
	orderedColl := SortedCollection withAll: self sortBlock: aBlock.
	^ orderedColl</body>

<body package="SmallSuiteGenerator-Extensions" selector="copyFrom:to:">copyFrom: t1 to: t2 

	| t3 |
	t3 := t2 - t1 + 1.
	^(self species withSize: t3)
		replaceFrom: 1
		to: t3
		with: self
		startingAt: t1</body>
</methods>

<methods>
<class-id>Core.Collection</class-id> <category>accessing</category>

<body package="SmallSuiteGenerator-Extensions" selector="third">third

	^self at: 3</body>

<body package="SmallSuiteGenerator-Extensions" selector="fifth">fifth

	^self at: 5</body>

<body package="SmallSuiteGenerator-Extensions" selector="fourth">fourth

	^self at: 4</body>

<body package="SmallSuiteGenerator-Extensions" selector="second">second

	^self at: 2</body>
</methods>

<methods>
<class-id>Core.Collection</class-id> <category>COMPATIBILITY-testing</category>

<body package="SmallSuiteGenerator-Extensions" selector="max">max

	^self inject: self anyOne into: [:t1 :t2 | t1 max: t2]</body>

<body package="SmallSuiteGenerator-Extensions" selector="anyOne">anyOne

	self emptyCheck.
	self do: [:t1 | ^t1].
	^self</body>
</methods>

<methods>
<class-id>Core.Collection</class-id> <category>enumerating</category>

<body package="SmallSuiteGenerator-Extensions" selector="detect:ifFound:">detect: t1 ifFound: t2 

	^self
		detect: t1
		ifFound: t2
		ifNone: [nil]</body>

<body package="SmallSuiteGenerator-Extensions" selector="union:">union: t1 

	| t2 |
	t2 := (self asSet) addAll: t1; yourself.
	^self species withAll: t2 asArray</body>
</methods>

<methods>
<class-id>Core.Collection</class-id> <category>comparing</category>

<body package="SmallSuiteGenerator-Extensions" selector="includesAny:">includesAny: t1 

	t1
		do: 
			[:t2 | 
			(self includes: t2)
				ifTrue: [^true].
			nil].
	^false</body>

<body package="SmallSuiteGenerator-Extensions" selector="min">min

	^self inject: self anyOne into: [:t1 :t2 | t1 min: t2]</body>

<body package="SmallSuiteGenerator-Extensions" selector="includesAll:">includesAll: t1 

	t1 isCollection
		ifTrue: 
			[t1 size &lt;= self size ifTrue: [^t1 allSatisfy: [:t2 | (t1 occurrencesOf: t2)
						&lt;= (self occurrencesOf: t2)]].
			^false].
	^false</body>
</methods>


<methods>
<class-id>Core.SequenceableCollection</class-id> <category>comparing</category>

<body package="SmallSuiteGenerator-Extensions" selector="beginsWith:">beginsWith: t1 

	| t2 t3 |
	self size &lt; t1 size ifTrue: [^false].
	t2 := 1.
	t3 := t1 size.
	[t2 &lt;= t3]
		whileTrue: 
			[(self at: t2)
				= (t1 at: t2) ifFalse: [^false].
			t2 := t2 + 1].
	^true</body>
</methods>

<methods>
<class-id>Core.SequenceableCollection</class-id> <category>accessing</category>

<body package="SmallSuiteGenerator-Extensions" selector="combinationsAt:in:after:do:">combinationsAt: t1 in: t2 after: t3 do: t4 

	| t5 t6 |
	t5 := t3 + 1.
	t6 := self size.
	[t5 &lt;= t6]
		whileTrue: 
			[t2 at: t1 put: (self at: t5).
			t1 = t2 size
				ifTrue: [t4 value: t2]
				ifFalse: [self
						combinationsAt: t1 + 1
						in: t2
						after: t5
						do: t4].
			t5 := t5 + 1].
	^self</body>

<body package="SmallSuiteGenerator-Extensions" selector="combinations:atATimeDo:">combinations: t1 atATimeDo: t2 

	| t3 |
	t3 := Array new: t1.
	self
		combinationsAt: 1
		in: t3
		after: 0
		do: t2.
	^self</body>
</methods>

<methods>
<class-id>Core.SequenceableCollection</class-id> <category>copying</category>

<body package="SmallSuiteGenerator-Extensions" selector="allButLast">allButLast

	^self allButLast: 1</body>
</methods>


<methods>
<class-id>Kernel.SequenceNode</class-id> <category>probes</category>

<body package="SmallSuiteGenerator-Extensions" selector="probeInfoFor:doBefore:doAfter:">probeInfoFor: t1 doBefore: t2 doAfter: t3 
 
	| t4 t5 t6 t7 t8 |
	sourcePosition last + 1 &lt; t1 first ifTrue: t3.
	t7 := [^self probeRecordAtStart].
	sourcePosition first &gt; t1 first ifTrue: t2.
	sourcePosition first &gt; sourcePosition last ifTrue: [^self probeRecordAtStart].
	(sourcePosition first = t1 first and: [self mapEntry notNil])
		ifTrue: [^super probeRecordAtStart].
	t8 := statements size.
	t4 := 0.
	t5 := 
			[| t9 |
			(t4 := t4 - 1) = 0 ifTrue: t7.
			(t9 := (statements at: t4) probeRecordAtEnd) isNil ifFalse: [^t9].
			t5 value].
	^(t6 := 
			[(t4 := t4 + 1) &gt; t8 ifTrue: t5.
			^(statements at: t4)
				probeInfoFor: t1
				doBefore: t5
				doAfter: t6]) value</body>
</methods>


<methods>
<class-id>Core.GenericException</class-id> <category>private</category>

<body package="SmallSuiteGenerator-Extensions" selector="performHandler:">performHandler: t1 

	| t2 t3 |
	(handlerContext := t1) == nil
		ifTrue: 
			[t2 := self defaultAction.
			self isResumable
				ifTrue: 
					[handlerContext := initialContext.
					firstUnwindContext := nil.
					self unwind.
					thisContext terminateTo: handlerContext.
					handlerContext := nil]]
		ifFalse: 
			[t3 := handlerContext.
			t2 := handlerContext handlerBlock cull: self.
			handlerContext := t3.
			self unwind.
			thisContext terminateTo: handlerContext].
	^t2</body>
</methods>


<methods>
<class-id>Core.Link</class-id> <category>accessing</category>

<body package="SmallSuiteGenerator-Extensions" selector="asLink">asLink

	^self</body>
</methods>


<methods>
<class-id>Core.LinkValue</class-id> <category>comparing</category>

<body package="SmallSuiteGenerator-Extensions" selector="=">= t1 

	self species == t1 species
		ifTrue: 
			[self value = t1 value ifTrue: [^self nextLink == t1 nextLink].
			^false].
	^false</body>
</methods>


<methods>
<class-id>Core.OrderedCollection</class-id> <category>adding</category>

<body package="SmallSuiteGenerator-Extensions" selector="add:afterIndex:">add: t1 afterIndex: t2 
	(t2 between: 0 and: self size)
		ifFalse: [^self errorOutOfBounds].
	self insert: t1 before: firstIndex + t2.
	^t1</body>
</methods>

<methods>
<class-id>Core.OrderedCollection</class-id> <category>enumerating</category>

<body package="SmallSuiteGenerator-Extensions" selector="sum">sum

	^self inject: 0 into: [:t1 :t2 | t1 + t2]</body>

<body package="SmallSuiteGenerator-Extensions" selector="average">average

	^self sum / self size</body>
</methods>


<methods>
<class-id>Core.LimitedPrecisionReal</class-id> <category>As yet unclassified</category>

<body package="SmallSuiteGenerator-Extensions" selector="isBigEndian">isBigEndian

	&lt;primitive: 534&gt;
	self primitiveFailed.
	^self</body>

<body package="SmallSuiteGenerator-Extensions" selector="mantissaBitsAreZero">mantissaBitsAreZero

	self subclassResponsibility.
	^self</body>

<body package="SmallSuiteGenerator-Extensions" selector="isLittleEndian">isLittleEndian

	^self isBigEndian not</body>

<body package="SmallSuiteGenerator-Extensions" selector="isInfinity">isInfinity

	self isSpecialValue ifTrue: [^self mantissaBitsAreZero].
	^false</body>
</methods>


<methods>
<class-id>Core.SmallDouble</class-id> <category>comparing</category>

<body package="SmallSuiteGenerator-Extensions" selector="mantissaBitsAreZero">mantissaBitsAreZero

	^self asDegenerateDouble mantissaBitsAreZero</body>
</methods>


<methods>
<class-id>Core.String</class-id> <category>testing</category>

<body package="SmallSuiteGenerator-Extensions" selector="mutateToChange">mutateToChange
	| interval stringCopy |
	"correct bug to some characters form the string correctly, e.g: $-&gt; problem in a string"
	interval := (41 to: 127) asArray.
	stringCopy := self
		ifEmpty: [ '' ] 
		ifNotEmpty: [ self copyFrom: 1 to: self size - 1 ].
	^ ((Character value: (SmallSuiteGenerator.SPlatform randomGenerator selectAtRandom: interval))
		asString , stringCopy
		,
			(Character value: (SmallSuiteGenerator.SPlatform randomGenerator selectAtRandom: interval)) asString)
		asString</body>
</methods>

<methods>
<class-id>Core.String</class-id> <category>converting</category>

<body package="SmallSuiteGenerator-Extensions" selector="asString">asString

	^self</body>
</methods>

<methods>
<class-id>Core.String</class-id> <category>instance creation</category>

<body package="SmallSuiteGenerator-Extensions" selector="substrings:">substrings: t1

	| t2 t3 t4 t5 t6 t7 |
	t3 := (Array new: 10) writeStream.
	t5 := 1.
	t6 := self size.
	[t5 &lt;= t6]
		whileTrue: 
			[t4 := t5.
			t7 := self at: t4.
			(t1 includes: t7)
				ifTrue: [t2
						ifNotNil: 
							[t3 nextPut: (self copyFrom: t2 to: t4 - 1).
							t2 := nil]]
				ifFalse: [t2 ifNil: [t2 := t4]].
			t5 := t5 + 1].
	t2 ifNotNil: [t3 nextPut: (self copyFrom: t2 to: self size)].
	^t3 contents</body>
</methods>


<methods>
<class-id>Core.ByteSymbol</class-id> <category>testing</category>

<body package="SmallSuiteGenerator-Extensions" selector="mutateToChange">mutateToChange
	| interval stringCopy |
	"correct bug to some characters form the string correctly, e.g: $-&gt; problem in a string"
	interval := Character alphabet , $_ asString.
	stringCopy := self 
		ifEmpty: [ '' ]
		ifNotEmpty: [ self copyFrom: 1 to: self size - 1 ].
	^ ((SmallSuiteGenerator.SPlatform randomGenerator selectAtRandom: interval)
		asString , stringCopy
		,
			(SmallSuiteGenerator.SPlatform randomGenerator selectAtRandom: interval) asString)
		asSymbol</body>
</methods>


<methods>
<class-id>Core.Set</class-id> <category>removing</category>

<body package="SmallSuiteGenerator-Extensions" selector="=">= t1

	self == t1 ifTrue: [^true].
	self species == t1 species ifFalse: [^false].
	self size = t1 size ifFalse: [^false].
	^self allSatisfy: [:t2 | t1 includes: t2]</body>
</methods>


<methods>
<class-id>Core.Character</class-id> <category>testing</category>

<body package="SmallSuiteGenerator-Extensions" selector="mutateToChange">mutateToChange
	| newValue interval |
	interval := (33 to: 127) asArray. 
	newValue := SmallSuiteGenerator.SPlatform randomGenerator selectAtRandom: interval.
	[ newValue == self asInteger ]
		whileTrue: [ newValue := SmallSuiteGenerator.SPlatform randomGenerator selectAtRandom: interval ].
	^ Character value: newValue</body>
</methods>


<methods>
<class-id>Core.Dictionary</class-id> <category>accessing</category>

<body package="SmallSuiteGenerator-Extensions" selector="at:ifPresent:ifAbsentPut:">at: t1 ifPresent: t2 ifAbsentPut: t3 

	^self
		at: t1
		ifPresent: t2
		ifAbsent: [self at: t1 put: t3 value]</body>

<body package="SmallSuiteGenerator-Extensions" selector="at:ifPresent:ifAbsent:">at: t1 ifPresent: t2 ifAbsent: t3 

	| t4 t5 |
	t4 := true.
	t5 := self at: t1 ifAbsent: [t4 := false].
	t4 ifTrue: [^t2 cull: t5].
	^t3 value</body>
</methods>

<methods>
<class-id>Core.Dictionary</class-id> <category>testing</category>

<body package="SmallSuiteGenerator-Extensions" selector="=">= t1 

	self == t1 ifTrue: [^true].
	self species == t1 species ifFalse: [^false].
	self size = t1 size ifFalse: [^false].
	self keysAndValuesDo: 
		[:t2 :t3 | 
		(t1 at: t2 ifAbsent: [^false]) = t3
			ifTrue: [nil]
			ifFalse: [^false]].
	^true</body>
</methods>


<methods>
<class-id>Core.Double</class-id> <category>comparing</category>

<body package="SmallSuiteGenerator-Extensions" selector="mantissaBitsAreZero">mantissaBitsAreZero

	| t1 t2 |
	self isLittleEndian
		ifTrue: 
			[t1 := 1.
			[t1 &lt;= 6]
				whileTrue: 
					[(self basicAt: t1)
						= 0 ifFalse: [^false].
					t1 := t1 + 1].
			^((self basicAt: 7)
				bitAnd: 15)
				= 0].
	t2 := 3.
	[t2 &lt;= 8]
		whileTrue: 
			[(self basicAt: t2)
				= 0 ifFalse: [^false].
			t2 := t2 + 1].
	^((self basicAt: 2)
		bitAnd: 15)
		= 0</body>
</methods>


<methods>
<class-id>Core.Float</class-id> <category>comparing</category>

<body package="SmallSuiteGenerator-Extensions" selector="mantissaBitsAreZero">mantissaBitsAreZero

	self isLittleEndian
		ifTrue: 
			[(self basicAt: 1)
				= 0
				ifTrue: 
					[(self basicAt: 2)
						= 0 ifTrue: [^((self basicAt: 3)
							bitAnd: 127)
							= 0].
					^false].
			^false].
	(self basicAt: 4)
		= 0
		ifTrue: 
			[(self basicAt: 3)
				= 0 ifTrue: [^((self basicAt: 2)
					bitAnd: 127)
					= 0].
			^false].
	^false</body>
</methods>

<methods>
<class-id>Core.Float</class-id> <category>converting</category>

<body package="SmallSuiteGenerator-Extensions" selector="specialValueExponent">specialValueExponent

	^128</body>
</methods>


<methods>
<class-id>Core.Array</class-id> <category>printing</category>

<body package="SmallSuiteGenerator-Extensions" selector="storeOn:">storeOn: t1 

	self isLiteral
		ifTrue: 
			[t1 nextPutAll: '#('.
			t1 policy printCharactersLiterally: true while: [self do: [:t2 | t2 storeOn: t1]
					separatedBy: [t1 space]].
			t1 space.
			t1 nextPut: $)]
		ifFalse: [super storeOn: t1].
	^self</body>

<body package="SmallSuiteGenerator-Extensions" selector="printOn:">printOn: t1 

	| t2 |
	t2 := t1 position + self maxPrint.
	t1 nextPutAll: '#('.
	self
		do: 
			[:t3 | 
			t1 position &gt; t2
				ifTrue: 
					[t1 nextPutAll: (#etc &lt;&lt; #dialogs &gt;&gt; '...etc...') asString , ')'.
					^self].
			t3 printOn: t1]
		separatedBy: [t1 space].
	t1 space.
	t1 nextPut: $).
	^self</body>
</methods>


<methods>
<class-id>SUnit.TestCase</class-id> <category>backwards compatibility</category>

<body package="SmallSuiteGenerator-Extensions" selector="assertCollection:includesAll:">assertCollection: t1 includesAll: t2 

	^self assert: (t1 includesAll: t2)
		description: [t1 asString , ' does not include all in ' , t2 asString]</body>

<body package="SmallSuiteGenerator-Extensions" selector="deny:equals:">deny: t1 equals: t2 


	t1 = t2 ifTrue: [self signalFailure: t1 printString , ' is not equal to ' , t2 printString].
	^self</body>
</methods>

<methods>
<class-id>SUnit.TestCase</class-id> <category>converting</category>

<body package="SmallSuiteGenerator-Extensions" selector="fullSymbolOf:">fullSymbolOf: aSymbol 

	#('Core.' 'Smalltalk.' 'SmallSuiteGenerator.' ) detect: [:t2 | (Smalltalk at: t2 , aSymbol ifAbsent: [nil]) isNil not]
		ifFound: [:t3 | ^(t3 , aSymbol) asSymbol].
	self error: 'I cant find the namespace for: ' , aSymbol.
	^self</body>

<body package="SmallSuiteGenerator-Extensions" selector="fullNameOfClass:">fullNameOfClass: t1 

	#('Core.' 'Smalltalk.' 'SmallSuiteGenerator.' ) detect: [:t2 | (Smalltalk at: t2 , t1 ifAbsent: [nil]) isNil not]
		ifFound: [:t3 | ^t3 , t1 asString].
	self error: 'I cant find the namespace for: ' , t1.
	^self</body>
</methods>


<methods>
<class-id>CraftedSmalltalk.AuxCodeInfoExtractor</class-id> <category>decoding</category>

<body package="SmallSuiteGenerator-Extensions" selector="run">run

	[self atEnd]
		whileFalse: 
			[visited at: pc put: true.
			self interpretNextInstructionFor: self.
			pc &lt;= visited size ifTrue: [(visited at: pc)
					ifTrue: [self endBranch]]].
	^self</body>
</methods>


<methods>
<class-id>Core.SmallInteger</class-id> <category>security</category>

<body package="SmallSuiteGenerator-Extensions" selector="asBigEndianByteArray">asBigEndianByteArray

	| t1 t2 |
	self negative ifTrue: [self errorConvertingNegativeIntegerToBytes].
	self &gt; 65535 
		ifTrue: 
			[t1 := self bitShift: -16.
			t2 := self bitAnd: 65535.
			t1 &gt; 255 ifTrue: [^ByteArray
					with: (t1 bitShift: -8)
					with: (t1 bitAnd: 255)
					with: (t2 bitShift: -8)
					with: (t2 bitAnd: 255)].
			^ByteArray
				with: (t1 bitAnd: 255)
				with: (t2 bitShift: -8)
				with: (t2 bitAnd: 255)].
	self &gt; 255 ifTrue: [^ByteArray with: (self bitShift: -8)
			with: (self bitAnd: 255)].
	^ByteArray with: (self bitAnd: 255)</body>

<body package="SmallSuiteGenerator-Extensions" selector="specialLeftShift:">specialLeftShift: t1 

	t1 = 0 ifFalse: [^(self bitAnd: (self class leftShiftArray at: t1))
			bitShift: t1].
	^self</body>
</methods>



</st-source>
