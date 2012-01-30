isValidChar = (s) -> true

parseErr = (msg,frag) -> {"error":msg,"frag":frag}

checkStructure = (fly) ->
   if fly.length != 3
      return parseErr("3 pairs of chromosomes are needed: ",JSON.stringify(fly))
   for pair in fly
      if pair.length > 2 
         return parseErr("More than 2 chromosomes in the pair: ",JSON.stringify(pair))
      if pair.length == 0 
         return parseErr("Missing chromosomes: ",JSON.stringify(fly))
      for chromosome in pair
         if chromosome.length == 0 
             return parseErr("No genes on chromosomes: ",JSON.stringify(pair))
         for gene in chromosome
             if gene == ""
                 return parseErr("No genes on chromosomes: ",JSON.stringify(fly))    
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
            return parseErr("Constraint format is: gene1,gene2,...,geneN:tag Eg: CyO,CyO:l") 
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
   if f.length ==0
      return parseErr("No Fly!",frag)
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

window.validateFly = (id,sex) ->
   f = parseFly($("#"+id).val(),sex)
   if f.error
      $("#"+id+"Box").removeClass("success")
      $("#"+id+"Box").addClass("error")
      $("#"+id+"Msg").html(f.error)
      $('#o'+id).html("")
      window.punnettReq[id] = {"error":f.error}
   else
      $("#"+id+"Box").removeClass("error")
      $("#"+id+"Box").addClass("success")
      $("#"+id+"Msg").html("")
      $('#o'+id).html(geneHtml(f.fly))
      window.punnettReq[id] = f.fly

window.validateChild = () ->
   f = parseFly($("#child").val())
   if f.error
      if f.error=="No Fly!"
         $("#childBox").removeClass("error")
         $("#childBox").addClass("success")
         $("#childMsg").html("")
         $("#ochild").html(geneHtml(""))
         window.punnettReq["child"]=""
      else
         $("#childBox").removeClass("success")
         $("#childBox").addClass("error")
         $("#childMsg").html(f.error)
         $("#ochild").html("")
         window.punnettReq["child"] = {"error":f.error}
   else
      $("#childBox").removeClass("error")
      $("#childBox").addClass("success")
      $("#childMsg").html("")
      $("#ochild").html(geneHtml(f.fly))
      window.punnettReq["child"] = f.fly
      
window.parseBalancers = ->
   genes=parseCommaSepGenes($('#balancers').val())
   if genes.error
      $("#balancersBox").removeClass("success")
      $("#balancersBox").addClass("error")
      $("#balancersMsg").html(genes.error)
   else
      $("#balancersBox").removeClass("error")
      $("#balancersBox").addClass("success")
      $("#balancersMsg").html("")
   window.punnettReq["balancers"] = genes

window.parseMarkers = ->
   genes=parseCommaSepGenes($('#markers').val())
   if genes.error
      $("#markersBox").removeClass("success")
      $("#markersBox").addClass("error")
      $("#markersMsg").html(genes.error)
   else
      $("#markersBox").removeClass("error")
      $("#markersBox").addClass("success")
      $("#markersMsg").html("")
   window.punnettReq["markers"] = genes

window.parseConstraints = ->
   constraints=parseConstraintList($('#constraints').val())
   if constraints.error
      $("#constraintsBox").removeClass("success")
      $("#constraintsBox").addClass("error")
      $("#constraintsMsg").html(constraints.error)
   else
      $("#constraintsBox").addClass("success")
      $("#constraintsBox").removeClass("error")
      $("#constraintsMsg").html("")
   window.punnettReq["constraints"] = constraints

window.loadDummy = -> 
   data = window[$("#crossNo").val()]
   $('#father').val(data["father"])
   $('#mother').val(data["mother"])
   $('#child').val(data["child"])
   $('#balancers').val(data["balancers"])
   $('#markers').val(data["markers"])
   $('#constraints').val(data["constraints"])

window.makePunnettRequest = ->  
   validateFly("father","M");
   validateFly("mother","F");
   validateChild();
   parseBalancers()
   parseMarkers()
   parseConstraints()
   
   for id,val of window.punnettReq
      if val.error
         alert ("First clear all the highlighted errors!")
         return
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
   
