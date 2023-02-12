//
//  WikipediaSearchAPIModel.swift
//  MVVMSample11
//
//  Created by 鈴木楓香 on 2023/02/10.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

/// 全てのエラー
enum QiitaSearchAPIError: LocalizedError {
    case NoData
    
    var errorDescription: String? {
        switch self {
        case .NoData:
            return "結果を取得できませんでした。"
        }
    }
}

class QiitaSearchAPIModel {
    let client = QiitaAPIclient()
    
    /// 検索結果を返す
    public func getQiitaArticle(parameters: [String : String]) -> Observable<[Result]> {
        return Observable<[Result]>.create { [weak self] observer in
            let request = self!.client.getRequest(parameters)
                .validate()
                .responseDecodable(of: [Result].self) { response in
                    guard let results = response.value else { return observer.onError(QiitaSearchAPIError.NoData)}
                    observer.onNext(results)
                    observer.onCompleted()
                }
            return Disposables.create { request.cancel() }
        }
    }
}
