"
Pelikenttä, jossa yksi alus liikkuu ammusten voimalla yrittäen tuhota asteroideja.

Peli saadaan käyntiin Playgroundissa: ""Space new.""
"
Class {
	#name : #Space,
	#superclass : #Morph,
	#instVars : [
		'asteroids',
		'exhausts',
		'ship'
	],
	#category : #'TIEA1130-Girlsteroids'
}

{ #category : #adding }
Space >> addAsteroid: asteroid [
	"Lisätään asteroidi listaan."
	
	asteroids add: asteroid.
	self addMorph: asteroid.
]

{ #category : #adding }
Space >> addExhaust: exhaust [
	"Lisätään ammus listaan."
	
	exhausts add: exhaust.
	self addMorphBack: exhaust.
]

{ #category : #adding }
Space >> deleteAsteroid: asteroid [
	"Postetaan asteroidi listalta."
	
	(asteroid) ifNil: [ ^self ].
	asteroids remove: asteroid ifAbsent: [].
	asteroid delete.
	
	(asteroids isEmpty) ifTrue: [ self shipWon. ]
]

{ #category : #adding }
Space >> deleteExhaust: exhaust [
	"Poistetaan ammus listalta."
	
	(exhaust) ifNil: [ ^self ].
	exhausts remove: exhaust ifAbsent: [].
	exhaust delete.
]

{ #category : #initialization }
Space >> initialize [ 
	"Alustetaan pelikenttä."

	| location |

	super initialize.

	"Luodaan ensin tausta."
	self color: Color yellow muchLighter.
	self extent: 600@600.
	self clipSubmorphs: true.
	self openInWorld.

	"Luodaan asteroideja varten linkitetty lista."
	asteroids := LinkedList new.
	exhausts := OrderedCollection new.
	
	"Luodaan kentälle kaksi asteroidia ylälaitaan."
	2 timesRepeat: 	
	[location := (500 atRandom)@(250 atRandom).
	self addAsteroid: (Asteroid newRandomAtPosition: location)].
	
	"Luodaan kentälle alus."
	ship := Ship new.
	ship center: 300@300.
	self addMorphFront: ship.
]

{ #category : #'event handling' }
Space >> shipDied [
	"Jos alus saa liikaa osumia asteroideista, loppuu peli ja näytetään viesti."
	
	self showMessage: 'Game Over'.
]

{ #category : #'event handling' }
Space >> shipWon [
	"Kun kaikki asteroidit on tuhottu, on peli voitettu, jolloin siitä näytetään viesti."
	
	self showMessage: 'You Won!'.
			

]

{ #category : #'event handling' }
Space >> showMessage: message [
	"Näytä haluttu viesti ruudulla."

	| messageMorph text font |
	
	font := (TextFontReference toFont: (LogicalFont familyName: 'Source Sans Pro' pointSize: 60)).
	text := message asText addAttribute: font.
	messageMorph := TextMorph new.
	messageMorph color: Color gray.
	messageMorph contents: text.
	messageMorph center: self center.
	self addMorphFront: messageMorph.
]

{ #category : #stepping }
Space >> step [
	"Osumatarkistukset ajan kuluessa."

	| isHit |
	
	exhausts do:
		[ :exhaust | exhaust ifNotNil: [
			asteroids do:
				[ :asteroid |
					isHit := false.
					exhaust vertices do: [ :vert | isHit := isHit or: [asteroid checkHit: vert]].
					isHit ifTrue: [
						asteroid hit.
						self deleteExhaust: exhaust.
					].
				]
			]
		].
	
	isHit := false.
	ship vertices do: [ :shipPoint | asteroids do: [ :asteroid |
			isHit := isHit or: (asteroid checkHit: shipPoint)] ].
	isHit ifTrue: [ ship hit. ].
]

{ #category : #stepping }
Space >> stepTime [
	"Sulavammat liikkeet."
	
	^33.3.
]
