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
      pair.push(pair[0]) if pair.length == 1
    return fly

sex = (fly) ->
   for chromosome in fly[0]
      for gene in chromosome
          if gene == "Y"
             return "M"
   return "F"

window.parseCommaSepGenes = (s) ->
   ret = []
   s = s.replace(" ","")
   state = 0
   openBrackets = 0
   gene = ""
   frag = ""
   for ch in s
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
                  ret.push(gene)  
                  gene = ""             
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
   ret.push gene
   return ret 

window.parseConstraintList = (s) ->
   ret = []
   arr = s.split "\n"
   for row in arr
      if row.length>0
         i = row.lastIndexOf(":")
         if i == -1
            return parseErr("Constraint fmt is:g1,g2...gn:tag Eg: Crlo,Crlo:L") 
         genes = row.substr(0,i)
         tag = row.substr(i+1)
         ret.push [parseCommaSepGenes(genes),tag]
   ret

window.parseFly = (f,gender=null) ->
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
   return {"fly":ret} 

#dad = parseFly("A,B,(((C)})/D,F;G,H/I,J;+/+","M")
#mom = parseFly("P,B,C/D,E,F;G,H/I,J;+/+","F")
#kid = parseFly("A,B,C/D,E,F;G,H/I,Q;+/+")

#for fly in [dad,mom,kid]
#   if fly.error?
#      alert fly.error+"\n"+fly.frag
#   else
#      alert JSON.stringify(fly)

window.validateFly = (id,sex) ->
   f = parseFly($("#"+id).val(),sex)
   if f.error
      $("#"+id+"Box").removeClass("success")
      $("#"+id+"Box").addClass("error")
      $("#"+id+"Msg").html("Error")
      $('#o'+id).html("")
   else
      $("#"+id+"Box").removeClass("error")
      $("#"+id+"Box").addClass("success")
      $("#"+id+"Msg").html("")
      $('#o'+id).html(geneHtml(f.fly))
      window.punnettReq[id] = f.fly
      
window.parseBalancers = ->
   window.punnettReq["balancers"] = parseCommaSepGenes($('#balancers').val())
window.parseMarkers = ->
   window.punnettReq["markers"] = parseCommaSepGenes($('#markers').val())
window.parseConstraints = ->
   #alert("makePunnet")
   window.punnettReq["constraints"] = parseConstraintList($('#constraints').val())

window.loadDummy = -> 
   data = window[$("#crossNo").val()]
   #alert JSON.stringify()
   $('#father').val(data["father"])
   $('#mother').val(data["mother"])
   $('#child').val(data["child"])
   $('#balancers').val(data["balancers"])
   $('#markers').val(data["markers"])
   $('#constraints').val(data["constraints"])

window.makePunnett = ->  
   validateFly("father","M");
   validateFly("mother","F");
   validateFly("child");
   parseBalancers()
   parseMarkers()
   parseConstraints()
   
   #alert JSON.stringify(window.punnettReq)
   server.post("/checkCross",JSON.stringify(window.punnettReq),handler)

geneHtml = (fly) ->
   chromosome = Handlebars.compile($("#chromosomeTpl").html())
   hr="<div style=\"margin:5px;height:2px;background-color:black\"></div>"
   semicolon="<td style=\"vertical-align:middle\"><H3>;</H3></td>"
   htmlChrPairs=[]
   for chrPair in fly
      htmlChrA=chromosome(chrPair[0])
      htmlChrB=chromosome(chrPair[1])
      htmlChrPairs.push("<td style=\"text-align:center\"><div>"+htmlChrA+"</div>"+hr+"<div>"+htmlChrB+"</div></td>")
   htmlGenotype="<div><table><tr>"+htmlChrPairs.join(semicolon)+"</tr></table></div>"
   return htmlGenotype
   

