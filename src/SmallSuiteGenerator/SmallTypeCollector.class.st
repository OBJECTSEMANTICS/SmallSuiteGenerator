"
SmallTypeCollector is a class to obtain information about the parameters of those methods that do not have enough information.

This information is obtained in two ways: using NEVENA techniques and using the type information provided by RoelfTyper.

EXAMPLE OF USE
---------------

SmallTypeCollector new collectTypeFrom: aClass
"
Class {
	#name : #SmallTypeCollector,
	#superclass : #SObject,
	#classInstVars : [
		'classDict'
	],
	#category : #'SmallSuiteGenerator-SmallType'
}

{ #category : #accessing }
SmallTypeCollector class >> classDict [
	classDict ifNil: [classDict := Dictionary new.
	Object withAllSubclasses do: [ :class|
			classDict at: class name asLowercase put: class.
		]].
	^ classDict  
]

{ #category : #reset }
SmallTypeCollector class >> resetClassDict [
	classDict := nil 
]

{ #category : #action }
SmallTypeCollector >> collectTypeFrom: aClass [
	|collector typeInfo methodInfo aBlock|
	aClass isMeta ifTrue:[ ^ nil.].
	typeInfo := STypeClassInfo newFrom: aClass name.
	aBlock := [ :coll :cls :symbol | |extractor|
		coll onClass: cls.
		extractor := coll newExtractor.
		cls selectorsAndMethodsDo: [ :selector :method |
		coll currentExtractedMethod: method. 
			extractor
				extractInterfacesFrom: method
				addTo: coll].
		cls methodDictValues do:[ :method | 
			coll localTypingResults at: method ifPresent:[ :tmpTypes |
				methodInfo := self methodInfoIn: method from: tmpTypes.
				typeInfo perform: symbol with: methodInfo.
			] ] ].
	collector := TypeCollector new.
	aBlock cull: collector cull: aClass cull: #addMethod:.
	collector := TypeCollector new.
	aBlock cull: collector cull: aClass class cull: #addClassMethod:.
	^ typeInfo.
]

{ #category : #action }
SmallTypeCollector >> methodInfoIn: aCompiledMethod from: tempTypes [
	|methodTypeInfo argTypes returnType types|
	methodTypeInfo := STypeMethodInfo new.
	methodTypeInfo 
		selector: aCompiledMethod selector;
		isQuick: aCompiledMethod isQuick;
		isAbstract: aCompiledMethod isAbstract;
		scalars: Dictionary new;
		isDeprecated: aCompiledMethod isDeprecated;
		executions: 0.
	argTypes := OrderedCollection new.
	aCompiledMethod ast argumentNames doWithIndex:[ :argName : index|
			|argType|
			argType := SMultiTypeInfo new.
			types := (tempTypes at: index) types.
			((types size = 1) and:[types first = Object]) ifTrue:[ "name type"
					argType type: (self typeFor: argName).
				] ifFalse:[
					types do:[ :argClass | argClass isMeta ifFalse: [ argType type: argClass name asSymbol ] ] ].
			#(#Object #SUndefinedObject) do: [:each | argType removeType: each ]. 
			argTypes add: argType.
		].
	returnType := SMultiTypeInfo new.
	types := tempTypes last types.
	((types size =1) and:[ types first = Object]) ifFalse:[
		types do:[ :argClass | returnType type: argClass name asSymbol. ].
	]. "if not it is empty"
	methodTypeInfo returnType: returnType.
	methodTypeInfo argTypes: argTypes.
	^ methodTypeInfo.
]

{ #category : #action }
SmallTypeCollector >> typeFor: argName [
	|index lastPart|
	(argName = 'arg') ifTrue:[^#nil.].
	"Case 1:"
	(self class classDict at: argName asLowercase ifPresent:[ :value | ^ value name ]).
	"Case 2:"
	index := 1.	
	[(index <= argName size) and:[ (argName at: index) isLowercase]] whileTrue:[ index := index + 1.].
	lastPart := argName copyFrom: index to: argName size.
	(self class classDict at: lastPart asLowercase ifPresent:[ :value | ^ value name ]).
	"Case 3:"
	(argName asLowercase = 'spec') ifTrue:[^ #MetacelloAbstractVersionConstructor].
	"Case 4:"
	('.*(b|B)lock.*' asRegex matches: argName) ifTrue:[^#BlockClosure].
	"Case 5:"
	('.*(o|O)rderedCollection.*' asRegex matches: argName) ifTrue:[^#OrderedCollection].
	('.*(a|A)rray.*' asRegex matches: argName) ifTrue:[^#Array].
	('.*(d|D)ictionary.*' asRegex matches: argName) ifTrue:[^#Dictionary].
	('.*(s|S)et.*' asRegex matches: argName) ifTrue:[^#Set ].
	('.*(b|B)ag.*' asRegex matches: argName) ifTrue:[^#Bag].
	('.*(c|C)ollection.*' asRegex matches: argName) ifTrue:[^#Collection].
	('.*(s|S)tring.*' asRegex matches: argName) ifTrue:[^#String].
	('.*(s|S)ymbol.*' asRegex matches: argName) ifTrue:[^#Symbol].
	
	^ #nil.
]
