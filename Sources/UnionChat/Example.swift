import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct ExampleMessage: ChatMessage {
    let id: UUID
    var role: ChatRole
    var timestamp: Date
    var kind: MessageKind
    var state: DeliveryState
    var text: String?
    var media: MessageMedia?
    var reactions: [MessageReaction]
    var replyToMessageID: AnyHashable?
    var metadata: [String: String]
    
    init(
        id: UUID,
        role: ChatRole,
        timestamp: Date = .now,
        kind: MessageKind = .text,
        state: DeliveryState = .sent,
        text: String? = nil,
        media: MessageMedia? = nil,
        reactions: [MessageReaction] = [],
        replyToMessageID: AnyHashable? = nil,
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.role = role
        self.timestamp = timestamp
        self.kind = kind
        self.state = state
        self.text = text
        self.media = media
        self.reactions = reactions
        self.replyToMessageID = replyToMessageID
        self.metadata = metadata
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct FullFeaturedChatExample: View {
    @State private var text = ""
    @State private var isTyping = true
    
    private let messages: [ExampleMessage] = [
        .init(
            id: UUID(),
            role: .user("alice"),
            timestamp: Date().addingTimeInterval(-3600),
            text: "Hey! How's the new chat SDK coming along?"
        ),
        .init(
            id: UUID(),
            role: .me,
            timestamp: Date().addingTimeInterval(-3500),
            text: "Really well! Just wrapping up the docs."
        ),
        .init(
            id: UUID(),
            role: .user("alice"),
            timestamp: Date().addingTimeInterval(-3400),
            text: "Can you show me what it looks like?"
        ),
        .init(
            id: UUID(),
            role: .me,
            timestamp: Date().addingTimeInterval(-3300),
            state: .read,
            text: "Sure! Check this out 👇"
        ),
        .init(
            id: UUID(),
            role: .system,
            timestamp: Date().addingTimeInterval(-3200),
            kind: .event,
            text: "Alice shared a file"
        ),
        .init(
            id: UUID(),
            role: .user("alice"),
            timestamp: Date().addingTimeInterval(-1800),
            text: "Love it! The bubbles look great."
        ),
        .init(
            id: UUID(),
            role: .me,
            timestamp: Date().addingTimeInterval(-1700),
            state: .delivered,
            text: "Thanks! The tail shapes really polish it."
        )
    ]
    
    var body: some View {
        Chat {
            Divider(date: Date().addingTimeInterval(-7200))
            
            ForEach(messages) { message in
                if message.kind == .event {
                    Event(message.text, time: message.timestamp)
                } else {
                    Message(message) {
                        Text(message.text)
                            .padding(12)
                            .background(.ultraThickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } avatar: {
                        Text(message.timestamp, style: .time)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .tag(message.id)
                }
            }
            
            Divider(date: Date().addingTimeInterval(-900))
        }
        .chatStyle(.bubble)
        .chatTypingUsers(isTyping ? [.user("alice")] : [])
        .tint(.blue)
        .chatMessageSpacing(8)
        .chatAutoscroll(.whenAtBottom)
        .chatInputPlaceholder("Message Alice...")
        .chatInputCapabilities([.camera, .photoLibrary])
        .onChatSend { text, media in
            sendMessage()
        }
        .chatBackground {
            LinearGradient(
                colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .chatControls {
            ScrollToBottomButton()
        }
    }
    
    private func sendMessage() {
        guard !text.isEmpty else { return }
        print("Sending: \(text)")
        text = ""
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct ChatStoreExample: View {
    @State private var messages: [ExampleMessage] = [
        ExampleMessage(
            id: UUID(),
            role: .user("bob"),
            text: "Hey, want to grab lunch?"
        ),
        ExampleMessage(
            id: UUID(),
            role: .me,
            text: "Sure! Where at?"
        )
    ]
    
    @State private var text = ""
    
    var body: some View {
        Chat(messages) { message in
            Message(message) {
                Text(message.text)
                    .padding(12)
                    .background(.ultraThickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .onChatSend { text, media in
            messages.append(ExampleMessage(
                id: UUID(),
                role: .me,
                text: text,
                media: media
            ))
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct ChatReaderExample: View {
    @State private var messages: [ExampleMessage] = []
    
    var body: some View {
        ChatReader { proxy in
            VStack {
                Chat(messages) { message in
                    Message(
                        id: message.id,
                        role: message.role,
                        time: message.timestamp
                    ) {
                        Text(message.text)
                            .padding(12)
                            .background(.ultraThickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                
                HStack {
                    Button("Scroll to First") {
                        if let first = messages.first {
                            proxy.scroll(to: .message(first.id), animated: true)
                        }
                    }
                    
                    Button("Scroll to Bottom") {
                        proxy.scroll(to: .bottom(), animated: true)
                    }
                    
                    Button("Last Visible") {
                        if let lastID = proxy.lastVisibleMessageID {
                            print("Last visible: \(lastID)")
                        }
                    }
                }
                .padding()
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct MultiRoleExample: View {
    @State private var messages: [ExampleMessage] = [
        .init(id: UUID(), role: .system, kind: .event, text: "Chat started"),
        .init(id: UUID(), role: .user("alice"), text: "Hi everyone!"),
        .init(id: UUID(), role: .user("bob"), text: "Hey Alice!"),
        .init(id: UUID(), role: .me, text: "Welcome to the group!"),
        .init(id: UUID(), role: .system, kind: .event, text: "Charlie joined"),
        .init(id: UUID(), role: .user("charlie"), text: "Thanks for adding me!")
    ]
    
    var body: some View {
        Chat(messages) { message in
            if message.kind == .event {
                Event(time: message.timestamp) {
                    Text(message.text)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                Message(message) {
                    VStack(alignment: .leading, spacing: 4) {
                        if case .user(let name) = message.role {
                            Text(name)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Text(message.text)
                    }
                    .padding(12)
                    .background(.ultraThickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
        .tint(.blue)
        .chatMessageStyle(.purple.gradient, for: .user("alice"))
        .chatMessageStyle(.green.gradient, for: .user("bob"))
        .chatMessageStyle(.orange.gradient, for: .user("charlie"))
    }
}

#Preview("Full Featured") {
    FullFeaturedChatExample()
}

#Preview("With State") {
    ChatStoreExample()
}

#Preview("Reader Proxy") {
    ChatReaderExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct BubbleStylingExample: View {
    @State private var messages: [ExampleMessage] = [
        ExampleMessage(id: UUID(), role: .user("alice"), text: "My messages use gray gradient"),
        ExampleMessage(id: UUID(), role: .me, text: "Your messages use app tint")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Default (uses .tint)").font(.caption)
            Chat(messages)
                .tint(.blue)
                .frame(height: 200)
            
            Divider()
            
            Text("Custom per-user colors").font(.caption)
            Chat(messages)
                .tint(.purple)
                .chatMessageStyle(.orange.gradient, for: .user("alice"))
                .frame(height: 200)
            
            Divider()
            
            Text("Custom gradients").font(.caption)
            Chat(messages)
                .chatMessageStyle(
                    LinearGradient(colors: [.pink, .orange], startPoint: .topLeading, endPoint: .bottomTrailing),
                    for: .me
                )
                .chatMessageStyle(.gray.gradient, for: .user("alice"))
                .frame(height: 200)
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct ChatControlsExample: View {
    @State private var messages: [ExampleMessage] = [
        ExampleMessage(id: UUID(), role: .user("alice"), text: "Try scrolling up!"),
        ExampleMessage(id: UUID(), role: .me, text: "Then use the button to scroll back")
    ]
    
    var body: some View {
        Chat(messages)
            .chatControls {
                ScrollToBottomButton()
            }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct ChatStylesExample: View {
    @State private var messages: [ExampleMessage] = [
        ExampleMessage(id: UUID(), role: .user("alice"), text: "Hey! What's up?"),
        ExampleMessage(id: UUID(), role: .me, text: "Not much, working on the chat SDK!"),
        ExampleMessage(id: UUID(), role: .user("alice"), text: "Cool! Can't wait to try it")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Bubble Style (iMessage)").font(.caption)
            Chat(messages)
                .chatStyle(.bubble)
                .tint(.blue)
                .frame(height: 250)
            
            Divider()
            
            Text("Plain Style (Slack/Discord)").font(.caption)
            Chat(messages)
                .chatStyle(.plain)
                .frame(height: 250)
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct CustomContentExample: View {
    @State private var messages: [ExampleMessage] = [
        ExampleMessage(id: UUID(), role: .user("alice"), text: "Are you available?"),
        ExampleMessage(id: UUID(), role: .me, text: "Not right now")
    ]
    
    var body: some View {
        Chat {
            ForEach(messages) { message in
                Message(message)
            }
            
            Banner {
                HStack {
                    Image(systemName: "moon.zzz.fill")
                        .foregroundStyle(.purple)
                    Text("Alice is on Do Not Disturb")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.quaternary)
                .clipShape(Capsule())
            }
        }
    }
}

#Preview("Chat Styles") {
    ChatStylesExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct EmptyStateExample: View {
    @State private var messages: [ExampleMessage] = []
    
    var body: some View {
        Chat(messages)
            .chatEmptyState {
                ContentUnavailableView(
                    "No Messages",
                    systemImage: "bubble.left.and.bubble.right",
                    description: Text("Send a message to start the conversation")
                )
            }
            .onChatSend { text, media in
                messages.append(ExampleMessage(
                    id: UUID(),
                    role: .me,
                    text: text,
                    media: media
                ))
            }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct TypingIndicatorExample: View {
    @State private var messages: [ExampleMessage] = [
        ExampleMessage(id: UUID(), role: .user("alice"), text: "Hey!"),
        ExampleMessage(id: UUID(), role: .me, text: "What's up?")
    ]
    @State private var typingUsers: Set<ChatRole> = []
    
    var body: some View {
        VStack {
            Chat(messages)
                .chatTypingUsers(typingUsers)
            
            Toggle("Alice is typing", isOn: Binding(
                get: { typingUsers.contains(.user("alice")) },
                set: { isTyping in
                    if isTyping {
                        typingUsers.insert(.user("alice"))
                    } else {
                        typingUsers.remove(.user("alice"))
                    }
                }
            ))
            .padding()
        }
    }
}

#Preview("Empty State") {
    EmptyStateExample()
}

#Preview("Typing Indicator") {
    TypingIndicatorExample()
}

#Preview("Custom Content") {
    CustomContentExample()
}

#Preview("Bubble Styling") {
    BubbleStylingExample()
}

#Preview("Chat Controls") {
    ChatControlsExample()
}

#Preview("Multi Role") {
    MultiRoleExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct ForEachIntegrationExample: View {
    @State private var messages: [ExampleMessage] = [
        .init(id: UUID(), role: .user("alice"), text: "Using ForEach!"),
        .init(id: UUID(), role: .me, text: "So much cleaner!"),
        .init(id: UUID(), role: .user("alice"), text: "Love the natural SwiftUI feel")
    ]
    
    var body: some View {
        Chat {
            ForEach(messages) { message in
                Message(message)
                    .accessibilityLabel("Message from \(userName(for: message.role))")
            }
        }
    }
    
    private func userName(for role: ChatRole) -> String {
        switch role {
        case .me: return "you"
        case .user(let name): return name
        case .system: return "system"
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct ReactionsExample: View {
    let aliceMessageID = UUID()
    let myMessageID = UUID()
    
    @State private var messages: [ExampleMessage] = []
    
    init() {
        let aliceMessage = ExampleMessage(
            id: aliceMessageID,
            role: .user("alice"),
            text: "I love this feature!",
            reactions: [
                MessageReaction(emoji: "❤️", userIDs: ["me", "bob"], includesMe: true),
                MessageReaction(emoji: "🔥", userIDs: ["me"], includesMe: true),
                MessageReaction(emoji: "👍", userIDs: ["charlie"], includesMe: false)
            ]
        )
        
        let myMessage = ExampleMessage(
            id: myMessageID,
            role: .me,
            text: "Thanks! 🙌",
            reactions: [
                MessageReaction(emoji: "😊", userIDs: ["alice"], includesMe: false)
            ]
        )
        
        _messages = State(initialValue: [aliceMessage, myMessage])
    }
    
    var body: some View {
        Chat(messages)
            .chatInteractions([.react])
            .onReaction { messageID, emoji, action in
                guard let index = messages.firstIndex(where: { $0.id == messageID }) else { return }
                
                switch action {
                case .adding:
                    let existingReactionIndex = messages[index].reactions.firstIndex(where: { $0.emoji == emoji })
                    if let existingIndex = existingReactionIndex {
                        var updated = messages[index].reactions[existingIndex]
                        var newUserIDs = updated.userIDs
                        newUserIDs.insert("me")
                        messages[index].reactions[existingIndex] = MessageReaction(
                            emoji: emoji,
                            userIDs: newUserIDs,
                            includesMe: true
                        )
                    } else {
                        messages[index].reactions.append(
                            MessageReaction(emoji: emoji, userIDs: ["me"], includesMe: true)
                        )
                    }
                case .removing:
                    if let reactionIndex = messages[index].reactions.firstIndex(where: { $0.emoji == emoji }) {
                        var updated = messages[index].reactions[reactionIndex]
                        var newUserIDs = updated.userIDs
                        newUserIDs.remove("me")
                        if newUserIDs.isEmpty {
                            messages[index].reactions.remove(at: reactionIndex)
                        } else {
                            messages[index].reactions[reactionIndex] = MessageReaction(
                                emoji: emoji,
                                userIDs: newUserIDs,
                                includesMe: false
                            )
                        }
                    }
                }
            }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct MediaTypesExample: View {
    @State private var messages: [ExampleMessage] = [
        ExampleMessage(
            id: UUID(),
            role: .user("alice"),
            text: "Check out this photo!",
            media: .image(url: URL(string: "https://picsum.photos/300/200")!)
        ),
        ExampleMessage(
            id: UUID(),
            role: .me,
            text: "Beautiful!"
        ),
        ExampleMessage(
            id: UUID(),
            role: .me,
            media: .audio(url: URL(string: "audio.m4a")!, duration: 15)
        ),
        ExampleMessage(
            id: UUID(),
            role: .user("alice"),
            text: "Here's the document you requested",
            media: .file(url: URL(string: "report.pdf")!, name: "Q4_Report.pdf", size: 1_500_000)
        )
    ]
    
    var body: some View {
        Chat(messages)
    }
}

#Preview("ForEach Integration") {
    ForEachIntegrationExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct SimpleReactionsExample: View {
    @State private var messages: [ExampleMessage] = [
        ExampleMessage(
            id: UUID(),
            role: .user("alice"),
            text: "This is amazing!",
            reactions: [
                MessageReaction(emoji: "❤️", userIDs: ["me"], includesMe: true),
                MessageReaction(emoji: "👍", userIDs: ["bob", "charlie"])
            ]
        ),
        ExampleMessage(
            id: UUID(),
            role: .me,
            text: "Thanks everyone!"
        )
    ]
    
    var body: some View {
        Chat(messages)
            .chatInteractions([.react])
            .onReaction { messageID, emoji, action in
                print("Reaction: \(emoji) \(action == .adding ? "added" : "removed") on \(messageID)")
            }
    }
}

#Preview("Reactions") {
    ReactionsExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct InteractionsExample: View {
    @State private var messages: [ExampleMessage] = [
        ExampleMessage(
            id: UUID(),
            role: .user("alice"),
            text: "Try long pressing this message!"
        ),
        ExampleMessage(
            id: UUID(),
            role: .me,
            text: "You can edit, delete, reply, or react to messages"
        )
    ]
    
    var body: some View {
        Chat(messages)
            .chatInteractions([.reply, .edit, .delete, .react])
            .onReply { messageID in
                print("Reply to: \(messageID)")
            }
            .onEdit { messageID, newText in
                if let index = messages.firstIndex(where: { $0.id == messageID }) {
                    messages[index].text = newText
                }
            }
            .onDelete { messageID in
                messages.removeAll { $0.id == messageID }
            }
            .onReaction { messageID, emoji, action in
                print("Reaction: \(emoji) \(action)")
            }
    }
}

#Preview("Simple Reactions") {
    SimpleReactionsExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct ThreadedRepliesExample: View {
    let originalMessageID = UUID()
    
    @State private var messages: [ExampleMessage] = []
    @State private var replyingTo: UUID?
    
    init() {
        let original = ExampleMessage(
            id: originalMessageID,
            role: .user("alice"),
            text: "What time should we meet?"
        )
        
        let reply = ExampleMessage(
            id: UUID(),
            role: .me,
            text: "How about 3pm?",
            replyToMessageID: originalMessageID
        )
        
        let followup = ExampleMessage(
            id: UUID(),
            role: .user("alice"),
            text: "Perfect!"
        )
        
        _messages = State(initialValue: [original, reply, followup])
    }
    
    var body: some View {
        Chat(messages)
            .chatInteractions([.reply, .react])
            .onReply { messageID in
                replyingTo = messageID as? UUID
            }
            .onChatSend { text, media in
                messages.append(ExampleMessage(
                    id: UUID(),
                    role: .me,
                    text: text,
                    media: media,
                    replyToMessageID: replyingTo
                ))
                replyingTo = nil
            }
    }
}

#Preview("Interactions") {
    InteractionsExample()
}

#Preview("Threaded Replies") {
    ThreadedRepliesExample()
}

#Preview("Media Types") {
    MediaTypesExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct MessageStyleExample: View {
    @State private var messages: [ExampleMessage] = [
        .init(id: UUID(), role: .user("alice"), text: "This is plain text"),
        .init(id: UUID(), role: .me, text: "This is in a bubble"),
        .init(id: UUID(), role: .user("alice"), text: "Another plain message"),
        .init(id: UUID(), role: .me, text: "Bubble with tail!")
    ]
    
    var body: some View {
        Chat {
            Message(
                "This is plain text",
                id: messages[0].id,
                role: .user("alice"),
                time: messages[0].timestamp
            )
            .messageStyle(.plain)
            
            Message(
                "This is in a bubble",
                id: messages[1].id,
                role: .me,
                time: messages[1].timestamp
            )
            .messageStyle(.bubble)
            
            Message(
                id: messages[2].id,
                role: .user("alice"),
                time: messages[2].timestamp
            ) {
                Text("Another plain message")
                    .font(.body)
            }
            .messageStyle(.plain)
            
            Message(
                id: messages[3].id,
                role: .me,
                time: messages[3].timestamp
            ) {
                Text("Bubble with tail!")
                    .padding(12)
            }
            .messageStyle(.bubble(.tail(.bottomRight)))
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct CleanSyntaxExample: View {
    @State private var messages: [ExampleMessage] = [
        .init(id: UUID(), role: .user("alice"), text: "Super clean syntax!"),
        .init(id: UUID(), role: .me, text: "Just pass the message directly"),
        .init(id: UUID(), role: .user("alice"), text: "Love it")
    ]
    
    var body: some View {
        Chat {
            ForEach(messages) { message in
                if message.role == .me {
                    Message(message)
                } else {
                    Message(message)
                        .messageStyle(.plain)
                }
            }
        }
    }
}

#Preview("Message Styles") {
    MessageStyleExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct MinimalExample: View {
    @State private var messages: [ExampleMessage] = [
        .init(id: UUID(), role: .user("alice"), text: "One line of code"),
        .init(id: UUID(), role: .me, text: "That's it!"),
        .init(id: UUID(), role: .system, kind: .event, text: "Alice reacted ❤️"),
        .init(id: UUID(), role: .user("alice"), text: "So simple")
    ]
    
    var body: some View {
        Chat(messages)
    }
}

#Preview("Clean Syntax") {
    CleanSyntaxExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct ChartsStyleExample: View {
    @State private var messages: [ExampleMessage] = [
        .init(id: UUID(), role: .user("bob"), text: "Charts-style syntax"),
        .init(id: UUID(), role: .me, text: "No ForEach needed!"),
        .init(id: UUID(), role: .user("bob"), text: "Super ergonomic")
    ]
    
    var body: some View {
        Chat(messages) { message in
            Message(message, avatar: message.role == .me ? nil : .initials(background: .blue)) {
                Text(message.text)
                    .font(message.role == .me ? .body : .system(size: 13))
            }
            .messageStyle(message.role == .me ? .bubble : .plain)
        }
    }
}

#Preview("Minimal (One Line)") {
    MinimalExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct CustomAvatarExample: View {
    @State private var messages: [ExampleMessage] = [
        .init(id: UUID(), role: .user("alice"), text: "Custom avatars!"),
        .init(id: UUID(), role: .me, text: "Using label closure")
    ]
    
    var body: some View {
        Chat(messages) { message in
            Message(message) {
                Text(message.text)
            } avatar: {
                if message.role != .me {
                    AvatarView(for: message.role, size: 40)
                }
            }
        }
    }
}

#Preview("Charts Style") {
    ChartsStyleExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct AutoAvatarExample: View {
    @State private var twoPersonMessages: [ExampleMessage] = [
        .init(id: UUID(), role: .user("alice"), text: "Just us two"),
        .init(id: UUID(), role: .me, text: "No avatars needed"),
        .init(id: UUID(), role: .user("alice"), text: "Keeps it clean")
    ]
    
    @State private var groupMessages: [ExampleMessage] = [
        .init(id: UUID(), role: .user("alice"), text: "Group chat!"),
        .init(id: UUID(), role: .user("bob"), text: "Hey everyone"),
        .init(id: UUID(), role: .me, text: "Avatars auto-show"),
        .init(id: UUID(), role: .user("charlie"), text: "Nice!")
    ]
    
    var body: some View {
        VStack {
            Text("1-on-1 (no avatars)").font(.caption).padding(.top)
            
            Chat(twoPersonMessages) { message in
                Message(message, avatar: .initials) {
                    Text(message.text)
                }
            }
            .frame(height: 200)
            
            Divider()
            
            Text("Group (auto avatars)").font(.caption)
            
            Chat(groupMessages) { message in
                Message(message, avatar: .initials) {
                    Text(message.text)
                }
            }
            .frame(height: 200)
            
            Divider()
            
            Text("Force visible").font(.caption)
            
            Chat(twoPersonMessages) { message in
                Message(message, avatar: .initials) {
                    Text(message.text)
                }
            }
            .chatAvatarVisibility(.visible, for: .user("alice"))
            .chatAvatarVisibility(.visible, for: .me)
            .frame(height: 200)
        }
    }
}

#Preview("Custom Avatar") {
    CustomAvatarExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct PaginationExample: View {
    @State private var messages: [ExampleMessage] = [
        .init(id: UUID(), role: .user("alice"), text: "Message 5"),
        .init(id: UUID(), role: .me, text: "Message 6"),
        .init(id: UUID(), role: .user("alice"), text: "Message 7")
    ]
    @State private var isLoadingMore = false
    @State private var page = 1
    
    var body: some View {
        Chat {
            if isLoadingMore {
                Loading()
            }
            
            ForEach(messages) { message in
                Message(message)
            }
        }
        .onChatEdge {
            await loadMoreMessages()
        }
    }
    
    private func loadMoreMessages() async {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        
        try? await Task.sleep(for: .seconds(1))
        
        let newMessages = [
            ExampleMessage(id: UUID(), role: .user("alice"), text: "Message \(page * 3 + 2)"),
            ExampleMessage(id: UUID(), role: .me, text: "Message \(page * 3 + 3)"),
            ExampleMessage(id: UUID(), role: .user("alice"), text: "Message \(page * 3 + 4)")
        ]
        
        messages.insert(contentsOf: newMessages, at: 0)
        page += 1
        isLoadingMore = false
    }
}

#Preview("Auto Avatar Visibility") {
    AutoAvatarExample()
}

#Preview("Pagination") {
    PaginationExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct RichMediaExample: View {
    @State private var messages: [ExampleMessage] = [
        ExampleMessage(
            id: UUID(),
            role: .user("alice"),
            text: "Check out this photo I took!",
            media: .image(url: URL(string: "https://picsum.photos/400/300")!)
        ),
        ExampleMessage(
            id: UUID(),
            role: .me,
            text: "Wow! That's beautiful 😍"
        ),
        ExampleMessage(
            id: UUID(),
            role: .me,
            text: "Here's my vacation video!",
            media: .video(url: URL(string: "https://picsum.photos/300/200")!)
        ),
        ExampleMessage(
            id: UUID(),
            role: .user("alice"),
            media: .image(url: URL(string: "https://picsum.photos/300/400")!)
        ),
        ExampleMessage(
            id: UUID(),
            role: .user("alice"),
            text: "Looks amazing! 🌴"
        )
    ]
    
    var body: some View {
        Chat(messages)
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct CustomMediaRenderingExample: View {
    @State private var messages: [ExampleMessage] = [
        ExampleMessage(
            id: UUID(),
            role: .user("alice"),
            text: "Check this out!",
            media: .image(url: URL(string: "https://picsum.photos/300/300")!)
        ),
        ExampleMessage(
            id: UUID(),
            role: .me,
            text: "Cool!"
        )
    ]
    
    var body: some View {
        Chat(messages) { message in
            if let media = message.media, case .image(let url) = media {
                Message(message) {
                    VStack(alignment: .leading, spacing: 12) {
                        if let text = message.text {
                            Text(text)
                                .font(.headline)
                        }
                        
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(alignment: .bottomTrailing) {
                            Image(systemName: "sparkles")
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .padding(8)
                        }
                    }
                    .padding(12)
                }
            } else {
                Message(message)
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct ImageGalleryExample: View {
    @State private var messages: [ExampleMessage] = [
        ExampleMessage(
            id: UUID(),
            role: .user("alice"),
            text: "Which one do you like best?"
        ),
        ExampleMessage(
            id: UUID(),
            role: .me,
            text: "I like the first one! 🌟"
        )
    ]
    
    let images = [
        URL(string: "https://picsum.photos/400/300?random=1")!,
        URL(string: "https://picsum.photos/400/300?random=2")!,
        URL(string: "https://picsum.photos/400/300?random=3")!
    ]
    
    var body: some View {
        Chat(messages) { message in
            if message.role == .user("alice") {
                Message(message) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Here are the three options:")
                            .padding(.horizontal, 12)
                            .padding(.top, 12)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(images, id: \.self) { imageURL in
                                    AsyncImage(url: imageURL) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Rectangle()
                                            .fill(.quaternary)
                                            .overlay { ProgressView() }
                                    }
                                    .frame(width: 180, height: 140)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                            .padding(.horizontal, 12)
                        }
                        
                        if let text = message.text {
                            Text(text)
                                .padding(.horizontal, 12)
                                .padding(.bottom, 12)
                        }
                    }
                }
            } else {
                Message(message)
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct AllThreeCasesExample: View {
    @State private var messages: [ExampleMessage] = [
        ExampleMessage(
            id: UUID(),
            role: .user("alice"),
            text: "Just text, no media"
        ),
        ExampleMessage(
            id: UUID(),
            role: .me,
            media: .image(url: URL(string: "https://picsum.photos/300/200")!)
        ),
        ExampleMessage(
            id: UUID(),
            role: .user("alice"),
            text: "Text AND an image below:",
            media: .image(url: URL(string: "https://picsum.photos/400/300")!)
        ),
        ExampleMessage(
            id: UUID(),
            role: .me,
            text: "Perfect! All three cases work! ✨"
        )
    ]
    
    var body: some View {
        Chat(messages)
    }
}

#Preview("All Three Cases") {
    AllThreeCasesExample()
}

#Preview("Rich Media (Auto)") {
    RichMediaExample()
}

#Preview("Custom Media Rendering") {
    CustomMediaRenderingExample()
}

#Preview("Image Gallery") {
    ImageGalleryExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct AutomaticInputExample: View {
    @State private var messages: [ExampleMessage] = [
        ExampleMessage(
            id: UUID(),
            role: .user("alice"),
            text: "Try sending a message!"
        )
    ]
    
    var body: some View {
        Chat(messages)
            .chatInputPlaceholder("Message Alice...")
            .chatInputCapabilities([.camera, .photoLibrary, .location])
            .onChatSend { text, media in
                messages.append(ExampleMessage(
                    id: UUID(),
                    role: .me,
                    text: text,
                    media: media
                ))
            }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct FullMediaInputExample: View {
    @State private var messages: [ExampleMessage] = []
    
    var body: some View {
        Chat(messages)
            .chatInputCapabilities(.all)
            .onChatSend { text, media in
                messages.append(ExampleMessage(
                    id: UUID(),
                    role: .me,
                    text: text,
                    media: media
                ))
            }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct MinimalInputExample: View {
    @State private var messages: [ExampleMessage] = []
    
    var body: some View {
        Chat(messages)
            .onChatSend { text, media in
                messages.append(ExampleMessage(
                    id: UUID(),
                    role: .me,
                    text: text,
                    media: media
                ))
            }
    }
}

#Preview("Automatic Input") {
    AutomaticInputExample()
}

#Preview("Full Media Input") {
    FullMediaInputExample()
}

#Preview("Minimal Input") {
    MinimalInputExample()
}

