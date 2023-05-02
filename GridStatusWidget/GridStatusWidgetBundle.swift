//
//  GridStatusWidgetBundle.swift
//  GridStatusWidget
//
//  Created by Nicolas Le Gorrec on 4/30/23.
//

import WidgetKit
import SwiftUI

@main
struct GridStatusWidgetBundle: WidgetBundle {
    var body: some Widget {
        GridStatusWidget()
        GridStatusWidgetLiveActivity()
    }
}
