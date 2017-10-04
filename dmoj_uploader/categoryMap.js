const directMappings = {
	// top level
	'Telerik Software Academy': 'sa',
	'Telerik Algo Academy': 'aa',
	'Telerik Kids Academy': 'ka',
	'Telerik Academy Alpha': 'al',
	'Bulgarian Competitions': 'bg',
	'Others': 'ot',
	'undefined': 'un',

	// Software academy
	'Homework': 'hw',
	'Workshops': 'ws',
	'2011_2012': '12',
	'2012_2013': '12',
	'2013_2014': '12',
	'2015_2016': '12',
	'2016_2017': '12',
	'2016_2017 Autumn': '12',

	// Algo academy
	'Telerik Algo Academy 2011_2012': '12',
	'Telerik Algo Academy 2012_2013': '13',
	'Telerik Algo Academy 2013_2014': '14',
	'Telerik Algo Academy 2014_2015': '15',
	'Telerik Algo Academy 2015_2016': '16',
};

const failed = new Set; // for debugging

function map(category) {
	const direct = directMappings[category];
	if(direct) return direct;

	failed.add(category);
	return category;
}

module.exports = {
	map,
	failed,
};
