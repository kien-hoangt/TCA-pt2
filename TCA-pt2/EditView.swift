//
//  EditView.swift
//  TCA-pt2
//
//  Created by Kien Hoang on 30/01/2024.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct EditReducer {
  @ObservableState
  struct State: Equatable {
    var count = 0
  }
  
  enum Action {
    case saveButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .saveButtonTapped:
        state.count = Int.random(in: 0..<100)
        return .none
      }
    }
  }
}

struct EditView: View {
  
  var store: StoreOf<EditReducer>
  
  var body: some View {
    VStack {
      Text("Edit View")
    }
  }
}

#Preview {
  EditView(
    store: Store(initialState: EditReducer.State()) {
      EditReducer()
    }
  )
}
