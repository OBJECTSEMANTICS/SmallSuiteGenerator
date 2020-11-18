Class {
	#name : #SZoomInAction,
	#superclass : #RSAbstractAction,
	#category : #'SmallSuiteGenerator-Visualization'
}

{ #category : #hooks }
SZoomInAction >> execute [
	| canvas keyNavigation |
	canvas := self roassalCanvas.
	keyNavigation := canvas controllerInteraction interactions at: RSKeyNavigationCanvas.
	keyNavigation zoomIn: canvas
]

{ #category : #hooks }
SZoomInAction >> icon [ 
	^ self iconNamed: #glamorousZoomIn
]

{ #category : #hooks }
SZoomInAction >> title [ 
	^ 'Zoom In'
]
