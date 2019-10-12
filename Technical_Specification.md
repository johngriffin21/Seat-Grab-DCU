# Technical Specification 
## John Griffin & Killian Byrne - SeatGrab
___
## Table of Contents
1. Introduction 
    * 1.1 Introdution
    * 1.2 Changes made since the Functional Specification
    * 1.3 Glossary
2.  Testing
    * 2.1 Testing
    * 2.2 User Evaluation
3.  System Design
    * 3.1 System Architecture
    * 3.2 High Level Design Diagram
    * 3.3 High Level Design Description
    * 3.4 Data Flow Diagram
4.  Misc
    * 4.1 Problems and Resolutions
    * 4.2 Download Information
    * 4.3 Dependencies used in our project
    * 4.4 Main resources used throughout our project

___
## 1. 1 Introduction

SeatGrab is a cross platform application created to solve the seating crisis currently experienced in many libraries around the world. The need for this system arose from past experiences of wasting time in the DCU library by checking every corner just trying to find a seat, and in some case to find no seat at all. This is especially problematic when exams are looming (busiest time of year). Another motivation for creating this app was to prevent library users from reserving seats for their friends, which is a massive issue in DCU library. This system will save users time and money as they will be able to plan when to go to the library when seats are available. The application also plans to solve the problem of students taking lunch breaks that go beyond what the library deems an acceptable time. Our solution tackles the problems outlined above, through NFC technology, the real-time database firebase cloud and hardware available on smartphones. Using our application, a user will have to scan an NFC tag that is stuck to the desk and reserve the given seat. This action will update the live map, available on the application, changing the colour of the seat from green (available) to red (occupied). This process will allow users to check at any time how busy the library is (by an occupancy percentage), and whether their favourite seat(s) are occupied or not. Once users have completed the process of occupying a seat, the accelerometer in their phone is activated. If a large value is detected by the accelerometer (which is set at such a value that the user is likely to be walking as walking returns high values), the user will be notified that they have left their seat. They will be given a time limit in which they need to return in. If they do not return in their time limit, the admin will be notified of their absence and their belongings will be returned to the front desk and their seat will be made available, which of course is at the discretion of the admin and no students will be able to see if the student has been absent.
Users may also set study goals in the study planner section of the app. Here they may set and remove modules and module details that they set for themselves. This is achieved by creating a document in the Firebase Cloud database using the User ID, then adding sub-collection to each of these documents in the database called planner. Students can also use the about section of the app to look at current library times and navigate the DCU Library website from within the application.




___





## 1.2 Changes made since the Functional Specification

There is very little change between what we set out to do with our functional specification and our finished product. Logistically, some things we set out do were not possible according to our research on the topics. This was sometimes due to us using the Flutter framework to develop our app, which is just out of the Beta stage of development. As a result, there is very little literature on it and bugs are ever present when using some features. This was the case when trying to get a constant stream of communication between the NFC (refer to glossary) tag and the device. We solved this by utilizing the accelerometer feature in the phone so the end user would not be able to detect the change. We also originally planned to do our map using SVG (refer to glossary) but again due to flutters primacy, it wasn’t possible to use SVG in flutter. The app remains very precognitive and should be adaptable to many different environments which was one of our original goals when setting out to develop it.  Regarding the system design itself, some class designs that we had originally planned to use would simply not work in Flutter due to its unique structure as being structured around Widgets.
___





## 1.3 Glossary

* __Dart__: an object-oriented language, developed by Google, that is used to build web, server and mobile applications
* __Flutter__: an open source web development kit, developed by Google, used to develop applications for ios and android.
* __Firebase__: a mobile and web application development platform and a Backend as a service.
Backend as a service: a model for providing web and mobile application developers with a way to link their applications to a backend cloud storage, and also to APIs that are exposed to back end applications.
* __NFC__: Near field technology. A set of communication protocols that enable two electronic devices to establish communication by typically bringing them within 4 cm of each other. In our case, a tag and a mobile phone.
* __SDK__: An SDK is a collection of software used for developing applications for a specific device or operating system. Examples of SDKs include the Windows 7 SDK, the Mac OS X SDK, and the iPhone * SDK. SDKs typically include an integrated development environment (IDE), which serves as the central programming interface.
* __Widget__: an application, or a component of an interface, that enables a user to perform a function or access a service.
* __SVG__: Scalable Vector Graphics is an XML-based vector image format for two-dimensional graphics with support for interactivity and animation.
* __Access Token__: An object which grants an application the correct security permission to carry out tasks or access data for an agreed time period.
* __API__ : This is a software intermediary that allows two applications to talk to each other.
___





