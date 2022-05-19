//
//  SettingViewController.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/18.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    let settingList = ["로그아웃", "회원탈퇴"]
    let etcList = ["버전"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
        
        setUpTableView()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 1
        }
    }
    
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "SettingTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "SettingTableViewCell")
    }
}

// MARK: - Extension
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0 :
                return settingList.count
            case 1:
                return etcList.count
            default :
                return 0
        }
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0 :
                return "설정"
            case 1:
                return "기타"
            default :
                return ""
        }
    }
        
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let tableView = view as? UITableViewHeaderFooterView else { return }
        tableView.textLabel?.textColor = UIColor.fontColorGray
        tableView.textLabel?.font = UIFont.NanumSquare(type: .Bold, size: 14)
        tableView.contentView.backgroundColor = UIColor(hex: 0xF2F2F2)
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        
        let text: String = settingList[indexPath.row]
        cell.settingLabel.text = text
        cell.settingLabel.textColor = UIColor.fontColorGray
        cell.settingLabel.font = UIFont.NanumSquare(type: .Regular, size: 16)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        // get Version
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let versionLabel = UILabel()
        versionLabel.text = version
        cell.settingLabel.textColor = UIColor.fontColorGray
        cell.settingLabel.font = UIFont.NanumSquare(type: .Regular, size: 16)
        versionLabel.sizeToFit()
        
        if indexPath[0] == 1 {
            cell.accessoryView = versionLabel
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath[0] == 0 && indexPath[1] == 0 {
            let alert = UIAlertController(title:"로그아웃 하시겠습니까?",
                message: "",
                preferredStyle: UIAlertController.Style.alert)

            let yes = UIAlertAction(title: "확인", style: .destructive, handler: {
                action in

                do {
                    if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                            delegate.isLogged = false // 로그아웃 실행
                    }
                    
                    try Auth.auth().signOut()
                    self.navigationController?.popToRootViewController(animated: true)
                }
                catch let signOutError as NSError {
                    print("ERROR: signout \(signOutError.localizedDescription)")
                }
            })
            let no = UIAlertAction(title: "취소", style: .default, handler: nil)
            
            alert.addAction(yes)
            alert.addAction(no)
            
            present(alert,animated: true,completion: nil)
        } else if indexPath[0] == 0 && indexPath[1] == 1 {
            let alert = UIAlertController(title:"탈퇴 하시겠습니까?",
                message: "",
                preferredStyle: UIAlertController.Style.alert)

            let yes = UIAlertAction(title: "확인", style: .destructive, handler: {
                action in
                // 회원탈퇴 구현
                do {
                    try Auth.auth().signOut()
                    print("회원탈퇴 완료!")
                    self.navigationController?.popToRootViewController(animated: true)
                } catch let signOutError as NSError {
                    print("ERROR: signout \(signOutError.localizedDescription)")
                }
            })
            let no = UIAlertAction(title: "취소", style: .default, handler: nil)
            alert.addAction(yes)
            alert.addAction(no)
            
            present(alert,animated: true,completion: nil)
        }

    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
}