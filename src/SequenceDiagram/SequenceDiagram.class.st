Class {
	#name : #SequenceDiagram,
	#superclass : #RSAbstractContainerBuilder,
	#instVars : [
		'instances',
		'messages'
	],
	#category : #SequenceDiagram
}

{ #category : #adding }
SequenceDiagram >> addInstance: anObject [ 
	^ instances add: (SequenceNode model: anObject)
]

{ #category : #adding }
SequenceDiagram >> addMessage: aSequenceEdge [
	messages add: aSequenceEdge
]

{ #category : #hooks }
SequenceDiagram >> createAllCallLinesWithScale: scale [
	^ messages collectWithIndex: [ :aSequenceEdge :index |
		 self createCallLineFor: aSequenceEdge at: (scale * index) ]
]

{ #category : #hooks }
SequenceDiagram >> createAllLifelinesOfHeight: totalHeight [
	^ self canvas nodes collect: [ :aShape | self createLifelinesOfHeight: totalHeight for: aShape ].
	
]

{ #category : #hooks }
SequenceDiagram >> createCallLineFor: aSequenceEdge at: yPosition [ 
	| shapeSender shapeReceiver  |
	shapeSender := self canvas nodes shapeFromModel: aSequenceEdge sender.
	shapeReceiver := self canvas nodes shapeFromModel: aSequenceEdge receiver.
	^ RSArrowedLine new
		model: aSequenceEdge;
		color: Color black;
		in: [ :line | line markerEnd shape extent: 3@5 ];
		startPoint: shapeSender position x @ (yPosition+(shapeSender height));
		endPoint: shapeReceiver position x @ (yPosition+(shapeReceiver height)); 
		yourself
]

{ #category : #hooks }
SequenceDiagram >> createCallLineLabelFor: line [ 
	| label |
	label := RSLabel new
		text: line model selector;
		fontSize: 5;
		color: Color black;
		yourself.
	label position: line position + (label height / -2).
	^ label
		
]

{ #category : #hooks }
SequenceDiagram >> createCallLineLabels: callLines [
	^ callLines collect: [ :line | self createCallLineLabelFor: line ]
]

{ #category : #'as yet unclassified' }
SequenceDiagram >> createColumnFor: aSequenceNode [ 
	| label box |
	label := RSLabel new
		text: aSequenceNode title;
		color: Color black;
		yourself.
	box := RSBox new
		color: Color white;
		border: (RSBorder new color: Color black);
		yourself.
	box extent: label extent + 10.
	^ { box. label } asShape
		draggable;
		model: aSequenceNode;
		yourself.
]

{ #category : #'as yet unclassified' }
SequenceDiagram >> createColumns [
	^ self instances collect: [ :aSequenceNode | self createColumnFor: aSequenceNode ]
]

{ #category : #hooks }
SequenceDiagram >> createLifelinesOfHeight: totalHeight for: aShape [
	| startPoint |
	startPoint := aShape position x@ (aShape position y + (aShape height / 2)).
	^ RSLine new
		dashArray: #(3 1);
		color: Color black;
		startPoint: startPoint;
		endPoint: aShape position x @(totalHeight + startPoint y);
		yourself.
]

{ #category : #'accessing - defaults' }
SequenceDiagram >> defaultContainer [
	^ RSCanvas new @ RSCanvasController.
]

{ #category : #initialization }
SequenceDiagram >> initialize [
	super initialize.
	instances := OrderedCollection new.
	messages := OrderedCollection new.
]

{ #category : #accessing }
SequenceDiagram >> instances [

	^ instances
]

{ #category : #accessing }
SequenceDiagram >> instances: anObject [

	instances := anObject
]

{ #category : #accessing }
SequenceDiagram >> messages [

	^ messages
]

{ #category : #accessing }
SequenceDiagram >> messages: anObject [

	messages := anObject
]

{ #category : #hooks }
SequenceDiagram >> renderIn: aCanvas [
	| columnShapes |
	columnShapes := self createColumns.
	RSHorizontalLineLayout on: columnShapes.
	aCanvas addAll: columnShapes.
	self renderLinesOn: aCanvas.
	
]

{ #category : #hooks }
SequenceDiagram >> renderLinesOn: aCanvas [

	| totalHeight lifelines callLines scaleFactor callLinesLabels minimumDiff maximumDiff |
	minimumDiff := 7.
	maximumDiff := 30.
	scaleFactor := maximumDiff / messages size max: minimumDiff.

	totalHeight := (messages size + 1) * scaleFactor.
	lifelines := self createAllLifelinesOfHeight: totalHeight.
	callLines := self createAllCallLinesWithScale: scaleFactor.
	callLinesLabels := self createCallLineLabels: callLines.
	aCanvas addAll: lifelines.
	aCanvas addAll: callLines.
	aCanvas addAll: callLinesLabels
]

{ #category : #accessing }
SequenceDiagram >> run [

	<script: 'self new run'>
	| a b c |
	a := self addInstance: 'A'.
	b := self addInstance: 'B'.
	c := self addInstance: 'B'.

	self addMessage: (a sends: 'get' to: b).
	self addMessage: (a sends: 'set' to: b).

	0 timesRepeat: [ 
		self addMessage: (a sends: 'get' to: b).

		self addMessage: (a sends: 'set' to: b).
		self addMessage: (b sends: 'compute' to: a).

		self addMessage: (c sends: 'foo' to: b).
		self addMessage: (c sends: 'bar' to: a).
		self addMessage: (a sends: 'zork' to: c) ].
	self open
]