## 2.1 Testing
SeatGrab uses many pages which operate using components that flutter called widgets. We therefore implemented widget tests to ensure these components were functioning as we intended. Unit tests were also used and were very useful as the app employs several units as functionality classes and these were tested also. Another way in which we tested our application was with compatibility testing. The application was tested on a Google Nexus Phone, a Vodafone Smart Phone and a Samsung Galaxy phone. This showed us that it would work across a large range of smartphones. The main testing of that we utilized while developing SeatGrab, was user testing. It was decided from the start that having our application usable as possible was crucial for the application to perform as intended. As the application was targeted towards students, we decided that having a simple and easy to use application was crucial so therefore we user tested throughout the process of developing the application. Interestingly, this user testing did change how we laid out our application and really emphasised the importance of it. We were granted ethical approval for our testing. If you want to read more about our testing, please refer to the testing section of SeatGrab’s GitLab.





___
## 2.2 User Evaluation
Our system involves two sets of users, administration staff and students. The students interact with our system by logging in with their Google accounts, reserving seats by placing their mobiles on the NFC tag and connecting to the system. They may also choose to add some to-do items in their study planner. The admins interact with the system by logging in using their Pin, and then having access to the seating map, but also an interactive list where they can see if a student is absent, and if the seat is overdue. They can tap on this list if they want to remove a student’s belongings and free up the seat for another student. 






___
## 3 System Architecture Diagram

![](technical_manual/images/architecture_for_seatgrab.png)

## 3.1 System Architecture
 
From this we can clearly see that our system contains five main components. The main focal point of our project would be the Client application which shows how a user would interact with the system itself. This component is connected to two essential components. The near filed communication component allows a user to gather the information needed to tell them what desk they are currently at.  The next component the client application is connected to is the accelerometer feature which allows the admin to tell when a phone has been moved from a seat. This is located within the phone but detaching it for the purpose of the diagram makes it much clearer. Another component the client application is linked with is the Firebase Database, which holds information data as well as seat number data. The final component in our diagram is the administration application. Both the client application and the client application are situated in one application for the purpose of the demonstration, but they serve very different purposes so we felt it would make much more sense to separate them to explain our system architecture effectively. 

The client application is an android app involves how the user interacts with the system itself. It will allow the user to login to their account via Google and it will also allow the user to connect to an NFC tag by placing his/her phone on the tag. This will in turn allow the user to manipulate the firebase cloud database in order to reserve his or her seat. Another feature that a user can access from the client application is the ability to add study tasks to his/her own personalised sub-collection in firebase cloud. 

The admin application is connected to the same firebase cloud database as the client application, but they have the ability to view different values in the database. These include if a seat is marked absent or if the seat is overdue. They also can directly manipulate this database in order to, for example, free up the seat for another user and mark it as free. This is crucial for the system to run as intended. The admin application requires a pin to access, and this is implemented using the pin_code_view package.

The firebase database will serve as the database in our application. The version we chose to opt for was firebase cloud, which is a real-time database provided by Google which is in the beta stage of production. This is crucial to the success of the application as it allows the user to receive, on a real-time map, the information about which seats are occupied. It also stores the users own personalised to-do list as a sub-collection in the database. The last feature of the firebase database that is used by the user is to authorize the users themselves. This is achieved by implementing the flutter firebase_auth package. This allows the system to implement Google’s state of the art security while also giving the user piece of mind.

The NFC component of the application allows the user to gather a seat number using NFC technology and in turn use this data to affect the firebase cloud database directly. This is achieved as all tags have an NFC id which, when transferred to the phone using near field communication, is then sent to the database where all NFC ID’s are listed in the database as documents and have seat numbers assigned to them using fields. This technology is crucial to the system itself.

