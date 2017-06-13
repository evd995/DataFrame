baselines
baseline: spec
	<baseline>
	
	spec for: #common do: [
		spec
			project: 'Roassal2' with: [
				spec
					className: 'ConfigurationOfRoassal2';
					version: #development;
					file:  'ConfigurationOfRoassal2';
					repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal2/main/' ];
				
			package: 'DataFrame-Core';
			package: 'DataFrame-Plots' with: [ 
				spec requires: 'DataFrame-Core' ];
			package: 'DataFrame-Tests' with: [ 
				spec requires: 'DataFrame-Core' ];
			package: 'DataFrame-Examples' with: [
				spec requires: #('DataFrame-Core' 'DataFrame-Plots')];
			package: 'DataFrame-DataSets' with: [
				spec requires: 'DataFrame-Core']].