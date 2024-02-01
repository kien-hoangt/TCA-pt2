//
//  SecondTab.swift
//  TCA-pt2
//
//  Created by Kien Hoang on 01/02/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SecondTabReducer {
  @ObservableState
  struct State: Equatable {
    var path = StackState<Destination.State>()
  }
  
  enum Action {
    case destination(StackAction<Destination.State, Destination.Action>)
    case addItemButtonTapped
    case detailItemButtonTapped
    case editItemButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .destination:
        return .none
      case .addItemButtonTapped:
        state.path.append(.addItem(AddReducer.State()))
        return .none
      case .detailItemButtonTapped:
        state.path.append(.detailItem(DetailReducer.State()))
        return .none
      case .editItemButtonTapped:
        state.path.append(.editItem(EditReducer.State()))
        return .none
      }
    }
    .forEach(\.path, action: \.destination) {
      Destination()
    }
  }
  
  @Reducer
  struct Destination {
    @ObservableState
    enum State: Equatable {
      case addItem(AddReducer.State)
      case detailItem(DetailReducer.State)
      case editItem(EditReducer.State)
    }
    enum Action {
      case addItem(AddReducer.Action)
      case detailItem(DetailReducer.Action)
      case editItem(EditReducer.Action)
    }
    var body: some ReducerOf<Self> {
      Scope(state: \.addItem, action: \.addItem) {
        AddReducer()
      }
      Scope(state: \.editItem, action: \.editItem) {
        EditReducer()
      }
      Scope(state: \.detailItem, action: \.detailItem) {
        DetailReducer()
      }
      Reduce { state, action in
        return .none
      }
    }
  }
}

struct SecondTab: View {
  @Bindable var store: StoreOf<SecondTabReducer>
  
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.destination)) {
      List {
        Button(
          action: {
            store.send(.addItemButtonTapped)
          },
          label: {
            Text("Add Item")
          }
        )
        Button(
          action: {
            store.send(.detailItemButtonTapped)
          },
          label: {
            Text("Detail Item")
          }
        )
        Button(
          action: {
            store.send(.editItemButtonTapped)
          },
          label: {
            Text("Edit Item")
          }
        )
      }
    } destination: { store in
      switch store.state {
      case .addItem:
        if let store = store.scope(state: \.addItem, action: \.addItem) {
          AddView(store: store)
        }
      case .detailItem:
        if let store = store.scope(state: \.detailItem, action: \.detailItem) {
          DetailView(store: store)
        }
      case .editItem:
        if let store = store.scope(state: \.editItem, action: \.editItem) {
          EditView(store: store)
        }
      }
    }
  }
}

#Preview {
  SecondTab(
    store: Store(initialState: SecondTabReducer.State()) {
      SecondTabReducer()
    }
  )
}
