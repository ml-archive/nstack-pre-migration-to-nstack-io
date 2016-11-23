import Vapor

extension Droplet {
    public var nstack: NStack? {
        get { return storage["nstack"] as? NStack }
        set { storage["nstack"] = newValue }
    }

}
