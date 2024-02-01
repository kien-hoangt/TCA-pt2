//
//  DetailView.swift
//  TCA-pt2
//
//  Created by Kien Hoang on 30/01/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct DetailReducer {
  @ObservableState
  struct State: Equatable {
    
  }
  
  enum Action {
    case closeButtonTapped
  }
  
  @Dependency(\.dismiss) var dismiss
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .closeButtonTapped:
        return .run { _ in await self.dismiss() }
      }
    }
  }
}

struct DetailView: View {
  @Environment(\.dismiss) var dismiss
  var store: StoreOf<DetailReducer>
  
  var body: some View {
    List {
      Button(
        action: {
          dismiss()
        },
        label: {
          Text("Dismiss From View")
        }
      )
      Button(
        action: {
          store.send(.closeButtonTapped)
        },
        label: {
          Text("Dismiss From Store")
        }
      )
    }
    .navigationTitle("Detail View")
  }
}

#Preview {
  DetailView(
    store: Store(initialState: DetailReducer.State()) {
      DetailReducer()
    }
  )
}
