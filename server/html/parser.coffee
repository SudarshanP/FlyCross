isValidChar = (s) -> true

parseErr = (msg,frag) -> {"error":msg,"frag":frag}

checkStructure = (fly) ->
   if fly.length != 3
      return parseErr("3 pairs of chromosomes are needed",JSON.stringify(fly))
   for pair in fly
      if pair.length > 2 
         return parseErr("More than 2 strands in",JSON.stringify(pair))
      if pair.length == 0 
         return parseErr("Missing chromosomes",JSON.stringify(fly))
      for chromosome in pair
         if chromosome.length == 0 
             return parseErr("No genes on chromosomes",JSON.stringify(pair))
         for gene in chromosome
             if gene == ""
                 return parseErr("No genes on chromosomes",JSON.stringify(fly))    
    return fly

sex = (fly) ->
   for chromosome in fly[0]
      for gene in chromosome
          if gene == "Y"
             return "M"
   return "F"

parseFly = (f,gender=null) ->
   ret = []
   gene = ""
   chromosome = []
   pair = []
   f = f.replace(" ","")
   state = 0
   openBrackets = 0
   frag = ""
   for ch in f
      frag += ch
      switch state
         when 0
            switch ch
               when '(','[','{'
                  gene += ch ; openBrackets++
                  state = 1
               when ')',']','}'
                  return parseErr("Closed bracket before opening",frag)                   
               when ','
                  chromosome.push(gene)  
                  gene = "" 
               when '/'
                  chromosome.push(gene) ; pair.push(chromosome)
                  gene = "" ; chromosome = []
               when ";"
                  chromosome.push(gene) ; pair.push(chromosome) ; ret.push(pair)
                  gene = "" ; chromosome = [] ; pair = []               
               else
                  if isValidChar(ch)
                     gene += ch
                  else
                     return parseErr("Unexpected Character",frag)
         when 1
            gene += ch
            if ch == "(" || ch == '[' || ch == '{'
                openBrackets++
            if ch == ")" || ch == ']' || ch == '}'
               openBrackets--
               if openBrackets == 0
                  state = 0
   if openBrackets
      return parseErr("Brackets do not match",frag)
   chromosome.push(gene)
   pair.push(chromosome)
   ret.push(pair)
   ret = checkStructure(ret)
   return(ret) if ret.error?               
   return parseErr("Wrong Gender, Check Y",f) if gender? && sex(ret)!=gender
   return ret 

genePool = (flies) ->
   ret = []
   for fly in flies
      for pair in fly
         for chromosome in pair
            for gene in chromosome
               if ret.indexOf(gene) == -1 && gene != "+"
                  ret.push gene
   ret

dad = parseFly("A,B,(((C)})/D,F;G,H/I,J;+/+","M")
mom = parseFly("P,B,C/D,E,F;G,H/I,J;+/+","F")
kid = parseFly("A,B,C/D,E,F;G,H/I,Q;+/+")

for fly in [dad,mom,kid]
   if fly.error?
      alert fly.error+"\n"+fly.frag
   else
      alert JSON.stringify(fly)
