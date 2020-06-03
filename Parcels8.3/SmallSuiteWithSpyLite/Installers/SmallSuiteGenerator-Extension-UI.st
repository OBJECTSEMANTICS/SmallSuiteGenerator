<?xml version="1.0"?>

<st-source>
<time-stamp>From VisualWorks®, 7.4 of December 5, 2005 on May 28, 2020 at 10:55:49 am</time-stamp>
<!-- Package SmallSuiteGenerator-Extension-UI* -->


<component-property>
<name>SmallSuiteGenerator-Extension-UI</name> <type>package</type>
<property>packageName</property> <value>'SmallSuiteGenerator-Extension-UI'</value>
</component-property>

<component-property>
<name>SmallSuiteGenerator-Extension-UI</name> <type>package</type>
<property>parcelName</property> <value>'SmallSuiteGenerator-Extension-UI'</value>
</component-property>

<class>
<name>AbstractSmallSuiteGeneratorUI</name>
<environment>SmallSuiteGenerator</environment>
<super>UI.ApplicationModel</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>packageModule packageModule1 classModule dialog generations population statements numberGenerations populationSize numberStatements </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category></category>
<attributes>
<package>SmallSuiteGenerator-Extension-UI</package>
</attributes>
</class>

<class>
<name>IconsSmallSuiteGenerator</name>
<environment>Smalltalk</environment>
<super>UI.ApplicationModel</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars></inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category></category>
<attributes>
<package>SmallSuiteGenerator-Extension-UI</package>
</attributes>
</class>

<class>
<name>SmallSuiteGeneratorGenericUI</name>
<environment>SmallSuiteGenerator</environment>
<super>SmallSuiteGenerator.AbstractSmallSuiteGeneratorUI</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>profiler </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category></category>
<attributes>
<package>SmallSuiteGenerator-Extension-UI</package>
</attributes>
</class>

<class>
<name>SmallSuiteGeneratorEditorUI</name>
<environment>SmallSuiteGenerator</environment>
<super>SmallSuiteGenerator.AbstractSmallSuiteGeneratorUI</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>documentModel </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category></category>
<attributes>
<package>SmallSuiteGenerator-Extension-UI</package>
</attributes>
</class>






