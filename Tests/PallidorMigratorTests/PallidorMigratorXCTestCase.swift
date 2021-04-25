//
//  File.swift
//  
//
//  Created by Eldi Cano on 25.04.21.
//

import Foundation
import XCTest
@testable import PallidorMigrator
import PathKit

class PallidorMigratorXCTestCase: XCTestCase, ResourceHandler {
    public typealias Container = InnerContainer
    
    public enum InnerContainer: ResourceContainer {
        case guides(MigrationGuides)
        case resources(Resources)
        case results(Results)
        
        public var instance: Resource {
            switch self {
            case let .guides(instance):
                return instance
            case let .resources(instance):
                return instance
            case let .results(instance):
                return instance
            }
        }
    }
    
    enum MigrationGuides: String, Resource {
        var name: String { rawValue }
        var bundle: Bundle { .module }
        var fileExtension: FileExtension { .json }
        
        case EmptyGuide
        
        case RenameEndpointAndReplaceAndDeleteMethodChange, RenameEndpointAndReplaceMethodChange, RenameEndpointAndDeletedMethodChange, RenameEndpointAndRenameMethodChange, RenamedEndpointAndRenameMethodAndReplaceAndDeleteParameterChange, RenamedEndpointAndRenameMethodAndAddAndDeleteParameterChange, RenamedEndpointAndRenameMethodAndReplaceAndDeleteParameterAndReplaceReturnValueChange, RenamedEndpointAndRenameMethodAndChangedParametersAndReplaceReturnValueChange
        
        case RenameEndpointChange, DeleteEndpointChange, RenameMethodAndChangeContentBodyChange
        
        case DeleteEnumCaseChange, DeleteEnumChange, RenameEnumChange, ReplaceEnumChange
        
        case RenameMethodAndReplaceAndDeleteParameterChange, RenameMethodAndAddParameterChange, RenameMethodAndRenameParameterChange, RenameMethodAndDeleteParameterChange, RenameMethodAndReplacedReturnValueChange
        
        case ReplaceMNParameterChange, ReplaceM1ParameterChange, Replace1NParameterChange, AddParameterChange, DeleteParameterChange, RenameMethodParameterChange, ReplaceMethodParameterChange, RequiringMethodParameterChange, ReplaceMethodContentBodyChange, AddContentBodyChange, ReplaceDefaultValueChange
        
        case RenameMethodChange, DeleteMethodChange, ReplaceMethodChange, ReplaceMethodInSameEndpointChange, ReplaceMethodReturnTypeChange
        
        case DeletedAndAddedProperty, RenameModelAndAddPropertyChange, RenameModelAndReplacePropertyChange, RenameModelAndDeletePropertyChange, RenameModelAndRenamedPropertyChange
        
        case AddSinglePrimitivePropertyChange, AddSingleComplexPropertyChange, DeletePropertyChange, ReplacePropertyTypeChange, RenamePropertyChange
        
        case DeleteModelChange, ReplaceModelChange, RenameModelChange
        
        case RenameOfTypeModelChange, DeleteOfTypeEnumCaseChange, DeleteOfTypeChange, ReplaceOfTypeModelChange
    }
    
    
    enum Resources: String, Resource {
        var name: String { rawValue }
        var bundle: Bundle { .module }
        
        case PetEndpointRenamedAndReplacedMethod, PetEndpointFacadeReplacedMethod, PetEndpointRenamedAndRenamedMethod, PetEndpointRenamedAndRenamedMethodAndReplacedParameter, PetEndpointRenamedAndReplacedAndDeletedMethod, PetEndpointRenamedAndRenamedMethodAndAddedAndDeletedParameter, PetEndpointRenamedAndRenamedMethodAndReplacedAndDeletedParameterAndReplacedReturnValue, PetEndpointRenamedAndRenamedMethodAndChangedParametersAndReplacedReturnValue
        
        case PetEndpointRenamed, PetEndpointFacade, EndpointPlaceholder, PetEndpointRenamedMethodAndContentBody, PetEndpointFacadeAddMethod
        
