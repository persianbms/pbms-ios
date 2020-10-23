//
//  SocialNetworks.swift
//  PersianBMS
//
//  Created by Arash on 7/13/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import UIKit

enum SocialNetwork: Int {
    case telegram = 0
    case instagram = 1
    case facebook = 2
    case youtube = 3
    case soundcloud = 4
}

class SocialNetworks {
    
    static private let appUrls: [SocialNetwork:String] = [
        .telegram: "tg://resolve?domain=Persianbms",
        .instagram: "instagram://persianbms",
        .facebook: "https://www.facebook.com/Persianbms",
        .youtube: "youtube://www.youtube.com/channel/UCZGvidZW7-YTVG7PY3-xw1A",
        .soundcloud: "soundcloud://users/persianbms",
    ]
    
    static private let webUrls: [SocialNetwork:String] = [
        .telegram: "https://t.me/Persianbms",
        .instagram: "https://www.instagram.com/persianbms/",
        .facebook: "https://www.facebook.com/Persianbms",
        .youtube: "https://www.youtube.com/channel/UCZGvidZW7-YTVG7PY3-xw1A",
        .soundcloud: "https://soundcloud.com/Persianbms",
    ]
    
    class func open(_ network: SocialNetwork) {
        let appUrl = URL(string: appUrls[network]!)!
        if UIApplication.shared.canOpenURL(appUrl) {
            UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
        } else {
            let webUrl = URL(string: webUrls[network]!)!
            UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
        }
    }
}
