"
An ObjectSequenceVisualizationTest is a test class for testing the behavior of ObjectSequenceVisualization
"
Class {
	#name : #ObjectSequenceVisualizationTest,
	#superclass : #TestCase,
	#category : #'SequenceDiagram-Tests'
}

{ #category : #tests }
ObjectSequenceVisualizationTest >> testBasic [
	| seq a b window |
	seq := SequenceDiagram new.
	a := seq addInstance: 'A'.
	b := seq addInstance: 'B'.
	
	seq addMessage: (a sends: 'get' to: b).

	window := seq open.
	window delete.
]
