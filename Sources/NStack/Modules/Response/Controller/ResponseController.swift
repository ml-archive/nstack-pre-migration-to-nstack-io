import Vapor

public final class ResponseController {

    private let application: Application

    init(application: Application) {
        self.application = application
    }

    public subscript(_ id: Int) -> Future<Response> {
        get {
            return application.connectionManager.getResponse(application: application, id: id)
        }
    }

    private struct DataWrapper<T: Decodable>: Decodable {
        let data: T
    }

    public subscript<T: Decodable>(_ id: Int) -> Future<T> {
        get {
            return application.connectionManager.getResponse(application: application, id: id)
                .flatMap {
                    try $0.content.decode(DataWrapper<T>.self).map { $0.data }
                }
        }
    }
}
