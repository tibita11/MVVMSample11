//
//  QiitaAPIClient.swift
//  MVVMSample11
//
//  Created by 鈴木楓香 on 2023/02/12.
//

import Foundation
import Alamofire

protocol APIClient {
    var url: String { get }
    func getRequest(_ parameters: [String : String]) -> DataRequest
}



class QiitaAPIclient: APIClient {
    let url = "https://qiita.com/api/v2/items"
    
    func getRequest(_ parameters: [String : String]) -> DataRequest {
        return AF.request(url, parameters: parameters)
    }
    
}
