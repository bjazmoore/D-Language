module rnd;

//My attempt to improve upon the randomness of Phobos
//   using the mir.random library.  A couple tricks are 
//   tossed in hoping to get better results.
//The get_rnd_range function will return an int between
//   the upper and lower values passed.  Pass a true bool
//   to see the random values being generated as the result
//   is determined. 
//The shuffle_array function is overloaded and accepts arrays of
//   int, double, char and string.  It will take the incoming
//   array and shuffle it randomly and return it shuffled.

import std.stdio;
import std.conv;
import mir.random;
import mir.random.engine;
import mir.random.engine.xorshift;
import std.datetime: Clock, UTC;




/// Int version of shuffle array
/// pass in a dynamic array of int (values do not need to be unique) - 
/// returns an array of int randomly reordered
int[] shuffle_array(int[] arr){

	int len = to!int(arr.length);
	int[] indexer = new int[len];
	int[] result = new int[len];

	if (len > 0) {
		indexer = build_indexer(indexer);
	} else {
		//if the array passed in had no elements - return a null
		return null;
	}

	//since we have a randomnized indexer - now lets reindex the array passed in
	foreach(i, val; arr){
		result[i] = arr[indexer[i]];
	}

	return result;

}


/// String version of shuffle array- 
/// pass in a dynamic array of strings (values do not need to be unique) - 
/// returns an array of int randomly reordered
string[] shuffle_array(string[] arr){

	int len = to!int(arr.length);
	int[] indexer = new int[len];
	string[] result = new string[len];

	if (len > 0) {
		indexer = build_indexer(indexer);
	} else {
		//if the array passed in had no elements - return a null
		return null;
	}

	//since we have a randomnized indexer - now lets reindex the array passed in
	foreach(i, val; arr){
		result[i] = arr[indexer[i]];
	}

	return result;

}


/// Char version of shuffle array- 
/// pass in a dynamic array of chars (values do not need to be unique) - 
/// returns an array of int randomly reordered
char[] shuffle_array(char[] arr){

	int len = to!int(arr.length);
	int[] indexer = new int[len];
	char[] result = new char[len];

	if (len > 0) {
		indexer = build_indexer(indexer);
	} else {
		//if the array passed in had no elements - return a null
		return null;
	}

	//since we have a randomnized indexer - now lets reindex the array passed in
	foreach(i, val; arr){
		result[i] = arr[indexer[i]];
	}

	return result;

}


/// Double version of shuffle array- 
/// pass in a dynamic array of doubless (values do not need to be unique) - 
/// returns an array of int randomly reordered
double[] shuffle_array(double[] arr){

	int len = to!int(arr.length);
	int[] indexer = new int[len];
	double[] result = new double[len];

	if (len > 0) {
		indexer = build_indexer(indexer);
	} else {
		//if the array passed in had no elements - return a null
		return null;
	}

	//since we have a randomnized indexer - now lets reindex the array passed in
	foreach(i, val; arr){
		result[i] = arr[indexer[i]];
	}

	return result;

}


/// This function creates an indexer array that is used for shuffling
private int[] build_indexer(int[] indexer){

	int len = to!int(indexer.length);

	if(len < 1){
		return null;
	}

	int[] source = new int[len];
	int value;

	for (int i=0 ; i < len ; ++i){
		source[i] = i;
	}

	for (int i=0 ; i < len ; ++i){
		do{
			value = get_rnd_range(0, len-1);
		} while (source[value] == -1);
		indexer[i] = value;
		source[value] = -1;
	}

	return indexer;

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
		result = cast(double)a/32_767.0;
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