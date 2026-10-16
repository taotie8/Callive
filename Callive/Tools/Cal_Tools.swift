
import Foundation

func check_stringNull(_ text: String?) -> Bool {
    text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != false
}

func check_validEmail(_ email: String) -> Bool {
    let str = email.trimmingCharacters(in: .whitespacesAndNewlines)
    let type = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    return str.range(
        of: type,
        options: .regularExpression
    ) != nil
}
