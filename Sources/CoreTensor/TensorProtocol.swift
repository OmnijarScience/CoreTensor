//
//  TensorProtocol.swift
//  CoreTensor
//
//  Copyright 2016-2017 The DLVM Team.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

public protocol ShapedArrayProtocol : RandomAccessCollection
    where IndexDistance == Int, Index == Int {
    associatedtype UnitType
    associatedtype UnitSequenceType: RandomAccessCollection
        where UnitSequenceType.Element == UnitType,
              UnitSequenceType.Index == Int,
              UnitSequenceType.IndexDistance == Int
    associatedtype Shape
    var shape: Shape { get }
    var dynamicShape: TensorShape { get }
    var units: UnitSequenceType { get }
    var unitCountPerElement: IndexDistance { get }
    init(shape: Shape, repeating repeatedValue: UnitType)
    subscript(index: Index) -> Element { get }
    func withUnsafeBufferPointer<Result>
        (_ body: (UnsafeBufferPointer<UnitType>) throws -> Result) rethrows -> Result
    mutating func withUnsafeMutableBufferPointer<Result>
        (_ body: (inout UnsafeMutableBufferPointer<UnitType>) throws -> Result) rethrows -> Result
}

public extension ShapedArrayProtocol {
    var unitCount: Int {
        return units.count
    }

    func unit(at index: Int) -> UnitType {
        return units[units.startIndex.advanced(by: index)]
    }
}

public protocol TensorProtocol : ShapedArrayProtocol
    where Shape == TensorShape, Element : TensorProtocol, Element.UnitType == UnitType {
    var elementShape: Shape? { get }
    subscript(index: TensorIndex) -> TensorSlice<UnitType> { get }
}

public extension TensorProtocol {
    var shape: TensorShape {
        return elementShape?.prepending(count) ?? .scalar
    }

    var dynamicShape: TensorShape {
        return shape
    }

    func unit(at index: TensorIndex) -> UnitType {
        return self[index].units[0]
    }
}

public extension TensorProtocol where UnitType : Equatable {
    static func ==<T: TensorProtocol>(lhs: Self, rhs: T) -> Bool where T.UnitType == UnitType {
        return lhs.shape == rhs.shape && lhs.units.elementsEqual(rhs.units)
    }

    func elementsEqual<T: TensorProtocol>(_ other: T) -> Bool where T.UnitType == UnitType {
        return self == other
    }
}

public extension TensorProtocol {
    func isSimilar(to other: Self) -> Bool {
        return shape ~ other.shape
    }

    func isIsomorphic(to other: Self) -> Bool {
        return shape == other.shape
    }
}

internal extension ShapedArrayProtocol {
    func unitIndex(fromIndex index: Int) -> Int {
        return unitCountPerElement * index
    }

    func unitSubrange(from tensorSubrange: CountableRange<Int>) -> CountableRange<Int> {
        return unitIndex(fromIndex: tensorSubrange.lowerBound)
            ..< unitIndex(fromIndex: tensorSubrange.upperBound)
    }
}

