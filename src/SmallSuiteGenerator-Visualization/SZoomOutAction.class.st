Class {
	#name : #SZoomOutAction,
	#superclass : #RSAbstractAction,
	#category : #'SmallSuiteGenerator-Visualization'
}

{ #category : #hooks }
SZoomOutAction >> execute [
	| canvas keyNavigation |
	canvas := self roassalCanvas.
	keyNavigation := canvas controllerInteraction interactions at: RSKeyNavigationCanvasInteraction.
	keyNavigation zoomOut: canvas
]

{ #category : #hooks }
SZoomOutAction >> icon [ 
	^ self iconNamed: #glamorousZoomOut
]

{ #category : #hooks }
SZoomOutAction >> title [ 	
	^ 'Zoom Out'
]
