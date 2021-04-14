module main;

//implemetation of tic tac toe in the D language

import std.stdio;
import std.string: capitalize, strip;
import std.conv;
import std.uni;
import std.algorithm;
import std.traits;
import std.format;
/// Import 2 custom modules
import rnd;
import flipcoin;

/// Enumerate the players of the game 
enum Players {CPU = 1, HUMAN, NONE}
/// Enumerate the players of the game 
enum GameState {Playing = 1, Won, Draw}

/// Struct TicTacToe allows us to pass and receive complex game data
struct TicTacToe{
	/// an array of char to represent the board
	char[9] game_board;
	/// track game state - enumeration type
	GameState game_state;
	/// The marker (X or O) that the human will be using - determined by who goes first
	char marker_human;
	/// The marker (X or O) that the cpu will be using - determined by who goes first
	char marker_cpu;
	/// track which player is playing - enmueration type
	Players player;
}

void main()
{

	string player_name;
	string verb;
	bool gameloop = true;

	// create a TicTacToe object and set the game state to playing
	TicTacToe game;

	// Begin the game...
	writeln("Welcome!  We are playing Tic-Tac-Toe.");
	
	while(gameloop){

		//get the starting player
		game = get_start_player(game);
		
		//initializing the game board is easy
		game.game_board[] = ' ';
		game.game_state = GameState.Playing;

		//play progresses in 4.5 rounds
		for (int round = 1; round < 6; ++round){
			game = play_round(round, game);
			if (game.game_state != GameState.Playing) {
				// the game has ended - break out of the for loop
				break;
			}
		}

		//if game state is still playing then the game is actually a draw - no winner found
		game.game_state = (game.game_state == GameState.Playing) ? GameState.Draw : game.game_state;

		//end of play results
		display_game_board(false, game.game_board);
		writeln("The game is over!");
		if(game.game_state != GameState.Draw){
			player_name = (game.player == Players.CPU) ? "Computer" : "Human";
			verb = (game.player == Players.CPU) ? "Sorry" : "Congratulations";
			writefln("%s - It looks like the %s has won", verb, player_name);
		} else {
			writeln("No one has won - the game was a draw!");
		}

		writeln("\n");
		if (toUpper(get_input(["Y","y","N","n"],"Do you want to play again (Y or N)?  ")) != "Y"){
			gameloop = false;
		}

	}
	
}

/// When passed the game board array display the current state of the game
/// if plays (bool) is false the grid of available plays will not be displayed
void display_game_board(bool plays, char[9] game_board){

	if (plays){
		writeln("\n  Game Board: \tAvailable Plays");
	} else {
		writeln("\n  Game Board:");
	}
	for (int i=0; i < 9; i+= 3){
		write("  ");
		//print the game board as it is
		for (int j = 0; j < 3; ++j){
			writef(" %s ",game_board[i+j]);
			(j < 2) ? write("|") : write("\t  ");
		}
		//print the available moves board
		if (plays){
			for (int j = 0; j < 3; ++j){
				(game_board[i+j] != ' ') ? writef(" %s ",cast(char)250) : writef(" %s ",i+j);
				(j < 2) ? write("|") : write("\n");
			}
		} else {
			write("\n");
		}
		if (plays){
			(i < 6) ? writeln("  -----------\t  -----------") : writeln("");
		} else {
			(i < 6) ? writeln("  -----------") : writeln("");
		}
	}
}

/// This is the heart of the game - the play round function manages play state and player moves
TicTacToe play_round(int round, TicTacToe game){

	string[5] roundname = ["First","Second","Third","Fourth","Final"];
	int[6] phases = [0,2,2,2,2,1];

	writefln("\nThis is the %s round.",roundname[round-1]);

	for (int phase = 1; phase <=phases[round] ; ++phase){

		if (game.game_state == GameState.Playing){
			if (game.player == Players.CPU) {
				writeln("It is the Computer's turn.");
				game = computer_play(round, game);
				game.game_state = check_for_winner(game.game_board);
				(game.game_state == GameState.Playing) ? (game.player = Players.HUMAN) : true;
			}  else {
				writeln("It is the Human's turn.");
				display_game_board(true, game.game_board);
				game = human_play(round, game);
				game.game_state = check_for_winner(game.game_board);
				(game.game_state == GameState.Playing) ? (game.player = Players.CPU) : true;
			}
		}

	}
	

	return game;
}

