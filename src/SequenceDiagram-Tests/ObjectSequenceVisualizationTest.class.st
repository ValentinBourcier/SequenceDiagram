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

{ #category : #tests }
ObjectSequenceVisualizationTest >> testFragments [
	| seq a b window c get set d |
	seq := SequenceDiagram new.
	a := seq addInstance: 'A'.
	b := seq addInstance: 'B'.
	c := seq addInstance: 'C'.
	d := seq addInstance: 'D'.
	get := seq addMessage: (a sends: 'get' to: b).
	set := seq addMessage: (b sends: 'get' to: b).
	
	seq addFragment: 'Fragment 1' forInstances: { a. b . d }.
	seq addFragment: 'Fragment 2' from: get to: set.

	window := seq open.
	window delete.
]

{ #category : #tests }
ObjectSequenceVisualizationTest >> testSelfCall [
	| seq a b window |
	seq := SequenceDiagram new.
	a := seq addInstance: 'A'.
	b := seq addInstance: 'B'.
	
	seq addMessage: (a sends: 'get' to: b).
	seq addMessage: (b sends: 'get' to: b).
	window := seq open.
	window delete.
]
