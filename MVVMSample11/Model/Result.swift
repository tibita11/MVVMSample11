//
//  Result.swift
//  MVVMSample11
//
//  Created by 鈴木楓香 on 2023/02/10.
//

import Foundation

// 検索結果を格納する
struct Result: Decodable {
    var title: String
    var user: User
    
    struct User: Decodable {
        var name: String
    }
}
