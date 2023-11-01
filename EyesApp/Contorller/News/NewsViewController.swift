//
//  NewsViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/29.
//

import UIKit

class NewsViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tbvNews: UITableView?
    
    // MARK: - Variables
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("NewsViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setupNewsTableView()
    }
    
    func setupNewsTableView() {
        tbvNews?.register(UINib(nibName: "HasPictureNewsTableViewCell", bundle: nil), forCellReuseIdentifier: HasPictureNewsTableViewCell.identified)
        tbvNews!.estimatedRowHeight = 100
        tbvNews!.rowHeight = UITableView.automaticDimension
        tbvNews?.dataSource = self
        tbvNews?.delegate = self
    }
    
    // MARK: - IBAction
    
}

// MARK: - Extension

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvNews?.dequeueReusableCell(withIdentifier: HasPictureNewsTableViewCell.identified,
                                                for: indexPath) as! HasPictureNewsTableViewCell
        cell.imgvPicture?.image = UIImage(systemName: "person.fill")
        return cell
    }
    
    
}

// MARK: - Protocol
