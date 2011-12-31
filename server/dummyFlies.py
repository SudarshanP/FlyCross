

#Cross1: should cause recombination
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
			'constraints':[[['CyO','CyO'],'l'],
								[['VGN6341','UAS TntG'],'l'],
								[['VGN6341','UAS TntG','tub Gal80ts'],'rl']],
			'balancers':['CyO'],
			'markers':['CyO']}


#Cross2: has a recessive marker
fMg=[[],[],[]]
fMg[0]=[['+'],['Y']]
fMg[1]=[['UAS TntG','e'],['CyO']]
fMg[2]=[['tub Gal80ts'],['tub Gal80ts']]

fFg=[[],[],[]]
fFg[0]=[['+'],['+']]
fFg[1]=[['Tft','e'],['CyO']]
fFg[2]=[['VGN6341'],['VGN6341']]

fCg=[[],[],[]]
fCg[0]=[['+'],['+']]
fCg[1]=[['UAS TntG','e'],['CyO']]
fCg[2]=[['tub Gal80ts'],['VGN6341']]

cross2= {'father':fMg,
		   'mother':fFg,
			'child':fCg,
			'index':['Y','UAS TntG','e','CyO','tub Gal80ts','Tft','VGN6341'],
			'constraints':[[['CyO','CyO'],'l'],
								[['VGN6341','UAS TntG'],'l'],
								[['VGN6341','UAS TntG','tub Gal80ts'],'rl']],
			'balancers':['CyO'],
			'markers':['Tft','e','CyO']}

