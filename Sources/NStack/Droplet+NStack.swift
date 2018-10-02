import Vapor

extension Droplet {
    public var nstack: NStack? {
        get { return storage["nstack"] as? NStack }
        set { storage["nstack"] = newValue }
    }

    public func assertNStack() throws -> NStack {
        guard let nstack = nstack else {
            throw Abort(.internalServerError, reason: "Missing NStack")
        }

        return nstack
    }

}
