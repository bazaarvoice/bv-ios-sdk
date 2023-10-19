//
//  BVTestUsers.swift
//  BVSDK
//
//  Copyright © 2023 Bazaarvoice. All rights reserved.
// 

import Foundation

class BVTestUsers {
    enum userIdKeys: String {
        case answerUserId = "answerUserId"
        case feedbackUserId = "feedbackUserId"
        case feedbackUser = "feedbackUser"
        case questionsUserId = "questionsUserId"
        case reviewUserId = "reviewUserId"
        case reviewUser = "reviewUser"
        case storeReviewUserId = "storeReviewUserId"
        case submitUserId = "submitUserId"
        case incorrectUserId = "incorrectUserId"
        case hostedAuthUserId = "hostedAuthUserId"
    }
    
    func loadKeyForUserId(userId: userIdKeys) -> String {
        guard let resourceURL =
                Bundle(
                    for: BVTestUsers.self)
                    .url(forResource: "userIdJSON",
                        withExtension: ".json") else {
            return ""
        }
        do {
            let data = try Data(contentsOf: resourceURL, options: [])
            if let json = try JSONSerialization.jsonObject(with: data) as? [String : Any] {
                return json[userId.rawValue] as? String ?? ""
            } else {
                return ""
            }
        } catch {
            return ""
        }
    }
    
}
