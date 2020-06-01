# SocialLogins

Enable iOS app Sign in with Apple, Twitter, Facebook, Google and LinkedIn with ease. It will really saves you a lot of hours. 

The origin is a reference to the struct  `AppleUserModel`,  `GoogleUserModel`,  `FacebookUserModel` ,  `TwitterUserModel` and `LinkedInUserModel`. For Google it has the property  `user`  that reference to  `GIDGoogleUser`  which you could use for any other Google APIs. While for Twitter, it has an  `OAuthToken`  to be use on other Twitter APIs.

## Installation

You just need to drag and drop respective social login folder to your project.

Open your  `AppDelegate.swift`  file, and add these codes

```swift
func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool  {
    if url.absoluteString.contains("google") {
        return GoogleSignInHelper.openURL(url)
    } else if url.absoluteString.contains("fb") {
        return FacebookSignInHelper.openURL(app: application, url: url, options: options)
    } else if url.absoluteString.contains("twitterkit-") {
        return TwitterSignInHelper.openURL(url)
    } else if url.absoluteString.contains("linkedin") {
        return  LinkedInSignInHelper.openURL(url)
    }
    return  true
}
```

## Usage

### Implementing Google Sign In

Get the  `Google Client ID`  and  `Scheme Path URL`  from  [Google API Console](https://console.developers.google.com/). You may follow the tutorial at  [Google Sign In](https://developers.google.com/identity/sign-in/ios/)  to get those. Put your  `Scheme Path URL`  to the  `URL Scheme`  configuration on Xcode.

And on your Google Sign In button action, specify with the code:

```swift
GoogleSignInHelper.shared.login(with: SocialCredentials.Google.clientId, from: self) { (error, user) in
    if let user = user {
        print(user)
    } else {
        print(error ?? "Unknown Error")
    }
}
```
### Implementing Facebook Sign In

Setup an app on  [Facebook Developer Portal](https://facebook.com/developer), and get the  `Facebook App ID`. Put your  `App ID`  on the  `Info.plist`  file:

```
<key>FacebookAppID</key>
<string>13434434</string>
```

Put  `fb-your-fb-app-id-`  on  `URL Scheme`. If your App ID is 13434434, then  `fb13434434`  need to be on your  `URL Scheme`. Put the  `fbauth2`  on your  `URL Scheme`  as well.

And on your Facebook Sign In button action, specify with the code:

```swift
FacebookSignInHelper.shared.login(from: self) { (error, user) in
    if let user = user {
        print(user)
    } else {
        print(error ?? "Unknown Error")
    }
}
```
### Implementing Twitter Sign In

Go to  [Twitter Developer Portal](https://developer.twitter.com/)  and get  `Twitter App Key`  and  `Twitter App Secret`. Put the  `twitterkit-your-appkey-`  to URL Scheme. If your app key is  `1212`  the put  `twitterkit-1212`.

And on your Twitter Sign In button action, specify with the code:

```swift
TwitterSignInHelper.shared.login(with: SocialCredentials.Twitter.kAPIKey, and: SocialCredentials.Twitter.kAPISecret) { (error, user) in
    if let user = user {
        print(user)
    } else {
        print(error ?? "Unknown Error")
    }
}
```
### Implementing Apple Sign In

On XCode, go to  `Signing & Capabilities`  tab. Enable  `Sign In with Apple`  there.

And on your Apple Sign In button action, specify with the code:

```swift
if  #available(iOS 13, *) {
    AppleSignInHelper.shared.login(from: self) { (error, user) in
        if let user = user {
            print(user)
        } else {
            print(error ?? "Unknown Error")
        }
    }
} else {
    // Fallback on earlier versions
    print("Sign in with Apple require iOS 13 and later")
}
```

### Implementing LinkedIn Sign In

You need to add supported library for it as follow:
-   Podfile
```
platform :ios, '10.0'
use_frameworks!

pod 'OAuthSwift', '~> 2.0.0'
```
#### [](https://github.com/OAuthSwift/OAuthSwift#setting-url-schemes)Setting URL Schemes

In info tab of your target  [![Image](https://github.com/OAuthSwift/OAuthSwift/raw/master/Assets/URLSchemes.png "Image")](https://github.com/OAuthSwift/OAuthSwift/blob/master/Assets/URLSchemes.png)  Replace oauth-swift by your application name

LinkedIn is not supporting custom URL Scheme as callback url. it is only allowing protocol ```http``` or ```https```. So you need to make one callback URL on server which redirects to your URL Scheme i.e ```oauth-swift```. 

You can find sample php file named ```callback.php```  in ```LinkedInSignInHelper``` directory.

And on your LinkedIn Sign In button action, specify with the code:

```swift
LinkedInSignInHelper.shared.login(with: SocialCredentials.LinkedIn.clientId, and: SocialCredentials.LinkedIn.clientSecret, redirectUrl: "http://localhost:8080/callback.php", viewController: self) { (error, user) in
    if let user = user {
        print(user)
        print(user.profilePictureUrls)
    } else {
        print(error ?? "Unknown Error")
    }
}
```

# License

```
Copyright 2020

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and

limitations under the License.
```
