all: squares recurse covidtracker

clean:
	rm -f squares recurse covidtracker

squares: squares.c
	g++ -g -o $@ $<

recurse: recurse.c
	g++ -g -o $@ $<

covidtracker: covidtracker.c
	g++ -g -o $@ $<
