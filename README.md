# ConnectFour
Connect Four Game for iOS. My first iOS App using Swift and XCode for iOS13. 

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

