Class {
	#name : #SMethodInfoTest,
	#superclass : #TestCase,
	#category : #'SmallSuiteGeneratorTest-Info'
}

{ #category : #tests }
SMethodInfoTest >> testType [
	| methodInfo |
	methodInfo := STypeMethodInfo type:
			#returnFloat
						->
							{#SmallFloat64.
							{}.
							false}.
	self assert: methodInfo returnType equals: #SmallFloat64.
	self assert: methodInfo argTypes isEmpty.
	self deny: methodInfo isQuick.
	methodInfo := STypeMethodInfo type:
					#returnString
						->
							{#ByteString.
							{}.
							false}.
	self assert: methodInfo returnType equals: #ByteString.
	self assert: methodInfo argTypes isEmpty.
	self deny: methodInfo isQuick.
	methodInfo := STypeMethodInfo type:
					#return:
						->
							{#OrderedCollection.
							{#OrderedCollection}.
							false}.
	self assert: methodInfo returnType equals: #OrderedCollection.
	self assertCollection: methodInfo argTypes hasSameElements: {#OrderedCollection}.
	self deny: methodInfo isQuick.			
	methodInfo := STypeMethodInfo type:		
					#score:
						->
							{#SFoo.
							{#SmallInteger}.
							false}.
	self assert: methodInfo returnType equals: #SFoo.
	self assertCollection: methodInfo argTypes hasSameElements: {#SmallInteger}.
	self deny: methodInfo isQuick.	
	methodInfo := 	STypeMethodInfo type:					
					#score
						->
							{#SmallInteger.
							{}.
							true}.
	self assert: methodInfo returnType equals: #SmallInteger.
	self assert: methodInfo argTypes isEmpty.
	self assert: methodInfo isQuick.					

]
