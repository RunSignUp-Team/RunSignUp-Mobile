RunSignUp-Mobile Timer
======================

RunSignup Mobile Timer is a mobile application that allows three users to time and place a race in real time. It does this through integration with RunSignup.com, and requires a Race Director account.

![Sign in menu](http://i.imgur.com/W07R6.png)

You can sign in or record a race offline. After doing so, choose your race/event and move on to the main menu:

![Main menu](http://i.imgur.com/YZCm6.png)

Choosing timer shows the timing screen which is used to collect times and places.

![Timer view](http://i.imgur.com/z1dMy.png)

You may also use the chute to collect bib numbers and places.

![Chute view](http://i.imgur.com/itlSM.png)

The app will be released on the app store soon! For now, if you wish to try out the application yourself, go ahead and create an account on RunSignUp.com so you can get the most use out of the app. After you do this, make sure to download XCode (only available for Mac OS X), fork the code here on Github, and get build the project.

The most useful code to take a look at is the RSUModel.h and RSUModel.m. This object handles all the interaction between the application and RunSignUp.com. It will internally handle all the credentials specifics, and all subsequent calls to the methods that require an event and raceid will use the ones specified when the user views SelectRaceViewController.

Most of the code files are self explanatory in what their purpose is, but the ones that may not be are as follows:
RXMLElement is code borrowed from another Github repository used for reading XML in RSUModel.
TimerLabel is a custom UILabel that is seen in the timer screenshot, it handles the actual timekeeping and writing of the formatted time.
NumpadView is a custom UIView that is only used on the iPad's chute and checker views. It replaces the default keyboard due to the need for bigger buttons in a centralized location.
RoundedLoadingIndicator and RoundedBarcodeView are two views that function as custom "popups". RoundedLoadingIndicator displays the RunSignUp animated loading icon.

Currently the Settings view doesn't do too much. The bigger timing button feature is only taken into account on the iPhone and iPod Touch and Timer Hours is a placeholder for a different setting.

IMPORTANT:
The archive view is very important. All timing, checker and chute data is saved locally to the device at each data point, so there is no way to lose all your data aside from deleting the application from the device. In the archive, you may view, edit and even reorder data (chute data only).

Thanks!