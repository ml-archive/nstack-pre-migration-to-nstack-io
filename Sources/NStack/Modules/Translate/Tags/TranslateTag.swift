import Vapor

///
/// Usage:
/// #nstack:translate("section", "key")
/// #nstack:translate("section", "key", "search1", "replace1", "search2, "replace2", ...)
///
/// Note: Uses the currently selected NStack application and default translate configuration!
public final class TranslateTag: TagRenderer {

    private let nstack: NStack

    public init(nstack: NStack) {
        self.nstack = nstack
    }

    public func render(tag: TagContext) throws -> Future<TemplateData> {

        guard
            tag.parameters.count >= 2,
            let section = tag.parameters[0].string,
            let key = tag.parameters[1].string
        else {
            throw tag.error(reason: "Expected at least section + key name parameters.")
        }

        var searchReplacePairs = [String:String]()
        for index in stride(from: 2, to: tag.parameters.count, by: 2) {

            if
                let search = tag.parameters[index].string,
                let replace = tag.parameters[index+1].string {
                searchReplacePairs[search] = replace

            } else {
                break
            }
        }

        let translationFuture = self.nstack.application.translate.get(
            on: tag.container,
            section: section,
            key: key,
            searchReplacePairs: searchReplacePairs
        )

        return translationFuture.map { translation in
            return .string(translation)
        }
    }
}
