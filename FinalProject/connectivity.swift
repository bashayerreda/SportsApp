//
//  connectivity.swift
//  FinalProject
//
//  Created by MacOSSierra on 3/6/21.
//  Copyright © 2021 MacOSSierra. All rights reserved.
// bashayer r mansour

import Foundation
import Alamofire
struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
