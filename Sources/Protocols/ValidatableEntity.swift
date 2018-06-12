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
    /**
     Note, that validate does NOT rely on 'valid()' function,
     because 'valid()' returns a representation of the entity
     in case it's fully valid, but not necessary has to contain
     all validatable values in it, i.e. you don't want to include
     password in a representation, or instead of representing it
     with a String you might want just use Bool to indicare
     if it's set or not.
     */
    func validate() throws
    {
        var issues: [ValueValidationFailed] = []

        //---

        Mirror(reflecting: self)
            .children
            .map{ $0.value }
            .compactMap{ $0 as? Validatable }
            .forEach{

                do
                {
                    try $0.validate()
                }
                catch
                {
                    (error as? ValueValidationFailed).map{ issues.append($0) }
                }
            }

        //---

        if
            !issues.isEmpty
        {
            throw EntityValidationFailed(
                context: Utils.globalContext(with: self),
                issues: issues
            )
        }
    }
}
