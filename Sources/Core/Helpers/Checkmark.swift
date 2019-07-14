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

/**
 Represents values that only can be set or not set (logically same as a
 checkmark - it either can be empty or checked). Supposed to be used in
 conjunction wiht ‘Optional’ - ‘nil’ represents empty/unset state, and
 when non-‘nil’ - it’s the ‘checked’ state of checkmark.
 */
public
protocol Checkmark: ValueSpecification where Value == CheckmarkValue {}

//---

public
enum CheckmarkValue: UInt, Codable
{
    case checked
}

//---

public
extension Swift.Optional
    where
    Wrapped: ValueWrapper,
    Wrapped.Specification: Checkmark
{
    var isChecked: Bool
    {
        switch self
        {
            case .some:
                return true

            case .none:
                return false
        }
    }

    mutating
    func toggle()
    {
        switch self
        {
            case .some:
                self = .none

            case .none:
                self = .some(CheckmarkValue.checked.wrapped())
        }
    }

    mutating
    func toggleOn()
    {
        self = .some(CheckmarkValue.checked.wrapped())
    }

    mutating
    func toggleOff()
    {
        self = .none
    }

    mutating
    func set(checked isOn: Bool)
    {
        (isOn ? toggleOn() : toggleOff())
    }
}

//---

public
extension Swift.Optional
    where
    Wrapped == CheckmarkValue
{
    var isChecked: Bool
    {
        switch self
        {
            case .some:
                return true

            case .none:
                return false
        }
    }

    mutating
    func toggle()
    {
        switch self
        {
            case .some:
                self = .none

            case .none:
                self = .some(.checked)
        }
    }

    mutating
    func toggleOn()
    {
        self = .some(.checked)
    }

    mutating
    func toggleOff()
    {
        self = .none
    }

    mutating
    func set(checked isOn: Bool)
    {
        (isOn ? toggleOn() : toggleOff())
    }
}
