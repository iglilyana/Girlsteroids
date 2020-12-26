"
Asteroidit, jotka liikkuvat pelikentällä. Jos ammus osuu asteroidiin ensimmäisen kerran, pienenee asteroidi. Jos ammus osuu asteroidiin toisen kerran, pienenee asteroidi lisää. Jos ammus osuu asteroidiin kolmannen kerran, tuhoutuu asteroidi.
"
Class {
	#name : #Asteroid,
	#superclass : #BaseMorph,
	#instVars : [
		'rotation',
		'angle',
		'size'
	],
	#category : #'TIEA1130-Girlsteroids'
}

{ #category : #'instance creation' }
Asteroid class >> newAtPosition: position size: size [ 
	"Alustetaan uusi asteroidi."
	
	^self new
		size: size;
		initializeAsteroid;
		center: position;
		yourself.
]

{ #category : #'instance creation' }
Asteroid class >> newRandomAtPosition: position [
	"Luodaan uusi asteroidi tiettyyn kohtaan"
	
	^self new
		initializeAsteroid;
		center: position;
		yourself.
]

{ #category : #accessing }
Asteroid >> checkHit: point [
	"Tarkistaa osuuko piste asteroidiin."
		
	| distance centerPoint firstPoint p1 p2 mayBeHit isHit |
	
	isHit := false.
	
	distance := self center dist: point.
	
	mayBeHit := distance <= (size + 10).
	
	mayBeHit ifFalse: [ ^isHit. ].
	
	centerPoint := self center.
	
	self vertices do: [ :vert |
		"Antaa varoituksen, mutta on ok."
		p2 := p1.
		p1 := vert.
		p2 ifNil: [firstPoint := p1.] ifNotNil: [
			isHit := isHit or: [point insideTriangle: centerPoint with: p1 with: p2]. 
		].
	].
	isHit := isHit or: [point insideTriangle: centerPoint with: p1 with: firstPoint].
	
	^isHit.
]

{ #category : #'event handling' }
Asteroid >> hit [
	"Otetaan vastaan viesti, että asteroidiin on osunut ammus.
	Luodaan kaksi uutta pienempää asteroidia ja poistetaan osuman saanut asteroidi."
	
	| minSize asteroid wholeSize halfSize |

	minSize := 10.
	
	wholeSize := (size) floor.
	halfSize := (size/2) floor.
	(size > minSize) ifTrue: [	
		2 timesRepeat: [ 
			asteroid := self class newAtPosition:
				(self center 
					+((wholeSize atRandom)@(wholeSize atRandom))
					-((halfSize)@(halfSize))) size: halfSize.
			self owner addAsteroid: asteroid.
		].
	].

	owner deleteAsteroid: self.
]

{ #category : #initialization }
Asteroid >> initializeAsteroid [
	"Alustetaan asteroidi ja asetetaan sille suunta ja nopeus."

	| speed direction vertAngle dist verts sizeVariance |

	"Jos ei ole vielä asetettu arvoja, alustetaan ne tässä."
	(size) ifNil: [
		"Alustetaan asteroidille satunnainen koko."
		size := 55 + (20 atRandom).
	].
	
	(vector) ifNil: [
		"Alustetaan asteroidille satunnainen liikkumissuunta."
		direction := 360 atRandom degreesToRadians.
		"Alustetaan asteroidille satunnainen liikkumisnopeus."
		speed := 2 + (5 atRandom).
		vector := (speed * direction sin)@(speed * direction cos).
	].
	
	sizeVariance := (size / 3) ceiling.

	"Alustetaan asteroidin asento sekä satunnainen pyörimissuunta ja -nopeus"
	angle := 0.
	rotation := 10 atRandom -5.
	
   "Tehdään hiukan satunnaisen muotoinen ja kokoinen asteroidi
	asettamalla 10 pistettä vakiokulmiin eri etäisyyksille."
	verts := OrderedCollection new.
	0 to: 9 do: [ :i |
		vertAngle := i * (Float pi) / 5.
		dist := size - (((sizeVariance * 10) atRandom) / 10).
		verts add: (dist * vertAngle cos)@(dist * vertAngle sin).
		].

	self
		vertices: verts
		color: Color green muchLighter
		borderWidth: 2
		borderColor: Color green lighter.
	self beStraightSegments.
	self start.
]

{ #category : #stepping }
Asteroid >> onStep [
	"Asteroidin pyöriminen."

	angle := angle + rotation.
	self rotationDegrees: angle.
]

{ #category : #accessing }
Asteroid >> size [
	"Palauttaa asteroidin koon."
	
	^self size.
]

{ #category : #accessing }
Asteroid >> size: newSize [
	"Asettaa asteroidille koon."
			
	size := newSize.
]
