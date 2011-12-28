import itertools

def genoHash(genotype):
	genoHash=[]
	for chrA,chrB in genotype:
		genoHash.append(sorted([chrA.cHash,chrB.cHash]))
	return genoHash

index=[]
compMatrix=[]
balancers=[]
markers=[]
def updateLists(indexList,compMat,balancersList,markersList):
	global index
	global compMatrix
	global balancers
	global markers
	(index,compMatrix,balancers,markers)=(indexList,compMat,balancersList,markersList)


class Chromosome():
	def __init__(self,geneList):
		self.geneList=geneList
		self.cHash=sorted(geneList)
		self.Y=False
		self.domMarkers=[]
		self.recMarkers=[]
		self.balancer=False
		for gene in geneList:
			if gene in markers:
				if gene[0].isupper:self.domMarkers.append(gene)
				elif gene[0].islower:self.recMarkers.append(gene)
			if gene=='Y':self.Y=True
			if gene in balancers:self.balancer=True

	def __str__(self):
		return ','.join(self.geneList)

class Fly():
	def __init__(self,genotypeList):
		self.genotype=[]
		self.allGenes=[]
		self.gender=None
		self.phenotype=[]
		self.phenoHash=[]
		self.flyHash=[]
		self.gametes=[]
		self.lethal=None
		self.sterile=None
		self.markerInterference=None

		# # add genes to allGenes, and fill genotype with chromosome objects
		for chrAList,chrBList in genotypeList:
			self.allGenes+=chrAList+chrBList
			self.genotype.append([Chromosome(chrAList),Chromosome(chrBList)])
		self.allGenes=filter(lambda x: x!='+',self.allGenes)#remove all instances of +

		# # Find Gender
		for allosome in self.genotype[0]:
			if allosome.Y:self.gender='Male'
		if not self.gender:
			self.gender='Female'

		# # Find Phenotype
		self.phenotype=[self.gender]
		for chrA,chrB in self.genotype:
			recA=chrA.recMarkers
			recB=chrB.recMarkers
			self.phenotype+=filter(lambda x:x in chrA.domMarkers,chrB.domMarkers)#intersection of domMarkers
			self.phenotype+=chrA.recMarkers+filter(lambda x:x not in chrA.recMarkers,chrB.recMarkers)#union of recMarkers
			#self.phenotype+=chrA.domMarkers+chrB.domMarkers
			#for m in recA:
			#	if m in recB:self.phenotype.append(m)

		# # Find genoHash and phenoHash
		self.flyHash=genoHash(self.genotype)
		self.phenoHash=sorted(self.phenotype)

		# # Find gametes
		chrList=[]
		for chrA,chrB in self.genotype:
			if chrA.cHash==chrB.cHash:chrList.append([chrA])
			else:chrList.append([chrA,chrB])
		self.gametes=list(itertools.product(*chrList))

		# # look at compMatrix for lethality(l),sterility(s) and markerInterference(i)
		geneCombinations=itertools.product(self.allGenes,self.allGenes)
		self.lethal=False
		self.sterile=False
		self.markerInterference=False
		for combo in geneCombinations:
			i=index.index(combo[0])#first 'index' is my variable, second id list func.... Needs better naming
			j=index.index(combo[1])#first 'index' is my variable, second id list func.... Needs better naming
			tag=compMatrix[i][j]
			if 'l' in tag : self.lethal=True
			if 's' in tag : self.sterile=True
			if 'i' in tag : self.markerInterference=True

	def __str__(self):
		#return str(self.allGenes)
		return " ; ".join([str(chromosomeA)+' / '+str(chromosomeB) for chromosomeA,chromosomeB in self.genotype])

def cross(gamete1,gamete2):
	flyG=[]
	warnings=[]
	for i in range(len(gamete1)):
		if (gamete1[i].cHash != gamete2[i].cHash) and not(gamete1[i].balancer or gamete2[i].balancer) and not(gamete1[i].Y or gamete2[i].Y):
			warnings.append( "Warning! Recombination will occur betweeen "+str(gamete1[i])+" and "+str(gamete2[i]))
		flyG.append([gamete1[i].geneList,gamete2[i].geneList])
	return warnings,Fly(flyG)


def punnett(fly1,fly2):
	punnettSquare=[]
	for gamete1 in fly1.gametes:
		flyRow=[]
		for gamete2 in fly2.gametes:
			warnings,fly=cross(gamete1,gamete2)
			flyRow.append({'warnings':warnings,
								'Fly':fly})
		punnettSquare.append(flyRow)
	return (fly1.gametes,
			  fly2.gametes,
			  punnettSquare)

def punnettDict(fly1,fly2):
	fly1AxisChr,fly2AxisChr,punnettSqr=punnett(fly1,fly2)

	# Convert the chromosome object filled gametes to strings
	fly1Axis=[';'.join([str(chromosome) for chromosome in gamete]) for gamete in fly1AxisChr]
	fly2Axis=[';'.join([str(chromosome) for chromosome in gamete]) for gamete in fly2AxisChr]
	
	genotypeMappings={}
	phenotypeMappings={}
	p=[]
	for row in range(len(punnettSqr)):
		pRow=[]
		for col in range(len(punnettSqr[row])):
			fly=punnettSqr[row][col]['Fly']
			warnings=punnettSqr[row][col]['warnings']

			# Make mappings of genoHashes to human readable genotypes
			if str(fly.flyHash) in genotypeMappings:
				genotype=genotypeMappings[str(fly.flyHash)]
			else:
				genotype=genotypeMappings[str(fly.flyHash)]=str(fly)

			# Make mappings of phenoHashes to human readable phenotypes
			if str(fly.phenoHash) in phenotypeMappings:
				phenotype=phenotypeMappings[str(fly.phenoHash)]
			else:
				phenotype=phenotypeMappings[str(fly.phenoHash)]=fly.phenotype

			flyDict={'genotype':genotype,
						'phenotype':phenotype,
						'sterile':fly.sterile,
						'lethal':fly.lethal,
						'warnings':warnings,
						'markerInterference':fly.markerInterference}
			pRow.append(flyDict)
		p.append(pRow)
	return {'fly1Axis':fly1Axis,
			  'fly2Axis':fly2Axis,
			  'punnetSquare':p}

def oldCross(fly1,fly2):
	f1Flies=[]
	prod=itertools.product(fly1.gametes,fly2.gametes)
	for fly1gam,fly2gam in prod:
		f1FlyG=[]
		for i in range(len(fly1gam)):
			if (fly1gam[i].cHash != fly2gam[i].cHash) and not(fly1gam[i].balancer or fly2gam[i].balancer) and not(fly1gam[i].Y or fly2gam[i].Y):
				print "Warning! Recombination will occur betweeen "+str(fly1gam[i])+" and "+str(fly2gam[i])
			f1FlyG.append([fly1gam[i].geneList,fly2gam[i].geneList])
		f1Flies.append(Fly(f1FlyG))
	return f1Flies

