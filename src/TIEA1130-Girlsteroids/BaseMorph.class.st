"
Perusmorph, jolta asteroidit, ammukset ja alus voi periä metodeita.
"
Class {
	#name : #BaseMorph,
	#superclass : #PolygonMorph,
	#instVars : [
		'vector'
	],
	#category : #'TIEA1130-Girlsteroids'
}

{ #category : #'instance creation' }
BaseMorph class >> newAtPosition: position size: size [ 
	"Alustetaan uusi asteroidi."
	
	^self new
		size: size;
		initializeAsteroid;
		center: position;
		yourself.
]

{ #category : #'instance creation' }
BaseMorph class >> newAtPosition: position size: size speed: speed direction: direction [ 
	"Luodaan ja alustetaan uusi asteroidi."
	
	^self new
		center: position;
		size: size;
		speed: speed;
		direction: direction;
		initializeAsteroid;
		yourself.
]

{ #category : #'instance creation' }
BaseMorph class >> newRandomAtPosition: position [
	"Luodaan uusi asteroidi tiettyyn kohtaan....???"
	"???? Create new asteroid with defined position, but otherwise random values"
	
	^self new
		center: position;
		initializeAsteroid;
		yourself.
]

{ #category : #initialization }
BaseMorph >> initialize [
	
	super initialize.
]

{ #category : #stepping }
BaseMorph >> onStep [

	^self.
]

{ #category : #stepping }
BaseMorph >> step [
	"Aika kuluu, liikutaan"
	
	self onStep.
	
	self position: self position + vector.

	self wrapAroundOwner.
]

{ #category : #stepping }
BaseMorph >> stepTime [
	"Sulavammat liikkeet."

	^33.3.
]

{ #category : #stepping }
BaseMorph >> wrapAroundOwner [

	(self owner) ifNil: [ ^self. ].
	
	"Tarkistaa sijainnin ja siirtää tarvittaessa vastakkaiseen laitaan aluetta"	
	self center y < self owner top
		ifTrue: [ self center: (self center x)@(self owner bottom) ].
	self center y > self owner bottom
		ifTrue: [ self center: (self center x)@(self owner top) ].
	self center x < self owner left
		ifTrue: [ self center: (self owner right)@(self center y) ].
	self center x > self owner right
		ifTrue: [ self center: (self owner left)@(self center y) ].
]
