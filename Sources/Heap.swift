//
// Heap.swift
//
// based on https://gist.github.com/AquaGeek/34b7511d794223c24340f0f399fc8ad0
//

public struct Heap<Element> {
    public typealias Index = Int

    private var storage: [Element]
    private let comparator: (Element, Element) -> Bool

    public var count: Int {
        storage.count
    }

    public var isEmpty: Bool {
        storage.isEmpty
    }

    public init(comparator: @escaping (Element, Element) -> Bool) {
        self.storage = []
        self.comparator = comparator
    }

    /// Inserts the given element into the `BinaryHeap`.
    ///
    /// - Complexity: O(log n)
    public mutating func insert(_ element: Element) {
        storage.append(element)
        siftUp(startingAt: lastStorageIndex)
    }

    /// Returns the first element in the `BinaryHeap`.
    ///
    /// - Complexity: O(1)
    public func peek() -> Element? {
        storage.first
    }

    /// Removes and returns the first element from the `BinaryHeap`.
    ///
    /// - Complexity: O(log n)
    public mutating func pop() -> Element? {
        deleteElement(at: 0)
    }

    // MARK: - Internals
    /// Remove the item at the given index
    ///
    /// - Complexity: O(log n)
    private mutating func deleteElement(at index: Index) -> Element? {
        guard storage.count > index else {
            return nil
        }

        guard storage.count > 1 else {
            // The element to remove is the only one we have
            return storage.removeLast()
        }

        storage.swapAt(index, lastStorageIndex)
        let removed = storage.removeLast()

        siftDown(startingAt: index)

        return removed
    }

    private mutating func siftUp(startingAt startIndex: Index) {
        var idx = startIndex

        // 1. Compare the element at idx to its parent.
        // 2. If they are not in the correct order:
        //    * Swap them
        //    * Go back to 1
        while idx > 0 && comparator(storage[idx], storage[parentIndex(of: idx)]) {
            let parentIdx = parentIndex(of: idx)
            storage.swapAt(idx, parentIdx)
            idx = parentIdx
        }
    }

    private mutating func siftDown(startingAt startIndex: Index) {
        var idx = startIndex

        // 1. Compare the element at idx with its children.
        // 2. If they are not in the correct order:
        //    * Swap the parent with its children based on the comparator
        //    * Go back to 1
        while idx < lastStorageIndex {
            let leftIdx = leftChildIndex(of: idx)
            let rightIdx = rightChildIndex(of: idx)

            guard leftIdx < storage.count, rightIdx < storage.count else {
                break
            }

            let leftChild = storage[leftIdx]
            let rightChild = storage[rightIdx]

            guard comparator(leftChild, storage[idx]) || comparator(rightChild, storage[idx]) else {
                // The heap is already in the correct order
                break
            }

            if comparator(leftChild, rightChild) {
                storage.swapAt(idx, leftIdx)
                idx = leftIdx
            } else {
                storage.swapAt(idx, rightIdx)
                idx = rightIdx
            }
        }
    }

    // MARK: Index Helpers
    private var lastStorageIndex: Index {
        storage.endIndex - 1
    }

    private func parentIndex(of index: Index) -> Index {
        (index - 1) / 2
    }

    private func leftChildIndex(of index: Index) -> Index {
        index * 2 + 1
    }

    private func rightChildIndex(of index: Index) -> Index {
        index * 2 + 2
    }
}

// MARK: -
extension Heap {
    public init<Value>(keyPath: KeyPath<Element, Value>, comparator: @escaping (Value, Value) -> Bool) {
        self.init { lhs, rhs in
            comparator(lhs[keyPath: keyPath], rhs[keyPath: keyPath])
        }
    }
}

extension Heap where Element: Comparable {
    public static func minHeap(withContentsOf elements: [Element]? = nil) -> Self {
        var heap = self.init(comparator: <)
        if let elements = elements {
            elements.forEach { heap.insert($0) }
        }
        return heap
    }

    public static func maxHeap(withContentsOf elements: [Element]? = nil) -> Self {
        var heap = self.init(comparator: >)
        if let elements = elements {
            elements.forEach { heap.insert($0) }
        }
        return heap
    }
}

extension Heap where Element: Equatable {
    public func firstIndex(of element: Element) -> Int? {
        storage.firstIndex(of: element)
    }

    public subscript(_ index: Index) -> Element {
        storage[index]
    }

    public mutating func delete(at index: Index) -> Element? {
        deleteElement(at: index)
    }
}
