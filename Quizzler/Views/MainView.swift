//
//  MainView.swift
//  Quizzler
//
//  Created by Сергей Золотухин on 30.01.2023.
//

import UIKit

protocol MainViewDelegate: AnyObject {
    func buttonDidTap(senderTitle: String)
}

final class MainView: UIView {

    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var trueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("True", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 5.0
        button.layer.borderColor = UIColor(red: 70/255, green: 99/255, blue: 144/255, alpha: 1).cgColor
        button.clipsToBounds = true
        return button
    }()

    private lazy var falseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("False", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 5.0
        button.layer.borderColor = UIColor(red: 70/255, green: 99/255, blue: 144/255, alpha: 1).cgColor
        button.clipsToBounds = true
        return button
    }()

    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.0
        progressView.trackTintColor = .white
        progressView.progressTintColor = UIColor(red: 251/255, green: 115/255, blue: 165/255, alpha: 1)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    weak var delegate: MainViewDelegate?
    var mainViewModel = ProgressViewModel(progress: 0.0, isTrue: "")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMainView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func buttonTapped(_ sender: UIButton) {
        guard let senderTitle = sender.titleLabel?.text else { return }
        delegate?.buttonDidTap(senderTitle: senderTitle)
        
        if senderTitle == String(mainViewModel.isTrue) {
            sender.backgroundColor = .green
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                sender.backgroundColor = .clear
            }
        } else {
            sender.backgroundColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                sender.backgroundColor = .clear
            }
        }
    }
}

extension MainView {
    func updateTitleLabel(labelText: String) {
        questionLabel.text = labelText
    }

    func updateProgressBar(_ viewModel: ProgressViewModel) {
        progressView.setProgress(viewModel.progress, animated: true)
        mainViewModel = viewModel
    }

    func progressCheck(with attempsCounter: Int) {
        if progressView.progress >= 1 {
            questionLabel.text = "Congratulation, you won for \(attempsCounter) attemps"
            questionLabel.textColor = .red
            trueButton.isEnabled = false
            falseButton.isEnabled = false
        }
    }
}

private extension MainView {
    func setupMainView() {
        backgroundColor = UIColor(red: 49/255, green: 58/255, blue: 93/255, alpha: 1)
        addSubviews()
        setConstraints()
    }

    func addSubviews() {
        mainStackView.addArrangedSubview(questionLabel)
        mainStackView.addArrangedSubview(trueButton)
        mainStackView.addArrangedSubview(falseButton)
        mainStackView.addArrangedSubview(progressView)

        addSubview(mainStackView)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor),

            trueButton.heightAnchor.constraint(equalToConstant: 80),
            falseButton.heightAnchor.constraint(equalToConstant: 80),
            progressView.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
}