/// convert the game board to a string matching the pattern 0,1,2,3,4,5,6,7,8,0,3,6,1,4,7,2,5,8,0,4,8,3,4,6
string convert_board(char[9] game_board){

	char[24] result;
	int[24] pattern = [0,1,2,3,4,5,6,7,8,0,3,6,1,4,7,2,5,8,0,4,8,2,4,6];

	for (int i=0 ; i < 24 ; ++i){
		result[i] = game_board[pattern[i]];
	}

    return to!string(result);
	
}

/// Checks the board for a winner - returns a GameState enumeration value
GameState check_for_winner(char[9] game_board){

	GameState state = GameState.Playing;

	string board = convert_board(game_board);

	//check horizontals
	state = (board[0..3] == "XXX" || board[0..3] == "OOO") ? GameState.Won : state;
	state = (board[3..6] == "XXX" || board[3..6] == "OOO") ? GameState.Won : state;
	state = (board[6..9] == "XXX" || board[6..9] == "OOO") ? GameState.Won : state;
	//check verticals
	state = (board[9..12] == "XXX" || board[9..12] == "OOO") ? GameState.Won : state;
	state = (board[12..15] == "XXX" || board[12..15] == "OOO") ? GameState.Won : state;
	state = (board[15..18] == "XXX" || board[15..18] == "OOO") ? GameState.Won : state;
	//check diaginals
	state = (board[18..21] == "XXX" || board[18..21] == "OOO") ? GameState.Won : state;
	state = (board[21..24] == "XXX" || board[21..24] == "OOO") ? GameState.Won : state;

	return state;

}

/// diagnostic routine - breaks the board string into easy to and easy to read string
string brk_board(string board){
	char[] result;
	result ~= '|';
	for (int i=0 ; i < board.length ; ++i){
		result ~= board[i];
		if ((i+1) % 3 == 0){
			result ~= '|';
		}
	}
	return to!string(result);
}

/// Find a move is used by the computer to locate BOTH a quick win and a defensive move
int find_a_move(char marker, string board){

	int play = -1;
	string left = format("%s%s ",marker,marker);
	string mid = format("%s %s",marker,marker);
	string right = format(" %s%s",marker,marker);

	//writefln("board = %s",brk_board(board));

	// pattern: [0,1,2][3,4,5][6,7,8][0,3,6][1,4,7][2,5,8][0,4,8][3,4,6]
	//check horizontals
	play = (board[0..3] == left) ? 2 : play;
	play = (board[0..3] == mid) ? 1 : play;
	play = (board[0..3] == right) ? 0 : play;
	play = (board[3..6] == left ) ? 5 : play;
	play = (board[3..6] == mid ) ? 4 : play;
	play = (board[3..6] == right ) ? 3 : play;
	play = (board[6..9] == left) ? 8 : play;
	play = (board[6..9] == mid) ? 7 : play;
	play = (board[6..9] == right) ? 6 : play;
	//check verticals
	play = (board[9..12] == left) ? 6 : play;
	play = (board[9..12] == mid) ? 3 : play;
	play = (board[9..12] == right) ? 0 : play;
	play = (board[12..15] == left) ? 7 : play;
	play = (board[12..15] == mid) ? 4 : play;
	play = (board[12..15] == right) ? 1 : play;
	play = (board[15..18] == left) ? 8 : play;
	play = (board[15..18] == mid) ? 5 : play;
	play = (board[15..18] == right) ? 2 : play;
	//check diaginals
	play = (board[18..21] == left) ? 8 : play;
	play = (board[18..21] == mid) ? 4 : play;
	play = (board[18..21] == right) ? 0 : play;
	play = (board[21..24] == left) ? 6 : play;
	play = (board[21..24] == mid) ? 4 : play;
	play = (board[21..24] == right) ? 2 : play;

	//writefln("Find_Move: %s",play); // <<<<<<
	return play;
}

