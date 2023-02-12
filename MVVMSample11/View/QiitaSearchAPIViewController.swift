//
//  WikipediaSearchAPIViewController.swift
//  MVVMSample11
//
//  Created by 鈴木楓香 on 2023/02/10.
//

import UIKit
import RxSwift
import RxCocoa

class QiitaSearchAPIViewController: UIViewController {
    @IBOutlet weak var keywordSearchBar: UISearchBar!
    @IBOutlet weak var articleTableView: UITableView!
    
    let disposeBag = DisposeBag()
    /// searchBarに関する通知処理
    private let searchBarRelay = PublishRelay<String>()
    /// searchBarの通知を渡すために定義
    var searchBarObservable: Observable<String> {
        return searchBarRelay.asObservable()
    }
    
    
    // MARK: - View Life Cycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "articleCell")
        setup()
    }
    
    
    // MARK: - Action
    
    private func setup() {
        let viewModel = QiitaSearchAPIViewModel()
        let input = QiitaSearchAPIInput(keywordSearchBar: searchBarObservable)
        viewModel.setup(input: input, model: QiitaSearchAPIModel())
        
        // delegateとdatasorceが紐づいているとエラーになるので注意する
        viewModel.outputs?.articlesObserver
            .drive(self.articleTableView.rx.items(cellIdentifier: "articleCell", cellType: ArticleTableViewCell.self)) { index, result, cell in
                cell.titleLabel.text = result.title
                cell.userNameLabel.text = result.user.name
            }
            .disposed(by: disposeBag)
        
    }

}


// MARK: - UISearchBarDelegate

extension QiitaSearchAPIViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        // 入力値をViewModelに渡す
        guard let text = searchBar.text else { return }
        searchBarRelay.accept(text)
    }
}