        case DeleteEnumCaseChange, DeleteEnumChange, RenameEnumChange, ReplaceEnumChange
        
        case EnumMessageLevelFacade, EnumPlaceholder, EnumTimeMode, EnumTimeModeFacade, EnumTimeModeDeletedCase, EnumTimeModeRenamed
        
        case ErrorEnum, ErrorEnumAddedCase, ErrorEnumDeletedCase, ErrorEnumFacadeAddedCase, ErrorEnumFacadeDeletedCase, ResultErrorEnumDeletedCase
        
        case PetEndpointRenamedMethodAndReplacedReturnValue, PetEndpointRenamedMethodAndDeletedParameter, PetEndpointRenamedMethodAndReplacedParameter, PetEndpointRenamedMethodAndAddedParameter, PetEndpointRenamedMethodAndRenamedParameter
        
        case PetEndpointAddedParameter, UserEndpointDeletedParameter, PetEndpointRenamedParameter, PetEndpointReplacedParameter, StoreEndpointReplaceContentBody, PetEndpointAddedContentBody, PetEndpointReplacedMethod, PetEndpointReplaceParameterMN, PetEndpointReplaceParameter32, PetEndpointDefaultParameter, PetEndpointRequiringParameter
        
        case PetEndpointRenamedMethod, PetEndpointReplacedReturnValue, PetEndpointDeletedMethod, UserEndpointReplacedMethod
        
        case ModelPet, ModelCustomerRenamedAndReplacedProperty, ModelCustomerRenamedAndDeletedProperty, ModelCategoryRenamedAndPropertyRenamed, ModelPetRenamedAndAddedProperty
        
        case ModelAddress, ModelCustomerReplacedProperty, ModelPetRenamedProperty, ModelCategoryRenamedProperty
        
        case ModelApiResponseFacadeDeleted, ModelPlaceholder, ModelOrderFacadeReplaced, ModelAddressRenamed
        
        case ModelOfType, ModelOfTypeRenamed, ModelOfTypeFacade
    }
    
    enum Results: String, Resource {
        var name: String { rawValue }
        var bundle: Bundle { .module }
        
        case ResultPetEndpointFacadeRenamedAndReplacedMethod, ResultPetEndpointFacadeRenamedAndRenamedMethod, ResultPetEndpointFacadeRenamedAndDeletedMethod, ResultPetEndpointFacadeRenamedAndRenamedMethodAndReplacedParameter, ResultPetEndpointFacadeRenamedAndReplacedAndDeletedMethod, ResultPetEndpointFacadeRenamedMethodAndAddedAndDeletedParameter, ResultPetEndpointFacadeRenamedAndRenamedMethodAndReplacedParameterAndReplacedReturnValue, ResultPetEndpointFacadeRenamedAndRenamedMethodAndChangedParametersAndReplacedReturnValue
        
        case ResultPetEndpointFacadeRenamed, ResultPetEndpointFacadeDeleted, ResultPetEndpointFacadeRenamedMethodAndContentBody
        
        case ResultEnumMessageLevelReplaced, ResultEnumTimeMode, ResultEnumTimeModeDeleted, ResultEnumTimeModeDeletedCase, ResultEnumTimeModeRenamed
        
        case ResultErrorEnum, ResultErrorEnumAddedCase, ResultErrorEnumDeletedCase
        
        case ResultPetEndpointRenamedMethodAndReplacedReturnValue, ResultPetEndpointFacadeRenamedMethodAndDeletedParameter,
             ResultPetEndpointFacadeRenamedMethodAndReplacedDeletedParameter, ResultPetEndpointFacadeRenamedMethodAndAddedParameter, ResultPetEndpointFacadeRenamedMethodAndReplacedReturnValue, ResultPetEndpointFacadeRenamedMethodAndRenamedParameter
        
