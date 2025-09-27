//
//  QuestionController.swift
//  SwiftTrainer
//
//

import UIKit

class QuestionController: UIViewController {
    
    var category: Category?         // сюда прилетает категория
    var subCategory: SubCategory?   // сюда прилетает подкатегория
    var questions: [Question] = [] // сюда прилетает вопросы
    var currentIndex = 0
    var correctCount = 0
    
    // MARK: - UI
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private let progressLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.boldSystemFont(ofSize: 16)
           label.textAlignment = .center
           return label
       }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private var answerButtons: [UIButton] = []
    
    private let hintButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подсказка", for: .normal)
      //  button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let finishButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Завершить тест"
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let subCategory = subCategory {
            let catName = category?.name ?? "Категория"
            categoryLabel.text = "\(catName): \(subCategory.name)"
        }
        
        // Подключаем подсказку
            hintButton.addTarget(self, action: #selector(showHint), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(finishTestTapped), for: .touchUpInside)

        setupUI()
        
        if !questions.isEmpty {
            showQuestion(at: currentIndex)
        }

        
        
    }
    
    private func setupUI() {
        // создаём кнопки ответов
        for i in 0..<4 {
            var config = UIButton.Configuration.filled()
            config.title = "Вариант \(i+1)"
            config.titleAlignment = .center   // текст слева
            config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)

            let button = UIButton(configuration: config, primaryAction: nil)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.layer.cornerRadius = 8
           
            
            button.tag = i
            button.addTarget(self, action: #selector(answerTapped(_:)), for: .touchUpInside)
            answerButtons.append(button)
        }
        
        let stack = UIStackView(arrangedSubviews: answerButtons)
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fill
        
        view.addSubview(categoryLabel)
        view.addSubview(progressLabel)
        view.addSubview(questionLabel)
        view.addSubview(stack)
        view.addSubview(hintButton)
        view.addSubview(finishButton)
       
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        hintButton.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        finishButton.translatesAutoresizingMaskIntoConstraints = false
               
     
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            progressLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 16),
            progressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
          //  progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            questionLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 16),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            stack.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 32),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            hintButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            hintButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
           
               
               // можно выровнять по одной линии
            finishButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 32),
               finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
    
    // MARK: - Helpers
    func showQuestion(at index: Int) {
        let question = questions[index]
        progressLabel.text = "Вопрос \(index + 1) из \(questions.count) :"
        questionLabel.text = question.questionText

        let answers = [question.answer1, question.answer2, question.answer3, question.answer4]
        for (i, button) in answerButtons.enumerated() {
            let title = answers[i] ?? "" // если поля опциональные
            applyDefaultConfiguration(to: button, title: title, tag: i)
        }
    }
    
    private func showFinishAlert() {
        let alert = UIAlertController(
            title: "Тест завершён",
            message: "Вы прошли все вопросы!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }


    
    // MARK: - Actions
    // ХЕЛПЕР: настраивает дефолтный вид кнопки и сбрасывает цвет/включённость
    private func applyDefaultConfiguration(to button: UIButton, title: String, tag: Int) {
        var config = button.configuration ?? UIButton.Configuration.filled()
        config.title = title
        config.titleAlignment = .center
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        // дефолтные цвета
        config.baseForegroundColor = .systemBlue
        config.baseBackgroundColor = .white

        // можно настроить стиль углов/тень здесь, если нужно
        // config.cornerStyle = .medium

        button.configuration = config
       
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.tag = tag
        button.isUserInteractionEnabled = true
    }

   
    // ПЕРЕПИСАННЫЙ answerTapped - подсветка через configuration
    @objc private func answerTapped(_ sender: UIButton) {
        guard currentIndex < questions.count else { return }
        let question = questions[currentIndex]
        let correctIndex = Int(question.correctAnswer)

        // подсветка выбранной
        if sender.tag == correctIndex {
            var config = sender.configuration ?? UIButton.Configuration.filled()
            config.baseBackgroundColor = .systemGreen
            config.baseForegroundColor = .white
            sender.configuration = config
            correctCount += 1
        } else {
            var wrongConfig = sender.configuration ?? UIButton.Configuration.filled()
            wrongConfig.baseBackgroundColor = .systemRed
            wrongConfig.baseForegroundColor = .white
            sender.configuration = wrongConfig

            // подсветим правильный
            if correctIndex < answerButtons.count {
                var correctConfig = answerButtons[correctIndex].configuration ?? UIButton.Configuration.filled()
                correctConfig.baseBackgroundColor = .systemGreen
                correctConfig.baseForegroundColor = .white
                answerButtons[correctIndex].configuration = correctConfig
            }
        }

        // заблокировать кнопки
        answerButtons.forEach { $0.isUserInteractionEnabled = false }

        // перейти к следующему
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.currentIndex += 1
            if self.currentIndex < self.questions.count {
                self.showQuestion(at: self.currentIndex)
            } else {
                let resultVC = ResultController()
                resultVC.totalQuestions = self.questions.count
                resultVC.correctAnswers = self.correctCount
                self.navigationController?.pushViewController(resultVC, animated: true)
            }
        }
    }

    
    @objc private func showHint() {
        guard currentIndex < questions.count else { return }
        let question = questions[currentIndex]
        
        let alert = UIAlertController(
            title: "Подсказка",
            message: question.hint,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func finishTestTapped() {
        let resultVC = ResultController()
        resultVC.totalQuestions = questions.count
        resultVC.correctAnswers = correctCount
        navigationController?.pushViewController(resultVC, animated: true)
    }
    
   
}
