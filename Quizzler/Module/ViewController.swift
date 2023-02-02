//
//  ViewController.swift
//  Quizzler
//
//  Created by Сергей Золотухин on 30.01.2023.
//

import UIKit

protocol ViewControllerProtocol: AnyObject {
    func updateTitleLabel(labelText: String)
    func updateProgressBar(_ viewModel: ProgressViewModel)
    func progressCheck(with attempsCounter: Int)
}

final class ViewController: UIViewController {
    
    var presenter: PresenterProtocol?
    private lazy var mainView: MainView = {
        let mainView = MainView()
        mainView.delegate = self
        mainView.translatesAutoresizingMaskIntoConstraints = false
        return mainView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        presenter?.viewDidLoad()
    }
}

extension ViewController: MainViewDelegate {
    func buttonDidTap(senderTitle: String) {
        presenter?.buttonDidTap(senderTitle: senderTitle)
    }
}

extension ViewController: ViewControllerProtocol {
    func updateTitleLabel(labelText: String) {
        mainView.updateTitleLabel(labelText: labelText)
    }
    
    func updateProgressBar(_ viewModel: ProgressViewModel) {
        mainView.updateProgressBar(viewModel)
    }
    
    func progressCheck(with attempsCounter: Int) {
        mainView.progressCheck(with: attempsCounter)
    }
}

private extension ViewController {
    func setupViewController() {
        view.backgroundColor = UIColor(red: 49/255, green: 58/255, blue: 93/255, alpha: 1)
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        view.addSubview(mainView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
}
