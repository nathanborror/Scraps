# Scraps

Scraps lets you jot down names of things quickly so you can return to real-life conversations. When you have some free time you can quickly turn those names into search queries by swiping them to the right.

It currently takes advantage of the [Parse iOS SDK](https://parse.com/docs/ios/api/) so you'll need a Parse account to use it. If you want to tinker, start a new [Parse App](https://parse.com/apps) and plug the App ID and Client Key into the macros in the AppDelegate.m file. Then go to Data Browser in the app your just created on Parse and add a new class called 'Scrap' and add a single column called 'text' with type String. Build the app using iOS7 and you should be up and running.

## Current mock

<img src="https://raw.github.com/nathanborror/Scraps/master/MOCK.png" width="395">
