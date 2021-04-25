// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pallidor",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "Pallidor", targets: ["Pallidor"]),
        .library(name: "PallidorGenerator", targets: ["PallidorGenerator"]),
        .library(name: "PallidorMigrator", targets: ["PallidorMigrator"]),
        .library(name: "PallidorUtils", targets: ["PallidorUtils"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-format.git", .branch("swift-5.3-branch")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "0.3.2")),
        .package(url: "https://github.com/mattpolzin/OpenAPIKit.git", from: "2.0.0"),
        .package(url: "https://github.com/kylef/PathKit.git", .exact("0.9.2")),
        .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.0"),
        .package(url: "https://github.com/krzysztofzablocki/Sourcery", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        
        // MARK: - Pallidor
        
        .target(
            name: "Pallidor",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftFormat", package: "swift-format"),
                .target(name: "PallidorGenerator"),
                .target(name: "PallidorMigrator")
            ]),
        
        // MARK: - Pallidor generator
        
        .target(
            name: "PallidorGenerator",
            dependencies: [
                .product(name: "OpenAPIKit", package: "OpenAPIKit"),
                .product(name: "PathKit", package: "PathKit"),
                .product(name: "Yams", package: "Yams"),
                .target(name: "PallidorUtils")
            ],
            resources: [
                .process("NetworkingTemplates/HTTPAuthorizationModel.md"),
                .process("NetworkingTemplates/NetworkManagerModel.md"),
                .process("MetaModels/TestFileModel.md"),
                .process("MetaModels/PackageModel.md"),
                .process("MetaModels/TestManifestModel.md"),
                .process("MetaModels/LinuxMainModel.md")
            ]
        ),
        
        // MARK: - Pallidor migrator
        
        .target(
            name: "PallidorMigrator",
            dependencies: [
                .product(name: "SourceryFramework", package: "Sourcery"),
                .target(name: "PallidorUtils")
            ]),
        
        // MARK: - Pallidor utils
        
        .target(name: "PallidorUtils"),
        
        // MARK: - Pallidor tests
        
        .testTarget(
            name: "PallidorTests",
            dependencies: ["PallidorMigrator", "PallidorGenerator"],
            resources: [
                .process("Resources/migrationguide.md"),
                .process("Resources/openapi.md")
            ]
        ),
        
        // MARK: - Pallidor generator tests
        
        .testTarget(
            name: "PallidorGeneratorTests",
            dependencies: ["PallidorGenerator", "PallidorUtils", "OpenAPIKit"],
            resources: [
                .process("Resources/petstore.md"),
                .process("Resources/petstore_unmodified.md"),
                .process("Resources/petstore_httpMethodChanged.md"),
                .process("Resources/petstore_minMax.md"),
                .process("Resources/lufthansa.md"),
                .process("Resources/wines.md"),
                .process("Resources/wines_any.md"),
                .process("Resources/Results/Pet.md"),
                .process("Resources/Results/OpenAPIErrorModel.md"),
                .process("Resources/Results/MessageLevel.md"),
                .process("Resources/Results/PaymentInstallmentSchedule.md"),
                .process("Resources/Results/PaymentInstallmentSchedule_Any.md"),
                .process("Resources/Results/PeriodOfOperation.md"),
                .process("Resources/Results/FlightAggregate.md"),
                .process("Resources/Results/LH_GetPassengerFlights.md"),
                .process("Resources/Results/Pet_addPet.md"),
                .process("Resources/Results/Pet_updatePetWithForm.md"),
                .process("Resources/Results/Pet_Endpoint.md"),
                .process("Resources/Results/Pet_updatePetChangedHTTPMethod.md"),
                .process("Resources/Results/Pet_getPetByIdMinMax.md")
            ]),
        
        // MARK: - Pallidor migrator tests
        
        .testTarget(
            name: "PallidorMigratorTests",
            dependencies: [
                "PallidorMigrator",
                .product(name: "SourceryFramework", package: "Sourcery")
            ],
            resources: [
                .process("Resources/Endpoints/Input/EndpointPlaceholder.md"),
                .process("Resources/Endpoints/Input/PetEndpoint.md"),
                .process("Resources/Endpoints/Input/PetEndpointAddedContentBody.md"),
                .process("Resources/Endpoints/Input/PetEndpointAddedParameter.md"),
                .process("Resources/Endpoints/Input/PetEndpointDeletedMethod.md"),
                .process("Resources/Endpoints/Input/PetEndpointFacade.md"),
                .process("Resources/Endpoints/Input/PetEndpointFacadeDeletedMethod.md"),
                .process("Resources/Endpoints/Input/PetEndpointFacadeReplacedMethod.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamed.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamedParameter.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamedMethod.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamedMethodAndContentBody.md"),
                .process("Resources/Endpoints/Input/PetEndpointReplacedMethod.md"),
                .process("Resources/Endpoints/Input/PetEndpointReplacedParameter.md"),
                .process("Resources/Endpoints/Input/PetEndpointReplacedReturnValue.md"),
                .process("Resources/Endpoints/Input/StoreEndpointReplaceContentBody.md"),
                .process("Resources/Endpoints/Input/UserEndpointDeletedParameter.md"),
                .process("Resources/Endpoints/Input/UserEndpointReplacedMethod.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamedMethodAndReplacedReturnValue.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamedMethodAndDeletedParameter.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamedAndReplacedMethod.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamedAndRenamedMethod.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamedMethodAndReplacedParameter.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamedAndRenamedMethodAndReplacedParameter.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamedAndReplacedAndDeletedMethod.md"),
                .process("Resources/Endpoints/Input/PetEndpointFacadeAddMethod.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamedMethodAndAddedParameter.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamedMethodAndRenamedParameter.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamedAndRenamedMethodAndAddedAndDeletedParameter.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamedAndRenamedMethodAndReplacedAndDeletedParameterAndReplacedReturnValue.md"),
                .process("Resources/Endpoints/Input/PetEndpointRenamedAndRenamedMethodAndChangedParametersAndReplacedReturnValue.md"),
                .process("Resources/Endpoints/Input/PetEndpointReplaceParameterMN.md"),
                .process("Resources/Endpoints/Input/PetEndpointReplaceParameter32.md"),
                .process("Resources/Endpoints/Input/PetEndpointDefaultParameter.md"),
                .process("Resources/Endpoints/Input/PetEndpointRequiringParameter.md"),
                
                
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedMethodAndRenamedParameter.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedMethodAndReplacedReturnValue.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeAddedContentBody.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedMethodAndAddedParameter.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeAddedParameter.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeDeleted.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeDeletedMethod.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamed.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedMethod.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedMethodAndContentBody.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedParameter.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeReplacedMethod.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeReplacedParameter.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeReplacedReturnValue.md"),
                .process("Resources/Endpoints/Results/ResultStoreEndpointFacadeReplacedContentBody.md"),
                .process("Resources/Endpoints/Results/ResultUserEndpointFacadeDeletedParameter.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeReplacedMethodInSameEndpoint.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointRenamedMethodAndReplacedReturnValue.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedMethodAndDeletedParameter.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedAndReplacedMethod.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedAndRenamedMethod.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedAndDeletedMethod.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedMethodAndReplacedDeletedParameter.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedAndRenamedMethodAndReplacedParameter.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedAndReplacedAndDeletedMethod.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedMethodAndAddedAndDeletedParameter.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedAndRenamedMethodAndReplacedParameterAndReplacedReturnValue.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRenamedAndRenamedMethodAndChangedParametersAndReplacedReturnValue.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeM1ParameterChange.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacade1NParameterChange.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacade32ParameterChange.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeDefaultParameter.md"),
                .process("Resources/Endpoints/Results/ResultPetEndpointFacadeRequiredParameter.md"),
                
                
                .process("Resources/Models/Input/ModelPlaceholder.md"),
                .process("Resources/Models/Input/ModelCustomerRenamedAndReplacedProperty.md"),
                .process("Resources/Models/Input/ModelAddress.md"),
                .process("Resources/Models/Input/ModelAddressRenamed.md"),
                .process("Resources/Models/Input/ModelApiResponseFacadeDeleted.md"),
                .process("Resources/Models/Input/ModelCategoryRenamedProperty.md"),
                .process("Resources/Models/Input/ModelCustomerReplacedProperty.md"),
                .process("Resources/Models/Input/ModelOfType.md"),
                .process("Resources/Models/Input/ModelOfTypeFacade.md"),
                .process("Resources/Models/Input/ModelOfTypeRenamed.md"),
                .process("Resources/Models/Input/ModelOrderFacadeReplaced.md"),
                .process("Resources/Models/Input/ModelPet.md"),
                .process("Resources/Models/Input/ModelPetRenamedProperty.md"),
                .process("Resources/Models/Input/ModelCustomerRenamedAndDeletedProperty.md"),
                .process("Resources/Models/Input/ModelCategoryRenamedAndPropertyRenamed.md"),
                .process("Resources/Models/Input/ModelPetRenamedAndAddedProperty.md"),
                
                
                .process("Resources/Models/Results/ResultModelCategoryRenamedAndRenamedProperty.md"),
                .process("Resources/Models/Results/ResultModelAddressRenamed.md"),
                .process("Resources/Models/Results/ResultModelApiResponseDeleted.md"),
                .process("Resources/Models/Results/ResultModelCategoryRenamedProperty.md"),
                .process("Resources/Models/Results/ResultModelCustomerReplacedProperty.md"),
                .process("Resources/Models/Results/ResultModelOfType.md"),
                .process("Resources/Models/Results/ResultModelOfTypeDeleted.md"),
                .process("Resources/Models/Results/ResultModelOfTypeDeletedCase.md"),
                .process("Resources/Models/Results/ResultModelOfTypeRenamed.md"),
                .process("Resources/Models/Results/ResultModelOfTypeReplaced.md"),
                .process("Resources/Models/Results/ResultModelOrderReplaced.md"),
                .process("Resources/Models/Results/ResultModelPet.md"),
                .process("Resources/Models/Results/ResultModelPetAddedComplexProperty.md"),
                .process("Resources/Models/Results/ResultModelAddressAddedSimpleProperty.md"),
                .process("Resources/Models/Results/ResultModelPetDeletedProperty.md"),
                .process("Resources/Models/Results/ResultModelPetRenamedProperty.md"),
                .process("Resources/Models/Results/ResultModelPetAddedAndDeletedProperty.md"),
                .process("Resources/Models/Results/ResultModelCustomerRenamedAndReplacedProperty.md"),
                .process("Resources/Models/Results/ResultModelCustomerRenamedAndDeletedProperty.md"),
                .process("Resources/Models/Results/ResultModelPetRenamedAndAddedProperty.md"),
                
                .process("Resources/Enums/Input/EnumMessageLevelFacade.md"),
                .process("Resources/Enums/Input/EnumPlaceholder.md"),
                .process("Resources/Enums/Input/EnumTimeMode.md"),
                .process("Resources/Enums/Input/EnumTimeModeFacade.md"),
                .process("Resources/Enums/Input/EnumTimeModeDeletedCase.md"),
                .process("Resources/Enums/Input/EnumTimeModeRenamed.md"),
                .process("Resources/Enums/Input/ErrorEnum.md"),
                .process("Resources/Enums/Input/ErrorEnumAddedCase.md"),
                .process("Resources/Enums/Input/ErrorEnumDeletedCase.md"),
                .process("Resources/Enums/Input/ErrorEnumFacadeAddedCase.md"),
                .process("Resources/Enums/Input/ErrorEnumFacadeDeletedCase.md"),
                
                .process("Resources/Enums/Results/ResultEnumMessageLevelReplaced.md"),
                .process("Resources/Enums/Results/ResultEnumTimeMode.md"),
                .process("Resources/Enums/Results/ResultEnumTimeModeDeleted.md"),
                .process("Resources/Enums/Results/ResultEnumTimeModeDeletedCase.md"),
                .process("Resources/Enums/Results/ResultEnumTimeModeRenamed.md"),
                .process("Resources/Enums/Results/ResultErrorEnum.md"),
                .process("Resources/Enums/Results/ResultErrorEnumAddedCase.md"),
                .process("Resources/Enums/Results/ResultErrorEnumDeletedCase.md"),
                
                .process("Resources/MigrationGuides/RenameModelAndRenamedPropertyChange.json"),
                .process("Resources/MigrationGuides/RenamePropertyChange.json"),
                .process("Resources/MigrationGuides/DeleteEnumChange.json"),
                .process("Resources/MigrationGuides/ReplaceModelChange.json"),
                .process("Resources/MigrationGuides/RenameEndpointAndReplaceAndDeleteMethodChange.json"),
                .process("Resources/MigrationGuides/AddContentBodyChange.json"),
                .process("Resources/MigrationGuides/DeleteEndpointChange.json"),
                .process("Resources/MigrationGuides/RenameMethodParameterChange.json"),
                .process("Resources/MigrationGuides/ReplaceMNParameterChange.json"),
                .process("Resources/MigrationGuides/ReplaceMethodInSameEndpointChange.json"),
                .process("Resources/MigrationGuides/RequiringMethodParameterChange.json"),
                .process("Resources/MigrationGuides/ReplaceDefaultValueChange.json"),
                .process("Resources/MigrationGuides/AddParameterChange.json"),
                .process("Resources/MigrationGuides/ReplaceMethodContentBodyChange.json"),
                .process("Resources/MigrationGuides/RenameMethodAndChangeContentBodyChange.json"),
                .process("Resources/MigrationGuides/RenameMethodAndReplaceAndDeleteParameterChange.json"),
                .process("Resources/MigrationGuides/RenamedEndpointAndRenameMethodAndAddAndDeleteParameterChange.json"),
                .process("Resources/MigrationGuides/DeleteParameterChange.json"),
                .process("Resources/MigrationGuides/ReplaceMethodReturnTypeChange.json"),
                .process("Resources/MigrationGuides/RenamedEndpointAndRenameMethodAndReplaceAndDeleteParameterAndReplaceReturnValueChange.json"),
                .process("Resources/MigrationGuides/RenameModelAndReplacePropertyChange.json"),
                .process("Resources/MigrationGuides/RenameEndpointAndDeletedMethodChange.json"),
                .process("Resources/MigrationGuides/RenameOfTypeModelChange.json"),
                .process("Resources/MigrationGuides/DeletePropertyChange.json"),
                .process("Resources/MigrationGuides/RenameMethodChange.json"),
                .process("Resources/MigrationGuides/DeleteModelChange.json"),
                .process("Resources/MigrationGuides/DeleteMethodChange.json"),
                .process("Resources/MigrationGuides/RenameEndpointChange.json"),
                .process("Resources/MigrationGuides/ReplaceM1ParameterChange.json"),
                .process("Resources/MigrationGuides/ReplaceMethodChange.json"),
                .process("Resources/MigrationGuides/AddSingleComplexPropertyChange.json"),
                .process("Resources/MigrationGuides/RenameMethodAndAddParameterChange.json"),
                .process("Resources/MigrationGuides/RenamedEndpointAndRenameMethodAndReplaceAndDeleteParameterChange.json"),
                .process("Resources/MigrationGuides/ReplaceEnumChange.json"),
                .process("Resources/MigrationGuides/RenamedEndpointAndRenameMethodAndChangedParametersAndReplaceReturnValueChange.json"),
                .process("Resources/MigrationGuides/AddSinglePrimitivePropertyChange.json"),
                .process("Resources/MigrationGuides/RenameModelChange.json"),
                .process("Resources/MigrationGuides/ReplacePropertyTypeChange.json"),
                .process("Resources/MigrationGuides/RenameEndpointAndRenameMethodChange.json"),
                .process("Resources/MigrationGuides/DeletedAndAddedProperty.json"),
                .process("Resources/MigrationGuides/RenameMethodAndDeleteParameterChange.json"),
                .process("Resources/MigrationGuides/RenameEndpointAndReplaceMethodChange.json"),
                .process("Resources/MigrationGuides/RenameMethodAndReplacedReturnValueChange.json"),
                .process("Resources/MigrationGuides/Replace1NParameterChange.json"),
                .process("Resources/MigrationGuides/RenameMethodAndRenameParameterChange.json"),
                .process("Resources/MigrationGuides/RenameModelAndDeletePropertyChange.json"),
                .process("Resources/MigrationGuides/DeleteOfTypeEnumCaseChange.json"),
                .process("Resources/MigrationGuides/DeleteEnumCaseChange.json"),
                .process("Resources/MigrationGuides/RenameModelAndAddPropertyChange.json"),
                .process("Resources/MigrationGuides/DeleteOfTypeChange.json"),
                .process("Resources/MigrationGuides/ReplaceMethodParameterChange.json"),
                .process("Resources/MigrationGuides/RenameEnumChange.json"),
                .process("Resources/MigrationGuides/ReplaceOfTypeModelChange.json"),
                .process("Resources/MigrationGuides/EmptyGuide.json")
            ]
        )
    ]
)
