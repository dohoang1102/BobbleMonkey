BobbleMonkey
============

A Game You Can Play With Your Head!
----------------------------------------

This is an attempt to create a unique game-playing mechanism for iOS devices; think of this as bringing the Kinect-like interactivity to the iOS platform using computer vision. The idea was that instead of interacting with the device using your fingers, the input is your head. The result is a modular mechanism into which I can drop any Cocos2D game or UIKit application, which can then be driven using the movement of the user's head. As a proof of concept for the idea, I have written a game which could be played with your head.  

The Game
--------

It is a side-scrolling game. You tilt your head right, the monkey moves right. You tilt your head left, the monkey moves left. The goal is to catch as many fruits as possible and avoid all stone tablets. 

iPad Screenshots:

<a href="http://www.flickr.com/photos/46486952@N02/7160778836/" title="IMG_0135 by al242, on Flickr"><img src="http://farm8.staticflickr.com/7082/7160778836_dfb5363beb_n.jpg" width="240" height="320" alt="IMG_0135"></a>
<a href="http://www.flickr.com/photos/46486952@N02/7160779242/" title="IMG_0139 by al242, on Flickr"><img src="http://farm8.staticflickr.com/7091/7160779468_acf9939326.jpg" width="240" height="320" alt="IMG_0140"></a>
<a href="http://www.flickr.com/photos/46486952@N02/7160779882/" title="IMG_0142 by al242, on Flickr"><img src="http://farm8.staticflickr.com/7226/7160779882_27d41d2244.jpg" width="240" height="320" alt="IMG_0142"></a>
<a href="http://www.flickr.com/photos/46486952@N02/7160778606/" title="IMG_0147 by al242, on Flickr"><img src="http://farm8.staticflickr.com/7093/7160778606_44d2e0fb0e.jpg" width="240" height="320" alt="IMG_0147"></a>

iPhone Screenshots: 



The project is currently progessing at a crawl because I don't personally own any Apple computers or devices (being a student), so at the time, I am doing most of the development at the UW Macintosh Lab and borrowing my friends' devices for testing. The bulk of the coding for the project came together around the March - April 2012 timeline. 



The Game
--------



Demo: My Image:





Known Issues:

The application does not work well on the iPhone 4 and the iPod Touch fourth gen. Here is what I suspect is why:
Issue 1: Currently, the Face Detector object is communicating with the Game Controller object using NSNotifactionCenter which has obvious overhead but there were thread safety issues with the communication between the Face Detector object and the Game Controller object and that was a quick fix. 
Issue 2: The processing of the image is very CPU intensive. On the iPad2, the grand central dispatch delegates the image-processing responsibility to the second core whereas the drawing and the image processing appears to be occurring on the same processor. An obvious solution to this issue would be to reduce the processing time. This would be accomplished by scaling the size of the image down to about 25% before sending it to be processed, the rationale being: less pixels to be processed, therefore reduced time for processing. This would reduce the accuracy of the face detection but I am only interested in the relative position of the face features.


Technical Roadmap

- Fix application navigation: Currently, there is no way to exit from the game to the menu
- Fix loading indicators: Currently, there is no standard loading paradigm which makes the application feel disjointed

Appstore Release

- Leveling up Mechanism: Currently, there are 8 levels which are all unlocked. This needs to be improved such that there is only one level unlocked and the user needs to acheive a certain score on each level to unlock the following level 
- High Score Mechanism: The players need an incentive to play the game.
 
 Appstore Update 
 
- Fix Issue 1: Migrate the communication mechanism between the Face Detector object and the Game Controller object from NSNotificationCenter to Delegation. 
- Fix Issue 2: Scale down the image received from the pixel bufer for faster processing. 
- Retina Art Assets: I currently I don't have retina art assets which means the game does look very good on retina devices. 
- Migrate to Cocos-2D V 2.0: Currently using Cocos-2D V 1.0

Appstore Update 

- Implement Collision Detection Using Box2D: Currently performing a simple radial collision detection
- Game Center Integration

Appstore Update 

- Add a new game which can be played using the same gaming mechanism.  

This application is a hybrid of Cocos2D( http://www.cocos2d-iphone.org/ ) and UIKit an incorporates the following api's:

iOS 5 face Detection Api: 
Accelerometer Api

What does this exactly do:

