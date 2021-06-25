//
//  SettingItem.swift
//  QueritelPractical
//
//  Created by Bright Ahedor on 24/06/2021.
//

import Foundation


struct SettingsItem {
    var image: String
    var name: String
    var action: SettingAction
}

enum SettingAction {
   case PROFILE
   case RECORD
   case NOTIFICATION
}
