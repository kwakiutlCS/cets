var engine = {

    depth: 1,

    puzzle: 1,

    // gets all the possible moves in the board in a [["e2","e4"],["d2","d4"], ... ] format
    getPossibleMoves: function(position, turn) {
	 var moves = [];
	 
	 if (turn === "white") {
	     for (var k in position) {
		  
		  if (position[k] === position[k].toUpperCase()) {
		      var partialMoves = [];
		      
		      var possibleMoves = chessBoard.filterIllegalMoves(k, chessBoard.getPossibleMoves(k,position), "black", position, "-");

		      for (var m in possibleMoves) {
			   partialMoves.push([k,possibleMoves[m]]);
		      }

		      for (var m in partialMoves) {
			   moves.push(partialMoves[m]);
		      }
		  }
	     }
	 }
	 else if (turn === "black") {
	     for (var k in position) {
		  
		  if (position[k] === position[k].toLowerCase()) {
		      var partialMoves = [];
		      
		      var possibleMoves = chessBoard.filterIllegalMoves(k,chessBoard.getPossibleMoves(k,position), "white", position, "-");

		      for (var m in possibleMoves) {
			   partialMoves.push([k,possibleMoves[m]]);
		      }

		      for (var m in partialMoves) {
			   moves.push(partialMoves[m]);
		      }
		  }
	     }
	 }

	 return moves;
    
    },


    getEvaluation: function(pos, turn, depth, opposition, puzzle, type) {
	 var opposition = opposition || false;
	 opposition = opposition ? opposition[1] : false;
	 var type = type || "stupid";

	 var other = turn === "black" ? "white" : "black";
	 
	 if (depth === 1) {
	     var possibleMoves = this.getPossibleMoves(pos, turn);
            possibleMoves.sort(function() {return 0.5 - Math.random()}) 
	    
	     var score, opponent_pos, m, r, possibleResponses, finalPosition, bestMove=false, bestScore, avgScore;

	     for (var move in possibleMoves) {
                bestScore = false;
		  avgScore = 0;

		  m = possibleMoves[move];
		  opponent_pos = chessBoard.generateNewPosition(m[0], m[1], "-", pos);
		  
		  if (puzzle === 14) {
		      score = this.getPPHeuristic(opponent_pos, turn);
		      
		      if (turn === "white") {
			   if (!bestMove || score > bestMove[1])
				bestMove = [m,score];
                    }
                    else {
			   if (!bestMove || score < bestMove[1])
				bestMove = [m,score];
                    }
		      
		  }

		  else if (!opposition) {
		      var heuristicFunction = this.getHeuristic;
		      
		      possibleResponses = this.getPossibleMoves(opponent_pos, other);
                    for (var response in possibleResponses) {
			   r = possibleResponses[response];
			   finalPosition = chessBoard.generateNewPosition(r[0], r[1], "-", opponent_pos);
			   
			   score = heuristicFunction(finalPosition, turn); 
			   avgScore += score;
			   if (!bestScore)
				bestScore =  score;
			   else if (turn === "white")
				bestScore = score < bestScore ? score : bestScore;
			   else if (turn === "black")
				bestScore = score > bestScore ? score : bestScore;
		      }
		      avgScore /= possibleResponses.length;
		  
		      score = type === "stupid" ? avgScore : bestScore;
		  
		      if (turn === "white") {
			   if (!bestMove || score > bestMove[1])
				bestMove = [m,score];
                    }
                    else {
			   if (!bestMove || score < bestMove[1])
				bestMove = [m,score];
                    }
                }
		  else if (opposition) {
		      score = this.getPartialHeuristic(opponent_pos, turn, opposition);
		      
		      if (turn === "white") {
			   if (!bestMove || score > bestMove[1])
				bestMove = [m,score];
                    }
                    else {
			   if (!bestMove || score < bestMove[1])
				bestMove = [m,score];
                    }
		      
		  }
	     }
	     
	     return bestMove;
	 }

	 
	 
	 
	 
    },




    getHeuristic: function(position,turn) {
	 var score = 0;
	     
	 var result = chessBoard.getResult(position,turn,"-");
	 
	 if (result === "white")
	     return 1000;
	 else if (result === "black")
	     return -1000;
	 else if (result === "draw")
	     return 0;

	 var pieceValue = {"K":0, "Q":8.5, "R": 4.5, "B":3, "N":2.5, "P":1, "k":0, "q":-8.5, "r": -4.5, "b":-3, "n":-2.5, "p":-1 };  
	 
	 for (var k in position) 
	     score += pieceValue[position[k]];
	 
	 score += engine.manClosestPiece(position,turn);
	 
	 return score;
    },

    
    getPPHeuristic: function(position, turn) {
	 var result = chessBoard.getResult(position,turn,"-");
	 
	 if (result === "white")
	     return 1000;
	 else if (result === "black")
	     return -1000;
	 else if (result === "draw")
	     return 0;

	 var score = turn === "black" ? 50 : -50;
	 var pawn, square, wk, bk, king;
	 var rows = {"a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8};
	 
	 for (var k in position) {
	     if (position[k].toLowerCase() === "p")
		  pawn = k;
	     else if (position[k] === "k")
		  bk = k;
	     else if (position[k] === "K")
		  wk = k;
	 }

	 if (typeof pawn === "undefined") {
	     if (turn === "black")
		  return 1000;
	     else 
		  return -1000;
	 }
	     
	 square = turn === "black" ? pawn[0]+"8" : pawn[0]+"1";
	 king = turn === "black" ? bk : wk;

	 score = turn === "black" ? score-0.2/(Math.abs(rows[king[0]]-rows[square[0]])+1) : score+0.2/(Math.abs(rows[king[0]]-rows[square[0]])+1);
	 
	 if (Math.abs(rows[king[0]]-rows[square[0]]) > Math.abs(parseInt(square[1])-parseInt(pawn[1])))
	     score = turn === "black" ? 1000 : -1000;
	 
	 

	 if (wk[0] === bk[0] && Math.abs(parseInt(wk[1])-parseInt(bk[1])) === 2)
	     score = turn === "black" ? score-5 : score+5;
	 if (wk[0] === bk[0] && Math.abs(parseInt(wk[1])-parseInt(bk[1])) === 4)
	     score = turn === "black" ? score-2 : score+2;
	 if (wk[0] === bk[0] && Math.abs(parseInt(wk[1])-parseInt(bk[1])) === 6)
	     score = turn === "black" ? score-1 : score+1;

	 var bx = Math.abs(rows[bk[0]]-rows[pawn[0]]);
	 var by = Math.abs(parseInt(bk[1]-parseInt(pawn[1])));
	 bMaxDistance = Math.sqrt(bx*bx+by*by);
	 var wx = Math.abs(rows[wk[0]]-rows[pawn[0]]);
	 var wy = Math.abs(parseInt(wk[1]-parseInt(pawn[1])));
	 wMaxDistance = Math.sqrt(wx*wx+wy*wy);

	 
	 score = turn === "black" ? score-1./bMaxDistance : score+1./wMaxDistance;

	 
	 if (turn === "black") 
	     score = wMaxDistance > bMaxDistance ? score-8 : score;
	 else 
	     score = bMaxDistance > wMaxDistance ? score+8 : score;

	 
	 if (turn === "black") {
	     if (parseInt(king[1]) < parseInt(pawn[1]))
		  score = 1000;
	     else if (parseInt(king[1]) === parseInt(pawn[1]) && wMaxDistance < 2*bMaxDistance)
		  score = 1000;
	 }
	 else {
	     if (parseInt(king[1]) > parseInt(pawn[1]))
		  score = -1000;
	     else if (parseInt(king[1]) === parseInt(pawn[1]) && bMaxDistance < 2*wMaxDistance)
		  score = -1000;
	 }

	 return score;
	 
    },



    getPartialHeuristic: function(position,turn,opposition) {
	 
	 var score = turn === "white" ? this.getOppositionScore(position, turn,opposition) : -this.getOppositionScore(position, turn, opposition);
	 score += this.manSquare(position,turn,opposition);
	 
	 return score;
    },

    

    

    manClosestPiece: function(pos, turn) {
	 var kingSquare;
	 if (turn === "white") {
	     for (var k in pos) {
		  if (pos[k] === "K") {
		      kingSquare = k;
		      break;
		  }
	     }	  
	 }
	 else {
	     for (var k in pos) {
		  if (pos[k] === "k") {
		      kingSquare = k;
		      break;
		  }
	     }	  
	 }
	 
	 var rows = {"a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8};
	 var row = rows[kingSquare[0]];
	 var col = parseInt(kingSquare[1]);
	 var bigger = 14;
	 var tmp;

	 if (turn === "white") {
	     
	     for ( var k in pos ) {
		  
		  if (pos[k].toLowerCase() === pos[k] && pos[k] !== "k") {
		      tmp = Math.abs(rows[k[0]]-row)+ Math.abs(parseInt(k[1])-col);
		      bigger = tmp < bigger ? tmp : bigger;
		  }
		      
	     }
	 }

	 if (turn === "black") {
	     
	     for ( var k in pos ) {
		  
		  if (pos[k].toUpperCase() === pos[k] && pos[k] !== "K") {
		      tmp = Math.abs(rows[k[0]]-row)+ Math.abs(parseInt(k[1])-col);
		      bigger = tmp < bigger ? tmp : bigger;
		  }
		      
	     }
	 }
	 
	 var result = turn === "white" ? 0.2/bigger : -0.2/bigger;
	 
	 return result;
    },



    


    manSquare: function(pos, turn, square) {
	 
	 var kingSquare;
	 if (turn === "white") {
	     for (var k in pos) {
		  if (pos[k] === "K") {
		      kingSquare = k;
		      break;
		  }
	     }	  
	 }
	 else {
	     for (var k in pos) {
		  if (pos[k] === "k") {
		      kingSquare = k;
		      break;
		  }
	     }	  
	 }
	 
	 var rows = {"a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8};
	 var row = rows[kingSquare[0]];
	 var col = parseInt(kingSquare[1]);
	 

	 var result = Math.abs(rows[square[0]]-row)+ 1.1*Math.abs(parseInt(square[1])-col)+1;
	 result = turn === "white" ? 10./result : -10./result;
	 
	 return result;
    },


    getOppositionScore: function(pos, turn, square) {
	 var kingSquare, opponent;
	 if (turn === "white") {
	     for (var k in pos) {
		  if (pos[k] === "K") {
		      kingSquare = k;
		  }
		  if (pos[k] === "k") {
		      opponent = k;
		  }
	     }	  
	 }
	 else {
	     for (var k in pos) {
		  if (pos[k] === "k") {
		      kingSquare = k;
		  }
		  if (pos[k] === "K") {
		      opponent = k;
		  }
	     }	  
	 }

	 var rows = {"a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8};
	 var row = rows[kingSquare[0]];
	 var opprow = rows[opponent[0]];
	 var col = parseInt(kingSquare[1]);
	 var oppcol = parseInt(opponent[1]);
	 var score = 0;

	 if (Math.abs(row-opprow) % 2 === 0 && Math.abs(col-oppcol) % 2 === 0)
	     score = 1;
	 if (row === opprow && Math.abs(square[1] - col) <= Math.abs(square[1] - oppcol)) {
	     score *= 100;
	 }
	 if (col === oppcol && Math.abs(rows[square[0]] - row) <= Math.abs(rows[square[0]] - opprow)) {
	     score *= 100;
	 }

	 return score;
    },
}


