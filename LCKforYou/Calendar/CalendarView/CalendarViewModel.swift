//
//  CalendarViewModel.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 02/05/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CalendarViewModel {
    var detail: PublishSubject<[SectionOfCustomData]>
    
    let disposeBag = DisposeBag()
    
    init(request: Requests = Requests()) {
        self.detail = PublishSubject<[SectionOfCustomData]>()

    }
}