<methods>
<class-id>SmallSuiteGenerator.AbstractSmallSuiteGeneratorUI class</class-id> <category>interface opening</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="open">open

	^super open</body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.AbstractSmallSuiteGeneratorUI class</class-id> <category>interface specs</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="advancedSettings">advancedSettings

	&lt;resource: #canvas&gt;
	^#(#{UI.FullSpec} #window: #(#{UI.WindowSpec} #properties: #(#{UI.PropertyListDictionary} #labelFromApplication false ) #label: 'Advanced Settings' #min: #(#{Core.Point} 20 20 ) #max: #(#{Core.Point} 0 0 ) #bounds: #(#{Graphics.Rectangle} 640 311 972 581 ) ) #component: #(#{UI.SpecCollection} #collection: #(#(#{UI.GroupBoxSpec} #layout: #(#{Graphics.LayoutFrame} 10 0 12 0 320 0 120 0 ) #name: #GroupBox2 ) #(#{UI.GroupBoxSpec} #layout: #(#{Graphics.LayoutFrame} 10 0 126 0 320 0 229 0 ) #name: #GroupBox1 ) #(#{UI.LabelSpec} #layout: #(#{Graphics.LayoutOrigin} 21 0 27 0 ) #name: #Label1 #label: 'Generations:' ) #(#{UI.LabelSpec} #layout: #(#{Graphics.LayoutOrigin} 22 0 58 0 ) #name: #Label2 #label: 'Statements:' ) #(#{UI.LabelSpec} #layout: #(#{Graphics.LayoutOrigin} 21 0 81 0 ) #name: #Label3 ) #(#{UI.SpinButtonSpec} #layout: #(#{Graphics.LayoutFrame} 119 0 26 0 305 0 47 0 ) #name: #numberGenerations #model: #numberGenerations #type: #number #low: 1 #high: 100 #interval: 1 ) #(#{UI.SpinButtonSpec} #layout: #(#{Graphics.LayoutFrame} 117 0 57 0 308 0 78 0 ) #name: #numberStatements #model: #numberStatements #type: #number #low: 1 #high: 100 #interval: 1 ) #(#{UI.LabelSpec} #layout: #(#{Graphics.LayoutOrigin} 22 0 89 0 ) #name: #Label4 #label: 'Population:' ) #(#{UI.SpinButtonSpec} #layout: #(#{Graphics.LayoutFrame} 117 0 89 0 307 0 110 0 ) #name: #numberPopulation #model: #populationSize #type: #number #low: 1 #high: 100 #interval: 1 ) #(#{UI.LabelSpec} #layout: #(#{Graphics.LayoutOrigin} 22 0 135 0 ) #name: #Label5 #label: 'Class:' ) #(#{UI.LabelSpec} #layout: #(#{Graphics.LayoutOrigin} 22 0 168 0 ) #name: #Label6 #label: 'Package(s):' ) #(#{UI.LabelSpec} #layout: #(#{Graphics.LayoutOrigin} 20 0 200 0 ) #name: #Label7 #label: 'Output package:' ) #(#{UI.SubCanvasSpec} #layout: #(#{Graphics.LayoutFrame} 117 0 194 0 311 0 222 0 ) #name: #packageModule1 #flags: 0 #majorKey: #{EntryWithPasteButtonModule} #minorKey: #windowSpec #clientKey: #packageModule1 ) #(#{UI.SubCanvasSpec} #layout: #(#{Graphics.LayoutFrame} 117 0 164 0 310 0 189 0 ) #name: #packageModule #flags: 0 #majorKey: #{EntryWithPasteButtonModule} #minorKey: #windowSpec #clientKey: #packageModule ) #(#{UI.SubCanvasSpec} #layout: #(#{Graphics.LayoutFrame} 117 0 134 0 310 0 158 0 ) #name: #classModule #flags: 0 #majorKey: #{EntryWithPasteButtonModule} #minorKey: #windowSpec #clientKey: #classModule ) #(#{UI.ActionButtonSpec} #layout: #(#{Graphics.LayoutFrame} 193 0 240 0 250 0 261 0 ) #name: #accept #model: #acceptButton #label: #(#{Kernel.UserMessage} #key: #OK #defaultString: 'OK' #catalogID: #labels ) #isDefault: true #defaultable: true ) #(#{UI.ActionButtonSpec} #layout: #(#{Graphics.LayoutFrame} 263 0 241 0 320 0 262 0 ) #model: #cancelButton #label: #(#{Kernel.UserMessage} #key: #Cancel #defaultString: 'Cancel' #catalogID: #labels ) #defaultable: true ) ) ) )</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.AbstractSmallSuiteGeneratorUI</class-id> <category>interface opening</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="openDialogInterface:">openDialogInterface: t1 

	builder := (dialog := SimpleDialog new) builder.
	dialog postBuildBlock: [:t2 :t3 | self postBuildWith: t3].
	dialog postOpenBlock: [:t4 :t5 | self postOpenWith: t5].
	dialog openFor: self interface: t1.
	^self</body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.AbstractSmallSuiteGeneratorUI</class-id> <category>initialize-release</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="initialize">initialize

	super initialize.
	packageModule := EntryWithPasteButtonModule forPackages.
	packageModule1 := EntryWithPasteButtonModule forPackages.
	classModule := EntryWithPasteButtonModule forClasses.
	generations := 20.
	statements := 10.
	population := 30.
	numberStatements := statements asValue.
	numberGenerations := generations asValue.
	populationSize := population asValue.
	^self</body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.AbstractSmallSuiteGeneratorUI</class-id> <category>accessing</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="packageModule">packageModule

	^packageModule</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="cancelButton">cancelButton

	self populationSize value: population.
	self numberGenerations value: generations.
	self numberStatements value: statements.
	dialog doCancel.
	^self</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="numberStatements">numberStatements

	^numberStatements</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="numberGenerations">numberGenerations

	^numberGenerations</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="acceptButton">acceptButton

	population := self populationSize value.
	generations := self numberGenerations value.
	statements := self numberStatements value.
	dialog accept; closeRequest.
	^self</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="packageModule1">packageModule1

	^packageModule1</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="numberOfPopulation">numberOfPopulation

	^self widgetAt: #numberPopulation</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="numberOfGenerations">numberOfGenerations

	^self widgetAt: #numberGenerations</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="numberOfStatements">numberOfStatements

	^self widgetAt: #numberStatements</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="classModule">classModule

	^classModule</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="populationSize">populationSize

	^populationSize</body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.AbstractSmallSuiteGeneratorUI</class-id> <category>actions</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="createTestCasesFor:">createTestCasesFor: t1 

	^(STestCaseFactoryVisualWorks new) typeInfo: t1; fitness: SStatementCoverage new; targetClassName: classModule value asSymbol; targetPackageRegex: packageModule value; outputPackageName: packageModule1 value; numberOfGenerations: generations; numberOfStatements: statements; populationSize: population; createTestCases; yourself</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="showAdvancedSettings">showAdvancedSettings

	| |
	self openDialogInterface: #advancedSettings.
	^self</body>
