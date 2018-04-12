pragma solidity ^0.4.17;

// @title Prototype contract for the place board and necessary functions
// @author Brandon Nieves
contract Proto {

	// This is a 2x2 board
	bytes1[2] board;
	// Need better variable name
	uint8 colorBit = 4;

	mapping(uint => address) blockIdToAddress;

	// constructor for this contract
	function Proto() public {

		// initialize the board as empty
		for(uint i; i < board.length; i++){
			board[i] = 0x00;
		}

	}

	// @param x is the x coordinate for the block to change color
	// @param y is the y coordinate for the block to change color
	// @param color is a 4 bit color that occupies half of the byte passed
	// @notice changeColor modifies board to the color designated
	function changeColor(uint x, uint y, bytes1 color) public validCoordinates(x, y) {

		uint offset = (board.length * x + y);
		uint byteIndex = offset / 2;
		uint bytePos = offset % 2;

		bytes1 result;

		blockIdToAddress[offset] = msg.sender;

		// Get the byte you're looking for, in storage
		bytes1 square = board[byteIndex];

		// if the color to change is at the back of the byte 
		if(bytePos == 0){

			// the front 4 bits of block are changing
			// left shift color 4 bits then or it with the last 4 bits of square
			bytes1 lastBits = lastNBits(square, 4);
			result = shiftLeft(color, 4) | lastBits;

		} else {

			// get only the first 4 bits of byte you're looking for
			// shift the 4 bits of square to the left then or it with color
			
			bytes1 firstBits = shiftRight(square, 4);
			result = shiftLeft(firstBits, 4) | color;

		}

		board[byteIndex] = result;

	}

	function getLatestVoter(uint x, uint y) public view validCoordinates(x, y) returns (address) {

		uint index = x + y;

		return blockIdToAddress[index];
	}

	
	function getColor(uint x, uint y) public view validCoordinates(x, y) returns (bytes1) {
		// coordinates must be valid in order to continue
		uint offset = (board.length * x + y);
		uint byteIndex = offset / 2;
		uint bytePos = offset % 2;

		bytes1 square = board[byteIndex];

		bytes1 result;

		// get the front 4 bits
		if(bytePos == 0){

			result = firstNBits(square, 4);

		} else {
			// get last 4 bits

			result = lastNBits(square, 4);

		}

		return result;

	}

	function shiftLeft(bytes1 bite, uint8 n) private pure returns (bytes1) {

		 uint8 aInt = uint8(bite);
		 uint8 shifted = aInt * 2 ** n;
		 return bytes1(shifted);
	}

	function shiftRight(bytes1 bite, uint8 n) private pure returns (bytes1) {
		uint8 bInt = uint8(bite);
		uint8 shifted = bInt / 2 ** n;
		return bytes1(shifted);
	}
	
	function firstNBits(bytes1 bite, uint8 n) private pure returns (bytes1) {

		bytes1 Ones = 0xff;
		bytes1 mask = shiftLeft(Ones, 8 - n);
		bite & mask;

		return bite;
	}

	function lastNBits(bytes1 bite, uint8 n) private pure returns (bytes1) {

		uint8 lastBits = uint8(bite) % 2 ** n;
		bytes1 res = bytes1(lastBits);
		return res;
	}

	function getBoard() public view returns (bytes1[2]) {
		return board;
	}

	modifier validCoordinates(uint x, uint y) {
		require((0 <= x) && (x <= (board.length - 1) ) && (0 <= y) && (y <= (board.length - 1)));
		_;
	}
}