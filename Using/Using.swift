//
//  Using.swift
//  Using
//
//  Created by Grayson Hansard on 5/5/16.
//  Copyright © 2016 From Concentrate Software. All rights reserved.
//

public func using<T: Disposable>( item: T, action: (T) -> () ) {
	defer { item.dispose() }
	action(item)
}

public func using<T: Disposable>( item: T, action: (T) throws -> () ) throws {
	defer { item.dispose() }
	try action(item)
}

public func using<T>( tuple: ( item: T, disposer: () -> () ), action: (T) -> () ) {
	defer { tuple.disposer() }
	action(tuple.item)
}

public func using<T>( tuple: ( item: T, disposer: () -> () ), action: (T) throws -> () ) throws {
	defer { tuple.disposer() }
	try action(tuple.item)
}