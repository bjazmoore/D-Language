module rnd;

//My attempt to improve upon the randomness of Phobos
//   using the mir.random library.  A couple tricks are 
//   tossed in hoping to get better results.
//The get_rnd_range function will return an int between
//   the upper and lower values passed.  Pass a true bool
//   to see the random values being generated as the result
//   is determined. 

import std.stdio;
import std.conv;
import mir.random;
import mir.random.engine;
import mir.random.engine.xorshift;
import std.datetime: Clock, UTC;


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
	auto iterations = Clock.currTime(UTC()).second + 1;	 // @suppress(dscanner.suspicious.unmodified)
	
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
		result = cast(double)a / 32_767.0;
		if (verbose){
			//If verbose is enabled summerize the results from this iteration
			writefln("Loop: %s \tValue: %s \tErrors: %s",i,result,errs);
		}
		//reset the error counter to a negative number 
		errs = -1;
	}
	
	//now convert the winning random value to a number between the range
	//   specified by the calling program
	
	return  cast(int)((result*((cast(double)(upper + 1)) - (cast(double)lower))) + (cast(double)lower));
} 

/// An auxillary function that will shuffle an array of int:
/// pass in a dynamic array of int (values do not need to be unique) - 
/// returns an array of int randomly reordered
int[] shuffle_array(int[] arr){

	int len = to!int(arr.length);
	int[] indexer = new int[len];
	int[] result = new int[len];
	int value;

	if (len > 0) {
		//build an indexer array to be used for shuffling
		for (int i=0 ; i < len ; ++i){
			//flag to force while loop to cycle
			value = -214_7483_648;  
			while(value == -214_7483_648){
				//select a random value in the range of arr length
				value = get_rnd_range(0, len-1);
				//loop to see if that value is in use yet
				for (int j=0 ; j < i ; ++j ){
					if (indexer[j] == value){
						//value is in use - force the while loop to select another value and cycle again
						value = -214_7483_648;
						break;
					}
				}
			}
			indexer[i] = value;
		}
	} else {
		//if the array passed in had no elements - return a null
		return null;
	}

	//since we have a randomnized indexer now lets reindex the array passed in
	foreach(i, val; arr){
		result[i] = arr[indexer[i]];
	}

	return result;

}