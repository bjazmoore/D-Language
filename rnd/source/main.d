module main;

/// Examples of using the functions in the rnd.d module

import std.stdio;
import rnd;


void main()
{
	int value;
	for (int i = 0; i < 20; ++i){
	   value = get_rnd_range(1, 10);
	   //writefln("%s,",value);
	}

	int[] arr = [0,0,2,2,4,4,6,6,8,8];
	int[] result = shuffle_array(arr);
	writefln("%s\n%s",arr,result);

	string[] sarr = ["One", "Two","Three","Four","Five"];
	string[] sresult = shuffle_array(sarr);
	writefln("%s\n%s",sarr,sresult);

	char[] carr = ['a','b','c','d','e','f','g','h'];
	char[] cresult = shuffle_array(carr);
	writefln("%s\n%s",carr,cresult);
	
	double[] darr = [1.23,2.34,3.45,4.56,5.67,6.78,7.89,8.9,9.0];
	double[] dresult = shuffle_array(darr);
	writefln("%s\n%s",darr,dresult);
	
}