</methods>


<methods>
<class-id>IconsSmallSuiteGenerator class</class-id> <category>resources</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="rec">rec

	&lt;resource: #image&gt;
	^CachedImage on: (Image
			extent: 32 @ 32
			depth: 2
			bitsPerPixel: 2
			palette: (Graphics.MappedPalette withColors: (#(#(#{Graphics.ColorValue} #scaledRed:scaledGreen:scaledBlue: #(4096 0 0 ) ) #(#{Graphics.ColorValue} #scaledRed:scaledGreen:scaledBlue: #(8191 0 0 ) ) #(#{Graphics.ColorValue} #scaledRed:scaledGreen:scaledBlue: #(8191 8191 8191 ) ) ) collect: [:t1 | (t1 at: 1) value perform: (t1 at: 2)
							withArguments: (t1 at: 3)]))
			usingBits: (ByteArray fromPackedString: '******************************************************* @@@@@@J***@AUUUUT***(@@@@@@R*** @@@@@AJ***@@@@@@D***(@@@@@@R*** @@@@@AJ***@@@@@@D***(@@@@@@R***!@@@@@AJ***D@@@@@D***(P@@@@@R***!@@@@@AJ***D@@@@@@***(P@@@@@B***!@@@@@@J***D@@@@@@***(P@@@@@B***!UUUU@@J***@@@@@@@**************************************************************************** @a'))</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="console">console

	&lt;resource: #image&gt;
	^CachedImage on: (Image
			extent: 32 @ 32
			depth: 3
			bitsPerPixel: 4
			palette: (Graphics.MappedPalette withColors: (#(#(#{Graphics.ColorValue} #scaledRed:scaledGreen:scaledBlue: #(0 0 0 ) ) #(#{Graphics.ColorValue} #scaledRed:scaledGreen:scaledBlue: #(0 8191 0 ) ) #(#{Graphics.ColorValue} #scaledRed:scaledGreen:scaledBlue: #(0 4096 0 ) ) #(#{Graphics.ColorValue} #scaledRed:scaledGreen:scaledBlue: #(8191 8191 8191 ) ) #(#{Graphics.ColorValue} #scaledRed:scaledGreen:scaledBlue: #(3072 3072 3072 ) ) ) collect: [:t1 | (t1 at: 1) value perform: (t1 at: 2)
							withArguments: (t1 at: 3)]))
			usingBits: (ByteArray fromPackedString: 'L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L1D3L0@@@@@@@@@@@@@@@@DRL3L@@@@@@@@@@@@@@@@QH#L3@DQDQDQDQDQDQDQAD"H3L0ACL3L3L3L3L3L3DRH!L3L@P3@3L3L3L3L3LQH"D3L3@DL0@3L3L3L3L1D"HSL3L0ACL@@3L3L3DSDRH!L3L3L@P3L@@3L3LRHQH"DCL3L3@DL3L@@3L3D"H"HP@3L3L0ACL0@CL3L3D"H!P@L3L3L@P3@@L3L3L3D"D4@CL3L3@DL0@3L0@@L3DSM@@3L3L0ACLCL3@@@@L3L3P@L3L3L@P3L3L3L3L3L3L4@CL3L3@DL3L3L3L3L3L3M@@3L3L0ADQDQDQDQDQDQDP@L3L3L@@@@@@@@@@@@@@@@CL3L3@@@@@@@@@@@@@@@@@3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3L3Lb'))</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="tests">tests

	&lt;resource: #image&gt;
	^CachedImage on: (Image
			extent: 32 @ 32
			depth: 3
			bitsPerPixel: 4
			palette: (Graphics.MappedPalette withColors: (#(#(#{Graphics.ColorValue} #scaledRed:scaledGreen:scaledBlue: #(0 0 0 ) ) #(#{Graphics.ColorValue} #scaledRed:scaledGreen:scaledBlue: #(3072 3072 3072 ) ) #(#{Graphics.ColorValue} #scaledRed:scaledGreen:scaledBlue: #(8191 8191 8191 ) ) #(#{Graphics.ColorValue} #scaledRed:scaledGreen:scaledBlue: #(5461 5461 5461 ) ) #(#{Graphics.ColorValue} #scaledRed:scaledGreen:scaledBlue: #(0 8191 0 ) ) #(#{Graphics.ColorValue} #scaledRed:scaledGreen:scaledBlue: #(0 4096 0 ) ) ) collect: [:t1 | (t1 at: 1) value perform: (t1 at: 2)
							withArguments: (t1 at: 3)]))
			usingBits: (ByteArray fromPackedString: 'H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"IEH"H"L3L3L3L3L3L2H"H$URH"H#DQDQDQDQDQD"H"QUT"H"H1@@@@@@@@@@H"IEUTH"H"LP@@@@@@@@@BH$UUP"H"H#D@DQDQDQDQD"QUUBH"H"H1@AH"H"H"H"IEUTH"H"H"LP@RH"H"H"H$UUP"H"H"H#D@D"H"H"H"QUUBH"H"H"H1@AH"H"H"IEUTH"H"H"H"LP@RH$P"H$UUP"D@D2H"H#D@D"QUP"QUUBH!@AL"H"H1@AH$UUQEUTH"HP@SH"H"LP@RH$UUUUP"H"D@D2H"H#D@D"H$UUUBH"H!@AL"H"H1@AH"H$UTH"H"HP@SH"H"LP@RH"H$P"H"H"D@D2H"H#D@D"H"H"H"H"H!@AL"H"H1@AH"H"H"H"H"HP@SH"H"LP@RH"H"H"H"H"D@D2H"H#D@D3L3L3L3L3L1@AL"H"H1@ADQDQDQDQDQDP@SH"H"LP@@@@@@@@@@@@@@D2H"H#D@@@@@@@@@@@@@@AL"H"H1DQDQDQDQDQDQDQDSH"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"H"Hb'))</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SmallSuiteGeneratorGenericUI class</class-id> <category>interface specs</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="windowSpec">windowSpec

	&lt;resource: #canvas&gt;
	^#(#{UI.FullSpec} #window: #(#{UI.WindowSpec} #label: 'SmallSuiteGenerator' #min: #(#{Core.Point} 430 155 ) #max: #(#{Core.Point} 430 155 ) #bounds: #(#{Graphics.Rectangle} 576 434 1006 589 ) #flags: 4 ) #component: #(#{UI.SpecCollection} #collection: #(#(#{UI.GroupBoxSpec} #layout: #(#{Graphics.LayoutFrame} 11 0 9 0 416 0 110 0 ) #name: #GroupBox1 ) #(#{UI.LabelSpec} #layout: #(#{Graphics.LayoutOrigin} 24 0 54 0 ) #name: #Label1 #label: 'Packages:' ) #(#{UI.LabelSpec} #layout: #(#{Graphics.LayoutOrigin} 23 0 79 0 ) #name: #Label2 #label: 'Output package:' ) #(#{UI.ActionButtonSpec} #layout: #(#{Graphics.LayoutFrame} 308 0 125 0 413 0 146 0 ) #name: #ActionButton1 #model: #generateTests #label: 'Create tests' #defaultable: true ) #(#{UI.SubCanvasSpec} #layout: #(#{Graphics.LayoutFrame} 121 0 45 0 403 0 73 0 ) #name: #packageModule #flags: 0 #clientKey: #packageModule #majorKey: #{EntryWithPasteButtonModule} #minorKey: #windowSpec ) #(#{UI.SubCanvasSpec} #layout: #(#{Graphics.LayoutFrame} 122 0 75 0 403 0 100 0 ) #name: #packageModule1 #flags: 0 #clientKey: #packageModule1 #majorKey: #{EntryWithPasteButtonModule} #minorKey: #windowSpec ) #(#{UI.LabelSpec} #layout: #(#{Graphics.LayoutOrigin} 24 0 24 0 ) #name: #Label3 #label: 'For class:' ) #(#{UI.SubCanvasSpec} #layout: #(#{Graphics.LayoutFrame} 120 0 21 0 402 0 42 0 ) #name: #classModule #flags: 0 #clientKey: #classModule #majorKey: #{EntryWithPasteButtonModule} #minorKey: #windowSpec ) #(#{UI.ActionButtonSpec} #layout: #(#{Graphics.LayoutFrame} 11 0 124 0 124 0 145 0 ) #name: #ActionButton2 #model: #showAdvancedSettings #label: 'Advanced Settings' #defaultable: true ) #(#{UI.ActionButtonSpec} #layout: #(#{Graphics.LayoutFrame} 129 0 124 0 186 0 145 0 ) #name: #startButton #model: #start #label: 'Rec' #defaultable: true ) #(#{UI.ActionButtonSpec} #layout: #(#{Graphics.LayoutFrame} 190 0 124 0 247 0 145 0 ) #name: #startButton #model: #stop #label: 'Stop' #defaultable: true ) ) ) )</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SmallSuiteGeneratorGenericUI</class-id> <category>initialize-release</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="profilerForPackagesMatching:">profilerForPackagesMatching: t1 

	profiler := Spy1.SSTypeCollector new.
	Transcript show: 'profiling...'; cr.
	profiler beforeProfiling.
	profiler gatherForPackages: (self packagesMatchingWith: t1).
	profiler install.
	profiler beforeProfiling.
	^self</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="packagesMatchingWith:">packagesMatchingWith: t1 

	^Store.Registry allPackages select: [:t2 | t1 match: t2 name asString]</body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.SmallSuiteGeneratorGenericUI</class-id> <category>accessing</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="generateTests">generateTests

	[Notice show: #LoadingParcelOrParcels &lt;&lt; #dialogs &gt;&gt; 'Generating tests...' while: [profiler ifNotNil: [self createTestCasesFor: (SmallSuiteGenerator.STypeInfo asTypeInfo: profiler)]]]
		on: SError do: [:t1 | Dialog warn: t1 messageText withCRs].
	^self</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="checkInvariants">checkInvariants

	self assert: classModule value isNil not description: 'Please provide a target class'.
	self assert: packageModule1 value isNil not description: 'Please provide a package output'.
	^self</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="stop">stop

	Notice show: #LoadingParcelOrParcels &lt;&lt; #dialogs &gt;&gt; 'Deconstructing...' while: [profiler ifNotNil: [self uninstall]].
	^self</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="uninstall">uninstall

	profiler afterProfiling; uninstall.
	Transcript show: 'ended...'; cr.
	^self</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="start">start

	Notice show: #LoadingParcelOrParcels &lt;&lt; #dialogs &gt;&gt; 'Instrumenting...'
		while: 
			[profiler ifNotNil: [self uninstall].
			self profilerForPackagesMatching: packageModule value].
	^self</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SmallSuiteGeneratorEditorUI class</class-id> <category>resources</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="menuBar">menuBar

	&lt;resource: #menu&gt;
	^#(#{UI.Menu} #(#(#{UI.MenuItem} #rawLabel: 'Settings' ) #(#{UI.MenuItem} #rawLabel: 'Help' ) ) #(2 ) nil ) decodeAsLiteralArray</body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.SmallSuiteGeneratorEditorUI class</class-id> <category>interface specs</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="windowSpec">windowSpec

	&lt;resource: #canvas&gt;
	^#(#{UI.FullSpec} #window: #(#{UI.WindowSpec} #label: 'SmallSuiteGenerator' #min: #(#{Core.Point} 577 422 ) #max: #(#{Core.Point} 577 422 ) #bounds: #(#{Graphics.Rectangle} 687 239 1264 661 ) #flags: 4 ) #component: #(#{UI.SpecCollection} #collection: #(#(#{Refactory.Browser.SourceCodeEditorSpec} #properties: #(#{UI.PropertyListDictionary} #dropSelector #drop: #dragOverSelector #dragOver: #dragEnterSelector #dragEntry: ) #layout: #(#{Graphics.LayoutFrame} 2 0 39 0 584 0 366 0 ) #name: #document #flags: 15 #isOpaque: true #model: #documentModel #isWrapped: true #isReadOnly: false #showHiddenCharacters: false #showLineStriping: false #autoAccept: true #continuousAccept: false #showInputCursor: true #showSelection: true ) #(#{UI.LabelSpec} #layout: #(#{Graphics.LayoutOrigin} 11 0 376 0 ) #name: #Label1 #label: 'Packages:' ) #(#{UI.LabelSpec} #layout: #(#{Graphics.LayoutOrigin} 298 0 376 0 ) #name: #Label2 #label: 'Output package:' ) #(#{UI.ActionButtonSpec} #layout: #(#{Graphics.LayoutFrame} 5 0 11 0 110 0 32 0 ) #name: #ActionButton1 #model: #generateTests #label: 'Create tests' #defaultable: true ) #(#{UI.SubCanvasSpec} #layout: #(#{Graphics.LayoutFrame} 7 0 387 0 289 0 415 0 ) #name: #packageModule #flags: 0 #majorKey: #{EntryWithPasteButtonModule} #minorKey: #windowSpec #clientKey: #packageModule ) #(#{UI.SubCanvasSpec} #layout: #(#{Graphics.LayoutFrame} 296 0 392 0 564 0 417 0 ) #name: #packageModule1 #flags: 0 #majorKey: #{EntryWithPasteButtonModule} #minorKey: #windowSpec #clientKey: #packageModule1 ) #(#{UI.LabelSpec} #layout: #(#{Graphics.LayoutOrigin} 233 0 14 0 ) #name: #Label3 #label: 'For class:' ) #(#{UI.SubCanvasSpec} #layout: #(#{Graphics.LayoutFrame} 293 0 16 0 566 0 34 0 ) #name: #classModule #flags: 0 #majorKey: #{EntryWithPasteButtonModule} #minorKey: #windowSpec #clientKey: #classModule ) #(#{UI.ActionButtonSpec} #layout: #(#{Graphics.LayoutFrame} 116 0 11 0 229 0 32 0 ) #name: #ActionButton2 #model: #showAdvancedSettings #label: 'Advanced Settings' #defaultable: true ) ) ) )</body>
</methods>


<methods>
<class-id>SmallSuiteGenerator.SmallSuiteGeneratorEditorUI</class-id> <category>initialize-release</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="initialize">initialize

	super initialize.
	documentModel := Graphics.Document new asValue.
	^self</body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.SmallSuiteGeneratorEditorUI</class-id> <category>accessing</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="documentModel">documentModel

	^documentModel</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="document">document

	^documentModel value</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="document:">document: t1 

	documentModel value: t1.
	^self</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="newCode">newCode

	self class compile: 'performTest
	' , self document asString.
	^self</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="typeInfoFor:">typeInfoFor: t1

	^STypeInfo asTypeInfo: (Spy1.SSTypeCollector profile: t1 inPackagesMatching: packageModule value)</body>
</methods>

<methods>
<class-id>SmallSuiteGenerator.SmallSuiteGeneratorEditorUI</class-id> <category>actions</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="performTest">performTest

	^self</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="generateTests">generateTests

	[Notice show: #LoadingParcelOrParcels &lt;&lt; #dialogs &gt;&gt; 'Generating tests...'
		while: 
			[| t1 |
			self newCode.
			t1 := self typeInfoFor: [self performTest].
			self createTestCasesFor: t1]]
		on: SError do: [:t2 | Dialog warn: t2 messageText withCRs].
	^self</body>
</methods>


<methods>
<class-id>Tools.VisualLauncher</class-id> <category>toolbar</category>

<body package="SmallSuiteGenerator-Extension-UI" selector="toolbarItemNewSmallSuiteGeneratorEditor">toolbarItemNewSmallSuiteGeneratorEditor

	&lt;menuItem: #(#NewCanvas #UIPainter 'New SmallSuite' ) icon: #newSmallSuiteEditorIcon nameKey: nil menu: #(#launcherToolBar ) position: 45.02 helpText: #(#EditANewCanvas #UIPainter 'Open generator of tests with editor' )&gt;
	self applicationForClassNamed: #{SmallSuiteGenerator.SmallSuiteGeneratorEditorUI} do: [:t1 | t1 open].
	^self</body>

<body package="SmallSuiteGenerator-Extension-UI" selector="toolbarItemNewSmallSuiteGenerator">toolbarItemNewSmallSuiteGenerator

	&lt;menuItem: #(#NewCanvas #UIPainter 'New SmallSuite' ) icon: #newSmallSuiteIcon nameKey: nil menu: #(#launcherToolBar ) position: 45.01 helpText: #(#EditANewCanvas #UIPainter 'Open generator of tests' )&gt;
	self applicationForClassNamed: #{SmallSuiteGenerator.SmallSuiteGeneratorGenericUI} do: [:t1 | t1 open].
	^self</body>
</methods>



</st-source>
