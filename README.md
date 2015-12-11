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

Setting it up is pretty simple, but there are some steps you need to follow. Simply go to [this site](https://git-scm.com/downloads) and click the button for the type of computer you have. Then, 