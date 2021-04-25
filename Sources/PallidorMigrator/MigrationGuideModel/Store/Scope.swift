import PathKit

/// Scope of layers
enum Scope: CaseIterable {
    case currentAPI
    case previousFacade
    
    private var folderPrefix: String {
        self == .currentAPI ? "" : "Persistent"
    }
    
    var modelsPath: Path {
        Path("\(folderPrefix)Models")
    }
    
    var apisPath: Path {
        Path("\(folderPrefix)APIs")
    }
    
    var errorEnumFileName: String {
        "\(self == .currentAPI ? "_" : "")APIErrors.swift"
    }
}
