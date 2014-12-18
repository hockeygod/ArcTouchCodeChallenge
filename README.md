ArcTouchCodeChallenge
=====================

ArcTouch Code Challenge

# ArcTouch's Code Test

Your challenge is to create a simple application which searches some routes and timetables of Florianópolis's public transportation.

## App Specs

The app will consist of two screens: The List View and the Details View

- The List View, which shows the routes as a list. There will be a search box, where the user can type a name of a street and then tap on a button called "Search". The app should query this endpoint to get the results:

POST https://dashboard.appglu.com/v1/queries/findRoutesByStopName/run

Headers:

Authorization: Basic
V0tENE43WU1BMXVpTThWOkR0ZFR0ek1MUWxBMGhrMkMxWWk1cEx5VklsQVE2OA==X-AppGlu-Environment: staging

Body:

{
"params": {
"stopName": "%lauro linhares%"
}
}

Some streets for testing: [Delminda Silveira, Mauro Ramos, Governador Irineu Bornhausen, Deputado Antônio Edu Vieira].

The results are displayed as a list of routes that contain the named street within it's track. The user may tap on a route listed to go to the next screen showing the route's details.

- The Details view shows the Route's name, the list of streets within the route and its timetable organised by type of the day -- weekday, saturday or sunday. The app should query these endpoints:

POST https://dashboard.appglucom/v1/queries/findStopsByRouteId/run

Headers:

Authorization: Basic
V0tENE43WU1BMXVpTThWOkR0ZFR0ek1MUWxBMGhrMkMxWWk1cEx5VklsQVE2OA==X-AppGlu-Environment: staging

Body:

{
"params": {
"routeId": 35
}
}

POST https://dashboard.appglu.com/v1/queries/findDeparturesByRouteId/run

Headers:

Authorization: Basic
V0tENE43WU1BMXVpTThWOkR0ZFR0ek1MUWxBMGhrMkMxWWk1cEx5VklsQVE2OA==X-AppGlu-Environment: staging

Body:

{
"params": {
"routeId": 17
}
}

On the Details Screen, there should be a button called "Back" which takes the user to the previous screen and show the last search results.

## Choosing your tools

For creating the app you should choose one of those technologies:

- iOS
- Android
- HTML5 (Javascript/CSS3/Phonegap)

Choose the technology that you're most confortable with, but there isn't any specific choice that will make you earn more "points". If you choose HTML5 just keep in mind that ArcTouch is an App Studio, so your app should run and look good in any mobile browser (go for IOS/Android in this case).
You can use any open-source library available but try to make your own code -- avoid copy'n'paste from stackoverflow.com

## How to build the app

Here are the steps that you must follow for creating you app:

1. Create a public repository on GitHub. If you don't have an username just create one, it's free. You can pick whatever name for your repo.
2. Create a branch and commit your code to it. DO NOT PUSH YOUR CODE TO THE MASTER BRANCH.
3. Think that you're writing code which could be use from your future co-workers, and here we believe on collective ownership so you code must:

- First of all, compile and run :)
- Be as clean as possible
- Have the best practices on design and architectural patterns

4. If your code needs any additional steps on how to run it, for instance, a script or a deployment instruction, you should add it to GitHub's README.MD file. We are app developers, not clairvoyants :)
5. After finishing your app, create a pull request and send us its link. We'll assign someone to review it and send any comments on how to improve or fix any part.

That's it. If you need any assistance ask for help to your interviewer.
We wish you good luck and hope to have you onboard.

## Bonus

If you have time from your deadline you can try to add one more feature:
The feature consists of a map button on the List/search screen that will open another view with a Google map. The user will be able to select a street using the map as opposed to using the street name. When the user selects a street and taps on an ok button, the app should query the routes using the same endpoint of the first screen and show a list with its results on the List View.

Good Luck!!

