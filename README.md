# Project 4 - *BootLegram*

**BootLegram** is a photo sharing app using Parse as its backend.

Time spent: **X** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption.

The following **optional** features are implemented:

- [ ] Run your app on your phone and use the camera to take the photo
- [ ] Style the login page to look like the real Instagram login page.
- [x] Style the feed to look like the real Instagram feed.
- [x] User can use a tab bar to switch between all "Instagram" posts and posts published only by the user. AKA, tabs for Home Feed and Profile
- [x] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.
- [x] Show the username and creation time for each post
- [x] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- User Profiles:
  - [x] Allow the logged in user to add a profile photo
  - [x] Display the profile photo with each post
  - [ ] Tapping on a post's username or profile photo goes to that user's profile page
- [ ] User can comment on a post and see all comments for each post in the post details screen.
- [x] User can like a post and see number of likes for each post in the post details screen.
- [ ] Implement a custom camera view.

The following **additional** features are implemented:

- [x] Heart showing status of whether or not the user has liked a post is visible in the post details screen
- [x] Profile picture and name at the top of profile view scroll with the table view (i.e. included in the table view header)

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Although I have a rudimentary 'likes' functionality working, I have a lot of concerns about my implementation. It seems finicky and I was having odd behavior while testing with Parse.
2. Generally, I'd like to get a better understanding of Parse. I feel like I have some confusion over things that seem like they should be simple, and I think understanding what Parse is doing better will help me work with it better.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://i.imgur.com/1aNiY3J.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [Recordit](http://www.recordit.co).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [DateTools](https://github.com/MatthewYork/DateTools) - Dates and times made easy in iOS
- [MBProgressHUD](https://github.com/matej/MBProgressHUD) - an iOS activity indicator view
- [Parse](https://github.com/parse-community/Parse-SDK-iOS-OSX) - A library that gives access to the Parse Server backend


## Notes

- Took longer than expected to have the profile photo and name label scrollable, and still unsure if my implementation is the most optimal. I did not really know how to work with the UITableViewHeaderHeaderFooterView subclass that I ended up using, and using that in conjunction with the image selector was definitely a challenge.
- My 'likes' mechanism, although it works, seems buggy at times when I test it with Parse.

## License

    Copyright 2020 Clara Kim

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
