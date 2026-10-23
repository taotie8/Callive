import Foundation

struct CalLocalChatMessage: Codable {
    let id: String
    let friendId: Int64
    let friendName: String
    let friendAvatar: String
    let senderName: String
    let senderAvatar: String
    let isMine: Bool
    let content: String
    let createdAt: Date
}

struct CalLocalChatConversation: Codable {
    let friendId: Int64
    var friendName: String
    var friendAvatar: String
    var messages: [CalLocalChatMessage]
    var updatedAt: Date

    var lastMessage: String {
        messages.last?.content ?? ""
    }
}

final class CalLocalChatStorage {

    static let shared = CalLocalChatStorage()

    private init() {}

    private let storageKey = "cal_local_chat_conversations"

    func messages(for friendId: Int64) -> [CalLocalChatMessage] {
        conversations().first(where: { $0.friendId == friendId })?.messages ?? []
    }

    func conversations() -> [CalLocalChatConversation] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return []
        }

        return (try? JSONDecoder().decode(
            [CalLocalChatConversation].self,
            from: data
        )) ?? []
    }

    func append(_ message: CalLocalChatMessage) {
        var items = conversations()

        if let index = items.firstIndex(where: { $0.friendId == message.friendId }) {
            items[index].friendName = message.friendName
            items[index].friendAvatar = message.friendAvatar
            items[index].messages.append(message)
            items[index].updatedAt = message.createdAt
        } else {
            items.append(
                CalLocalChatConversation(
                    friendId: message.friendId,
                    friendName: message.friendName,
                    friendAvatar: message.friendAvatar,
                    messages: [message],
                    updatedAt: message.createdAt
                )
            )
        }

        save(items)
    }

    private func save(_ items: [CalLocalChatConversation]) {
        guard let data = try? JSONEncoder().encode(items) else {
            return
        }

        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
