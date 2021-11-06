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

import XCTest

@testable
import XCEValidatableValue

//---

class DisplayNamedTests: XCTestCase {}

//---

extension DisplayNamedTests
{
    func test_displayName_implicit()
    {
        enum FirstName: DisplayNamed {}

        XCTAssertEqual(FirstName.intrinsicDisplayName, "First Name")
        XCTAssertEqual(FirstName.displayName, FirstName.intrinsicDisplayName)
        XCTAssertEqual(FirstName.displayName, FirstName.displayPlaceholder)
        XCTAssertNil(FirstName.displayHint)
    }
    
    func test_displayName_explicit()
    {
        enum LastName: DisplayNamed
        {
            static
            let displayName = "Your Last Name"
            
            static
            let displayPlaceholder: String? = "Your last/family name here"
            
            static
            let displayHint: String? = "We need to know your last name"
        }

        XCTAssertEqual(LastName.displayName, "Your Last Name")
        XCTAssertEqual(LastName.displayPlaceholder, "Your last/family name here")
        XCTAssertEqual(LastName.displayHint, "We need to know your last name")
    }
    
    func test_displayName_implicit_withOverrides()
    {
        enum FirstName: DisplayNamed
        {
            static
            let displayHint: String? = "How should we call you?"
        }

        XCTAssertEqual(FirstName.intrinsicDisplayName, "First Name")
        XCTAssertEqual(FirstName.displayName, FirstName.intrinsicDisplayName)
        XCTAssertEqual(FirstName.displayName, FirstName.displayPlaceholder)
        XCTAssertEqual(FirstName.displayHint, "How should we call you?")
    }
}
