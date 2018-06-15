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

public
protocol ContextualEntity: DisplayNamed
{
    associatedtype Context

    typealias DisplayNameRegistry = [(context: Any.Type, name: String)]

    /**
     Display name registry. If no explicit name found for the
     'Context' - then explicit self-defined display name will be used
     or intrinsic display name will be used.
     NOTE: intrinsic name may look inappropriate for displaying in GUI,
     because it will contain 'Context' generic type mentioned,
     to specify 'default non-intrinsic' kind of display name —
     put 'self' type into registry with desired display name.
     */
    static
    var displayNameFor: DisplayNameRegistry { get }
}

//---

public
extension ContextualEntity
{
    static
    var displayName: String
    {
        return displayNameFor
            .filter{ $0.context == Context.self }
            .first?
            .name
            ??
            displayNameFor
            .filter{ $0.context == self }
            .first?
            .name
            ??
            intrinsicDisplayName
    }
}
