################### Matrix Functions ####################

makeSqrMat = (n,value) ->
   n--
   ret = []
   for i in [0..n]
      m = []
      ret.push m
      for j in [0..n]
         m[j]=value
   ret

alertMat = (mat) ->
   ret = ""
   for row in mat
      ret += row + "\n"
   alert ret

################### Fly Constraints ######################

lethality = [
    ["A","B"]
    ["a","a"]
    ["O","P"]
    ["e","E"]
]
sterility = [
    ["A","B"]
    ["B","b"]
    ["O","P"]
    ["Z","Z"]
]
compatibility = [
    ["A","C"]
    ["D","E"]
    ["O","P"]
    ["e","B"]
]
################### Parser #############################
isAlNum = (s) -> true

parse = (s) ->
   ret = []
   gene = ""
   chromosome = []
   pair = []
   s = s.replace(" ","")
   state = 0
   openBrackets = 0
   err = "Error at : "
   for ch in s
      err += ch
      switch state
         when 0
            if ch == '('
               gene += ch ; openBrackets++
               state = 1
            else if ch == ')'
               return [],err,"Closed bracket before opening"                   
            else if isAlNum(ch) || ch == "+" || ch == "-" 
               gene += ch
            else if ch == ','
               chromosome.push(gene)  
               gene = "" 
            else if ch == '/'
               chromosome.push(gene) ; pair.push(chromosome)
               gene = "" ; chromosome = []
            else if ch == ";"
               chromosome.push(gene) ; pair.push(chromosome) ; ret.push(pair)
               gene = "" ; chromosome = [] ; pair = []               
            else
               return [],err,"Closed bracket before opening"
         when 1
            gene += ch
            if ch == ")"
               openBrackets--
               if openBrackets == 0
                  state = 0
   chromosome.push(gene)
   pair.push(chromosome)
   ret.push(pair)               
   return ret             
   

################### Gene Functions #####################3

genePool = (flies) ->
   ret = []
   for fly in flies
      for gene in parse(fly)
         if ret.indexOf(gene) == -1
            ret.push gene
   ret

makeLookupMatrix = (pool,l,s,c) ->
   geneIdx = {}
   i = 0
   for gene in pool
      geneIdx[gene] = i++

   ret = makeSqrMat(pool.length,"?")
   matChars = [[l,"L"],[s,"S"],[c,"C"]]
   for tmp in matChars
      mapping = tmp[0] ; ch = tmp[1]
      for pair in mapping
         i = geneIdx[pair[0]]
         j = geneIdx[pair[1]]
         if i? && j?
             ret[i][j] = ret[j][i] = ch
   ret

###################### Test Code ###############################

male = "a,b,c,d,e,f"
female = "A,B,C,D,E,F"
child = "A,Y,Z"

pool = genePool([male,female,child]) 
#alert pool
mat = makeLookupMatrix(pool,lethality,sterility,compatibility)
#alertMat mat
#alert pool.join("~")
for s of "Hello"
   alert s
