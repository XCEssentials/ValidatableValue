/**
 Custom value wrapper.
 */
public
struct CustomBase<T>
    where
    T: Codable & Equatable
{
    public
    typealias Value = T

    public
    init(_ value: Value) { self.value = value }

    public
    var value: Value
}
