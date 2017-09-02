public
typealias ValidationBody<Input> = (_ input: Input) -> Bool

//===

public
struct Validation<Input>
{
    public
    let title: String
    
    let body: ValidationBody<Input>
    
    // MARK: - Initializers

    public
    init(_ title: String, _ body: @escaping ValidationBody<Input>)
    {
        self.title = title
        self.body = body
    }
    
    init()
    {
        self.init("Accept anything") { _ in return true }
    }
}

// MARK: - Perform validation

public
extension Validation
{
    func isPassed(with input: Input) -> Bool
    {
        return body(input)
    }
    
    func perform(with input: Input) throws
    {
        if
            !body(input)
        {
            throw ValidationFailed(title, input: input)
        }
    }
}

// MARK: - Alias

public
typealias Validate<Input> = Validation<Input>
