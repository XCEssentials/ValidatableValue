/*

 MIT License

 Copyright (c) 2016 Maxim Khatskevich (maxim@khatskevi.ch)

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 */

import Foundation

//---

/**
 Provides user friendly 'display name' suitable for showing in GUI.
 */
public
protocol DisplayNamed
{
    /**
     Recommended end-user friendly name/title of the field where
     any instance of this type is being displayed in GUI.
     */
    static
    var displayName: String { get }

    /**
     Recommended end-user friendly subtitle of the field where
     any instance of this type is being displayed in GUI.
     */
    static
    var displayHint: String? { get }

    /**
     Recommended end user friendly placeholder of the field where
     any instance of this type is being displayed in GUI.
     */
    static
    var displayPlaceholder: String? { get }
}

// MARK: - Default implementation

public
extension DisplayNamed
{
    static
    var displayName: String
    {
        return intrinsicDisplayName
    }

    static
    var displayHint: String?
    {
        return nil
    }

    static
    var displayPlaceholder: String?
    {
        return nil
    }
}

// MARK: - Convenience helpers

public
extension DisplayNamed
{
    var displayName: String
    {
        return type(of: self).displayName
    }

    var displayHint: String?
    {
        return type(of: self).displayHint
    }

    var displayPlaceholder: String?
    {
        return type(of: self).displayPlaceholder
    }
}

// MARK: - Internal helpers

//internal
extension DisplayNamed
{
    static
    var intrinsicDisplayName: String
    {
        return Utils.intrinsicDisplayName(for: self)
    }
}

//---

fileprivate
enum Utils
{
    static
    func intrinsicDisplayName<T>(
        for input: T.Type
        ) -> String
    {
        let selfScopeTypeName = String
            .init(describing: input)
            .components(
                separatedBy: .whitespacesAndNewlines
            )
            .first
            ??
            ""

        //---

        let result = selfScopeTypeName
            .splitBefore{ $0.isUpperCase }
            .joined(separator: " ")

        //---

        return String(result)
    }
}

//---

fileprivate
extension Sequence
{
    /**
     Thanks to https://stackoverflow.com/a/39593723
     */
    func splitBefore(
        separator isSeparator: (Iterator.Element) throws -> Bool
        ) rethrows -> [AnySequence<Iterator.Element>]
    {
        var result: [AnySequence<Iterator.Element>] = []
        var subSequence: [Iterator.Element] = []

        var iterator = self.makeIterator()

        while
            let element = iterator.next()
        {
            if
                try isSeparator(element)
            {
                if
                    !subSequence.isEmpty
                {
                    result.append(AnySequence(subSequence))
                }
                subSequence = [element]
            }
            else
            {
                subSequence.append(element)
            }
        }

        result.append(AnySequence(subSequence))

        //---

        return result
    }
}

//---

fileprivate
extension Character
{
    var isUpperCase: Bool
    {
        return String(self) == String(self).uppercased()
    }
}
