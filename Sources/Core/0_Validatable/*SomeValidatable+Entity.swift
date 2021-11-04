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

// MARK: - SomeValidatableEntity

public
extension SomeValidatableEntity
{
    /**
     Validates all validateable values contained inside the entity,
     throws a validation error if any issues found.
     */
    func validate() throws
    {
        var issues: [Error] = []

        //---

        try allValidatableMembers.forEach{

            do
            {
                try $0.validate()
            }
            catch let error as ValidationError
            {
                issues.append(error)
            }
            catch
            {
                // throw any unexpected erros right away
                throw error
            }
        }

        //---

        if
            !issues.isEmpty
        {
            throw issues.asValidationIssues(for: self)
        }
    }
}

public
extension Array where Element == Error // ValidationError
{
    func asValidationIssues<E: SomeValidatableEntity>(
        for entity: E
        ) -> ValidationError
    {
        .invalidEntity(self)
            
//        .entityIsNotValid(
//            origin: type(of: entity).displayName,
//            issues: self,
//            report: type(of: entity).prepareReport(with: self)
//        )
    }
}