The accelerometer in the application is used to detect when a phone has been removed from the table. This is implemented using the sensors package in flutter (sensors 0.4.0+1). The concept behind this is that when the phone is on the desk and placed on the NFC tag, the accelerometer is activated. This would give a value of zero on the accelerometer. When the phone is removed from the desk the system can detect this because the accelerometer values would increase, therefore transferring this information to the phone. The client application then changes the value absent on the database to true, which the admin application can now see, as both are connected to the same firebase cloud database.

___







## 3.2 High-Level Design Diagram

![](technical_manual/images/highlevel.jpg)

 

## 3.3 High-Level Design Description

__Stage 1__ - Splashscreen loading page: When users log into the application users are presented with a splash screen loading page. This gives the application time to load. On the screen there is a cyan colour loader and the SeatGrab logo.

__Stage 2__- User login screen: Here users are presented with a login screen which contains two options for the users. “Login as a student” or “Login as an Admin”. These are presented as buttons and users can choose either. 

__Stage 3__- Login as Admin: Users have selected login as admin, so they are presented with the option to enter a pincode into the pincode screen. This is implemented using the futter pin_code_view package. 

__Stage 4__- Access Map: The admin can view a specialized admin application where the current capacity is displayed. The admin can also view what seats are currently being occupied by users. This information is gathered from firebase cloud.

__Stage 5.1__- Access seating list: Admin can access a list view of all seats that are occupied. The admin can view a number of fields regarding seating capacity including what seats have become absent, what seats are occupied and what seats are overdue 

__Stage 5.2__- Alter Seating List: On tapping one of the list tiles on the admin seating map the admin can free up the seat for another user, at their discretion. This is achieved by setting the values in the database to false again, which will alter the map that the user sees, in real time capacity. This also updates the capacity.

__Stage 7__- Login as student: The student has pressed login as student. They are now presented with the option to login with their Google accounts. This is achieved by using firebase authorization to verify the details given are correct. Upon login in for the first time, a sub-collection is also created in the database where the user can add items to a to-do list.

__Stage 8.1__ – Access Seat Reserve: This is the default page a user is brought to when they originally log in. They are immediately presented with a button to reserve a seat via NFC. The page also displays a welcome message and a bottom navigation bar. 

__Stage 8.2__- Connect with NFC: User has selected the option to connect with NFC, which starts the NFC scan on their respective phone. Upon scanning the tag and acquiring the NFC id, the NFC process is stopped.

__Stage 8.3__- Update database: The tag has now been acquired and the database document for that particular tag is updated to show the that the seat is now taken. This starts the accelerometer in the phone, which detects if the phone has been moved from the desk. If this is the case, the user is immediately presented with a user dialog displaying the time the phone was taken off the desk and if this goes over 45 minutes the seat is marked as overdue. The admin can see this and change it at their discretion. 

__Stage 8.4__ – Vacate Seat: If the user is finished with their study session, they can choose to vacate the seat for another. They do this by clicking the vacate seat button which will gather the NFC ID for that seat and update the database to mark that seat as free now. The user can now choose to log-out or choose any of the options on the bottom Nav Bar.

__Stage 9__ – Access Map: The user can access a map the seats in the library and see which seats are currently occupied. This can be determined by colour, with occupied being red and unoccupied as green. They are also presented with a current capacity percentage.

__Stage 10.1__ – Access Study Planner: Here the student is presented with their own personalised database. This is achieved by adding a sub-collection in the firebase cloud database for each user called planner. The user can add modules, topics for that modules. They may also delete some of these modules by tapping and holding on the topic. This will delete the entry from the real time database. 

__Stage 11__ – Access Library Information: The users can access the DCU library website from within the application. Here, they can search for books they need and view library times. 

__Stage 12__ – Logout: This option is always visible in the top-right hand corner of the app bar and when tapped will log the user out of the application using Firebase Authentication.  This will automatically redirect the user to the Login Page where they can login again if they choose to do so.

___
## 3.4 Data Flow Diagram

![](technical_manual/images/data_flow_diagram.png)

The data flow diagram shows the flow of data in SeatGrab. It shows how the user, NFC tag, admin, and databse interact with eachother and type of data is trasfered between them. This is repersented by arrows, with the information passing displayed in a list format directly above the arrows.

___
## 4.1 Problems and Resolutions

