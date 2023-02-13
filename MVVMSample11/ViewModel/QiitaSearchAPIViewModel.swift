//
//  WikipediaSearchAPIViewModel.swift
//  MVVMSample11
//
//  Created by 鈴木楓香 on 2023/02/10.
//

import Foundation
import RxSwift
import RxCocoa

struct QiitaSearchAPIInput {
    let keywordSearchBar: Observable<String>
}

protocol QiitaSearchAPIOutput {
    var articlesObserver: Driver<[Result]> { get }
}

protocol QiitaSearchAPIType {
    var outputs: QiitaSearchAPIOutput? { get }
    func setup(input: QiitaSearchAPIInput, model: QiitaSearchAPIModel)
}

class QiitaSearchAPIViewModel: QiitaSearchAPIType {
    var outputs: QiitaSearchAPIOutput?
    let disposeBag = DisposeBag()
    /// 検索結果を格納する
    var articles: Observable<[Result]>!
    
    init() {
        self.outputs = self
    }
    
    func setup(input: QiitaSearchAPIInput, model: QiitaSearchAPIModel) {
        articles = input.keywordSearchBar
            .flatMapLatest { text -> Observable<Event<[Result]>> in
                return model.getQiitaArticle(parameters: ["query" : "qiita title:\(text)"])
                    .materialize()
            }
            .flatMap { event -> Observable<[Result]> in
                switch event {
                case .next:
                    return .just(event.element!)
                case let .error(error as QiitaSearchAPIError):
                    print(error)
                    return .empty()
                case .error, .completed:
                    return .empty()
                }
            }
    }
    
}


// MARK: - QiitaSearchAPIOutput

extension QiitaSearchAPIViewModel: QiitaSearchAPIOutput {
    var articlesObserver: Driver<[Result]> {
        return articles.asDriver(onErrorDriveWith: .empty())
    }
    
    
}
