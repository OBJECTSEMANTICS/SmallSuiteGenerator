"
Abstract class of those nodes responsible for the genetic algorithm evolution:

	- engine (like its name says, it is responsible to execute the algorithm in order to get the testCases with the highest fitness value)
	- operations classes -> Responsible for executing crossover and mutation operation
	- selection algorithm class -> It selects the fittest individuals testCases
"
Class {
	#name : #SGAObject,
	#superclass : #SObject,
	#category : #'SmallSuiteGenerator-GA'
}
