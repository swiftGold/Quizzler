//
//  Presenter.swift
//  Quizzler
//
//  Created by Сергей Золотухин on 30.01.2023.
//
protocol PresenterProtocol {
    func viewDidLoad()
    func buttonDidTap(senderTitle: String)
}

final class Presenter {
    weak var viewController: ViewControllerProtocol?
    
    var progress: Float = 0.0
    var attempsCounter = 0
    var quizBrain = QuizBrain()
}

extension Presenter: PresenterProtocol {
    func viewDidLoad() {
        updateLabel()
    }
    
    func buttonDidTap(senderTitle: String) {
        userAnswerCheck(senderTitle)
        questionsCounter()
        updateLabel()
        attempsCounter += 1
        progressCheck()
    }
}

private extension Presenter {
    func userAnswerCheck(_ senderTitle: String) {
        let userAnswer = senderTitle
        let actualAnswer = quizBrain.quiz[quizBrain.questionNumber].answer
        if userAnswer == actualAnswer {
            let progressBarStep = Float(1.0) / Float(quizBrain.quiz.count)
            progressStep(actualAnswer, progressBarStep)
        } else {
            let progressBarStep: Float = 0.0
            progressStep(actualAnswer, progressBarStep)
        }
    }
    
    func questionsCounter() {
        if quizBrain.questionNumber + 1 < quizBrain.quiz.count {
            quizBrain.questionNumber += 1
        } else {
            quizBrain.questionNumber = 0
        }
    }
    
    func progressStep(_ isTrue: String, _ progressBar: Float) {
        let isTrue: String = isTrue
        progress += progressBar
        let progressViewModel = ProgressViewModel(progress: progress,
                                                  isTrue: isTrue
        )
        viewController?.updateProgressBar(progressViewModel)
    }
    
    func updateLabel() {
        let labelText = quizBrain.quiz[quizBrain.questionNumber].text
        viewController?.updateTitleLabel(labelText: labelText)
    }
    
    func progressCheck() {
        viewController?.progressCheck(with: attempsCounter)
    }
}
