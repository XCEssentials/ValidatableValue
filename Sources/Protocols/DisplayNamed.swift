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

// MARK: - DisplayNamed

public
protocol DisplayNamed
{
    /**
     End user friendly title of any instance of this type,
     represents the recommended way to refer to instances
     of this type in GUI. Implemented automatically if
     the type conforms to 'AutoDisplayName' protocol.
     */
    static
    var displayName: String { get }
}

//---

public
extension DisplayNamed
{
    static
    var intrinsicDisplayName: String
    {
        return String(describing: self)
    }

    /**
     Convenience helper to access 'displayName' from instance level.
     */
    var displayName: String
    {
        return type(of: self).displayName
    }
}

// MARK: - AutoDisplayNamed

public
protocol AutoDisplayNamed: DisplayNamed {}

//---

public
extension AutoDisplayNamed
{
    static
    var displayName: String
    {
        return intrinsicDisplayName
    }
}

// MARK: - DisplayNameProvider

/**
 Provides a more meaningful way to describe a type
 dedicated just for being a source for custom non-intrinsic
 'displayName' for a value wrapper.
 */
public
protocol DisplayNameProvider: DisplayNamed {}
