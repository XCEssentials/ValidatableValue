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
 Data model type that supposed to store all important data
 in various validatable value properties. Such properties will be automatically
 checked for validity each time when whole entity is being tested for validity.
 Those property will be also automatically encoded and decoded.
 */
public
protocol SomeValidatableEntity: SomeValidatable, DisplayNamed {}

// MARK: - Convenience helpers

public
extension SomeValidatableEntity
{
    var allMembers: [Any]
    {
        return Mirror(reflecting: self)
            .children
            .map{ $0.value }
    }
    
    /**
     Returns list of all members that have to be involved in
     automatic entity validation.
     */
    var allValidatableMembers: [any SomeValidatable]
    {
        return allMembers
            .compactMap{ $0 as? (any SomeValidatable) }
    }
}

// MARK: - SomeValidatable support

public
extension SomeValidatableEntity
{
    /// Performs built-in default validation based on validatable members only.
    func validate() throws
    {
        try validateAllValidatableMembers()
    }
    
    /**
     Validates all validateable values contained inside the entity,
     throws a validation error if any issues found.
     */
    func validateAllValidatableMembers() throws
    {
        let validationIssues: [Error] = allValidatableMembers
            .compactMap{
                
                do
                {
                    try $0.validate()
                    return nil // no issue with that member
                }
                catch
                {
                    return error
                }
            }

        //---

        if
            !validationIssues.isEmpty
        {
            throw ValidationError.invalidEntity(validationIssues)
        }
    }
}
