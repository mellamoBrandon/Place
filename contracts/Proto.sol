pragma solidity ^0.4.17;

/// @title Prototype contract for an rplace game
/// @author Brandon Nieves
/// @dev Protoype contract that keeps track of the board and it's 4-bit colors
contract Proto {

	// 2x2 board
	bytes1[2] board;

	// every 4-bit color mapped to an address
	mapping(uint => address) blockIdToAddress;

	/// @notice Creates the main Proto smart contract instance
	function Proto() public {

		// point all blockIds to 0 initially
		for(uint i; i < (board.length * board.length); i++){
			blockIdToAddress[i] = address(0);
		}

	}

	/// @param _x is the x coordinate of the block to change color
	/// @param _y is the y coordinate of the block to change color
	/// @param _color is a 4 bit color that occupies half of the byte passed
	/// @notice changeColor modifies board to the color designated
	function changeColor(uint _x, uint _y, bytes1 _color) public validCoordinates(_x, _y) {

		// @dev offset is used to get the index of the block for the board and is also the id for blockIdToAddress
		uint offset = (board.length * _x + _y);
		uint byteIndex = offset / 2;
		// bytePos will be 0 if the 4-bit color is the first 4 bits
		uint bytePos = offset % 2;

		bytes1 result;

		// Set the address mapped to the id as the sender
		blockIdToAddress[offset] = msg.sender;

		// Get the byte associated with the given x, y coordinates
		bytes1 square = board[byteIndex];

		// If the color to change is in the first 4 bits
		if(bytePos == 0){

			// Keep the last 4 bits
			bytes1 lastBits = lastNBits(square, 4);
			// Left shift the 4 bits of the new color and OR it with the last 4
			// bits of the existing byte
			result = shiftLeft(_color, 4) | lastBits;

		} else {

			// Keep the first 4 bits
			bytes1 firstBits = shiftRight(square, 4);
			// Left shift the first 4 bits and OR it with the new color
			result = shiftLeft(firstBits, 4) | _color;

		}

		// Set the new byte as the result from above
		board[byteIndex] = result;

	}

	/// @notice Returns the address that changed the square, given x and y coordinates, most recently
	function getLatestVoter(uint _x, uint _y) public view validCoordinates(_x, _y) returns (address) {

		uint index = board.length * _x + _y;

		return blockIdToAddress[index];
	}

	/// @notice Returns the 4-bit color of a square in the board, given x and y coordinates
	function getColor(uint _x, uint _y) public view validCoordinates(_x, _y) returns (bytes1) {
		// coordinates must be valid in order to continue
		uint offset = (board.length * _x + _y);
		uint byteIndex = offset / 2;
		uint bytePos = offset % 2;

		bytes1 square = board[byteIndex];

		bytes1 result;

		if(bytePos == 0){

			// Get the first 4 bits
			result = firstNBits(square, 4);

		} else {

			// Get the last 4 bits
			result = lastNBits(square, 4);

		}

		return result;

	}

	/// @notice Given a byte(bite), shift it n bits to the left
	function shiftLeft(bytes1 _bite, uint8 _n) private pure returns (bytes1) {

		 uint8 aInt = uint8(_bite);
		 uint8 shifted = aInt * 2 ** _n;
		 return bytes1(shifted);
	}

	/// @notice Given a byte(bite), shift it n bits to the right
	function shiftRight(bytes1 _bite, uint8 _n) private pure returns (bytes1) {

		uint8 bInt = uint8(_bite);
		uint8 shifted = bInt / 2 ** _n;
		return bytes1(shifted);
	}

	/// @notice Given a byte(bite), return the first n bits
	function firstNBits(bytes1 _bite, uint8 _n) private pure returns (bytes1) {

		// byte with the value 11111111
		bytes1 Ones = 0xff;
		bytes1 mask = shiftLeft(Ones, 8 - _n);
		_bite & mask;

		return _bite;
	}

	/// @notice Given a byte(bite), return the last n bits 
	function lastNBits(bytes1 _bite, uint8 _n) private pure returns (bytes1) {

		uint8 lastBits = uint8(_bite) % 2 ** _n;
		bytes1 res = bytes1(lastBits);
		return res;
	}


	/// @notice Returns the board the game is being played on
	function getBoard() public view returns (bytes1[2]) {
		return board;
	}

	/// @notice Modifier that requires given x and y coordinates are valid in the board
	modifier validCoordinates(uint x, uint y) {
		require((0 <= x) && (x <= (board.length - 1) ) && (0 <= y) && (y <= (board.length - 1)));
		_;
	}
}