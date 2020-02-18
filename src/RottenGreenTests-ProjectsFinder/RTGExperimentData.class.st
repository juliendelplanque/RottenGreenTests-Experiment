Class {
	#name : #RTGExperimentData,
	#superclass : #Object,
	#instVars : [
		'name',
		'tests',
		'helpers',
		'helperCalls',
		'projectData'
	],
	#category : #'RottenGreenTests-ProjectsFinder'
}

{ #category : #accessing }
RTGExperimentData class >> headerArrayForCSVExport [
	^ #(
	'Project'
	'Description'
	'Number of packages'
	'Number of classes'
	'Number of test classes'
	'Minimum class depth'
	'Median class depth'
	'Maximum class depth'
	'Number of tests'
	'Number of helpers'
	'Minimum max helper depth'
	'Median max helper depth'
	'Maximum max helper depth'
	'Minimum primitive calls in test count'
	'Median primitive calls in test count'
	'Maximum primitive calls in test count'
	'Minimum helper calls in test count'
	'Median helper calls in test count'
	'Maximum helper calls in test count'
	'Minimum helper call/definition delta'
	'Median helper call/definition delta'
	'Maximum helper call/definition delta'
	'Insidious cat. 1'
	'Insidious cat. 2'
	'Insidious cat. 3'
	'Insidious cat. 4'
	)
]

