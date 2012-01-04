### Working version is up and running at http://flycrosser.appspot.com

A webapp(on google appengine) to check drosophila crosses

#### Context:
In many routine Drosophila crosses set up in research labs, it is important to know if the intended genes are passed down to the progeny. This is done using markers that are added along with the gene, or in trans with it. But in some cases, the same phenotype could arise out of different genotypes. In a usual fly lab scenario, this is unfravourable, as there is no one-isto-one relationship between genoptype and phenotype. This tool is designed to show the user when such phenotype clashes occur.

Another common cause of concern is genetic recombination. Genetic recombination is often undesirable in crosses set up in the lab, and balancer chromosomes are used widely to prevent this. The tool also shows when such recombinations will occur.

#### Meant for:
- students still getting the hang of drosophila crosses
- seasoned researchers, who want an easy confirmation that their complex cross strategies dont have phenotype clashes.

#### What this is NOT:
- a typical mendelian genetics based punnett square generator (It doesnt take care of recombination, it just warns that its going to happen)
- a teaching tool for mendelian genetics

#### Summary for other coders:
- The server side of the code is python and does the core genetics-ey stuff, to produce the core punnetSquare data
- The client side uses jQuery, handlebars templates and coffeeScript. It mainly does ui stuff and parsing of the input genotypes