        case ResultPetEndpointFacadeAddedParameter, ResultUserEndpointFacadeDeletedParameter, ResultPetEndpointFacadeRenamedParameter, ResultPetEndpointFacadeReplacedParameter, ResultStoreEndpointFacadeReplacedContentBody, ResultPetEndpointFacadeAddedContentBody, ResultPetEndpointFacadeReplacedMethodInSameEndpoint, ResultPetEndpointFacadeM1ParameterChange, ResultPetEndpointFacade1NParameterChange, ResultPetEndpointFacade32ParameterChange, ResultPetEndpointFacadeDefaultParameter, ResultPetEndpointFacadeRequiredParameter
        
        case ResultPetEndpointFacadeRenamedMethod, ResultPetEndpointFacadeReplacedReturnValue, ResultPetEndpointFacadeDeletedMethod, ResultPetEndpointFacadeReplacedMethod
        
        case ResultModelPetAddedAndDeletedProperty, ResultModelCustomerRenamedAndReplacedProperty, ResultModelCustomerRenamedAndDeletedProperty, ResultModelCategoryRenamedAndRenamedProperty, ResultModelPetRenamedAndAddedProperty
        
        case ResultModelAddressAddedSimpleProperty, ResultModelPetAddedComplexProperty, ResultModelPetDeletedProperty, ResultModelCustomerReplacedProperty, ResultModelPetRenamedProperty, ResultModelCategoryRenamedProperty
        
        case ResultModelPet, ResultModelApiResponseDeleted, ResultModelOrderReplaced, ResultModelAddressRenamed
        
        case ResultModelOfType, ResultModelOfTypeRenamed, ResultModelOfTypeDeletedCase, ResultModelOfTypeDeleted, ResultModelOfTypeReplaced
    }
    
    /// Returns the parsed modifiable file of the resource
    func modifiable(_ resource: Resources) -> ModifiableFile {
        modifiableFile(from: resourceContent(resource: resource))
    }
    
    /// Returns the string content of the resource
    func resourceContent(resource: Resource) -> String {
        if let content = try? resource.content() {
            return content
        }
        
        fatalError("Failed to read the resource \(resource.name)")
    }
    
    /// Returns the string content of result
    func expectation(_ result: Results) -> String {
        String(resourceContent(resource: result).dropLast())
    }
    
    /// Returns the string content of resource
    func resource(_ resource: Resources) -> String {
        String(resourceContent(resource: resource).dropLast())
    }
    
    /// Returns the string content of migration guide
    func migrationGuide(_ guide: MigrationGuides) -> String {
        resourceContent(resource: guide)
    }
    
    /// Returns the migrated target from migration guide
    func migration(_ guide: MigrationGuides, target: Resources) -> ModifiableFile {
        let types = modifiableFile(from: resource(target))
        XCTAssertNoThrow(try types.accept(migrationSet(from: guide)))
        return types
    }
    
    /// All migration sets used throughout the target initialized through this method.
    /// Injects the store accordingly to singleton of `TestCodeStore`
    func migrationSet(from guide: MigrationGuides) -> MigrationSet {
        guard let migrationGuide = try? MigrationGuide.guide(with: migrationGuide(guide)) else {
            fatalError("Migration guide is malformed")
        }
        return migrationGuide.handled(in: TestCodeStore.instance).migrationSet
    }
}

class TestCodeStore: Store {
    /// Singleton of TestCodeStore
    static let instance = TestCodeStore()
    
    /// Store
    var previousFacade: [ModifiableFile]
    var currentAPI: [ModifiableFile]
    
    /// Test code store does not collect code from paths
    func collect(at targetDirectory: Path) {}
    
    /// Initializer
    private init() {
        previousFacade = []
        currentAPI = []
    }
    
    /// Used to prepare APIs for each test case. Injects the `Store` to each modifiable
    static func inject(previous: [ModifiableFile], current: [ModifiableFile]) {
        previous.forEach { $0.store = instance }
        current.forEach { $0.store = instance }
        
        instance.previousFacade = previous
        instance.currentAPI = current
    }
}
