# umee_app

newsletter_demo app using Flutter, Provider, and SharedPreferences

design to create user specific accounts with registered posts and a general feed of posts on the 
home screen, also includes likes and dislikes functionality

Login screen -> 
    enter a username and submit using 'Login' button to register a new account
        new accounts will automatically be sent to a newly created homepage
    prior accounts will have an icon that allows for easy access to previous posts
Home Page ->
    general newsfeed contains a listing of posts with the recent-most showing first
        posts can be clicked on for a more direct view of its contents and its details
    contains two navigation icons on the top right
        the triple dotted icon creates a logout popup menu that brings the user back to the login screen
Profile screen ->
    clicking the person icon will bring the user to the profile screen which better showcases
    all of the user's post history as well their like and dislike ratios
        users also have the option to create new posts here or delete all their posts
    these posts can also be clicked for a more direct view of post contents and details
