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

import Foundation

// MARK: - SomeStorageKey

public
protocol SomeStorageKey
{}

//---

public
extension SomeStorageKey
{
    var name: String
    {
        .init(reflecting: self)
    }
}

// MARK: - ValueStorage

public
enum ValueStorage: Equatable
{
    case appStorageStandard(key: SomeStorageKey)
    case appStorage(key: SomeStorageKey, storageName: String)
    //case keychain(key: SomeStorageKey)
    
    public
    static
    func == (lhs: ValueStorage, rhs: ValueStorage) -> Bool
    {
        switch (lhs, rhs)
        {
            case (.appStorageStandard(let lhsKey), .appStorageStandard(let rhsKey)):
                return lhsKey.name == rhsKey.name
                
            case (.appStorage(let lhsKey, let lhsStorageName), .appStorage(let rhsKey, let rhsStorageName)):
                return (lhsKey.name == rhsKey.name && lhsStorageName == rhsStorageName)
            
            default:
                return false
        }
    }
}

//---

//internal
extension ValueStorage
{
    func fetchValue<T>(default defaultValue: T) -> T
    {
        switch self
        {
            case .appStorageStandard(let key):
                
                if
                    ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil
                {
                    return (UserDefaults.standard.value(forKey: key.name) as? T) ?? defaultValue
                }
                else
                {
                    return defaultValue
                }
                
            case .appStorage(key: let key, storageName: let storageName):
                
                if
                    ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil
                {
                    return (UserDefaults(suiteName: storageName)?.value(forKey: key.name) as? T) ?? defaultValue
                }
                else
                {
                    return defaultValue
                }
        }
    }
    
    func store<T>(value: T?)
    {
        switch self
        {
            case .appStorageStandard(let key):
                
                if
                    ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil
                {
                    let theStore = UserDefaults.standard
                    theStore.set(value, forKey: key.name)
                    theStore.synchronize()
                }
                
            case .appStorage(key: let key, storageName: let storageName):
                
                if
                    ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil
                {
                    let theStore = UserDefaults(suiteName: storageName)
                    theStore?.set(value, forKey: key.name)
                    theStore?.synchronize()
                }
        }
    }
}
