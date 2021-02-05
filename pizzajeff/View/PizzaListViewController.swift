//
//  PizzaListViewController.swift
//  pizzajeff
//
//  Created by Carlos Diaz Moreno on 2/2/21.
//

import UIKit

class PizzaListViewController: BaseViewController {
    
    @IBOutlet weak var pizzaListCollectionView: UICollectionView!
    
    var presenter: MasterViewPresenter?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        presenter = ListPresenter(self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pizza Jeff"
        addLogoutButton()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false

        let cellWidth = self.view.frame.width - 40
        let layout = PizzaCollectionViewLayout(itemSize: cellWidth)

        pizzaListCollectionView.setCollectionViewLayout(layout, animated: true)
        showLoadingAnnimation()
        presenter?.loadPizzas()

    }
    
    func addLogoutButton() {
        let logoutButton = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logoutAction))
        logoutButton.tintColor = UIColor.black
        logoutButton.isAccessibilityElement = true
        logoutButton.accessibilityIdentifier = "logoutButton"
        self.navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc func logoutAction() {
        self.showLoadingAnnimation()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            UserDefaults.standard.removeObject(forKey: "name")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "status")
            self.removeLoadingAnimation()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupUI() {
        pizzaListCollectionView.register(UINib(nibName: String.init(describing: PizzaListItemViewCell.self), bundle: nil), forCellWithReuseIdentifier: "pizzaCell")
        pizzaListCollectionView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        pizzaListCollectionView.refreshControl = refreshControl
    }

    func reloadData() {
        pizzaListCollectionView.refreshControl?.endRefreshing()
        pizzaListCollectionView.reloadData()
        self.removeLoadingAnimation()
    }

    @objc private func pullToRefresh() {
        presenter?.loadPizzas()
    }
    
}

extension PizzaListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.pizzaCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pizzaCell", for: indexPath) as? PizzaListItemViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: presenter?.getPizzaAt(position: indexPath))
        
        return cell
    }
}

extension PizzaListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = PizzaDetailViewController(nibName: String(describing: PizzaDetailViewController.self), bundle: nil, pizzaList: presenter?.pizzas, pizza: presenter?.getPizzaAt(position: indexPath), isSingleClient: UserDefaults.standard.value(forKey: "status") as? Bool ?? false)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}


class PizzaCollectionViewLayout: UICollectionViewFlowLayout {
    convenience init(itemSize: CGFloat) {
        self.init()
        self.itemSize = CGSize(width: itemSize, height: itemSize/2)
        sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
    }
    
}

