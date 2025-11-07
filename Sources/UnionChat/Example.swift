import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct FullFeaturedChatExample: View {
    @State private var text = ""
    @State private var position = ChatPosition.automatic
    @State private var selection: UUID?
    @State private var isTyping = true
    @State private var showReadReceipts = true
    
    private let messages: [ChatMessage<UUID>] = [
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
        Chat(position: $position, selection: $selection) {
            DividerMark(date: Date().addingTimeInterval(-7200))
            
            ForEach(messages) { message in
                if message.kind == .event {
                    EventMark(time: message.timestamp) {
                        Text(message.text)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.quaternary)
                            .clipShape(Capsule())
                    }
                } else {
                    MessageMark(
                        id: message.id,
                        role: message.role,
                        time: message.timestamp,
                        state: message.state
                    ) {
                        Text(message.text)
                            .padding(12)
                            .background(.ultraThickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } label: {
                        HStack(spacing: 4) {
                            Text(message.timestamp, style: .time)
                            if showReadReceipts && message.role == .me {
                                deliveryStateIcon(for: message.state)
                            }
                        }
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    }
                    .tag(message.id)
                    
                    if showReadReceipts && message.role == .me {
                        ReceiptMark(
                            for: message.id,
                            position: .trailing,
                            state: message.state
                        )
                    }
                }
            }
            
            DividerMark(date: Date().addingTimeInterval(-900))
            
            if isTyping {
                TypingMark(users: ["Alice"])
            }
        }
        .alignScale([
            .me: .trailing,
            .system: .center,
            .user("alice"): .leading
        ])
        .chatForegroundStyleScale([
            .me: .tint,
            .system: Color.secondary,
            .user("alice"): Color.primary
        ])
        .bubbleShapeScale([
            .text: .tail(.bottomRight),
            .event: .rounded(12)
        ])
        .grouping(.byDay)
        .messageSpacing(8)
        .readReceipts(showReadReceipts)
        .chatInteractions([.tap, .longPress, .dragToReply, .copy])
        .autoscroll(.whenAtBottom())
        .theme(.glass(.regular))
        .header {
            ChatHeader(
                title: "Alice",
                avatar: Image(systemName: "person.circle.fill"),
                action: {
                    print("Header tapped")
                }
            )
        }
        .composer {
            InputBar(text: $text, placeholder: "Message Alice...") {
                sendMessage()
            }
        }
        .keyboardAccessory {
            ScrollToBottomButton()
        }
        .chatBackground {
            LinearGradient(
                colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .chatControls {
            VStack {
                ScrollToBottomButton()
                Button {
                    showReadReceipts.toggle()
                } label: {
                    Image(systemName: showReadReceipts ? "checkmark.circle.fill" : "checkmark.circle")
                        .font(.title2)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
        }
        .scrollPosition($position)
    }
    
    private func sendMessage() {
        guard !text.isEmpty else { return }
        print("Sending: \(text)")
        text = ""
    }
    
    @ViewBuilder
    private func deliveryStateIcon(for state: DeliveryState) -> some View {
        switch state {
        case .composing:
            Image(systemName: "pencil")
        case .sending:
            Image(systemName: "arrow.up.circle")
        case .sent:
            Image(systemName: "checkmark")
        case .delivered:
            Image(systemName: "checkmark.circle")
        case .read:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.blue)
        case .failed:
            Image(systemName: "exclamationmark.triangle")
                .foregroundStyle(.red)
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct ChatStoreExample: View {
    @State private var store = ChatStore([
        ChatMessage(
            id: UUID(),
            role: .user("bob"),
            text: "Hey, want to grab lunch?"
        ),
        ChatMessage(
            id: UUID(),
            role: .me,
            text: "Sure! Where at?"
        )
    ])
    
    @State private var text = ""
    
    var body: some View {
        Chat(store.messages) { message in
            MessageMark(
                id: message.id,
                role: message.role,
                time: message.timestamp,
                state: message.state
            ) {
                Text(message.text)
                    .padding(12)
                    .background(.ultraThickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .alignScale([.me: .trailing, .user("bob"): .leading])
        .composer {
            InputBar(text: $text) {
                let newMessage = ChatMessage(
                    id: UUID(),
                    role: .me,
                    text: text
                )
                store.append(newMessage)
                text = ""
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct ChatReaderExample: View {
    @State private var messages: [ChatMessage<UUID>] = []
    
    var body: some View {
        ChatReader { proxy in
            VStack {
                Chat(messages) { message in
                    MessageMark(
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
    @State private var messages: [ChatMessage<UUID>] = [
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
                EventMark(time: message.timestamp) {
                    Text(message.text)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                MessageMark(
                    id: message.id,
                    role: message.role,
                    time: message.timestamp
                ) {
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
        .alignScale([
            .me: .trailing,
            .system: .center,
            .user("alice"): .leading,
            .user("bob"): .leading,
            .user("charlie"): .leading
        ])
        .chatForegroundStyleScale([
            .me: .tint,
            .system: Color.secondary,
            .user("alice"): Color.purple,
            .user("bob"): Color.green,
            .user("charlie"): Color.orange
        ])
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct CustomThemeExample: View {
    @State private var selectedTheme: ThemeOption = .glass
    
    enum ThemeOption: String, CaseIterable {
        case glass = "Glass"
        case gradient = "Gradient"
        case solid = "Solid"
    }
    
    var body: some View {
        VStack {
            Picker("Theme", selection: $selectedTheme) {
                ForEach(ThemeOption.allCases, id: \.self) { theme in
                    Text(theme.rawValue).tag(theme)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Chat {
                MessageMark(
                    id: UUID(),
                    role: .user("demo"),
                    time: Date()
                ) {
                    Text("Check out this theme!")
                        .padding(12)
                        .background(.ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                MessageMark(
                    id: UUID(),
                    role: .me,
                    time: Date()
                ) {
                    Text("Looks great!")
                        .padding(12)
                        .background(.ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .theme(currentTheme)
            .alignScale([.me: .trailing, .user("demo"): .leading])
        }
    }
    
    private var currentTheme: ChatTheme {
        switch selectedTheme {
        case .glass:
            return .glass(.regular)
        case .gradient:
            return ChatTheme(
                bubbleMaxWidthRatio: 0.7,
                insets: NSDirectionalEdgeInsets(
                    top: 16,
                    leading: 16,
                    bottom: 16,
                    trailing: 16
                )
            )
        case .solid:
            return ChatTheme(
                bubbleMaxWidthRatio: 0.8,
                insets: NSDirectionalEdgeInsets(
                    top: 8,
                    leading: 8,
                    bottom: 8,
                    trailing: 8
                )
            )
        }
    }
}

#Preview("Full Featured") {
    FullFeaturedChatExample()
}

#Preview("With Store") {
    ChatStoreExample()
}

#Preview("Reader Proxy") {
    ChatReaderExample()
}

#Preview("Multi Role") {
    MultiRoleExample()
}

#Preview("Custom Theme") {
    CustomThemeExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct ForEachIntegrationExample: View {
    @State private var messages: [ChatMessage<UUID>] = [
        .init(id: UUID(), role: .user("alice"), text: "Using ForEach!"),
        .init(id: UUID(), role: .me, text: "So much cleaner!"),
        .init(id: UUID(), role: .user("alice"), text: "Love the natural SwiftUI feel")
    ]
    
    var body: some View {
        Chat {
            ForEach(messages) { message in
                MessageMark(
                    id: message.id,
                    role: message.role,
                    time: message.timestamp
                ) {
                    Text(message.text)
                        .padding(12)
                        .background(.ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .accessibilityLabel("Message from \(userName(for: message.role))")
            }
        }
        .alignScale([.me: .trailing, .user("alice"): .leading])
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
struct MultiSelectExample: View {
    @State private var messages: [ChatMessage<UUID>] = [
        .init(id: UUID(), role: .user("bob"), text: "Select me!"),
        .init(id: UUID(), role: .me, text: "Or select me!"),
        .init(id: UUID(), role: .user("bob"), text: "Multi-select enabled")
    ]
    @State private var selectedMessages: Set<UUID> = []
    
    var body: some View {
        VStack {
            if !selectedMessages.isEmpty {
                HStack {
                    Text("\(selectedMessages.count) selected")
                    Spacer()
                    Button("Delete") {
                        deleteSelected()
                    }
                    Button("Clear") {
                        selectedMessages.removeAll()
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
            }
            
            Chat {
                ForEach(messages) { message in
                    MessageMark(
                        id: message.id,
                        role: message.role,
                        time: message.timestamp
                    ) {
                        HStack {
                            if selectedMessages.contains(message.id) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.blue)
                            }
                            Text(message.text)
                        }
                        .padding(12)
                        .background(.ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .tag(message.id)
                }
            }
            .chatSelection(values: $selectedMessages)
            .chatInteractions([.tap, .select])
            .alignScale([.me: .trailing, .user("bob"): .leading])
        }
    }
    
    private func deleteSelected() {
        messages.removeAll { selectedMessages.contains($0.id) }
        selectedMessages.removeAll()
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct ReactionsExample: View {
    @State private var messages: [ChatMessage<UUID>] = [
        .init(id: UUID(), role: .user("alice"), text: "I love this feature!"),
        .init(id: UUID(), role: .me, text: "Thanks! 🙌")
    ]
    
    let aliceMessageID = UUID()
    let myMessageID = UUID()
    
    var body: some View {
        Chat {
            MessageMark(
                id: aliceMessageID,
                role: .user("alice"),
                time: Date()
            ) {
                Text("I love this feature!")
                    .padding(12)
                    .background(.ultraThickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
            ReactionMark(
                for: aliceMessageID,
                reactions: [
                    (emoji: "❤️", users: ["me", "bob"]),
                    (emoji: "🔥", users: ["me"]),
                    (emoji: "👍", users: ["charlie"])
                ]
            )
            
            MessageMark(
                id: myMessageID,
                role: .me,
                time: Date()
            ) {
                Text("Thanks! 🙌")
                    .padding(12)
                    .background(.ultraThickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
            ReactionMark(
                for: myMessageID,
                reactions: [
                    (emoji: "😊", users: ["alice"])
                ]
            )
        }
        .chatInteractions([.tap, .react])
        .alignScale([.me: .trailing, .user("alice"): .leading])
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct AttachmentsExample: View {
    var body: some View {
        Chat {
            MessageMark(
                id: UUID(),
                role: .user("alice"),
                time: Date()
            ) {
                Text("Check out this photo!")
                    .padding(12)
                    .background(.ultraThickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
            AttachmentMark(
                id: UUID(),
                role: .user("alice"),
                time: Date(),
                attachmentType: .image
            ) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.blue.gradient)
                    .frame(width: 200, height: 150)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    }
            }
            
            MessageMark(
                id: UUID(),
                role: .me,
                time: Date()
            ) {
                Text("Beautiful!")
                    .padding(12)
                    .background(.ultraThickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
            AttachmentMark(
                id: UUID(),
                role: .me,
                time: Date(),
                attachmentType: .audio
            ) {
                HStack {
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                    VStack(alignment: .leading) {
                        Text("Voice Message")
                            .font(.caption)
                        Text("0:15")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(12)
                .background(.ultraThickMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .alignScale([.me: .trailing, .user("alice"): .leading])
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct EnhancedProxyExample: View {
    @State private var messages: [ChatMessage<UUID>] = []
    @State private var hoveredMessageID: UUID?
    
    var body: some View {
        ChatReader { proxy in
            ZStack(alignment: .topTrailing) {
                Chat {
                    ForEach(messages) { message in
                        MessageMark(
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
                }
                .chatGesture { proxy in
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if let id = proxy.messageID(at: value.location) {
                                hoveredMessageID = id as? UUID
                            }
                        }
                }
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text("Content: \(Int(proxy.contentSize.height))pt")
                    Text("Visible: \(proxy.visibleMessageIDs.count)")
                    
                    if let hoveredMessageID {
                        Text("Hover: \(hoveredMessageID.uuidString.prefix(8))")
                    }
                    
                    Button("Scroll to Top") {
                        proxy.scroll(to: .top, animated: true)
                    }
                    .buttonStyle(.bordered)
                }
                .font(.caption)
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding()
            }
        }
    }
}

#Preview("ForEach Integration") {
    ForEachIntegrationExample()
}

#Preview("Multi-Select") {
    MultiSelectExample()
}

#Preview("Reactions") {
    ReactionsExample()
}

#Preview("Attachments") {
    AttachmentsExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct MessageStyleExample: View {
    @State private var messages: [ChatMessage<UUID>] = [
        .init(id: UUID(), role: .user("alice"), text: "This is plain text"),
        .init(id: UUID(), role: .me, text: "This is in a bubble"),
        .init(id: UUID(), role: .user("alice"), text: "Another plain message"),
        .init(id: UUID(), role: .me, text: "Bubble with tail!")
    ]
    
    var body: some View {
        Chat {
            MessageMark(
                "This is plain text",
                id: messages[0].id,
                role: .user("alice"),
                time: messages[0].timestamp
            )
            .messageStyle(.plain)
            
            MessageMark(
                "This is in a bubble",
                id: messages[1].id,
                role: .me,
                time: messages[1].timestamp
            )
            .messageStyle(.bubble)
            
            MessageMark(
                id: messages[2].id,
                role: .user("alice"),
                time: messages[2].timestamp
            ) {
                Text("Another plain message")
                    .font(.body)
            }
            .messageStyle(.plain)
            
            MessageMark(
                id: messages[3].id,
                role: .me,
                time: messages[3].timestamp
            ) {
                Text("Bubble with tail!")
                    .padding(12)
            }
            .messageStyle(.bubble(.tail(.bottomRight)))
        }
        .alignScale([.me: .trailing, .user("alice"): .leading])
    }
}

#Preview("Enhanced Proxy") {
    EnhancedProxyExample()
}

@available(iOS 17.0, macOS 14.0, *)
struct CleanSyntaxExample: View {
    @State private var messages: [ChatMessage<UUID>] = [
        .init(id: UUID(), role: .user("alice"), text: "Super clean syntax!"),
        .init(id: UUID(), role: .me, text: "Just pass the message directly"),
        .init(id: UUID(), role: .user("alice"), text: "Love it")
    ]
    
    var body: some View {
        Chat {
            ForEach(messages) { message in
                if message.role == .me {
                    MessageMark(message)
                } else {
                    MessageMark(message)
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
    @State private var messages: [ChatMessage<UUID>] = [
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
    @State private var messages: [ChatMessage<UUID>] = [
        .init(id: UUID(), role: .user("bob"), text: "Charts-style syntax"),
        .init(id: UUID(), role: .me, text: "No ForEach needed!"),
        .init(id: UUID(), role: .user("bob"), text: "Super ergonomic")
    ]
    
    var body: some View {
        Chat(messages) { message in
            MessageMark(message, avatar: message.role == .me ? nil : .initials(background: .blue)) {
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
    @State private var messages: [ChatMessage<UUID>] = [
        .init(id: UUID(), role: .user("alice"), text: "Custom avatars!"),
        .init(id: UUID(), role: .me, text: "Using label closure")
    ]
    
    var body: some View {
        Chat(messages) { message in
            MessageMark(message) {
                Text(message.text)
            } label: {
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

#Preview("Custom Avatar") {
    CustomAvatarExample()
}

