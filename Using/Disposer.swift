//
//  Disposer.swift
//  Using
//
//  Created by Grayson Hansard on 5/5/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

final class Disposer : Disposable {
	private let action: () -> ()
	private var isDisposed = false

	init(action: () -> ()) {
		self.action = action
	}

	deinit {
		dispose()
	}

	func dispose() {
		guard !isDisposed else { return }
		action()
	}
}
