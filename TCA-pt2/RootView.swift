//
//  RootView.swift
//  TCA-pt2
//
//  Created by Kien Hoang on 01/02/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct RootReducer {
  @ObservableState
  struct State: Equatable {
    var firstTab = FirstTabReducer.State()
    var secondTab = SecondTabReducer.State()
    
    var currentTab: Tab = .firstTab
  }
  
  enum Action {
    case firstTabSelected(FirstTabReducer.Action)
    case secondTabSelected(SecondTabReducer.Action)
    
    case tabChanged(Tab)
  }
  
  enum Tab: Int, CaseIterable, Identifiable {
    case firstTab
    case secondTab
    
    var id: Int { self.rawValue }
    
    var title: String {
      switch self {
      case .firstTab:
        return "Tree-based"
      case .secondTab:
        return "Stack-based"
      }
    }
    
    var systemImage: String {
      switch self {
      case .firstTab:
        return "tree.fill"
      case .secondTab:
        return "square.stack.3d.up.fill"
      }
    }
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.firstTab, action: \.firstTabSelected) {
      FirstTabReducer()
    }
    Scope(state: \.secondTab, action: \.secondTabSelected) {
      SecondTabReducer()
    }
    Reduce { state, action in
      switch action {
      case .firstTabSelected:
        return .none
      case .secondTabSelected:
        return .none
      case .tabChanged(let selectedTab):
        state.currentTab = selectedTab
        return .none
      }
    }
  }
}

struct RootView: View {
  @Bindable var store: StoreOf<RootReducer>
  
  var body: some View {
    TabView(selection: $store.currentTab.sending(\.tabChanged)) {
      NavigationStack {
        FirstTab(
          store: store.scope(
            state: \.firstTab,
            action: \.firstTabSelected
          )
        )
      }
      .tag(RootReducer.Tab.firstTab)
      .tabItem {
        Label(
          RootReducer.Tab.firstTab.title,
          systemImage: RootReducer.Tab.firstTab.systemImage
        )
      }
      
      SecondTab(
        store: store.scope(
          state: \.secondTab,
          action: \.secondTabSelected
        )
      )
      .tag(RootReducer.Tab.secondTab)
      .tabItem {
        Label(
          RootReducer.Tab.secondTab.title,
          systemImage: RootReducer.Tab.secondTab.systemImage
        )
      }
    }
  }
}

#Preview {
  RootView(
    store: Store(initialState: RootReducer.State()) {
      RootReducer()
    }
  )
}
