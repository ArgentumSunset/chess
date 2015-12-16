# Ruby Chess

Pretty self-explanatory, honestly. Just chess made in Ruby, with the Gosu Gem used for underlying rendering and drawing purposes.

## Rules of Chess
(For those who don't know how to play)

There are two teams, black and white, each with a king, a queen, two bishops, two knights, two rooks, and eight pawns.

- Kings can move one space in any direction (but not diagonally). They are your most important pieces; don't put them at risk.
- Queens can move across the board both diagonally and vertically / horizontally. Queens are the most powerful pieces on the board.
- Rooks can move vertically and horizontally. They're also known as castles.
- Bishops can move diagonally in any direction.
- Knights move in an "L" shape, like one space up and two to the left, or two up and one to the right. Knights are the only pieces that can skip over other pieces; they don't have to stop behind a piece and wait.
- Pawns are kind of complicated. Usually, they can only move forward one space. If there is an opposing piece on the space forward and to the side, though (diagonally ahead one space) then they can take it. They can also move two spaces forward at the start of the game. Note: If a pawn reaches your opponent's end of the board (the row their king starts in) then they turn into another queen.

If a piece from the other side has the ability to take your king (your king is in its line of fire) then your king is in **check**. You must move your king or block the checking piece with one of yours to get out of check.

If your king can't move out of check and you don't have any pieces to block with, then you are in **checkmate** and the other team wins the game. Kings can't actually be taken; checkmating is the winning move.

And remember: White always moves first.

## Setup

Setting it up is pretty simple, but there are some steps you need to follow. First, either go to your friendly local command line application (or Terminal for Mac) or download Git Bash from [this site](https://git-scm.com/downloads), right-click on your desktop background, and click the 'Open Git Bash Here' option. Once you have the command line open, navigate to the folder you want to put the chess program into and paste the following commands: 

```sh
$ git clone https://github.com/ArgentumSunset/chess.git chess
$ cd chess
```

This will clone the chess project into a new folder called 'chess' and navigate you into that folder. Now, all you need to do is paste this command to run the program:

```sh
$ ruby main.rb
```

And you're done!

## Problems I Encountered While Making This

I did not realize what a * horrifying, horrifying idea * it was to make chess when I came up with the idea to do so. My biggest problem revolved around getting checkmate to work. See, there are four basic conditions to checkmate that I had to focus on:

- 1. The king is in check.
- 2. The king cannot move out of check (i.e. to either side)
- 3. No other piece on the king's team can block the check
- 4. If the checking piece is within the king's move radius, it must be protected by another piece on its team.

Doing this was incredibly hard, and at best the checkmate function I made is a rough approximation. It satisfies conditions 1, 2, and 4, and does so admirably, but my blocking function only works incredibly well for bishops and queens, and I feel like I could have made this a lot better. But still, given the amount of time I had to work with, I think my chess game is fairly good.


Checking was a total pain.

	I didn't want to have to actually make a whole lot of functions that would undo a move if that move did not lead to a king's going out of check, so instead I made a function that simply says "White (or black) did not contest the check on them, therefore they forfeit by default." As good an incentive as any, I suppose, and it doesn't really detract from the overall game.

Pawns suck. They really, really suck.

# Overview

I feel like I deserve an A on this project because not only is it based on sound logic and extensive knowledge of Ruby methods, objects, and logical iterators, but it also is quite a successful one when one considers the complexity and ambition of what I was attempting to do.







