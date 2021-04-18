import Foundation

class _PaymentInstallmentSchedule: Codable {

    //sourcery: isCustomInternalEnumType
    var of: AnyOf

    //sourcery: OfTypeEnum
    enum AnyOf : Codable {

    case psiInstallmentSchedule(_PsiInstallmentSchedule)
case psdInstallmentSchedule(_PsdInstallmentSchedule)
    case psdInstallmentSchedulePsiInstallmentSchedule(_PsdInstallmentSchedulePsiInstallmentSchedule)

        //sourcery: ignore
        func encode(to encoder: Encoder) throws {
            switch self {
                case .psiInstallmentSchedule(let of):
    try of.encode(to: encoder)
    break
case .psdInstallmentSchedule(let of):
    try of.encode(to: encoder)
    break
                case .psdInstallmentSchedulePsiInstallmentSchedule(let of):
    try of.encode(to: encoder)
    break
            }
        }

        //sourcery: ignore
        init(from decoder: Decoder) throws {
            if let psiInstallmentSchedule = try? _PsiInstallmentSchedule.init(from: decoder) {
self = .psiInstallmentSchedule(psiInstallmentSchedule)
return
}
if let psdInstallmentSchedule = try? _PsdInstallmentSchedule.init(from: decoder) {
self = .psdInstallmentSchedule(psdInstallmentSchedule)
return
}
            if let psdInstallmentSchedulePsiInstallmentSchedule = try? _PsdInstallmentSchedulePsiInstallmentSchedule.init(from: decoder) {
    self = .psdInstallmentSchedulePsiInstallmentSchedule(psdInstallmentSchedulePsiInstallmentSchedule)
        return
}

            throw APIEncodingError.canNotEncodeOfType(_PaymentInstallmentSchedule.self)
        }
        
    }

    init(of: AnyOf){
        self.of = of
    }

    //sourcery: ignore
    func encode(to encoder: Encoder) throws {
        try of.encode(to: encoder)
    }

    //sourcery: ignore
    required init(from decoder: Decoder) throws {
        self.of = try AnyOf.init(from: decoder)
    }

}