/// This function processes the computer move - the AI
TicTacToe computer_play(int round, TicTacToe game){

	int play = -1;
	string board = convert_board(game.game_board);
	
	//                 0  1 2  3  4  5 6  7 8
	int[] op_corner = [8,-1,6,-1,-1,-1,2,-1,0];
	int[] corners = [0,2,6,8];

	//see if there is a quick win or defensive move (only if rouond > 1)
	if (round > 1){

		//look for the easy win
		play = find_a_move(game.marker_cpu, board);

		//look for a defensive move
		if (play == -1){
			play = find_a_move(game.marker_human, board);
		} 
	} 

	//writefln("1) Play = %s",play); // <<<<<<

	//offensive moves - depend on rouund and order of play
	if(play == -1 && round == 1){
		corners = shuffle_array(corners);
		for (int i=0; i<4 ; ++i){
			if(game.game_board[corners[i]] == ' '){
				play = corners[i];
				break;
			}
		}
	}
	//writefln("2) Play = %s",play);   // <<<<<<

	//special play for round 2
	if(play == -1 && round == 2){
		//find the corner the computer played in
		for (int i=0; i<4 ; ++i){
			if(game.game_board[corners[i]] == game.marker_cpu){
				//make sure that the opposite corner is free to play in
				if(game.game_board[op_corner[corners[i]]] == ' '){
					play = op_corner[corners[i]];
				}
				//either way we break out.
				break;
			}
		}
	}
	//writefln("3) Play = %s",play);  // <<<<<<

	//if we still dont have a play try for the middle space
	if(play == -1){
		if(game.game_board[4] == ' '){
			play = 4;
		}
	}
	//writefln("4) Play = %s",play);  // <<<<<<

	//Add a routine that will select any open corner before selecting randomly.
	if(play == -1){
		for (int i=0; i<4 ; ++i){
			if(game.game_board[corners[i]] == ' '){
				play = corners[i];
				break;
			}
		}
	}
	//writefln("5) Play = %s",play);  // <<<<<<

	//if we still dont have a play then simply select an available space at random
	if(play == -1){
		do{
			play = get_rnd_range(0, 8);
			//writefln("Random play %s - currently (%s)",play,game.game_board[play]); // <<<<<<
		}while(game.game_board[play] != ' ');
	}
	//writefln("6) Play = %s",play);  // <<<<<<

	//make the play
	writefln("Computer selects cell %s.\n",play);
	game.game_board[play] = game.marker_cpu;
	
	return game;
}

/// Allow the human to play
TicTacToe human_play(int round, TicTacToe game){

	string[9] plays;
	int cnt = 0;

	foreach (int i, c; game.game_board){
		if (c == ' '){
			plays[cnt] = to!string(i);
			++cnt;
		}
	}

	writefln("You are playing '%s' this game.",game.marker_human);
	string user_response = (get_input(plays,"Please select a cell for your move. "));
	int cell = to!int(user_response);
	game.game_board[cell] = game.marker_human;

	return game;
}

/// function to determine who will be the starting player.  
/// borrowed from an earlier program to simply flip a coin.
TicTacToe get_start_player(TicTacToe game){

	string user_response;
	string verb;
	string winner;

	writeln("\nWe will flip a coin to see who goes first.");
	user_response = (toUpper(get_input(["T","t","H","h"],"Please type (H) for heads or (T) for tails? ")));
	
	//flip the coin by calling the flip_coin function in flipcoin.d
	Sides side = flip_coin(3);
	winner = capitalize(to!string(side));

	//Use startsWith to see if the response matches the flipped coin
	if (startsWith(winner, user_response) == 1){
		verb = "WIN";
		game.player = Players.HUMAN;
		game.marker_cpu = 'O';
		game.marker_human = 'X';
	} else {		
		verb = "LOSE";
		game.player = Players.CPU;
		game.marker_cpu = 'X';
		game.marker_human = 'O';
	}

	//report the results
	writefln("It was %s - you %s", winner, verb);
	writefln("You will play %s and I will play %s.", game.marker_human, game.marker_cpu);

	return game;
}

/// General function to get user input from STDIN and return it as a string
string get_input(string[] validvals, string message = ""){

	char[] arrValue;
	string answer = "";

	if (message.length > 0){
		write(message);
	}
	//we will not return an empty string - loop until we have a value
	while (true){
		readln(arrValue);
		// strip deletes the newline at the end of array
		arrValue =  strip(arrValue);
		//conver the returned array of char to a string
		answer = to!string(arrValue);
		//if there was no entry then the array length will be zero.
		if (arrValue.length == 0){
		 	if (message.length > 0){
				write("I did not get that - please try again:");
			 }
		} else { 
			if (validvals.length > 0){
				// if an array of valid answers was passed in - see if the user response is in it
				if (canFind(validvals[],answer)){
					break;
				} else {
					// only print an error message if there was a user message passed in
					if (message.length > 0){
						writef("Invalid Input - %s", message);
					}
				}
			} else {
				//if there was no array of valid answers - just return this answer
				if (answer.length < 1) {
					break;
				}
			}
		}
	}
	return answer;
}