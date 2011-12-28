
fMg=[[],[],[]]
fMg[0]=[['+'],['Y']]
fMg[1]=[['UAS TntG'],['CyO','UAS Dicer']]
fMg[2]=[['tub Gal80ts'],['tub Gal80ts']]

fFg=[[],[],[]]
fFg[0]=[['+'],['+']]
fFg[1]=[['UAS TntG'],['CyO']]
fFg[2]=[['tub Gal80ts'],['VGN6341']]

fCg=[[],[],[]]
fCg[0]=[['+'],['+']]
fCg[1]=[['UAS TntG'],['CyO']]
fCg[2]=[['tub Gal80ts'],['VGN6341']]

cross1= {'father':fMg,
		   'mother':fFg,
			'child':fCg,
			'index':['Y','UAS TntG','CyO','UAS Dicer','tub Gal80ts','VGN6341'],
			'compMatrix':[['0','0','0','0','0','0'],
							  ['0','0','0','0','0','l'],
							  ['0','0','l','0','0','0'],
							  ['0','0','0','0','0','0'],
							  ['0','0','0','0','0','0'],
							  ['0','l','0','0','0','0']],
			'balancers':['CyO'],
			'markers':['CyO']}
