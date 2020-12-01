const { readFileSync } = require('fs');

// const input = [1721, 979, 366, 299, 675, 1456]
const inputFile = readFileSync('input.txt', { encoding: 'utf-8'});
const input = inputFile.split('\n').map(n => parseInt(n, 10));

const target = 2020;
function findPair(numbers = []) {
  for (let x = 0; x < numbers.length - 1; x++) {
    for (let y = x + 1; y < numbers.length; y++) {
      if (input[x] + input[y] === target) {
        return [input[x], input[y]];
      }
    }
  }
}

function findTriplet(numbers = []) {
  for (let x = 0; x < numbers.length - 2; x++) {
    for (let y = x + 1; y < numbers.length - 1; y++) {
      for (let z = y + 1; z < numbers.length; z++) {
        if (input[x] + input[y] + input[z] === target) {
          return [input[x], input[y], input[z]];
        }
      }
    }
  }
}


// Puzzle 1 
// const pair = findPair(input)
// console.log(JSON.stringify(pair) == JSON.stringify([1721, 299]), pair[0] * pair[1] === 514579)
// console.log(pair[0] * pair[1])

// Puzzle 2 
const triplet = findTriplet(input)
// console.log(JSON.stringify(triplet) == JSON.stringify([979, 366, 675]), triplet[0] * triplet[1] * triplet[2] === 241861950)
console.log(triplet, triplet[0] * triplet[1] * triplet[2])


