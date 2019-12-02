"
SMultiFitnessFunciton is the fitness function that contains simple fitness function's collection.
"
Class {
	#name : #SMultiFitnessFunction,
	#superclass : #SFitnessFunction,
	#instVars : [
		'fitness'
	],
	#classInstVars : [
		'multiFitnessFunction'
	],
	#category : #'SmallSuiteGenerator-GA'
}

{ #category : #accessing }
SMultiFitnessFunction >> add: aFitness weight: aFloat [
	fitness at: aFitness put: aFloat.
]

{ #category : #actions }
SMultiFitnessFunction >> compute: aTestCase [
	"^ fitness associations inject: 0 into:[:assoc :acum |  
				acum +  ((assoc first compute: aTestCase)* (assoc second))s]."
]

{ #category : #initialization }
SMultiFitnessFunction >> initialize [ 
	super initialize.
	fitness := Dictionary new.
]
