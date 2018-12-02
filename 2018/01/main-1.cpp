#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main() {
  int freq = 0;
  string line;
  ifstream myInput ("input.txt");

  if (myInput.is_open()) {
    while (getline(myInput, line)) {
      int num = stoi(line.substr(1));
      if (line.at(0) == '+') {
        freq += num;
      } else {
        freq -= num;
      }
      cout << freq << endl;
    }
    myInput.close();
  }

  return 0;
}
