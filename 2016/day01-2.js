var raw = "L4, L3, R1, L4, R2, R2, L1, L2, R1, R1, L3, R5, L2, R5, L4, L3, R2, R2, L5, L1, R4, L1, R3, L3, R5, R2, L5, R2, R1, R1, L5, R1, L3, L2, L5, R4, R4, L2, L1, L1, R1, R1, L185, R4, L1, L1, R5, R1, L1, L3, L2, L1, R2, R2, R2, L1, L1, R4, R5, R53, L1, R1, R78, R3, R4, L1, R5, L1, L4, R3, R3, L3, L3, R191, R4, R1, L4, L1, R3, L1, L2, R3, R2, R4, R5, R5, L3, L5, R2, R3, L1, L1, L3, R1, R4, R1, R3, R4, R4, R4, R5, R2, L5, R1, R2, R5, L3, L4, R1, L5, R1, L4, L3, R5, R5, L3, L4, L4, R2, R2, L5, R3, R1, R2, R5, L5, L3, R4, L5, R5, L3, R1, L1, R4, R4, L3, R2, R5, R1, R2, L1, R4, R1, L3, L3, L5, R2, R5, L1, L4, R3, R3, L3, R2, L5, R1, R3, L3, R2, L1, R4, R3, L4, R5, L2, L2, R5, R1, R2, L4, L4, L5, R3, L4";

var visited = [];

function visit(x, y) {
	coord_str = x + "," + y;
	// console.log(coord_str);
	if (visited.indexOf(coord_str) === -1) {
		visited.push(coord_str);
		return false;
	} else {
		return true;
	}
}

function convertRawInputToInstructions(input) {
	var raw_array = input.split(", ");
	return raw_array.map(function(item) {
		return {
			direction: item.charAt(0) === "L" ? -1 : 1,
			steps: parseInt(item.slice(1)),
		};
	});
}

function distance(coordinates) {
	return Math.abs(coordinates.x) + Math.abs(coordinates.y);
}

function Player(instructions) {
	return {
		instructions: instructions,
		state: {facing: 0, x: 0, y: 0},

		run: function () {

			return this.instructions.reduce(function(state, instruction) {

				state.facing += instruction.direction;

				switch (state.facing) {
					case -1:
						state.facing = 3;
						break;
					case 4:
						state.facing = 0;
						break;
				}

				switch (state.facing) {
					case 0:
						while (instruction.steps--) {
							if (visit(state.x, ++state.y)) {
								console.log(state);
								// return state;
							}
						}
						break;
					case 1:
						while (instruction.steps--) {
							if (visit(++state.x, state.y)) {
								console.log(state);
								// return state;

							}
						}
						break;
					case 2:
						while (instruction.steps--) {
							if (visit(state.x, --state.y)) {
								console.log(state);
								// return state;

							}
						}
						break;
					case 3:
						while (instruction.steps--) {
							if (visit(--state.x, state.y)) {
								console.log(state);
								// return state;
							}
						}
						break;
				}

				return state;

			}, this.state);

		},

	};
}


var instructions = convertRawInputToInstructions(raw);
var me = new Player(instructions);
var state = me.run();

// console.log(distance(state));

