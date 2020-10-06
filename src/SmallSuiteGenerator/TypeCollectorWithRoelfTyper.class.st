Class {
	#name : #TypeCollectorWithRoelfTyper,
	#superclass : #SmallTypeCollector,
	#category : #'SmallSuiteGenerator-SmallType'
}

{ #category : #action }
TypeCollectorWithRoelfTyper >> methodInfoIn: aCompiledMethod from: tempTypes [
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
			((types size = 1) and:[types first = Object]) 
				ifFalse:[
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
