//
//  AddView.swift
//  TCA-pt2
//
//  Created by Kien Hoang on 30/01/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AddReducer {
  @ObservableState
  struct State: Equatable {
    @Presents var destination: Destination.State?
  }
  
  enum Action {
    case destination(PresentationAction<Destination.Action>)
    case detailButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .detailButtonTapped:
        state.destination = .detailItem(.init())
        return .none
      case .destination:
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
      case detailItem(DetailReducer.State)
    }
    
    enum Action {
      case detailItem(DetailReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
      Scope(state: \.detailItem, action: \.detailItem) {
        DetailReducer()
      }
      Reduce { state, action in
        return .none
      }
    }
  }
}

struct AddView: View {
  @Bindable var store: StoreOf<AddReducer>
  
  var body: some View {
    List {
      Button(
        action: {
          store.send(.detailButtonTapped)
        },
        label: {
          Text("Detail View")
        }
      )
    }
    .navigationTitle("Add View")
    .navigationDestination(
      item: $store.scope(
        state: \.destination?.detailItem,
        action: \.destination.detailItem)
    ) { store in
        DetailView(store: store)
    }
  }
}

#Preview {
  AddView(
    store: Store(initialState: AddReducer.State()) {
      AddReducer()
    }
  )
}
