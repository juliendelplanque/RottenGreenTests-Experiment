Class {
	#name : #RGTProject,
	#superclass : #Object,
	#instVars : [
		'username',
		'projectName',
		'baselinePath',
		'token'
	],
	#classInstVars : [
		'token'
	],
	#category : #'RottenGreenTests-ProjectsFinder'
}

{ #category : #accessing }
RGTProject class >> blacklist [
	^ #('pharo-project/pharo' 'moosetechnology/Moose' 'jecisc/Bazard' 'exercism/pharo-smalltalk')
]

{ #category : #accessing }
RGTProject class >> token [
	^ token
]

{ #category : #accessing }
RGTProject class >> token: anObject [
	token := anObject
]

{ #category : #'instance creation' }
RGTProject class >> username: username projectName: projectName [
	^ self new
		username: username;
		projectName: projectName;
		yourself
]

{ #category : #accessing }
RGTProject >> baseRepoAPIUrl [
	^ 'https://api.github.com/repos' asZnUrl / self username / self projectName
]

{ #category : #private }
RGTProject >> baselineDetectionForDirectory: subDirectory ifFound: ifFoundBlock [
	[ | json |
		json := STONJSON fromString: (self getContents: (self baseRepoAPIUrl / 'contents' / subDirectory)).
		^ ifFoundBlock value: (Path * subDirectory / ((self findBaselineIn: json) at: #name))
	] on: NotFound, ZnHttpUnsuccessful do: [ :error |
		Transcript show: error asString; cr.
		^ nil ]
]

{ #category : #accessing }
RGTProject >> baselinePath [
	^ baselinePath
]

{ #category : #accessing }
RGTProject >> baselinePath: anObject [
	baselinePath := anObject
]

{ #category : #private }
RGTProject >> findBaselineIn: arrayOfDictionary [
	^ [ arrayOfDictionary detect: [ :dict |
		(dict at: 'name') beginsWith: 'BaselineOf' ] ] on: Error do: [ NotFound signal ]
]

{ #category : #'as yet unclassified' }
RGTProject >> getContents: aZnUrl [
	^ ZnClient new
		headerAt: 'Authorization' put: 'token ' , self token;
		url: aZnUrl;
		get
]

{ #category : #'as yet unclassified' }
RGTProject >> githubUrl [
	^ 'https://github.com' asZnUrl / self username / self projectName
]

{ #category : #testing }
RGTProject >> hasBaselinePath [
	^ self baselinePath isNotNil
]

{ #category : #testing }
RGTProject >> hasTravisConfig [
	^ (STONJSON fromString: (self getContents: (self baseRepoAPIUrl / 'contents' / '.travis.yml')))
			at: 'name' ifPresent: [ true ] ifAbsent: [ false ]
]

{ #category : #'as yet unclassified' }
RGTProject >> openInWebBrowser [
	^ WebBrowser openOn: self githubUrl asString
]

{ #category : #printing }
RGTProject >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self username;
		nextPut: $/;
		nextPutAll: self projectName;
		nextPut: $)
]

{ #category : #accessing }
RGTProject >> projectName [
	^ projectName
]

{ #category : #accessing }
RGTProject >> projectName: anObject [
	projectName := anObject
]

{ #category : #accessing }
RGTProject >> token [
	^ token ifNil: [ token := self class token ]
]

{ #category : #accessing }
RGTProject >> token: anObject [
	token := anObject
]

{ #category : #accessing }
RGTProject >> tryToRetrieveBaselinePath [
	#('' 'repository' 'src' 'source' 'Pharo' 'mc' 'pharo-repository' 'tonel')
		do: [ :subDirectory | 
			self
				baselineDetectionForDirectory: subDirectory
				ifFound: [ :path | 
					self baselinePath: path.
					^ self baselinePath ] ].
	self baselinePath: nil.
	^ self baselinePath
]

{ #category : #accessing }
RGTProject >> username [
	^ username
]

{ #category : #accessing }
RGTProject >> username: anObject [
	username := anObject
]
