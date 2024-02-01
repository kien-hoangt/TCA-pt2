//
//  TCA_pt2Tests.swift
//  TCA-pt2Tests
//
//  Created by Kien Hoang on 31/01/2024.
//

import XCTest
import ComposableArchitecture
@testable import TCA_pt2

@MainActor
final class TCA_pt2Tests: XCTestCase {
  func testDismissal() async {
    let store = TestStore(
      initialState: RootReducer.State(
        path: StackState([
          .detailItem(DetailReducer.State())
        ])
      )) {
        RootReducer()
      }
    store.exhaustivity = .off
    
    await store.send(.path(.element(id: 0, action: .detailItem(.closeButtonTapped))))
    await store.receive(\.path.popFrom)
  }
  
  func testSaveEditItem_shouldDismiss() async {
    let store = TestStore(
      initialState: RootReducer.State()) {
        RootReducer()
      }
    store.exhaustivity = .off
    
    await store.send(.editItemButtonTapped)
    await store.send(.path(.element(id: 0, action: .editItem(.saveButtonTapped))))
    // TODO: How to test?
  }
}
