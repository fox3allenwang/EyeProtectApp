//
//  RecordViewController.swift
//  EyesApp
//
//  Created by imac-2437 on 2023/5/19.
//

import UIKit

class RecordViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var recordTableView: UITableView!
    
    // MARK: - Property／Variables
    
    var timeRecord: [Date] = []
    
    var statusRecord: [String] = ["環境亮度低", "環境亮度中", "環境亮度中", "環境亮度低"]

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    
    private func setupUI() {
        navigationItem.title = "環境紀錄"
        setupTableView()
    }
    
    func setupTableView() {
        recordTableView.register(UINib(nibName: "RecordTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: RecordTableViewCell.identifier )
        recordTableView.dataSource = self
        recordTableView.delegate = self
    }
    
    // MARK: - Function
    
    func setupTimeRecord(now: Date) -> String {
        // 創建一個日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print("當前日期時間：\(dformatter.string(from: now))")
        return dformatter.string(from: now)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension RecordViewController: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalDatabase.shared.timeRecord.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier,
                                                       for: indexPath) as? RecordTableViewCell else {
            fatalError("RecordTableViewCell Load Failed")
        }
        cell.timeLabel.text = self.setupTimeRecord(now: LocalDatabase.shared.timeRecord[indexPath.row])
        cell.statusLabel.text = String(LocalDatabase.shared.statusRecord[indexPath.row])
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 3
        cell.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        let backgroundView = UIView()
        if LocalDatabase.shared.statusRecord[indexPath.row] <= 150 {
            cell.backgroundColor = UIColor(red: 201/255, green: 222/255, blue: 223/255, alpha: 1)
            cell.statusLabel.text = "燈光亮度充足"
        } else if (LocalDatabase.shared.statusRecord[indexPath.row] <= 300 &&
                   LocalDatabase.shared.statusRecord[indexPath.row] > 150) {
            cell.statusLabel.text = "燈光亮度稍微不足"
            cell.backgroundColor = UIColor(red: 245/255, green: 221/255, blue: 173/255, alpha: 1)
        } else if (LocalDatabase.shared.statusRecord[indexPath.row] > 300) {
            cell.statusLabel.text = "燈光亮度嚴重不足"
            cell.backgroundColor = UIColor(red: 241/255, green: 188/255, blue: 174/255, alpha: 1)
        }
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
