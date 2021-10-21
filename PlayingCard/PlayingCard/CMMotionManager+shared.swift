//
//  CMMotionManager+shared.swift
//  PlayingCard
//
//  Created by macbook on 11/15/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import CoreMotion

extension CMMotionManager {
    // creating shared motion manager, anyone who uses it can access it
    static var shared = CMMotionManager()
}
