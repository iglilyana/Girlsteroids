"
Aluksen ampumat ammukset, joiden voimalla alus liikkuu. Ammuksien on tarkoitus tuhota asteroidit.
"
Class {
	#name : #Exhaust,
	#superclass : #BaseMorph,
	#instVars : [
		'lifeTime'
	],
	#category : #'TIEA1130-Girlsteroids'
}

{ #category : #initialization }
Exhaust >> initialize [ 
	"Alustetaan ammus."
	
	super initialize.
	
	vector := 0@0.
	"30 ruutua pitäisi olla noin sekunti elinaikaa, mutta jostain syystä on tuplat, joten..."
	lifeTime := 15.
	self
		"Sydän. :)"
		vertices: { 0@(-2) . 3@(-4) . 5@0 . 0@4 . -5@0 . -3@(-4) }
		color: Color yellow
		borderWidth: 2
		borderColor: Color pink.
	self beStraightSegments.
	self rotationCenter: 0.5@0.5.

	self start.
]

{ #category : #stepping }
Exhaust >> onStep [
	"Ammuksen elinajan kuluminen."
	
	lifeTime := lifeTime - 1.
	lifeTime = 0
		ifFalse: [ ^ self ].
	owner deleteExhaust: self.
]

{ #category : #accessing }
Exhaust >> vector: newVector [
	"Asetetaan vektori (suunta ja nopeus)."

	vector := newVector.
]
