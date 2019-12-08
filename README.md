# ConnectFour
Connect Four Game for iOS

<img src="https://i.imgur.com/Q3vtoK8.png" width="246"> <img src="https://i.imgur.com/yXjG5xD.png" width="246"> <img src="https://i.imgur.com/FxZTzc1.png" width="250">

## Goal
This is an iOS Application implemention of the popular Connect Four game.

## To play the game
1. Tap on the column where you want to place your token.  The game will wait for you to tap on a non-full column before proceeding to the second player's turn.
2. Phone will then place its token 1 second later
3. Repeat steps 1-2 until a pattern is formed.
4. If no pattern forms and grid is full, "its a tie!" message will appear and no one get a point.
5. Tap "New Game" to start a new game while maintaining current scores.
6. Tap "Reset Game & Stats" to reset the Player's and AI's scores.

### A pattern is formed and a winner is declared if one of the following happens:
1. Four same colored tokens connect consecutively in the horizontal direction
2. Four same colored tokens connect consecutively in the vertical direction.
3. Four same colored tokens connect diagnoally.

## Usage
1. Clone this repo
2. Open it in XCode (I used XCode 11.1 on MacOS 10.15.1)
3. Run on iPhone 11 simulator

## Assumptions made
### A few asumptions were made during the implementation of this game. However, the code is designed in a way such that it would be easy to acommodate most of the following limitations: 
1. No more than two players.
2. Players can't pick colors or names.
3. Human player will always go first.
4. AI player will always play exactly one second after human player does.
5. There is no indication (e.g. label) to indicate whose turn it is.
6. Token drop-down animation is non-blocking. This means human player can play their turn while the AI's token is still traveling down to its position. Human player cannot overtake AI's token position. Human player cannont play during the one second timeout while waiting for AI to make their move.

### Optimizations & TODOs
1. Optimize the way we look for patterns. Current implementaion is O(row*column*K) time. Can definetly be optimized to O(K) where K = 4 (number of tokens that need to match to declare winner)
2. Make animation blocking. Add callbacks to send a notification to ViewController when animation is done to swap players' turns. Current animation implementation does not block player from playing while AI's token is moving down.
