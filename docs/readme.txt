Flow
-----

RootViewController

PopBalloonAppDelegate

MenuLayer- shows "Tab to Play" and replaceScene to BalloonLayer.mm when clicked

BalloonLayer.mm:
    MenuLayer.mm
    Game.mm
        Balloon.mm

random
=======
The following will generate a number between 0 and 73 inclusive.
arc4random_uniform(74)