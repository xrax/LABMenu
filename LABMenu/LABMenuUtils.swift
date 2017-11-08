//
//  LABMenuUtils.swift
//  LABMenu
//
//  Created by Leonardo Armero Barbosa on 11/8/17.
//  Copyright © 2017 Exsis. All rights reserved.
//

import Foundation

class LABMenuUtils {
    static func getPercentWith(min: CGFloat, max: CGFloat, num: CGFloat) -> CGFloat {
        return (num - min) / (max - min)
    }
}
