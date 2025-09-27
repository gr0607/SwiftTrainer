//
//  ResultController.swift
//  SwiftTrainer
//
//  Created by admin on 23.09.2025.
//

import UIKit

class ResultController: UIViewController {
    
    var totalQuestions: Int = 0
    var correctAnswers: Int = 0
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let repeatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Повторить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let homeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("На главную", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .white
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        resultLabel.text = "Правильных ответов: \(correctAnswers) из \(totalQuestions)"
        
        repeatButton.addTarget(self, action: #selector(repeatTapped), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        
        setupUI()
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [resultLabel, repeatButton, homeButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        repeatButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        homeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func repeatTapped() {
        if let nav = navigationController {
                // Находим предыдущий QuestionController в стеке
                if let questionVC = nav.viewControllers.first(where: { $0 is QuestionController }) as? QuestionController {
                    // Сбрасываем состояние
                    questionVC.currentIndex = 0
                    questionVC.correctCount = 0
                    questionVC.showQuestion(at: 0)
                    
                    // Возвращаемся к нему
                    nav.popToViewController(questionVC, animated: true)
                }
            }
    }
    
    @objc private func homeTapped() {
        navigationController?.popToRootViewController(animated: true) // на главный экран
    }
}

