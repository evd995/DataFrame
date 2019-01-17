"
I am  the internal representation of a DataFrame. I store the data very efficiently and allow you to access it very quickly. 
"
Class {
	#name : #DataFrameInternal,
	#superclass : #Collection,
	#instVars : [
		'contents'
	],
	#category : #'DataFrame-Core'
}

{ #category : #'instance creation' }
DataFrameInternal class >> fromColumns: anArrayOfArrays [
	
	| numberOfRows numberOfColumns dfInternal |
	
	numberOfRows := anArrayOfArrays first size.
	numberOfColumns := anArrayOfArrays size.
	dfInternal := self new: (numberOfRows @ numberOfColumns ).
	
	1 to: numberOfRows do: [ :i |
		1 to: numberOfColumns do: [ :j |
			dfInternal at: i at: j put:
				((anArrayOfArrays at: j) at: i) ] ].
		
	^ dfInternal
]

{ #category : #'instance creation' }
DataFrameInternal class >> fromMatrix: aMatrix [

	| dfInternal |
	
	"We can't use Matrix>>extent, because it gives us col@row instead of row@col"
	dfInternal := self new:
		(aMatrix rowCount @ aMatrix columnCount).
	
	aMatrix withIndicesDo: [ :each :i :j |
		dfInternal at: i at: j put: each ].
	
	^ dfInternal
]

{ #category : #'instance creation' }
DataFrameInternal class >> fromRows: anArrayOfArrays [

	| numberOfRows numberOfColumns dfInternal |
	
	numberOfRows := anArrayOfArrays size.
	numberOfColumns := anArrayOfArrays first size.
	dfInternal := self new: (numberOfRows @ numberOfColumns ).
	
	1 to: numberOfRows do: [ :i |
		1 to: numberOfColumns do: [ :j |
			dfInternal at: i at: j put:
				((anArrayOfArrays at: i) at: j) ] ].
		
	^ dfInternal
]

{ #category : #'instance creation' }
DataFrameInternal class >> new: aPoint [

	^ self new initialize: aPoint
]

{ #category : #comparing }
DataFrameInternal >> = other [

	((other class == self class)
		and: [ other numberOfRows = self numberOfRows 
		and: [ other numberOfColumns = self numberOfColumns]])
		ifFalse: [ ^ false ].
		
	other withIndicesDo: [ :each :i :j |
		(self at: i at: j) = each
			ifFalse: [ ^ false ] ].
		
	^ true.

	
	
]

{ #category : #adding }
DataFrameInternal >> addColumn: anArray [

	| newContents |
	
	anArray size = self numberOfRows
		ifFalse: [ SizeMismatch signal ].
	
	newContents := Matrix
		rows: (self numberOfRows)
		columns: (self numberOfColumns + 1).
	
	1 to: self numberOfRows do: [ :i |
		1 to: self numberOfColumns do: [ :j |
			newContents at: i at: j put:
				(self at: i at: j) ] ].
	
	1 to: self numberOfRows do: [ :i |
		newContents at: i at: (self numberOfColumns + 1)
			put: (anArray at: i) ].
	
	contents := newContents.
]

{ #category : #adding }
DataFrameInternal >> addRow: anArray [

	| newContents |
	
	anArray size = self numberOfColumns
		ifFalse: [ SizeMismatch signal ].
	
	newContents := Matrix
		rows: (self numberOfRows + 1)
		columns: (self numberOfColumns).
	
	1 to: self numberOfRows do: [ :i |
		1 to: self numberOfColumns do: [ :j |
			newContents at: i at: j put:
				(self at: i at: j) ] ].
	
	1 to: self numberOfColumns do: [ :j |
		newContents at: (self numberOfRows + 1) at: j
			put: (anArray at: j) ].
	
	contents := newContents.
]

{ #category : #converting }
DataFrameInternal >> asArrayOfColumns [
	"Converts DataFrameInternal to the array of columns"

	^ (1 to: self numberOfColumns) collect: [ :j |
		(1 to: self numberOfRows) collect: [ :i |
			self at: i at: j ] ].
]

{ #category : #converting }
DataFrameInternal >> asArrayOfRows [
	"Converts DataFrameInternal to the array of rows"

	^ (1 to: self numberOfRows) collect: [ :i |
		(1 to: self numberOfColumns) collect: [ :j |
			self at: i at: j ] ].
]

{ #category : #converting }
DataFrameInternal >> asMatrix [
	^ contents
]

{ #category : #accessing }
DataFrameInternal >> at: rowIndex at: columnIndex [

	^ contents at: rowIndex at: columnIndex.
]

{ #category : #accessing }
DataFrameInternal >> at: rowIndex at: columnIndex put: value [

	^ contents at: rowIndex at: columnIndex put: value.
]

{ #category : #enumerating }
DataFrameInternal >> collect: aBlock [

	^ self class fromMatrix:
		(contents collect: aBlock).
]

{ #category : #accessing }
DataFrameInternal >> columnAt: aNumber [

	^ (1 to: self numberOfRows) collect: [ :i |
		self at: i at: aNumber ].
]

{ #category : #accessing }
DataFrameInternal >> columnAt: aNumber put: anArray [
"Sets all the values of a given column equal to the values in array. It is assumed that array is of the same size as every column (number of rows). This should be tested in DataFrame"

	(1 to: self numberOfRows) do: [ :i |
		self at: i at: aNumber put: (anArray at: i) ].
]

{ #category : #accessing }
DataFrameInternal >> columnsAt: anArrayOfNumbers [

	| dfInternal numberOfRows numberOfColumns |
	
	numberOfRows := self numberOfRows.
	numberOfColumns := anArrayOfNumbers size.
	dfInternal := DataFrameInternal new: (numberOfRows @ numberOfColumns).
	
	1 to: numberOfRows do: [ :i |
		anArrayOfNumbers doWithIndex: [ :j :k |
			dfInternal at: i at: k put: (self at: i at: j) ] ].
	
	^ dfInternal.
]

{ #category : #copying }
DataFrameInternal >> deepCopy [

	^ self class fromMatrix: contents.
]

{ #category : #enumerating }
DataFrameInternal >> do: aBlock [

	^ contents do: aBlock.
]

{ #category : #initialization }
DataFrameInternal >> initialize [
	
	super initialize.
	contents := Matrix new.
	^ self.
]

{ #category : #initialization }
DataFrameInternal >> initialize: aPoint [
	
	contents := Matrix
		rows: aPoint x
		columns: aPoint y.
		
	^ self.
]

{ #category : #accessing }
DataFrameInternal >> numberOfColumns [

	contents numberOfColumns isNil
		ifTrue: [ ^ 0 ].
		
	^ contents numberOfColumns.
]

{ #category : #accessing }
DataFrameInternal >> numberOfRows [

	contents numberOfRows isNil
		ifTrue: [ ^ 0 ].
		
	^ contents numberOfRows.
]

{ #category : #printing }
DataFrameInternal >> printOn: aStream [

	contents printOn: aStream.
]

{ #category : #removing }
DataFrameInternal >> removeColumnAt: columnNumber [

	| newContents |
	newContents := Matrix
		rows: (self numberOfRows)
		columns: (self numberOfColumns - 1).
		
	1 to: self numberOfRows do: [ :i |
		1 to: columnNumber - 1 do: [ :j |
			newContents at: i at: j put:
				(contents at: i at: j) ].
			
		columnNumber + 1 to: self numberOfColumns do: [ :j |
			newContents at: i at: j - 1 put:
				(contents at: i at: j) ] ].
		
	contents := newContents.
]

{ #category : #removing }
DataFrameInternal >> removeRowAt: rowNumber [

	| newContents |
	newContents := Matrix
		rows: (self numberOfRows - 1)
		columns: (self numberOfColumns).
		
	1 to: self numberOfColumns do: [ :j |
		1 to: rowNumber - 1 do: [ :i |
			newContents at: i at: j put:
				(contents at: i at: j) ].
			
		rowNumber + 1 to: self numberOfRows do: [ :i |
			newContents at: i - 1 at: j put:
				(contents at: i at: j) ] ].
		
	contents := newContents.
]

{ #category : #accessing }
DataFrameInternal >> rowAt: aNumber [

	^ (1 to: self numberOfColumns) collect: [ :j |
		self at: aNumber at: j ].
]

{ #category : #accessing }
DataFrameInternal >> rowAt: aNumber put: anArray [
"Sets all the values of a given row equal to the values in array. It is assumed that array is of the same size as every row (number of columns). This should be tested in DataFrame"

	(1 to: self numberOfColumns) do: [ :j |
		self at: aNumber at: j put: (anArray at: j) ].
]

{ #category : #accessing }
DataFrameInternal >> rowsAt: anArrayOfNumbers [

	| dfInternal numberOfRows numberOfColumns |
	
	numberOfRows := anArrayOfNumbers size.
	numberOfColumns := self numberOfColumns.
	dfInternal := DataFrameInternal new: (numberOfRows @ numberOfColumns).
	
	anArrayOfNumbers doWithIndex: [ :i :k |
		1 to: numberOfColumns do: [ :j |
			dfInternal at: k at: j put: (self at: i at: j) ] ].
	
	^ dfInternal.
]

{ #category : #enumerating }
DataFrameInternal >> withIndicesCollect: aBlock [

	^ self class fromMatrix:
		(contents withIndicesCollect: aBlock).
]

{ #category : #enumerating }
DataFrameInternal >> withIndicesDo: aBlock [

	^ contents withIndicesDo: aBlock.
]