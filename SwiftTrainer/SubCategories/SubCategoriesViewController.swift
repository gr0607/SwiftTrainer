//
//  SubCategoriesViewController.swift
//  SwiftTrainer
//
//

import UIKit
import CoreData

class SubCategoriesViewController: UIViewController {
    
    private var subcategories: [SubCategory] = []
    private var category: Category
       
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10      // вертикальный отступ между ячейками
        layout.minimumInteritemSpacing = 10 // горизонтальный отступ между ячейками
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16) // отступы по краям
        let itemWidth = (view.bounds.width - 48) / 2  // 2 столбца (отступы по 16)
        layout.itemSize = CGSize(width: itemWidth, height: 80)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SubCategoryCell.self, forCellWithReuseIdentifier: "SubCategoryCell")
        collectionView.backgroundColor = .systemGroupedBackground
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSubcategories()
       
        title = "Темы"
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func fetchSubcategories() {
        subcategories = CoreDataManager.shared.fetchSubcategories(for: category)
               collectionView.reloadData()
           
       }
}

// MARK: - DataSource
extension SubCategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subcategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
        cell.configure(with: subcategories[indexPath.item].name)
        return cell
    }
}

// MARK: - Delegate
extension SubCategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Выбрана подкатегория: \(subcategories[indexPath.item])")
        // здесь потом пушим экран вопросов
        let selectedSubCategory = subcategories[indexPath.item]
         
        
        let questions = CoreDataManager.shared.fetchQuestions(for: selectedSubCategory)
        
        let vc = QuestionController()
        vc.category = category
        vc.questions = questions
        vc.subCategory = selectedSubCategory
        navigationController?.pushViewController(vc, animated: true)
    }
}

