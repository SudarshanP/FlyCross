window.parseDad = -> 
   m = parseFly($('#dad').val(),"M")
   #alert(JSON.stringify(m))
   $('#oDad').html(geneHtml(m.fly))
   window.punnettReq["father"] = m["fly"]
window.parseMom = -> 
   f = parseFly($('#mom').val(),"F")
   $('#oMom').html(geneHtml(f.fly))
   window.punnettReq["mother"] = f["fly"]
window.parseKid = -> 
   k = parseFly($('#kid').val())
   $('#oKid').html(geneHtml(k.fly))
   window.punnettReq["child"] = k["fly"]
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
   $('#dad').val(data["father"])
   $('#mom').val(data["mother"])
   $('#kid').val(data["child"])
   $('#balancers').val(data["balancers"])
   $('#markers').val(data["markers"])
   $('#constraints').val(data["constraints"])

window.makePunnett = ->
   
   parseDad()
   parseMom()
   parseKid()   
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
