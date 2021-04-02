import std.stdio;
import std.string: capitalize;
import std.conv;
import std.random: uniform, Random;
import std.datetime: Clock, UTC;

///Side of a coin
enum Sides { heads = 1, tails}

void main()
{
	Sides side = flip_coin(31, true);
	string winner = to!string(side);
	writefln("%s wins!", capitalize(winner));
}

///flip a coin - 
///    pass in number of flips as an int (default is 3)
///    pass in a bool as true if you want a report of the results of the flips
///         (default is false)
Sides flip_coin(int flips=3, bool verbose=false){

	int heads = 0;
	int tails = 0;

	//make sure flips is not negative
	(flips < 0) ? flips=1 : flips;
	//make sure total flips is an odd number - so there is no tie
	(flips%2 == 0) ? ++flips : flips; 
	auto rand = Random(Clock.currTime(UTC()).second);
	for (int i = 0; i < flips; ++i){
	   (uniform(0, 2000, rand) % 2 == 1) ? ++heads : ++tails;
	}
	if (verbose != false){
		writefln("Flips: %s, heads: %s, tails: %s",flips,heads,tails);
	}
	return (heads > tails) ? Sides.heads : Sides.tails;
}
