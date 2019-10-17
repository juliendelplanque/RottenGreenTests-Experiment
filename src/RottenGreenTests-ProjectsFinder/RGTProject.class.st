Class {
	#name : #RGTProject,
	#superclass : #Object,
	#instVars : [
		'username',
		'projectName',
		'baselinePath'
	],
	#category : #'RottenGreenTests-ProjectsFinder'
}

{ #category : #accessing }
RGTProject class >> blacklist [
	^ #('pharo-project/pharo' 'moosetechnology/Moose' 'jecisc/Bazard' 'exercism/pharo-smalltalk')
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
	] on: NotFound, ZnHttpUnsuccessful do: [
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
		headerAt: 'Authorization' put: 'token f9cbf45df00a664110593555d8d6d1d72f8e425f';
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
