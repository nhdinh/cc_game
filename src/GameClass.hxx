#include <iostream>
#include <string>

using namespace std;

#ifndef CC_GAME_GAMECLASS_HXX
#define CC_GAME_GAMECLASS_HXX


class GameClass {
public:
    GameClass();
    string ClassMessage();

private:
    string _classMessage;

};


#endif //CC_GAME_GAMECLASS_HXX
