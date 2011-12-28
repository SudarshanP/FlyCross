import cgi,re,json

from Flies import *
import dummyFlies

from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app


class MainPage(webapp.RequestHandler):
	def get(self):
		self.response.out.write("""
			<html>
			  <body>
			    <form action="/checkCross" method="post">
				   <div><textarea name="data" rows="5" cols="100">"""+json.dumps(dummyFlies.cross2)+"""</textarea></div>
				   </br>
				   <div><input type="submit" value="Check cross"></div>
			    </form>
			  </body>
			</html>""")

class CheckCrossReply(webapp.RequestHandler):
	def post(self):
		jsonDataFromCS=json.loads(cgi.escape(self.request.get('data')))
		index=jsonDataFromCS['index']
		compMatrix=jsonDataFromCS['compMatrix']
		balancers=jsonDataFromCS['balancers']
		markers=jsonDataFromCS['markers']
		updateLists(indexList=index,compMat=compMatrix,balancersList=balancers,markersList=markers)
		father=Fly(jsonDataFromCS['father'])
		mother=Fly(jsonDataFromCS['mother'])
		child=Fly(jsonDataFromCS['child'])

		punnettSqr=json.dumps(punnettDict(father,mother))

		#self.response.out.write('<html><body>You wrote:<pre>')
		self.response.out.write(punnettSqr)
		#self.response.out.write('</pre></body></html>')

application = webapp.WSGIApplication(
                                     [('/', MainPage),
                                      ('/checkCross', CheckCrossReply)],
                                     debug=True)

def main():
	run_wsgi_app(application)

if __name__ == "__main__":
	main()
