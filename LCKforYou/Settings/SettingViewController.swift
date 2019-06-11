//
//  ProfileViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 13/07/2018.
//  Copyright © 2018 Seungyeon Lee. All rights reserved.
//

import UIKit
import MessageUI
import UserNotifications
import RxSwift
import RxCocoa
import RxDataSources
import AcknowList

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let supportList: [String] = ["알림 설정"]
    let lckforyouList: [String] = ["이메일로 문의하기", "트위터"]
    let opensourceList: [String] = ["오픈소스 라이센스"]
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableview
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.navigationController?.navigationBar.topItem?.title = "설정"
        
        setupBind()
        
    }
    
    private func setupBind() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData2>(
            configureCell: { dataSource, tableView, indexPath, titles in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell2", for: indexPath)
                cell.textLabel?.text = titles
                return cell
                
        })
        
        let sections = [SectionOfCustomData2(items: supportList), SectionOfCustomData2(items: lckforyouList), SectionOfCustomData2(items: opensourceList)]
        
        Observable.just(sections)
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { (indexPath) in
                if indexPath.section == 0 {
                    guard let settingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsURL) else {
                        return
                    }
                    UIApplication.shared.open(settingsURL)
                }
                else if indexPath.section == 1 && indexPath.row == 0 {
                    //메일 보내기
                    if !MFMailComposeViewController.canSendMail() {
                        print("Mail services are not available")
                        return
                    }
                    
                    let composeVC = MFMailComposeViewController()
                    composeVC.mailComposeDelegate = self
                    
                    composeVC.setToRecipients(["adie0423@gmail.com"])
                    composeVC.setSubject("[DailyLCK]")
                    
                    self.present(composeVC, animated: true, completion: nil)
                    
                } else if indexPath.section == 1 && indexPath.row == 1 {
                    let screenName =  "dailylck"
                    let appURL = URL(string: "twitter://user?screen_name=\(screenName)")!
                    let webURL = URL(string: "https://twitter.com/\(screenName)")!
                    
                    // 사용자가 트위터 앱을 설치한 경우 앱에서 열음
                    if UIApplication.shared.canOpenURL(appURL) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(appURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(appURL)
                        }
                    } else {
                        // 사용자가 트위터 앱이 없는 경우 사파리로 리다이렉트
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(webURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(webURL)
                        }
                    }
                } else if indexPath.section == 2 {
                    let acknowListViewController = AcknowListViewController()
                    acknowListViewController.title = "오픈소스 라이센스"
                    acknowListViewController.footerText = ""
                    self.navigationController?.pushViewController(acknowListViewController, animated: true)
                }

            }).disposed(by: disposeBag)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// RxDataSources
struct SectionOfCustomData2 {
    var items: [String]
}

extension SectionOfCustomData2: SectionModelType {
    init(original: SectionOfCustomData2, items: [String]) {
        self = original
        self.items = items
    }
}
