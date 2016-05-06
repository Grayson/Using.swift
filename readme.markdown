# Using

This is a simple pattern of code that I find that I use frequently enough across my Swift projects to warrant bundling it in one place.  It vaguely follows the [C# `using` statement](https://msdn.microsoft.com/en-us/library/yh598w02.aspx) in functionality.  I use it when I want to "bookend" some code with an explicit cleanup or followup.

## Usage

This code exposes two basic paradigms (okay, two and a half): the "disposable" protocol and the "using" statement.

### `Disposable`

Disposables are defined in two ways.  First, there are objects that conform to the `Disposable` protocol.  They implement the `dispose` method (`() -> ()`).  The second is a tuple with two items: an object and a (non-throwing) block (`() -> ()`).

### `Using`

The `using` statement is a function that takes in a Disposable and an action.  It will call the action, passing in the object, and dispose the object appropriately (either calling `dispose` or executing the "dispose" block as according to its input).

###  Example

Imagine you had an abstraction for writing and reading files.  You wanted to open them and automatically close those files:

	class File {
		let path: String
		...
		func openForReading() -> (File, () -> ()) {
			let filePointer = fopen(path, "r")
			return ( self, { fclose(filePointer) } )
		}
	}
	
	let someFile: File = ...
	using(someFile.openForReading()) { f: File in
		print(f.read())
		...
	}

In the above example, the block that closes the file pointer (`{ fclose(filePointer) }`) will be called at the end of the `using` execution block.

Let's say that you've implemented a custom reader class for file reading.  It can implement the `Disposable` protocol and clean up automatically:

	final class FileReader : Disposable {
		private let pointer: UnmanagedMutablePointer<FILE> = nil
		init(path: String) {
			pointer = fopen(path, "r")
		}
		
		deinit {
			dispose()
		}
		
		func dispose() {
			if pointer != nil { fclose(pointer) }
		}
		
		...
	}
	
	class File {
		...
		
		func openForReading() -> FileReader {
			return FileReader(path: self.path)
		}
	}
	
	using (someFile.openForReading()) { reader: FileReader in
		let byte = reader.readByte()
		...
	}

By implementing the `Disposable` protocol, the `using` function can automatically close and clean up the file descriptor for the `FileReader` object when it has finished executing.

# Future ideas

There are two basic ideas that's crossed my mind while working on various projects that use versions of this concept:

First, the `using` function could probably take the "disposable" parameter as an `@autoclosure`.  I haven't had any use for that, so I haven't bothered.  If you find a good use case, let's discuss it (details below).

The second idea that I've had is that I don't really like the tuple alternative form.  It's effective in that it allows certain low brow/ad hoc disposing, but it feels a little inelegant.  I'd like to get Swift 3.0's generic typealias support and play around with making an explicit type, but I don't think it will sell me on tuples as the form for encapsulating this behavior.  What do you think?  Yay or nay?  Alternative?  Let me know.

# Contact

For complaints, compliments, or discussion, I can be reached at:

Grayson Hansard  
[@Grayson](http://twitter.com/Grayson)  
[grayson.hansard@gmail.com](mailto:grayson.hansard@gmail.com)  
[Github/Grayson](http://github.com/Grayson) (I figure you know this one.)
