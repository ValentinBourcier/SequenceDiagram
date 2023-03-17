Class {
	#name : #SequenceEdge,
	#superclass : #Object,
	#instVars : [
		'sender',
		'receiver',
		'selector'
	],
	#category : #SequenceDiagram
}

{ #category : #accessing }
SequenceEdge >> receiver [

	^ receiver
]

{ #category : #accessing }
SequenceEdge >> receiver: anObject [

	receiver := anObject
]

{ #category : #accessing }
SequenceEdge >> selector [

	^ selector
]

{ #category : #accessing }
SequenceEdge >> selector: anObject [

	selector := anObject
]

{ #category : #accessing }
SequenceEdge >> sender [

	^ sender
]

{ #category : #accessing }
SequenceEdge >> sender: anObject [

	sender := anObject
]
