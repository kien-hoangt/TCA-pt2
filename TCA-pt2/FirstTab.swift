//
//  FirstTab.swift
//  TCA-pt2
//
//  Created by Kien Hoang on 01/02/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct FirstTabReducer {
  @ObservableState
  struct State: Equatable {
    @Presents var destination: Destination.State?
  }
  
  enum Action {
    case destination(PresentationAction<Destination.Action>)
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
        state.destination = .addItem(AddReducer.State())
        return .none
      case .detailItemButtonTapped:
        state.destination = .detailItem(DetailReducer.State())
        return .none
      case .editItemButtonTapped:
        state.destination = .editItem(EditReducer.State())
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
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
//      case alert
//      case confirmationDialog
    }
    enum Action {
      case addItem(AddReducer.Action)
      case detailItem(DetailReducer.Action)
      case editItem(EditReducer.Action)
//      case alert
//      case confirmationDialog
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
    }
  }
}

struct FirstTab: View {
  @Bindable var store: StoreOf<FirstTabReducer>
  
  var body: some View {
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
    .sheet(
      item: $store.scope(state: \.destination?.addItem, action: \.destination.addItem)
    ) { store in
      NavigationStack {
        AddView(store: store)
      }
    }
    .popover(
      item: $store.scope(state: \.destination?.editItem, action: \.destination.editItem)
    ) { store in
      EditView(store: store)
    }
    .navigationDestination(
      item: $store.scope(state: \.destination?.detailItem, action: \.destination.detailItem)
    ) { store in
      DetailView(store: store)
    }
//    .alert(
//      $store.scope(state: \.alert, action: \.alert)
//    )
//    .confirmationDialog(
//      $store.scope(state: \.confirmationDialog, action: \.confirmationDialog)
//    )
  }
}

#Preview {
  FirstTab(
    store: Store(initialState: FirstTabReducer.State()) {
      FirstTabReducer()
    }
  )
}
