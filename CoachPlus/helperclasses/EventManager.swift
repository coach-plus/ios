//
//  EventManager.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 26.04.19.
//  Copyright © 2019 Mathandoro GbR. All rights reserved.
//

import Foundation
import RxSwift

class EventManager {
    
    static let shared = EventManager()
    
    var eventsChanged: PublishSubject<[Event]?>
    
    init() {
        self.eventsChanged = PublishSubject<[Event]?>()
    }
}
