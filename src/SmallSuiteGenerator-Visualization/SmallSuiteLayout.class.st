Class {
	#name : #SmallSuiteLayout,
	#superclass : #RTLayout,
	#category : #'SmallSuiteGenerator-Visualization'
}

{ #category : #hook }
SmallSuiteLayout >> doExecute: elements [
  "Performs the layout"
  "elements do: [:e |  e translateTo: (e model idPopulation * 10) @ (e model ni * 20) ]"
  elements do: [:e |  e translateTo: (e model idPopulation * 20) @ (e model ni * 30) ]
]
