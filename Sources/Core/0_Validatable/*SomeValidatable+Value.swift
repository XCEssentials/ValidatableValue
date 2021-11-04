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
extension SomeValidatableValueWrapperOLD
{
    func validate() throws
    {
        let failedConditions: [Error] = Specification
            .conditions
            .compactMap {
                
                do
                {
                    try $0.validate(rawValue)
                    return nil
                }
                catch
                {
                    return error
                }
            }
        
        //---
        
        if
            !failedConditions.isEmpty
        {
            throw ValidationErrorOLD.unsatisfiedConditions(
                failedConditions,
                rawValue: rawValue
            )
        }
    }
}

// MARK: - Convenience validation helpers

public
extension SomeValidatableValueWrapperOLD
{
    /**
     Convenience initializer initializes wrapper and validates it
     right away.
     */
    init(
        validate value: Specification.RawValue
        ) throws
    {
        self.init(wrappedValue: value)
        try self.validate()
    }

    /**
     Validate a given value without saving it.
     */
    static
    func validate(
        value: Specification.RawValue
        ) throws
    {
        _ = try Self.init(validate: value)
    }

    /**
     Set new value and validate it in single operation.
     */
    mutating
    func set(
        _ newValue: Specification.RawValue
        ) throws
    {
        rawValue = newValue
        try validate()
    }
}
