# Scraps

Scraps lets you jot down names of things quickly so you can return to real-life conversations. When you have some free time you can quickly turn those names into search queries by swiping them to the right.

It currently takes advantage of the Dropbox [Datastore API](http://www.dropbox.com/developers/datastore) so you'll need a Dropbox account to use it. If you want to tinker, start a new [Dropbox Datastore App](https://www.dropbox.com/developers/app_info/) and plug the App Key and App Secret into the macros in the AppDelegate.m file. Then go to the Info tab for your project and expand URL Types so you can replace APP_KEY with your App Key under URL Schemes. Build the app using iOS7, authenticate and you should be up and running.

## Current mock

<img src="https://raw.github.com/nathanborror/Scraps/master/MOCK.png" width="395">
