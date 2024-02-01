//
//  TCA_pt2App.swift
//  TCA-pt2
//
//  Created by Kien Hoang on 30/01/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_pt2App: App {
  var body: some Scene {
    WindowGroup {
      RootView(
        store: Store(initialState: RootReducer.State()) {
          RootReducer()
        }
      )
    }
  }
}