{ #category : #computed }
RTGExperimentData >> allRottenTests [
	^ self tests select: [ :array | array at: 11 ]
]

{ #category : #converting }
RTGExperimentData >> asArrayForCSVExport [
	^ { 
		self name.
		self projectDescription.
		self packagesCount.
		self classesCount.
		self testClassesCount.
		self minimumOfClassDepth.
		self medianOfClassDepth.
		self maximumOfClassDepth.
		self testsCount.
		self helpersCount.
		self minimumOfMaxHelperDepths.
		self medianOfMaxHelperDepths.
		self maximumOfMaxHelperDepths.
		self minimumOfPrimitiveCallsInTestCounts.
		self medianOfPrimitiveCallsInTestCounts.
		self maximumOfPrimitiveCallsInTestCounts.
		self minimumOfHelperCallsInTestCounts.
		self medianOfHelperCallsInTestCounts.
		self maximumOfHelperCallsInTestCounts.
		self minimumOfHelperCallDefinitionDelta.
		self medianOfHelperCallDefinitionDelta.
		self maximumOfHelperCallDefinitionDelta.
		self rottenTestsCategory1Count.
		self rottenTestsCategory2Count.
		self rottenTestsCategory3Count.
		self rottenTestsCategory4Count
	 }
]

{ #category : #'computed-metrics' }
RTGExperimentData >> classesCount [
	^ self projectData at: 3
]

{ #category : #computed }
RTGExperimentData >> helperCallDefinitionDelta [
	"Return the list of call/definition deltas.
	 This is an integer representing the number of class separating the class calling the method and the class where the helper is defined.
	 For example, if this number is 0, the helper is defined in the same class as the caller.
	 If the number is 2, the helper is defined 2 classes above in the inheritance hierarchy."
	^ self helperCalls collect: [ :array | array second abs ]
]

{ #category : #accessing }
RTGExperimentData >> helperCalls [
	^ helperCalls
]

{ #category : #accessing }
RTGExperimentData >> helperCalls: anObject [
	helperCalls := anObject
]

{ #category : #computed }
RTGExperimentData >> helperCallsInTestCounts [
	^ self tests collect: #seventh
]

{ #category : #accessing }
RTGExperimentData >> helpers [
	^ helpers
]

{ #category : #accessing }
RTGExperimentData >> helpers: anObject [
	helpers := anObject
]

{ #category : #'computed-metrics' }
RTGExperimentData >> helpersCount [
	^ self helpers size
]

{ #category : #computed }
RTGExperimentData >> maxHelperDepths [
	^ self tests collect: #third
]

{ #category : #'computed-metrics' }
RTGExperimentData >> maximumOfClassDepth [
	^ ((self testClassesDepth collect: #second) ifEmpty: [ #(-1) ]) max
]

{ #category : #'computed-metrics' }
RTGExperimentData >> maximumOfHelperCallDefinitionDelta [
	^ self helperCallDefinitionDelta ifEmpty: [ nil ] ifNotEmpty: #max
]

{ #category : #'computed-metrics' }
RTGExperimentData >> maximumOfHelperCallsInTestCounts [
	^ (self helperCallsInTestCounts ifEmpty: [ #(-1) ]) max
]

{ #category : #'computed-metrics' }
RTGExperimentData >> maximumOfMaxHelperDepths [
	"Return the maximum value for the 'max helper depth' metric."
	^ (self maxHelperDepths ifEmpty: [ #(-1) ]) max
]

{ #category : #'computed-metrics' }
RTGExperimentData >> maximumOfPrimitiveCallsInTestCounts [
	^ (self primitiveCallsInTestCounts ifEmpty: [ #(-1) ]) max
]

{ #category : #'computed-metrics' }
RTGExperimentData >> medianOfClassDepth [
	^ ((self testClassesDepth collect: #second) ifEmpty: [ #(-1) ]) median
]

{ #category : #'computed-metrics' }
RTGExperimentData >> medianOfHelperCallDefinitionDelta [
	^ self helperCallDefinitionDelta ifEmpty: [ nil ] ifNotEmpty: #median
]

{ #category : #'computed-metrics' }
RTGExperimentData >> medianOfHelperCallsInTestCounts [
	^ (self helperCallsInTestCounts ifEmpty: [ #(-1) ]) median
]

{ #category : #'computed-metrics' }
RTGExperimentData >> medianOfMaxHelperDepths [
	"Return the maximum value for the 'max helper depth' metric."
	^ (self maxHelperDepths ifEmpty: [ #(-1) ]) median
]

{ #category : #'computed-metrics' }
RTGExperimentData >> medianOfPrimitiveCallsInTestCounts [
	^ (self primitiveCallsInTestCounts ifEmpty: [ #(-1) ]) median
]

{ #category : #'computed-metrics' }
RTGExperimentData >> minimumOfClassDepth [
	^ ((self testClassesDepth collect: #second) ifEmpty: [ #(-1) ]) min
]

{ #category : #'computed-metrics' }
RTGExperimentData >> minimumOfHelperCallDefinitionDelta [
	^ self helperCallDefinitionDelta ifEmpty: [ nil ] ifNotEmpty: #min
]

{ #category : #'computed-metrics' }
RTGExperimentData >> minimumOfHelperCallsInTestCounts [
	^ (self helperCallsInTestCounts ifEmpty: [ #(-1) ]) min
]

{ #category : #'computed-metrics' }
RTGExperimentData >> minimumOfMaxHelperDepths [
	"Return the minimum value for the 'max helper depth' metric."
	^ (self maxHelperDepths ifEmpty: [ #(-1) ]) min
]

{ #category : #'computed-metrics' }
RTGExperimentData >> minimumOfPrimitiveCallsInTestCounts [
	^ (self primitiveCallsInTestCounts ifEmpty: [ #(-1) ]) min
]

{ #category : #accessing }
RTGExperimentData >> name [
	^ name
]

{ #category : #accessing }
RTGExperimentData >> name: anObject [
	name := anObject
]

{ #category : #'computed-metrics' }
RTGExperimentData >> packagesCount [
	^ self projectData at: 2
]

{ #category : #parsing }
RTGExperimentData >> parseHelperCallsDataIn: aFileReference [
	aFileReference
		readStreamDo: [ :s | 
			self
				helperCalls:
					((NeoCSVReader on: s)
						skipHeader;
						addField;
						addIntegerField;
						addField;
						upToEnd) ]
]

{ #category : #parsing }
RTGExperimentData >> parseHelpersDataIn: aFileReference [
	aFileReference
		readStreamDo: [ :s | 
			self
				helpers:
					((NeoCSVReader on: s)
						skipHeader;
						addField;
						addField;
						addIntegerField;
						addIntegerField;
						addIntegerField;
						addIntegerField;
						addIntegerField;
						addIntegerField;
						addFieldConverter: [ :str | str = 'true' ];
						addIntegerField;
						addFieldConverter: [ :str | str = 'true' ];
						addIntegerField;
						upToEnd) ]
]

{ #category : #parsing }
RTGExperimentData >> parseProjectIn: aFileReference [
	aFileReference
		readStreamDo: [ :s | 
			self
				projectData:
					(((NeoCSVReader on: s)
						separator: $,;
						skipHeader;
						addField;
						addIntegerField;
						addIntegerField;
						addIntegerField;
						upToEnd) detect: [ :array | array first = self name ]) ]
]

{ #category : #parsing }
RTGExperimentData >> parseTestsDataIn: aFileReference [
	aFileReference
		readStreamDo: [ :s | 
			self
				tests:
					((NeoCSVReader on: s)
						skipHeader;
						addField;
						addField;
						addIntegerField;
						addIntegerField;
						addIntegerField;
						addIntegerField;
						addIntegerField;
						addIntegerField;
						addFieldConverter: [ :str | str = 'true' ];
						addIntegerField;
						addFieldConverter: [ :str | str = 'true' ];
						addIntegerField;
						upToEnd) ]
]

{ #category : #computed }
RTGExperimentData >> primitiveCallsInTestCounts [
	^ self tests collect: #fourth
]

{ #category : #accessing }
RTGExperimentData >> projectData [
	^ projectData
]

{ #category : #accessing }
RTGExperimentData >> projectData: anObject [
	projectData := anObject
]

{ #category : #computed }
RTGExperimentData >> projectDescription [
	self flag: #TODO. "Not stored in meta-data file for now."
	^ nil
]

{ #category : #computed }
RTGExperimentData >> rottenTestsCategory1 [
	"tests containing not executed primitive assertions is characterised by the fact that the developer passed false to the assert primitive."
	^ self allRottenTests select: [ :array | array sixth > 0 ]
]

{ #category : #'computed-metrics' }
RTGExperimentData >> rottenTestsCategory1Count [
	^ self rottenTestsCategory1 size
]

{ #category : #computed }
RTGExperimentData >> rottenTestsCategory2 [
	"Often a test method contains a guard. Depending on the condition of the guard the test method stops its execution early on."
	^ self allRottenTests select: [ :array | array ninth ]
]

{ #category : #'computed-metrics' }
RTGExperimentData >> rottenTestsCategory2Count [
	^ self rottenTestsCategory2 size
]

{ #category : #computed }
RTGExperimentData >> rottenTestsCategory3 [
	"Context dependent assertion"
	^ self allRottenTests select: [ :array | (array at: 10) > 0 ]
]

{ #category : #'computed-metrics' }
RTGExperimentData >> rottenTestsCategory3Count [
	^ self rottenTestsCategory3 size
]

{ #category : #computed }
RTGExperimentData >> rottenTestsCategory4 [
	"Fully rotten tests, rotten tests that are not part of category 1, 2 or 3."
	| cat1 cat2 cat3 |
	cat1 := self rottenTestsCategory1.
	cat2 := self rottenTestsCategory2.
	cat3 := self rottenTestsCategory3.
	^ self allRottenTests reject: [ :array |
		(cat1 includes: array) or: [ (cat2 includes: array) or: [ cat3 includes: array ] ] ]
]

{ #category : #'computed-metrics' }
RTGExperimentData >> rottenTestsCategory4Count [
	"Fully rotten tests, rotten tests that are not part of category 1, 2 or 3."
	^ self rottenTestsCategory4 size
]

{ #category : #'computed-metrics' }
RTGExperimentData >> testClassesCount [
	^ self projectData at: 4
]

{ #category : #computed }
RTGExperimentData >> testClassesDepth [
	^ (self tests collect: [ :array |
		{ (array second splitOn: '>>') first . array at: 12 } ]) asSet asArray
]

{ #category : #computed }
RTGExperimentData >> testPackages [
	^ (self tests collect: #first) asSet
]

{ #category : #'computed-metrics' }
RTGExperimentData >> testPackagesCount [
	^ self testPackages size
]

{ #category : #accessing }
RTGExperimentData >> tests [
	^ tests
]

{ #category : #accessing }
RTGExperimentData >> tests: anObject [
	tests := anObject
]

{ #category : #'computed-metrics' }
RTGExperimentData >> testsCount [
	^ self tests size
]
