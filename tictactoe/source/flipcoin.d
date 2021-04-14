module flipcoin;

import std.stdio;
import rnd;
import std.conv;

///Side of a coin
enum Sides { heads = 1, tails}

///flip a coin - 
///    pass in number of flips as an int (default is 3)
///    pass in a bool as true if you want a report of the results of the flips
///         (default is false)
Sides flip_coin(int flips=3, bool verbose=false){

	int heads = 0;
	int tails = 0;
	int result;
	//int seed;

	///make sure flips is not negative
	(flips < 0) ? flips=1 : flips;
	//make sure total flips is an odd number - so there is no tie
	(flips%2 == 0) ? ++flips : flips; 
	for (int i = 0; i < flips; ++i){
		//use the mir.random based random function included in rnd.d
		result = get_rnd_range(1, 100_000);
		if (verbose) {
			//If verbose is enabled - summerize each interation
			writef("Round: %s - ",i+1);
			if (result % 2 == 1){
				writefln("Heads wins this time (%s)",result);
				++heads;
			} else {
				writefln("Tails wins this time (%s)",result);
				++tails;
			}
		} else {
			//if verbose is not enabled - just use the teneray operator 
			//   to increment the counters.
	   		(result % 2 == 1) ? ++heads : ++tails;
		}
	} 
	if (verbose){
		//If verbose is enabled - sumerize the entire process
		writefln("Flips: %s, heads: %s, tails: %s",flips,heads,tails);
	}
	return (heads > tails) ? Sides.heads : Sides.tails;
}
