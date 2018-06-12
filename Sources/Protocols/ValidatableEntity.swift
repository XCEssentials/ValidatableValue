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
protocol ValidatableEntity: Entity, Validatable
{
    associatedtype Draft
    associatedtype Valid

    func draft() -> Draft
    func valid() throws -> Valid
}

//---

/**
 Data model type that supposed to store all (dynamic) important data
 in various validatable value properties. Such properties will be automatically
 checked for validity each time when whole entity is being tested for validity.
 Those property will be also automatically encoded and decoded.
 */
public
extension ValidatableEntity
{
    var allValidatableMembers: [Validatable]
    {
        return Mirror(reflecting: self)
            .children
            .map{ $0.value }
            .compactMap{ $0 as? Validatable }
    }

    /**
     Validates all validateable values conteined inside the entity,
     throws 'EntityValidationFailed' if any issues found.

     Note, that validate does NOT rely on 'valid()' function,
     because 'valid()' function supposed to return a custom
     representation of the entity in case it's fully valid,
     but we should make NO assumption about what it is and
     which properties will be evaluated for validity during
     preparation of this representation. That means there is no
     guarantee that all presented validatable values of the entity
     will be validated during this process.
     */
    func validate() throws
    {
        var issues: [ValidatableValueError] = []

        //---

        allValidatableMembers.forEach{

            do
            {
                try $0.validate()
            }
            catch
            {
                (error as? ValidatableValueError).map{ issues.append($0) }
            }
        }

        //---

        if
            !issues.isEmpty
        {
            throw EntityValidationFailed(
                issues: issues
            )
        }
    }
}

//---

public
extension ValidatableEntity
    where Self: CustomReportable // NOT Auto!!!
{
    /**
     Note, that this is jsut a helper that may be used from
     custom entity to actually generate report for the whole entity.
     */
    func report<W>(
        for valueWrapper: W,
        with error: EntityValidationFailed
        ) -> (title: String, message: String)?
        where
        W: ValueWrapper & Validatable & CustomReportable
    {
        return error
            .issues
            .filter({ $0.origin == valueWrapper.reference })
            .first
            .flatMap({ $0 as? W.ReportInput })
            .map(valueWrapper.prepareReport)
    }

    func customReport<W>(
        for valueWrapper: W,
        ifMentionedIn error: EntityValidationFailed,
        _ composer: (W.ReportInput) -> (title: String, message: String)
        ) -> (title: String, message: String)?
        where
        W: ValueWrapper & Validatable & CustomReportable
    {
        return error
            .issues
            .filter({ $0.origin == valueWrapper.reference })
            .first
            .flatMap({ $0 as? W.ReportInput })
            .map(composer)
    }
}
