"
Alus, joka lentää kentällä. Alus ampuu ammuksia ja liikkuu niiden voimalla. Alus ampuu asteroideja yrittäen tuhota niitä. Jos alus osuu asteroidiin, alus pysähtyy ja menettää elämän.
"
Class {
	#name : #Ship,
	#superclass : #BaseMorph,
	#instVars : [
		'heading',
		'isTurningRight',
		'isTurningLeft',
		'isAccelerating',
		'hitpoints'
	],
	#category : #'TIEA1130-Girlsteroids'
}

{ #category : #stepping }
Ship >> fireThruster [
	"Hoitaa ampumisen."
	
	| vectorXchange vectorYchange acceleration exhaust exhaustVelocity |
	
	"Määritellään, kuinka nopeasti kiihdytetään."
	acceleration := 2.
	exhaustVelocity := acceleration * 3.5.
	
	vectorXchange := acceleration * heading sin.
	vectorYchange := (0-acceleration) * heading cos.
	vector := vector + ((vectorXchange)@(vectorYchange)).
	
	"Luodaan pakokaasuammus ja annetaan se avaruudelle."
	exhaust := Exhaust new.
	exhaust center: self center + ((-10 * heading sin)@(10 * heading cos)).
	exhaust vector: vector + (((0-exhaustVelocity) * heading sin)@(exhaustVelocity * heading cos)).

	self owner addExhaust: exhaust.
]

{ #category : #'event handling' }
Ship >> handlesKeyDown: evt [ 
	"Ottaa painallukset käsittelyyn."
	
	^ true.
]

{ #category : #'event handling' }
Ship >> handlesKeyUp: evt [ 
	"Ottaa painalluksen vapautukset käsittelyyn."
	
	^ true.
]

{ #category : #'event handling' }
Ship >> hit [
	"Alus osui asteroidiin. Vähennetään hitpointseja yhdellä aina aluksen osuessa asteroidiin.
	Muutetaan samalla väriä vaaleammaksi. Kun pisteitä on 0, poistetaan ohjausmahdollisuus ja
	hajotetaan alus pieniksi asteroideiksi."
	
	| asteroid |
	
	vector := 0@0.
	hitpoints := hitpoints - 1.
	color := color lighter.
	(hitpoints = 0) ifFalse: [ ^self. ].
	
	self primaryHand releaseKeyboardFocus.
	6 timesRepeat: [ 
		asteroid := Asteroid newAtPosition:
			(self center 
				+((30 atRandom)@(30 atRandom))
				-((15)@(15))) size: 10.
		self owner addAsteroid: asteroid.
	].
	self owner shipDied.
	self delete.
]

{ #category : #initialization }
Ship >> initialize [
	"Alustetaan alus."

	super initialize.

	isAccelerating := false.
	isTurningLeft := false.
	isTurningRight := false.
	heading := 0.
	vector := 0@0.
	hitpoints := 3.
	self
		"Sydän."
		vertices: { -5@24 . -12@26 . -18@20 . -16@10 . -9@0 . 0@(-20) . 9@0 . 16@10 . 18@20 . 12@26 . 5@24 . 0@15 }
		"Enemmän normaali alus."
		"vertices: { -8@26 . -18@20 . -10@0 . 0@(-20) . 10@0 . 18@20 . 8@26 . 0@15 }"
		color: Color purple muchLighter
		borderWidth: 2
		borderColor: Color purple lighter.
	self beStraightSegments.
	self rotationCenter: 0.5@0.5.
	self takeKeyboardFocus.
	self start.
]

{ #category : #'event handling' }
Ship >> keyDown: anEvent [
	"Kerrotaan, mitä tapahtuu näppäimen painamisesta."

	| keyValue |

	keyValue := anEvent keyValue. 
	keyValue = 30 "up arrow"
		ifTrue: [isAccelerating := true].
	keyValue = 29 "right arrow" 
		ifTrue: [isTurningRight := true]. 
	keyValue = 28 "left arrow" 
		ifTrue: [isTurningLeft := true]
]

{ #category : #'event handling' }
Ship >> keyUp: anEvent [
	"Kerrotaan, mitä tapahtuu näppäimen vapauttamisesta."
	
	| keyValue |

	keyValue := anEvent keyValue.
	keyValue = 30 "up arrow"
		ifTrue: [isAccelerating := false].
	keyValue = 29 "right arrow"
		ifTrue: [isTurningRight := false].
	keyValue = 28 "left arrow"
		ifTrue: [isTurningLeft := false]
]

{ #category : #stepping }
Ship >> onStep [
	"Aluksen ohjaus."

	isTurningLeft ifTrue: [ heading := heading - (Float pi / 18)].
	isTurningRight ifTrue: [ heading := heading + (Float pi / 18)].

	self rotationDegrees: heading radiansToDegrees.

	isAccelerating ifTrue: [ self fireThruster].
   "Alus hidastuu ajan mittaan."
	vector := vector * 0.975.
]
