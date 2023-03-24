Class {
	#name : #SequenceDiagram,
	#superclass : #RSAbstractContainerBuilder,
	#instVars : [
		'instances',
		'messages',
		'scaleFactor',
		'fragments'
	],
	#category : #SequenceDiagram
}

{ #category : #'as yet unclassified' }
SequenceDiagram class >> exampleWithFragments [
	| a b c diagram |
	diagram := self new.
	a := diagram addInstance: 'A'.
	b := diagram addInstance: 'B'.
	c := diagram addInstance: 'C'.

	diagram addMessage: (a sends: 'get' to: b).
	diagram addFragment: 'Fragment 1' forInstances: { a. c }.

	1 timesRepeat: [ 
		diagram addMessage: (a sends: 'set' to: b).
		diagram addMessage: (b sends: 'self' to: b).
		diagram addMessage: (b sends: 'compute' to: c).
		diagram addMessage: (c sends: 'message:with:params:' to: a).
		diagram addMessage: (a sends: 'messageWithAnEspeciallyLongSelector' to: c) ].
	^ diagram open
]

{ #category : #'as yet unclassified' }
SequenceDiagram class >> exampleWithMethodFragments [
	| a b c diagram get set zork |
	diagram := self new.
	a := diagram addInstance: 'A'.
	b := diagram addInstance: 'B'.
	c := diagram addInstance: 'C'.

	2 timesRepeat: [ 
		diagram addMessage: (a sends: 'set' to: b).
		diagram addMessage: (b sends: 'self' to: b).
		diagram addMessage: (b sends: 'compute' to: c).
		diagram addMessage: (c sends: 'message:with:params:' to: a).
		diagram addMessage: (a sends: 'messageWithAnEspeciallyLongSelector' to: c) ].
	
	get := diagram addMessage: (a sends: 'get' to: b).
	set := diagram addMessage: (a sends: 'set' to: b).	
	zork := diagram addMessage: (b sends: 'zork' to: c).	
	diagram addFragment: 'Fragment 2' from: get to: zork.
	
	2 timesRepeat: [ 
		diagram addMessage: (a sends: 'set' to: b).
		diagram addMessage: (b sends: 'self' to: b).
		diagram addMessage: (b sends: 'compute' to: c).
		diagram addMessage: (c sends: 'message:with:params:' to: a).
		diagram addMessage: (a sends: 'messageWithAnEspeciallyLongSelector' to: c) ].

	^ diagram open
]

{ #category : #adding }
SequenceDiagram >> addFragment: aString forInstances: aCollection [ 
	fragments add: (SequenceInstanceFragment new
		instances: aCollection;
		name: aString;
		yourself)
]

{ #category : #adding }
SequenceDiagram >> addFragment: aString from: aSequenceEdgeFrom to: aSequenceEdgeTo [
	fragments add: (SequenceMessageFragment new
		from: aSequenceEdgeFrom;
		to: aSequenceEdgeTo;
		name: aString;
		yourself)
]

{ #category : #adding }
SequenceDiagram >> addInstance: anObject [ 
	^ instances add: (SequenceNode model: anObject)
]

{ #category : #adding }
SequenceDiagram >> addMessage: aSequenceEdge [
	messages add: aSequenceEdge.
	^ aSequenceEdge
]

{ #category : #'as yet unclassified' }
SequenceDiagram >> computeGroupsFor: aSequenceInstanceFragment [
	| indexes groups previous shapeNodes |
	indexes := (aSequenceInstanceFragment instances collect: [ :instance |
		instances indexOf: instance ] as: Set) asSortedCollection.
	groups := OrderedCollection new.
	previous := -1.
	shapeNodes := container nodes.
	indexes do: [ :index | 
		index - previous > 1 ifTrue: [ 
			groups add: (OrderedCollection new) ].
		groups last add: (shapeNodes at: index).
		previous := index ].
	^ groups
	
]

{ #category : #hooks }
SequenceDiagram >> computeScaleFactor [
	"fewer messages => (more space between them <=> bigger scaleFactor)"
	| domainMin domainMax rangeMin rangeMax |
	domainMin := 7.
	domainMax := 30.
	rangeMin := 8.
	rangeMax := 20.
	scaleFactor := (1 - ((messages size - domainMin) / (domainMax - domainMin))) * (rangeMax - rangeMin) + rangeMin.
	scaleFactor := scaleFactor min: rangeMax max: rangeMin
]

{ #category : #hooks }
SequenceDiagram >> createAllCallLines [
	^ messages collectWithIndex: [ :aSequenceEdge :index |
		 self createCallLineFor: aSequenceEdge at: (scaleFactor * index) ]
]

{ #category : #hooks }
SequenceDiagram >> createAllLifelines [
	| totalHeight |
	totalHeight := (messages size + 1) * scaleFactor.
	^ self canvas nodes collect: [ :aShape | 
		self createLifelinesOfHeight: totalHeight for: aShape ].
	
]

{ #category : #hooks }
SequenceDiagram >> createCallLineFor: aSequenceEdge at: yPosition [ 
	| shapeSender shapeReceiver x1 x2 y1 y2 line arrow gap |
	shapeSender := self canvas nodes shapeFromModel: aSequenceEdge sender.
	shapeReceiver := self canvas nodes shapeFromModel: aSequenceEdge receiver.
	x1 := shapeSender position x.
	x2 := shapeReceiver position x.
	y1 := yPosition + shapeSender height.
	y2 := yPosition + shapeReceiver height.
	gap := 2 * (x1 - x2) sign.
	line := shapeSender = shapeReceiver ifTrue: [
		gap := 2.
		RSPolyline new
			controlPoints: { 
				x1 @ y1.
				shapeSender width / 2 + x1 @ y1.
				shapeSender width / 2 + x1 @ (scaleFactor / 2 + y1).
				x1 + gap @ (scaleFactor / 2 + y1) };
			yourself ]
		ifFalse: [ RSLine new
			startPoint: x1 @ y1;
			endPoint: x2 + gap @ y2;
			yourself  ].
	arrow := RSShapeFactory triangle
		color: Color black;
		extent: 3@4;
		asMarker.
	line
		model: aSequenceEdge;
		width: 0.6;
		markerEnd: arrow;
		"joinMiter;"
		color: Color black.
	^ line
		
]

{ #category : #hooks }
SequenceDiagram >> createCallLineLabelFor: line [ 
	| text label |
	text := RSLabel new
		metricsProvider: RSCairoFitMetricsProvider new;
		text: line model selector;
		fontSize: 5;
		color: Color black;
		yourself.
	
	label := { text } asShape
		color: Color white;
		yourself.
	"label position: line position x @ (line position y +  (label height / -2))."
	RSLocation new
		above;
		offset: 0@ -0.6;
		move: label on: line.
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
		model: aSequenceNode;
		yourself.
]

{ #category : #'as yet unclassified' }
SequenceDiagram >> createColumns [
	^ self instances collect: [ :aSequenceNode | self createColumnFor: aSequenceNode ]
]

{ #category : #'as yet unclassified' }
SequenceDiagram >> createFragmentGroupFor: aCollection name: fragmentName height: fragmentShapeHeight [
	| rectangle label polygon box |
	label := RSLabel new
		text: fragmentName;
		bold;
		color: Color black;
		fontSize: 5;
		yourself.
	rectangle := label encompassingRectangle.
	polygon := RSPolygon new
		color: Color white;
		points: {
			rectangle origin.
			rectangle topRight.
			rectangle rightCenter.
			rectangle corner x - (rectangle floatCenter y - rectangle origin y) @ rectangle corner y.
			rectangle bottomLeft.
			};
		yourself.
	polygon extent: polygon extent + (8 @ 2).
	
	polygon border: (RSBorder new width: 0.6; color: Color black).
	box := RSBox new.
	box noPaint.
	rectangle := aCollection asGroup encompassingRectangle.
	
	rectangle := rectangle origin x @ (rectangle origin y - label height)
		corner: rectangle corner x @ (rectangle corner y + fragmentShapeHeight).
	
	box fromRectangle: rectangle. 
	box extent: box extent + 10.
	RSLocation new
		inner; top; left;
		move: polygon on: box.
	label position: polygon position.
	
	box border: (RSBorder new
		color: Color black).
	
	^ { box. polygon. label } asShape
]

{ #category : #hooks }
SequenceDiagram >> createLifelinesOfHeight: totalHeight for: aShape [
	| startPoint |
	startPoint := aShape position x @ (aShape position y + (aShape height / 2)).
	^ RSLine new
		dashArray: #(3 1);
		color: Color black;
		startPoint: startPoint;
		endPoint: aShape position x @ (totalHeight + startPoint y);
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
	fragments := OrderedCollection new
]

{ #category : #accessing }
SequenceDiagram >> instances [

	^ instances
]

{ #category : #accessing }
SequenceDiagram >> instances: anObject [

	instances := anObject
]

{ #category : #hooks }
SequenceDiagram >> menuIn: aMenuMorph for: aShape [
	(aMenuMorph 
		add: 'Rename instance'
		target: self
		selector: #rename:
		argument: aShape)
		icon: (self iconNamed: #edit)
		
	
]

{ #category : #accessing }
SequenceDiagram >> messages [

	^ messages
]

{ #category : #accessing }
SequenceDiagram >> messages: anObject [

	messages := anObject
]

{ #category : #'menu - operations' }
SequenceDiagram >> rename: aShape [ 
	| name |
	name := UIManager default request: 'New name' initialAnswer: aShape model name.
	name ifNil: [ ^ self ].
	aShape model name: name trimBoth.
	self canvas signalUpdate.
]

{ #category : #hooks }
SequenceDiagram >> renderFragments [
	fragments do: [ :fragment | fragment renderIn: self ]
]

{ #category : #hooks }
SequenceDiagram >> renderIn: aCanvas [
	| columnShapes |
	columnShapes := self createColumns.
	self setInteractionsOn: columnShapes.
	RSHorizontalLineLayout on: columnShapes.
	aCanvas addAll: columnShapes.
	self renderLinesOn: aCanvas.
	self renderFragments
	
]

{ #category : #rendering }
SequenceDiagram >> renderInstanceFragment: aSequenceInstanceFragment [ 
	| groups fragmentShapes height |
	groups := self computeGroupsFor: aSequenceInstanceFragment.
	height := (messages size + 1) * scaleFactor.
	fragmentShapes := groups collect: [ :group | 
		self
			createFragmentGroupFor: group
			name: aSequenceInstanceFragment name
			height: height ].
	container addAll: fragmentShapes.
	fragmentShapes do: #pushBack.
]

{ #category : #hooks }
SequenceDiagram >> renderLinesOn: aCanvas [
	| lifelines callLines callLinesLabels |
	self computeScaleFactor.
	lifelines := self createAllLifelines.
	callLines := self createAllCallLines.
	callLinesLabels := self createCallLineLabels: callLines.
	aCanvas addAll: lifelines.
	aCanvas addAll: callLinesLabels.
	aCanvas addAll: callLines
]

{ #category : #rendering }
SequenceDiagram >> renderMessageFragment: aSequenceMessageFragment [
	
	| fromIndex toIndex lines group fragmentShape |
	fromIndex := messages indexOf: aSequenceMessageFragment from.
	toIndex := messages indexOf: aSequenceMessageFragment to.
	lines := container lines.
	group := (messages copyFrom: fromIndex to: toIndex) 
		collect: [:message | lines shapeFromModel: message ]
		as: RSGroup.
	fragmentShape := self
		createFragmentGroupFor: group
		name: aSequenceMessageFragment name
		height: 0.
	container add: fragmentShape.
	
]

{ #category : #hooks }
SequenceDiagram >> setInteractionsOn: columnShapes [
	columnShapes do: [ :shape |
		shape addInteraction: (RSMenuActivable new
			menuDo: [ :aMenuMorph :aShape | self menuIn: aMenuMorph for: aShape  ]
		) ]
]
