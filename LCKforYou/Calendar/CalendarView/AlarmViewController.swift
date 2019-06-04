//
//  AlarmViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 04/06/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import UserNotifications

class AlarmViewController: UIViewController {

    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var alarmView: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var timePickerView: UIPickerView!
    
    let disposeBag = DisposeBag()
    
    var match: Matches? = nil
    
    var time: Int = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBind()
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.dismissView.backgroundColor = .clear
    }
    
    private func setupBind() {
        // gesture 추가
        let tapGesture = UITapGestureRecognizer()
        self.dismissView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind(onNext: { recognizer in
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        
        // timepickerView
        let titleItems = Observable.just(["정시", "5분 전", "10분 전", "20분 전", "30분 전", "1시간 전", "2시간 전"])

        titleItems.bind(to: self.timePickerView.rx.itemTitles) { (row, element) in
            return element
        }.disposed(by: disposeBag)
        
        self.timePickerView.rx.itemSelected
            .subscribe(onNext: { (row, component) in
                print("\(row) component: \(component)")
                self.time = row
            }).disposed(by: disposeBag)
        
        // cancel button
        cancelButton.rx.tap
            .subscribe { (_) in
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        // confirm button
        okButton.rx.tap
            .subscribe { [unowned self] (_) in
                var timeSet = Double()
                
                switch self.time {
                case 0:
                    timeSet = TimeChoicer.M0.time
                case 1:
                    timeSet = TimeChoicer.M5.time
                case 2:
                    timeSet = TimeChoicer.M10.time
                case 3:
                    timeSet = TimeChoicer.M20.time
                case 4:
                    timeSet = TimeChoicer.M30.time
                case 5:
                    timeSet = TimeChoicer.H60.time
                case 6:
                    timeSet = TimeChoicer.H120.time
                default:
                    timeSet = TimeChoicer.M0.time
                }
                
                // 노티 등록
                registerNotification(time: timeSet, match: self.match!, type: .match)
                
                self.dismiss(animated: true, completion: nil)
                
            }.disposed(by: disposeBag)
    }
}
