//
//  CategoryCell.swift
//  SwiftTrainer
//
//

import UIKit

class CategoryCell: UITableViewCell {
    static let identifier = "CategoryCell"
    
    private let button = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    private func setupUI() {
        self.backgroundColor = .systemGroupedBackground
        button.translatesAutoresizingMaskIntoConstraints = false
               button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
       
               // цветовая гамма
               button.backgroundColor = .white
               button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
               button.layer.cornerRadius = 12
               button.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
               button.layer.shadowOpacity = 0.2
               button.layer.shadowRadius = 4
               button.layer.shadowOffset = CGSize(width: 0, height: 2)
               
               button.isUserInteractionEnabled = false // чтобы нажатие ловила ячейка
               contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configure(with title: String) {
        button.setTitle(title, for: .normal)
    }
}
