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

// internal
extension ValidatableEntity
{
    static
    func prepareReport(
        with issues: [ValidationError]
        ) -> Report
    {
        var result = defaultReport(with: issues)

        //---

        reviewReport(issues, &result)

        //---

        return result
    }

    static
    func defaultReport(
        with issues: [ValidationError]
        ) -> Report
    {
        let messages = issues
            .map{

                if
                    $0.hasNestedIssues // report from a nested entity...
                {
                    return """
                    ———
                    \($0.report.message)
                    ———
                    """
                }
                else
                {
                    return "- \($0.report.message)"
                }
            }
            .joined(separator: "\n")

        //---

        return (

            "\"\(displayName)\" validation failed",

            """
            \"\(displayName)\" validation failed due to the issues listed below.
            \(messages)
            """
        )
    }
}
