# UnionChat

A modern SwiftUI chat framework with automatic media handling, reactions, threading, and rich interactions.

## Features

**🎯 Simple & Powerful**
```swift
Chat(messages)
    .onChatSend { text, media in
        messages.append(MyMessage(role: .me, text: text, media: media))
    }
```

**📸 Automatic Media Support**
```swift
struct MyMessage: ChatMessage {
    var media: MessageMedia?  // .image, .video, .audio, .file, .location, .poll
}

Chat(messages)  // Framework automatically displays images, videos, etc.
```

**💬 Rich Interactions**
```swift
Chat(messages)
    .chatInteractions([.reply, .react, .edit, .delete])
    .onReaction { messageID, emoji, action in
        // User added/removed reaction
    }
    .onReply { messageID in
        // User tapped reply
    }
```

**🎨 Smart Defaults**
- Automatic message alignment (me → right, others → left)
- Gradient bubbles using app tint color (iMessage-style)
- Reactions display automatically from message data
- Threading with reply indicators

**⚡️ Automatic Input Bar**
```swift
Chat(messages)
    .chatInputPlaceholder("Message...")
    .chatInputCapabilities([.camera, .photoLibrary, .location])
    .onChatSend { text, media in
        // Framework handles photo picker, camera, location picker
        // You just get the results!
    }
```

## Quick Example

```swift
struct MyMessage: ChatMessage {
    let id: UUID
    var role: ChatRole
    var timestamp: Date
    var text: String?
    var media: MessageMedia?
    var reactions: [MessageReaction] = []
}

struct ChatView: View {
    @State private var messages: [MyMessage] = []
    
    var body: some View {
        Chat(messages)
            .chatInputCapabilities([.camera, .photoLibrary])
            .chatInteractions([.reply, .react])
            .onChatSend { text, media in
                messages.append(MyMessage(
                    id: UUID(),
                    role: .me,
                    timestamp: .now,
                    text: text,
                    media: media
                ))
            }
            .onReaction { messageID, emoji, action in
                // Handle reactions
            }
    }
}
```

## Protocol-Based Design

Define your own message types - the framework adapts:

```swift
protocol ChatMessage: Identifiable, Hashable, Sendable {
    var id: ID { get }
    var role: ChatRole { get }
    var timestamp: Date { get }
}
```

Optional properties with defaults:
- `reactions: [MessageReaction]`
- `replyToMessageID: AnyHashable?`
- `kind: MessageKind`
- `state: DeliveryState`

## Building

```bash
swift build
```

## Requirements

- iOS 17.0+ / macOS 14.0+
- Swift 5.9+
