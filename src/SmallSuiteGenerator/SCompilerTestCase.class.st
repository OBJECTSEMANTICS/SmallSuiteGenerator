Class {
	#name : #SCompilerTestCase,
	#superclass : #Object,
	#category : #'SmallSuiteGenerator-Core'
}

{ #category : #'as yet unclassified' }
SCompilerTestCase >> compileTestCase [
| _var0 _var1 _var2 _var3 _var4 _var5 _var6 _var7 _var8 _var9 _var10 _var11 _var12 _var13 _var14 |
_var0 := RTEquidistantCircleLayout new.
_var1 := RTSVGPath new.
_var2 := RTElement new.
_var3 := _var1 trachelShapeFor: _var2.
_var4 := RTMultiLine new.
_var5 := Announcer basicNew
	instVarAt: 1
		put:
		(SubscriptionRegistry basicNew
			instVarAt: 1 put: IdentitySet new;
			instVarAt: 2 put: Semaphore new;
			yourself);
	yourself.
_var6 := _var2 initialize.
_var7 := RTArc new.
_var8 := RTCellMatrix new.
_var9 := Color
	r: 0.875
	g: 0.875
	b: 0.875
	alpha: 1.0.
_var10 := 623.0 @ 206.0.
_var11 := 50.0 @ 50.0 corner: 462.0 @ 462.0.
_var12 := RTFilledCircle new.
_var13 := RTVerticalLineLayout new.
_var14 := RTNoShape new
]
