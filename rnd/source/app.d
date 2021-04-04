//My attempt to improve upon the randomness of Phobos
//   using the mir.random library.  A couple tricks are 
//   tossed in hoping to get better results.
//The get_rnd_range function will return an int between
//   the upper and lower values passed.  Pass a true bool
//   to see the random values being generated as the result
//   is determined. 

import std.stdio;
import mir.random;
import mir.random.engine;
import mir.random.engine.xorshift;
import std.datetime: Clock, UTC;


void main()
{
	int value;
	for (int i = 0; i < 100; ++i){
	   value = get_rnd_range(1, 10);
	   writefln("%s,",value);
	}
	
}

/// this is the heart of this module - it will return an int between the
///   upper and lower bounds (also passed as int). 
int get_rnd_range(int lower, int upper, bool verbose = false){
	
	short a = -1;
	int errs = -1;
	double result;
	
	//seed the random number generator
	auto gen = Xorshift(unpredictableSeed!uint);
	// we will take the nth result based on the number of seconds in the 
	//    current time.
	auto iterations = Clock.currTime(UTC()).second + 1;	
	
	for (int i = 0; i < iterations; ++i){
		do{
			// count how many iterations we run to get a positive number
			++errs;
			// aperently rand will return a negative value if the generator
			//    has not had enough cycles to create a random value
			a = gen.rand!short;
			//the loop repeats if the value of 'a' is not positive
		} while (a < 0);
		// convert the randomly generated value into a decimal 
		//    between 0 and 1 (exclusive)
		result = cast(double)a/32767.0;
		if (verbose){
			writefln("Loop: %s \tValue: %s \tErrors: %s",i,result,errs);
		}
		//reset the error counter to a negative number 
		errs = -1;
	}
	
	//now convert the winning random value to a number between the range
	//   specified by the calling program
	
	return  cast(int)((result*((cast(double)(upper + 1)) - (cast(double)lower))) + (cast(double)lower));
} 