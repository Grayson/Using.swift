//
//  UsingTests.swift
//  UsingTests
//
//  Created by Grayson Hansard on 5/5/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

import XCTest
@testable import Using

class UsingTests: XCTestCase {
	enum Error: ErrorType {
		case SomeError
	}

	func testUsingTuple() {
		var value = 42
		let tuple = ( value, { value += 1 })
		using(tuple) { XCTAssert($0 == 42) }
		XCTAssert(value == 43)
	}

	func testThrowUsingTuple() {
		var value = 42
		let tuple = (value, { value += 1 })
		do {
			try using(tuple) {
				XCTAssert($0 == 42)
				throw Error.SomeError
			}
		}
		catch {}
		XCTAssert(value == 43)
	}

	func testUsingWithDisposer() {
		var value = 42
		let disposer = Disposer(action: { value += 1 })
		using(disposer) { _ in }
		XCTAssert(value == 43)
	}

	func testThrowingUsingWithDisposer() {
		var value = 42
		let disposer = Disposer(action: { value += 1 })
		do {
			try using(disposer) { _ in throw Error.SomeError }
		}
		catch {}
		XCTAssert(value == 43)
	}

}
