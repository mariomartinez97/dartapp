//
//  ChannelsViewController.swift
//  FriendlyChatSwift
//
//  Created by Mario Miguel on 10/12/16.
//  Copyright © 2016 Google Inc. All rights reserved.
//

struct Constants {

  struct NotificationKeys {
    static let SignedIn = "onSignInCompleted"
  }

  struct Segues {
    static let SignInToFp = "SignInToFP"
    static let FpToSignIn = "FPToSignIn"
  }

  struct MessageFields {
    static let channel = "channel"
    static let name = "name"
    static let text = "text"
    static let photoURL = "photoURL"
    static let imageURL = "imageURL"
  }
    struct UserFields {
        static let email = "email"
        static let uid = "uid"
    }
}
