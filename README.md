# tutorNtutee App
The initial idea of this app is to build a UC Davis tutoring platform where tutors are current/post UC Davis students and can meet whoever needs class-specific tutoring sessions. These sessions can be virtually meetings through this app or a phycical meetings with their choice of time and avaliblities. Both tutors and tutees will be able to use this platform to exchange ideas, create a meeting session or even facetime to distances tutoring for a convinent purpuse. The tutors and tutees are matched up with their specified selected avaliablities an tutess will have an option to award the tutors by the end of session using online transaction/cash by the amount the tutor's listed price.


##### Team Members:  
Abudureheman Adila  
Alessandro Liu  
Junjie Han  


### Sprint One
Link to Trello: https://trello.com/b/Gw47mmuc/milestone-1  

Goal: (User stories, what user will be able to do and how)  


Break Items into Tasks(Individual Tasks):  


Login View for Tutors/Tutees: create account with email (Both email has to be UCDAVIS.EDU for the simplicity)

Home View:   
Two buttons option, "I Want To Learn" & "I Want To Teach"

TuteeView: 
Search for course/tutor. Upload which course he/she want to be taught then we can display in TutorView. An option to fulfill his/her personal information, like major, freshstudent or senior, which courses taking this quarter

TutorView:
Search for course/tutee. Upload which course he/she want to tutot then we can display in TuteeView. An option to fulfill his/her personal information, like major, graduate or undergraduate, which courses has taken.

Database:
database for user information
database for tutee needed
database for tutor needed


### Sprint Two
All the work progress and history (git commits) are in this repository: https://github.com/AlessandroAlleAlex/tutorNtutee <br>
Link to Trello: https://trello.com/b/JPucTCtK/milestone-2

Goals: 
- be able to chat between tutors and tutees
- fully working tutor and tutee view controllers
- improvements on database set up
- working tutor market view controller
- UI implementation of home view controller

Chat View Controller:<br>
two people have to be able to chat through out app in real time.

Tutor and Tutee view controllers:<br>
Tutors have to be able to select the class to be tutored and pick a date and time; while, tutees have to be able to search the tutor market filtered based on the class, date, and time range.

Database:<br>
be able to store text data into the firebase database and retrieve it.   

Tutor market view controller:<br>
be able to display all tutors with correct information from database.

Third party libaries:<br>
firebase

Navigation controllers:
from log in view controller to sign up view controller; if the user is authenticated, do present to home view controller, and navigation push to tutor view and tutee view.

test plan:
find friends to sign up and log in,then measure how long it takes.
find friends to sign in as a tutee and measure how long it finds the information he/she wanted.

team members:
![611573695166_ pic](https://user-images.githubusercontent.com/56142553/68819246-51e52e80-063c-11ea-9085-a733abdb3dc7.jpg)

left:Junjie Han. https://github.com/hjunjie0324 <br>
middle:Abudureheman Adila  https://github.com/aadila6 <br>
right:Alessandro Liu.  https://github.com/AlessandroAlleAlex <br>

### Sprint Three
link to trello for milestone 3: https://trello.com/b/1m1k7UMw/milestone-3

Goals: 
- be able to chat between tutors and tutees(Chatbox)
- fully working Home view controllers
- set up all databases
- working home view controller with posts,generate posts, chats and profile tabs
- UI implementation of home view controller
- implementation of generate newpost view controller
- implementation of menu bar

Chat View Controller:<br>
two people have to be able to chat through out app in real time.

Tutor and Tutee view controllers:<br>
Tutors have to be able to select the class to be tutored and pick a date and time; while, tutees have to be able to search the tutor market filtered based on the class, date, and time range.

Database:<br>
be able to store text data into the firebase database and retrieve it.   

Homeview feeds view controller:<br>
be able to display all tutors with correct information from database.
be able to generate new posts
be able to go into chatbox

Third party libaries:<br>
firebase

Navigation controllers:
from log in view controller to sign up view controller; if the user is authenticated, do present to home view controller, and navigation push to tutor view and tutee view.

test plan:
find friends to sign up and log in, and test for classes they need help with.
find friends to sign in as tutees and tutors and try to match them, and try to chat over through our chat system


### Sprint Four
link to trello for milestone 4: https://trello.com/b/JMdERqXy/milestone-4

Goals: 
- Able to store all the chat histories and chat with multiple people in a row(chat tableview)
- Able to upload profile image and set it perminently.
- Able to change username
- Generate Posts, chats and profile tabs
- Able to delete a exsiting post by creater
- Able to generate new email with prefilled receiver's email address.
- Tentative: implement google map API for class localization
- Tentative: implement real time class matcher

Chat View Controller:<br>
Able to store all the chat histories and chat with multiple people in a row by implementing a seperate view for scrollable chats.


HomeView:<br>
Polishing the existing posts and read the posts from firebase.
Be able to have the most recent post information all the time. 


Database:<br>
Add class schedules & locations

Homeview feeds view controller:<br>
be able to display all tutors with correct information from database.
be able to generate new posts. 
be able to go into chatbox.    

Class Localizer :<br>
Tentative: implement google map api with current user's location with (longitutde, latitude) within the range in real time.
Tentative: match classes with real time with the class time.
If both satisfy the user's location & time, it will auto generate classes for user when user try to look for a tutor session.

Third party libaries: <br>
Firebase
Google Map Api


test plan:<br>
Test out with friends before Push it to App store

