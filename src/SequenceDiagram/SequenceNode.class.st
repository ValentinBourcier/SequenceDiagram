Class {
	#name : #SequenceNode,
	#superclass : #Object,
	#instVars : [
		'model',
		'messages',
		'name'
	],
	#category : #SequenceDiagram
}

{ #category : #accessing }
SequenceNode class >> model: anObject [ 
	^ self new
		model: anObject;
		yourself
]

{ #category : #initialization }
SequenceNode >> initialize [
	super initialize.
	messages := OrderedCollection new.
	name := ''
]

{ #category : #accessing }
SequenceNode >> messages [

	^ messages
]

{ #category : #accessing }
SequenceNode >> messages: anObject [

	messages := anObject
]

{ #category : #accessing }
SequenceNode >> model [

	^ model
]

{ #category : #accessing }
SequenceNode >> model: anObject [ 
	model := anObject
]

{ #category : #accessing }
SequenceNode >> name [

	^ name
]

{ #category : #accessing }
SequenceNode >> name: anObject [

	name := anObject
]

{ #category : #'as yet unclassified' }
SequenceNode >> sends: selector to: aSequenceNode [ 
	| edge |
	edge := SequenceEdge new
		sender: self;
		receiver: aSequenceNode;
		selector: selector;
		yourself.
	messages add: edge.
	aSequenceNode messages add: edge.
	^ edge
]

{ #category : #accessing }
SequenceNode >> title [
	^ String streamContents: [ :stream | 
		name ifNotEmpty: [ stream << name; space ].
		stream << $: << model class name ]
]
