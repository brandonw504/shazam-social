# Shazam Social

## Overview
An iOS social media app in which users can use Shazam to find songs playing in the environment and share it with their friends through a post.

## Installing the App
This app requires an Apple Developer account to use ShazamKit and an Apple Music subscription if you'd like to play music from the posts. Clone the repository, navigate to the directory shazam-social in the Terminal, and run pod install. Then, open shazam-social.xcworkspace. Plug in an Apple device to your computer and pick that device from the list of simulators to run on. You may need to trust Developer apps to run in Settings. Run the app from Xcode. Run the app once, and then you can enable ShazamKit by selecting the app named \[your name\].shazam-social and checking the box for ShazamKit. You're all done! Run the app again to start using it.

## Using the App
Sign up for an account. On the home view, you'll be able to see posts by other users who Shazamed songs. At the bottom, you can choose to view the posts in a map format, where you can tap on a marker and see information about the song the user Shazamed. To make your own post, go to the feed page and tap the _Add_ button on the navigation bar. Once you've Shazamed the song, you can add a caption and a location to your post. Tap "Share Post" and you're all set! You can listen to any of the songs on your feed with Apple Music by tapping on the tile. You'll need an Apple Music subscription for this.

## Future Plans
In the future, I plan to:
- Implement protocols to delegating the music playback and another for storing the social media posts.
- Implement a follower and following system.
- Implement likes and comments.
- Restrict the feed and world map to only show posts based on who users follow. 
