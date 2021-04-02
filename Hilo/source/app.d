import std.stdio;
import std.string: strip;
import std.conv;
import std.random: uniform, Random;
import std.datetime: Clock, UTC;

///Structure to contain game level settings
struct Level{
		string name; ///name of the level
		int upper;   ///upper range of the level
	}

void main()
{
	
	string playername;
	int difficulty;
	int secret;
	int guesses;
	bool playing = true;

	Level[3] levels = [{"Mild",10},{"Normal",50},{"Spicy",500}];
	
	playername = get_player();

	//set up a loop to play multiple times
	while (playing){
		difficulty = get_difficulty(levels[]);
		writefln("You have chosen %s - you will be guessing a number between 1 and %s.", 
				levels[difficulty-1].name, levels[difficulty-1].upper);
		secret = choose_secret(levels[difficulty-1].upper);
		guesses = play_the_game(difficulty, secret,levels[difficulty-1].upper);

		writeln("\nCONGRATULATIONS!!!");
		writefln("The secret number was: %s, you guessed it in %s tries.",secret, guesses);

		playing = play_again();

	}

}

/// Query user to see if they want to play again
bool play_again(){

	char[] arrValue;
	bool result = false;
	string answer;

	write("\nDo you want to play agian (Y or N)?");
	readln(arrValue);
	// strip deletes the newline at the end of array
	arrValue =  strip(arrValue);
	//if there was no entry then the array length will be zero.
	if (arrValue.length > 0) {
		answer = to!string(arrValue);
		if (answer == "y" || answer == "Y"){
			result = true;
			writeln("");
		}
	}
	return result;

}

/// Randomly choose the secret between 1 and upperbnd (upper bound)
int choose_secret(int upperbnd){

	//Choose our random number
	auto rand = Random(Clock.currTime(UTC()).second);
	return uniform(1, upperbnd, rand);

}

/// The core of the game - the game play loop that queries the user for their guess
/// and evaluates it.
int play_the_game(int difficulty, int secret, int upperbnd){

	int cnt = 0;
	int guess = 0;

	//guess the secret numnber
	while (guess != secret){
		++cnt;
		writef("\nThis is guess number %s - ",cnt);
		guess = get_a_number("What is your guess? ",1, upperbnd);
		if (guess > secret){
			writefln("That guess (%s) was too high - try again.",guess);
		}
		if (guess < secret){
			writefln("That guess (%s) was too low - try again.", guess);
		}
	}

	return cnt;

}

/// get the player's name and greets them
string get_player(){

	char[] arrName;
	string yourname;

	writeln("Thank you for wanting to play Hi-Lo!");
	write("What's your name? ");
	readln(arrName);
	// strip deletes the newline at the end of array
	yourname = to!string(strip(arrName));
	writef("\nHello %s - ", yourname);
	//change the array of characters to a proper string
	return yourname;

} 

/// queries the user for the desired difficulty level
int get_difficulty(Level[] levels){

	int ub = to!int(levels.length);
	writeln("What difficulty do you want to play?");
	
	for (int x=0; x < ub; ++x) {
		writefln("(%s) %s", x+1, levels[x].name);
	}
	//writeln("(1) Mild\n(2) Normal\n(3) Spicy");
	return get_a_number("\nEnter a number (between 1 and 3): ", 1, 3);
}

/// general purpose routine for asking the user for a number - includes bounds checking
int get_a_number(string message, int lower=1, int upper=1){
	//gets a string, sanitizes it and returns it as a number if possible

	char[] arrValue;
	int value = -999;

	while (value < lower || value > upper){ 
		write(message);
		readln(arrValue);
		// strip deletes the newline at the end of array
		arrValue =  strip(arrValue);
		//if there was no entry then the array length will be zero.
		if (arrValue.length == 0) {
			value = -999;
			writeln("Please enter an numnber.");
		} else {
			value = to!int(arrValue);
			if (value < lower){
				writef("OUT OF RANGE: Enter a value higher than %s. ", lower);
			} else if (value > upper) {
				writef("OUT OF RANGE: Enter a value lower than %s. ", upper);
			}
		}

	}

	return value;
}