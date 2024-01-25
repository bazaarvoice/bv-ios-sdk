//
//  BVTestUsers.swift
//  BVSDK
//
//  Copyright © 2023 Bazaarvoice. All rights reserved.
// 

import Foundation

class BVTestUsers {
    enum testKeys: String {
        case conversationsKey1 = "conversationsKey1"
        case conversationsKey2 = "conversationsKey2"
        case conversationsKey3 = "conversationsKey3"
        case conversationsKey4 = "conversationsKey4"
        case conversationsKey5 = "conversationsKey5"
        case conversationsKey6 = "conversationsKey6"
        case conversationsKey7 = "conversationsKey7"
        case conversationsKey8 = "conversationsKey8"
        case conversationsKey9 = "conversationsKey9"
        case conversationsKey10 = "conversationsKey10"
        case conversationsKey11 = "conversationsKey11"
        case conversationsKey12 = "conversationsKey12"
        case conversationsKey13 = "conversationsKey13"
        case conversationsKey14 = "conversationsKey14"

        case answerUserId = "answerUserId"
        case feedbackUserId = "feedbackUserId"
        case feedbackUser = "feedbackUser"
        case questionsUserId = "questionsUserId"
        case reviewUserId = "reviewUserId"
        case reviewUser = "reviewUser"
        case storeReviewUserId = "storeReviewUserId"
        case submitUserId = "submitUserId"
        case incorrectUserId = "incorrectUserId"
        case hostedUserId = "hostedUserId"
        case progressiveReviewUser = "progressiveReviewUser"

        case buildRequestSession = "buildRequestSession"
        case buildHostedRequestSuccessSession = "buildHostedRequestSuccessSession"

    }
    
    func loadValueForKey(key: testKeys) -> String {
        guard let resourceURL =
                Bundle(
                    for: BVTestUsers.self)
                    .url(forResource: "testKeys",
                        withExtension: ".json") else {
            return ""
        }
        do {
            let data = try Data(contentsOf: resourceURL, options: [])
            if let json = try JSONSerialization.jsonObject(with: data) as? [String : Any] {
                return json[key.rawValue] as? String ?? ""
            } else {
                return ""
            }
        } catch {
            return ""
        }
    }
    
}