__Problem__: The main problem encountered throughout this project was learning a completely different way of coding by using the dart design language and the flutter application development framework. Because this framework is extremely new and just out of the beta stage of development, there is little to no literature on the language so solving problems and developing the application itself proved far more challenging than we had originally anticipated. Because Flutter is new, this also meant that there is a lot of bugs within the Framework that we had to find workarounds for, and meant that Google was updating the Framework bi-monthly. This meant that code that had previously worked would not work with the updates. This was a challenge for us but our solution was to rely mainly on the documentation of Flutter which actually helped us learn much more about the inter workings of the framework, instead of relying on tutorials which were being

__Problem__: No. of method references in a .dex file cannot exceed 64k.After a lot of research we figured out that when your app and the libraries it references exceed 65,536 methods, your app reaches the limit of the Android build architecture.  This turned out to be a simple enough solution to solve as you had to enable Multi-Dex support.  This allowed our app to be compiled past this barrier. The solution involved adding multidex support to our dependencies section of our app and this solved that particular problem.

__Problem__: SignInWithGoogle deprecated. Because our application depends on Google sign in as it is targeted at students who want to log into their DCU apps account, this was a huge blow for us. We had code written to successfully sign the student in which was implemented in our Auth file using the package google_sign_in. This effort was in vain though, as during mid-January google deprecated this, rendering our code useless through no fault of our own. The solution was to use the method SignInWithCredential and altering the code slightly. This worked out very well and the sign in is now working perfectly

__Problem__: Firebase authorization stopped working after the previous fix just a week before our project, with the build gradle failing every time. This was extremely alarming to us as is meant that we could not run our application at all. The solution tuned out that we had to Migrate our whole project to AndroidX. We solved this temporarily by adding multiple lines to our build gradle, build properties, java files, and removing android support form the android manifest.xml. With these fixes the program would still not run, but after viewing bug reports on flutters github we discovered that google had deleted the firebase package from the Jstore accidentally. This was alarming but it was replaced days later, and the issue was solved.

__Problem__: Another problem we encountered was the fact that NFC tags didn’t behave the way we wanted them to. Originally, we had planned to have the phone constantly connected to the NFC tag via a while loop or otherwise but once the phone had made the connection, it saved the NFC data until the NFC scan was stopped. This was a huge issue for us as we couldn’t detect if the student had left the desk or not.  Our solution was to use the accelerometer feature in modern phones once the connection was made. This detected if the phone had been moved or not by checking the accelerometer values. This works perfectly and allows us to tell if the phone has been moved without revealing the location of the student, as GPS was an option, we explored but decided not to use because of GDPR restrictions.







___
## 4.2 Download Information

Currently, as SeatGrab exists, it is a proof of concept. The application is also environment specific meaning that each new area would need a new map. This means that publishing the application in its current state would be of little to no use. Another reason is that we are planning on persuing this idea as a business and would therefore like more time to explore ways of making the map adapatable before publishing the application.











___
## 4.3 Dependencies used in our project:

__Sensors__: This is a package developed by google that we used to help access the accelerometer feature in devices used. This was very useful for us when implementing the accelerometer feature in SeatGrab. 

__flutter_nfc_reader__: This is a package we used in order to access the NFC capabilities of the devices running SeatGrab. It helps activate a pooling reading session that stops once a tag has been recorded.

__Firebase_auth package__: This is a plugin that helped SeatGrab authorise users using the google firebase system. It was quite problematic as it is still under development but worked extremely well once bugs were solved.

__Splashscreen__:  A package that helped develop our splashscreen for SeatGrab. 

__Cloud_firestore__: A package that helped connect SeatGrab with the real-time database firebase cloud. 

__Rxdart__: A dart package that is a functional programming library for Google Dart, which is based on ReactiveX.

__Http__: A library for dart that allows the program to make HTTP requests easily and efficiently. 

__animated_text_kit__: This is a package SeatGrab uses to implement the flashing loading sign when a user is connecting to a desk.


## 4.4 Main resources used throughout our project:
__Flutter Documentation__: https://flutter.dev/docs

__Jeff Delaney Tutorials__: https://fireship.io/lessons/flutter-firebase-google-oauth-firestore/

__Medium.com flutter page__: https://medium.com/flutter-io

__StackOverflow flutter section__: https://stackoverflow.com/questions/tagged/flutter

__Firebase Console Documentation__: https://firebase.google.com/docs/

__Flutter's github page__: https://github.com/flutter/flutter







