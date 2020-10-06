Class {
	#name : #TypeCollectorWithLightWeight,
	#superclass : #SmallTypeCollector,
	#category : #'SmallSuiteGenerator-SmallType'
}

{ #category : #action }
TypeCollectorWithLightWeight >> collectTypeFrom: aClass [
	| typeInfo |
	
	aClass isMeta ifTrue:[ ^ nil.].
	typeInfo := STypeClassInfo newFrom: aClass name.
	
	aClass methods do: [ :m | typeInfo addMethod: (self methodInfoIn: m) ].
	aClass class methods do: [ :m | typeInfo addClassMethod: (self methodInfoIn: m) ].
	
	^ typeInfo.
]

{ #category : #action }
TypeCollectorWithLightWeight >> methodInfoIn: aCompiledMethod [
	| methodTypeInfo argTypes returnType |
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
			argType type: (self typeFor: argName).
			#(#Object #SUndefinedObject) do: [:each | argType removeType: each ]. 
			argTypes add: argType.
		].
	returnType := SMultiTypeInfo new.
	returnType type: #SUndefinedObject.
	methodTypeInfo returnType: returnType.
	methodTypeInfo argTypes: argTypes.
	^ methodTypeInfo.
]
