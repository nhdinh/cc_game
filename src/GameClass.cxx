#include <iostream>
#include <string>

using namespace std;

#include "GameClass.hxx"

GameClass::GameClass() {
    _classMessage = "Hello from GameClass";
}

string GameClass::ClassMessage() {
    return this->_classMessage;
}
