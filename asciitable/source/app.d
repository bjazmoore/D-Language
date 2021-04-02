import std.stdio;
import std.ascii;
import std.algorithm.searching;

//this D language program just prints out the extended ascii
//table in columns of 8.


void main(){

    int cnt = 0;

    for( int a = 1; a < 255; a = a + 1 ) {
		//filter out the characters that do not print well
        if (canFind([7,8,9,10,11,12,13,27],a) == false) {
            writef(" (%3s) %s ", a, cast(char)a);
            ++cnt;
            if (cnt%8 == 0) {
                writeln("");
            }
        }
    }

}
