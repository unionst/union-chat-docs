import SwiftUI
import Foundation

@available(iOS 17.0, macOS 14.0, *)
public enum ChatRole: Hashable, Sendable {
    case me
    case system
    case user(String)
}

@available(iOS 17.0, macOS 14.0, *)
public enum MessageKind: Hashable, Sendable {
    case text
    case event
    case typing
}

@available(iOS 17.0, macOS 14.0, *)
public enum DeliveryState: Hashable, Sendable {
    case composing
    case sending
    case sent
    case delivered
    case read
    case failed
}

@available(iOS 17.0, macOS 14.0, *)
public enum MessageMedia: Hashable, Sendable {
    case image(url: URL)
    case video(url: URL, thumbnailURL: URL? = nil, duration: TimeInterval? = nil)
    case audio(url: URL, duration: TimeInterval? = nil, waveform: [Float]? = nil)
    case file(url: URL, name: String, size: Int64? = nil, mimeType: String? = nil)
    case location(latitude: Double, longitude: Double, name: String? = nil)
    case poll(question: String, options: [String], votes: [Int]? = nil)
}

@available(iOS 17.0, macOS 14.0, *)
public struct MessageReaction: Hashable, Sendable {
    public let emoji: String
    public let userIDs: Set<AnyHashable>
    public let includesMe: Bool
    
    public var count: Int { userIDs.count }
    
    nonisolated public init(emoji: String, userIDs: Set<AnyHashable>, includesMe: Bool = false) {
        self.emoji = emoji
        self.userIDs = userIDs
        self.includesMe = includesMe
    }
}

@available(iOS 17.0, macOS 14.0, *)
public enum ReactionAction: Sendable {
    case adding
    case removing
}

@available(iOS 17.0, macOS 14.0, *)
public struct ChatInputCapability: OptionSet, Sendable {
    public let rawValue: Int
    
    nonisolated public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let camera = ChatInputCapability(rawValue: 1 << 0)
    public static let photoLibrary = ChatInputCapability(rawValue: 1 << 1)
    public static let recordAudio = ChatInputCapability(rawValue: 1 << 2)
    public static let files = ChatInputCapability(rawValue: 1 << 3)
    public static let location = ChatInputCapability(rawValue: 1 << 4)
    public static let polls = ChatInputCapability(rawValue: 1 << 5)
    
    public static let all: ChatInputCapability = [.camera, .photoLibrary, .recordAudio, .files, .location, .polls]
}

@available(iOS 17.0, macOS 14.0, *)
public protocol ChatMessage<ID>: Identifiable, Hashable, Sendable where ID: Hashable & Sendable {
    associatedtype ID
    var id: ID { get }
    var role: ChatRole { get }
    var timestamp: Date { get }
}

@available(iOS 17.0, macOS 14.0, *)
extension ChatMessage {
    public var kind: MessageKind { .text }
    public var state: DeliveryState { .sent }
    public var reactions: [MessageReaction] { [] }
    public var replyToMessageID: AnyHashable? { nil }
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public protocol ChatContent: View {
    associatedtype Body: ChatContent
    @ChatContentBuilder @MainActor @preconcurrency var body: Body { get }
}

@available(iOS 17.0, macOS 14.0, *)
extension Never: ChatContent {
    @MainActor @preconcurrency public var body: Never {
        fatalError()
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension Optional: ChatContent where Wrapped: ChatContent {
    @MainActor @preconcurrency public var body: Never {
        fatalError()
    }
}

@available(iOS 17.0, macOS 14.0, *)
@frozen public struct BuilderConditional<TrueContent, FalseContent> {
}

@available(iOS 17.0, macOS 14.0, *)
extension BuilderConditional: ChatContent where TrueContent: ChatContent, FalseContent: ChatContent {
    @MainActor @preconcurrency public var body: Never {
        fatalError()
    }
}

@available(iOS 17.0, macOS 14.0, *)
@resultBuilder
public enum ChatContentBuilder {
    public static func buildBlock() -> EmptyChatContent {
        EmptyChatContent()
    }
    
    public static func buildBlock<C: ChatContent>(_ c: C) -> C {
        c
    }
    
    public static func buildOptional<C: ChatContent>(_ c: C?) -> some ChatContent {
        EmptyChatContent()
    }
    
    public static func buildEither<True: ChatContent, False: ChatContent>(first: True) -> BuilderConditional<True, False> {
        fatalError()
    }
    
    public static func buildEither<True: ChatContent, False: ChatContent>(second: False) -> BuilderConditional<True, False> {
        fatalError()
    }
    
    public static func buildArray<C: ChatContent>(_ components: [C]) -> TupleView<[C]> {
        fatalError()
    }
    
    public static func buildLimitedAvailability<Content>(_ content: Content) -> AnyChatContent where Content: ChatContent {
        AnyChatContent(content)
    }
    
    public static func buildExpression<Content>(_ content: Content) -> Content where Content: ChatContent {
        content
    }
}

@available(iOS 17.0, macOS 14.0, *)
public struct EmptyChatContent: ChatContent {
    nonisolated public init() { }
    public typealias Body = Never
}

@available(iOS 17.0, macOS 14.0, *)
extension EmptyChatContent: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct AnyChatContent: ChatContent {
    nonisolated public init<C>(_ base: C) where C: ChatContent { }
    public typealias Body = Never
}

@available(iOS 17.0, macOS 14.0, *)
extension AnyChatContent: Sendable {
}



@available(iOS 17.0, macOS 14.0, *)
public struct ChatStyle: Hashable, Sendable {
    public static var bubble: ChatStyle { ChatStyle() }
    public static var plain: ChatStyle { ChatStyle() }
}

@available(iOS 17.0, macOS 14.0, *)
public struct ChatBubbleShape: Shape {
    public enum TailPosition: Sendable {
        case bottomLeft
        case bottomRight
        case none
    }
    
    nonisolated public init(tailPosition: ChatBubbleShape.TailPosition) { }
    
    nonisolated public func path(in rect: CGRect) -> Path {
        Path()
    }
}


@available(iOS 17.0, macOS 14.0, *)
public struct ChatPosition: Equatable, Sendable {
    public static var automatic: ChatPosition {
        ChatPosition()
    }
    
    public static var top: ChatPosition {
        ChatPosition()
    }
    
    public static func message(_ id: AnyHashable, anchor: UnitPoint = .bottom) -> ChatPosition {
        ChatPosition()
    }
    
    public static func bottom(animated: Bool = true) -> ChatPosition {
        ChatPosition()
    }
    
    public static func offset(_ offset: CGFloat, from position: ChatPosition) -> ChatPosition {
        ChatPosition()
    }
    
    public static func index(_ index: Int) -> ChatPosition {
        ChatPosition()
    }
}

@available(iOS 17.0, macOS 14.0, *)
public struct ChatAutoscroll: Sendable, Equatable {
    public static var always: ChatAutoscroll { ChatAutoscroll() }
    public static var never: ChatAutoscroll { ChatAutoscroll() }
    public static var whenAtBottom: ChatAutoscroll { ChatAutoscroll() }
    
    public static func always(anchor: UnitPoint, animated: Bool = true) -> ChatAutoscroll { ChatAutoscroll() }
    public static func whenAtBottom(anchor: UnitPoint, animated: Bool = true) -> ChatAutoscroll { ChatAutoscroll() }
}

@available(iOS 17.0, macOS 14.0, *)
public struct ChatInteractionModes: OptionSet, Sendable {
    public let rawValue: Int
    
    nonisolated public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let reply = ChatInteractionModes(rawValue: 1 << 0)
    public static let edit = ChatInteractionModes(rawValue: 1 << 1)
    public static let delete = ChatInteractionModes(rawValue: 1 << 2)
    public static let react = ChatInteractionModes(rawValue: 1 << 3)
    public static let forward = ChatInteractionModes(rawValue: 1 << 4)
    
    public static let all: ChatInteractionModes = [.reply, .edit, .delete, .react, .forward]
}



@available(iOS 17.0, macOS 14.0, *)
extension EnvironmentValues {
    public var chatAutoscroll: ChatAutoscroll {
        get { fatalError() }
        set { }
    }
    
    public var chatInteractions: ChatInteractionModes {
        get { fatalError() }
        set { }
    }
    
    public var chatMessageSpacing: CGFloat {
        get { fatalError() }
        set { }
    }
    
    public var messageStyle: AnyMessageStyle {
        get { AnyMessageStyle(BubbleMessageStyle()) }
        set { }
    }
    
    public var avatarVisibility: Visibility {
        get { .automatic }
        set { }
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension View {
    nonisolated public func chatInputPlaceholder(_ placeholder: String) -> some View {
        self
    }
    
    nonisolated public func chatInputCapabilities(_ capabilities: ChatInputCapability) -> some View {
        self
    }
    
    nonisolated public func onChatSend(perform action: @escaping (_ text: String?, _ media: MessageMedia?) async -> Void) -> some View {
        self
    }
    
    nonisolated public func onReaction(perform action: @escaping (_ messageID: AnyHashable, _ emoji: String, _ action: ReactionAction) async -> Void) -> some View {
        self
    }
    
    nonisolated public func onReply(perform action: @escaping (_ messageID: AnyHashable) async -> Void) -> some View {
        self
    }
    
    nonisolated public func onEdit(perform action: @escaping (_ messageID: AnyHashable, _ newText: String) async -> Void) -> some View {
        self
    }
    
    nonisolated public func onDelete(perform action: @escaping (_ messageID: AnyHashable) async -> Void) -> some View {
        self
    }
    
    nonisolated public func onForward(perform action: @escaping (_ messageID: AnyHashable) async -> Void) -> some View {
        self
    }
    
    nonisolated public func chatInputVisibility(_ visibility: Visibility) -> some View {
        self
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension View {
    nonisolated public func chatStyle(_ style: ChatStyle) -> some View {
        self
    }
    
    nonisolated public func chatMessageStyle<S>(_ style: S, for role: ChatRole) -> some View where S: ShapeStyle {
        self
    }
    
    nonisolated public func chatAutoscroll(_ behavior: ChatAutoscroll) -> some View {
        self
    }
    
    nonisolated public func chatInteractions(_ modes: ChatInteractionModes) -> some View {
        self
    }
    
    nonisolated public func chatMessageSpacing(_ spacing: CGFloat) -> some View {
        self
    }
    
    nonisolated public func chatBackground<BG: View>(@ViewBuilder _ background: () -> BG) -> some View {
        self
    }
    
    nonisolated public func chatControls<Controls: View>(@ViewBuilder _ controls: () -> Controls) -> some View {
        self
    }
    
    nonisolated public func chatGesture(_ gesture: @escaping (ChatProxy) -> some Gesture) -> some View {
        self
    }
    
    nonisolated public func chatAvatarVisibility(_ visibility: Visibility) -> some View {
        self
    }
    
    nonisolated public func onChatEdge(_ edge: Edge = .top, perform action: @escaping () async -> Void) -> some View {
        self
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension ChatContent {
    nonisolated public func tag<V: Hashable>(_ tag: V) -> some ChatContent {
        EmptyChatContent()
    }
    
    nonisolated public func foregroundStyle(_ style: some ShapeStyle) -> some ChatContent {
        EmptyChatContent()
    }
    
    nonisolated public func messageStyle(_ style: some MessageStyle) -> some ChatContent {
        EmptyChatContent()
    }
    
    nonisolated public func accessibilityLabel(_ label: Text) -> some ChatContent {
        EmptyChatContent()
    }
    
    nonisolated public func accessibilityLabel(_ labelKey: LocalizedStringKey) -> some ChatContent {
        EmptyChatContent()
    }
    
    nonisolated public func accessibilityLabel<S>(_ label: S) -> some ChatContent where S: StringProtocol {
        EmptyChatContent()
    }
    
    nonisolated public func accessibilityValue(_ value: Text) -> some ChatContent {
        EmptyChatContent()
    }
    
    nonisolated public func accessibilityValue(_ valueKey: LocalizedStringKey) -> some ChatContent {
        EmptyChatContent()
    }
    
    nonisolated public func accessibilityValue<S>(_ value: S) -> some ChatContent where S: StringProtocol {
        EmptyChatContent()
    }
    
    nonisolated public func accessibilityHidden(_ hidden: Bool) -> some ChatContent {
        EmptyChatContent()
    }
    
    nonisolated public func accessibilityIdentifier(_ identifier: String) -> some ChatContent {
        EmptyChatContent()
    }
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct Chat<Content: ChatContent>: View {
    nonisolated public init(@ChatContentBuilder _ content: () -> Content) { }
    
    @MainActor @preconcurrency public var body: some View {
        EmptyView()
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension Chat: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
extension Chat {
    nonisolated public init<Data: RandomAccessCollection>(
        _ data: Data,
        @ChatContentBuilder content: @escaping (Data.Element) -> some ChatContent
    ) { }
    
    nonisolated public init<M: ChatMessage>(
        _ data: some RandomAccessCollection<M>,
        @ChatContentBuilder content: @escaping (M) -> some ChatContent
    ) { }
    
    nonisolated public init<Data: RandomAccessCollection>(
        _ data: Data,
        id: KeyPath<Data.Element, some Hashable>,
        role: KeyPath<Data.Element, ChatRole>,
        time: KeyPath<Data.Element, Date>,
        kind: KeyPath<Data.Element, MessageKind>,
        state: KeyPath<Data.Element, DeliveryState>,
        @ChatContentBuilder content: @escaping (Data.Element) -> some ChatContent
    ) { }
    
    nonisolated public init<M: ChatMessage>(_ messages: [M]) { }
    
    nonisolated public init<M: ChatMessage>(_ messages: some RandomAccessCollection<M>) { }
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct Message<Label, Content>: ChatContent where Label: View, Content: View {
    nonisolated public init(id: AnyHashable, role: ChatRole, time: Date, state: DeliveryState = .sent, @ViewBuilder content: () -> Content, @ViewBuilder avatar: () -> Label) { }
    
    nonisolated public init(id: AnyHashable, role: ChatRole, time: Date, state: DeliveryState = .sent, @ViewBuilder content: () -> Content) where Label == EmptyView { }
    
    public typealias Body = Never
}

@available(iOS 17.0, macOS 14.0, *)
extension Message where Content == Text, Label == EmptyView {
    nonisolated public init(_ titleKey: LocalizedStringKey, id: AnyHashable, role: ChatRole, time: Date, state: DeliveryState = .sent) { }
    
    nonisolated public init<S>(_ title: S, id: AnyHashable, role: ChatRole, time: Date, state: DeliveryState = .sent) where S: StringProtocol { }
}

@available(iOS 17.0, macOS 14.0, *)
extension Message where Label == EmptyView {
    nonisolated public init<M>(_ message: M, @ViewBuilder content: () -> Content) where M: ChatMessage { }
}

@available(iOS 17.0, macOS 14.0, *)
extension Message where Label == EmptyView {
    nonisolated public init<M>(_ message: M) where M: ChatMessage, Content == _AutomaticMessageContent { }
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct _AutomaticMessageContent: View {
    @MainActor @preconcurrency public var body: some View { EmptyView() }
}

@available(iOS 17.0, macOS 14.0, *)
extension Message {
    nonisolated public init<M>(_ message: M, @ViewBuilder content: () -> Content, @ViewBuilder avatar: () -> Label) where M: ChatMessage { }
}

@available(iOS 17.0, macOS 14.0, *)
extension Message where Label == AvatarView {
    nonisolated public init<M>(_ message: M, avatar: Avatar?, @ViewBuilder content: () -> Content) where M: ChatMessage { }
}

@available(iOS 17.0, macOS 14.0, *)
extension Message where Content == Text, Label == AvatarView {
    nonisolated public init<M>(_ message: M, avatar: Avatar?) where M: ChatMessage { }
}

@available(iOS 17.0, macOS 14.0, *)
extension Message: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
public protocol MessageStyle {
    associatedtype Body: View
    @ViewBuilder func makeBody(configuration: MessageStyleConfiguration) -> Body
}

@available(iOS 17.0, macOS 14.0, *)
public struct MessageStyleConfiguration {
    public let content: AnyView
    public let role: ChatRole
    public let timestamp: Date
    public let state: DeliveryState
}

@available(iOS 17.0, macOS 14.0, *)
public struct BubbleMessageStyle: MessageStyle {
    public let shape: BubbleShapeToken
    
    nonisolated public init(shape: BubbleShapeToken = .automatic) {
        self.shape = shape
    }
    
    public func makeBody(configuration: MessageStyleConfiguration) -> some View {
        EmptyView()
    }
}

@available(iOS 17.0, macOS 14.0, *)
public struct PlainMessageStyle: MessageStyle {
    nonisolated public init() { }
    
    public func makeBody(configuration: MessageStyleConfiguration) -> some View {
        EmptyView()
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension MessageStyle where Self == BubbleMessageStyle {
    public static var bubble: BubbleMessageStyle {
        BubbleMessageStyle()
    }
    
    public static func bubble(_ shape: BubbleShapeToken) -> BubbleMessageStyle {
        BubbleMessageStyle(shape: shape)
    }
    
    public static func bubble(cornerRadius: CGFloat) -> BubbleMessageStyle {
        BubbleMessageStyle(shape: .rounded(cornerRadius))
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension MessageStyle where Self == PlainMessageStyle {
    public static var plain: PlainMessageStyle {
        PlainMessageStyle()
    }
}

@available(iOS 17.0, macOS 14.0, *)
public struct AnyMessageStyle: MessageStyle {
    nonisolated public init<S>(_ style: S) where S: MessageStyle { }
    
    public func makeBody(configuration: MessageStyleConfiguration) -> some View {
        EmptyView()
    }
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct Typing: ChatContent {
    nonisolated public init(users: [String]) { }
    public typealias Body = Never
}

@available(iOS 17.0, macOS 14.0, *)
extension Typing: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct Loading: ChatContent {
    nonisolated public init() { }
    public typealias Body = Never
}

@available(iOS 17.0, macOS 14.0, *)
extension Loading: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct Divider: ChatContent {
    nonisolated public init(date: Date) { }
    public typealias Body = Never
}

@available(iOS 17.0, macOS 14.0, *)
extension Divider: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct Event<Content>: ChatContent where Content: View {
    nonisolated public init(time: Date, @ViewBuilder content: () -> Content) { }
    public typealias Body = Never
}

@available(iOS 17.0, macOS 14.0, *)
extension Event where Content == Text {
    nonisolated public init(_ titleKey: LocalizedStringKey, time: Date) { }
    nonisolated public init(_ titleResource: LocalizedStringResource, time: Date) { }
    nonisolated public init<S>(_ title: S, time: Date) where S: StringProtocol { }
}

@available(iOS 17.0, macOS 14.0, *)
extension Event: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct Label<Content>: ChatContent where Content: View {
    nonisolated public init(@ViewBuilder content: () -> Content) { }
    public typealias Body = Never
}

@available(iOS 17.0, macOS 14.0, *)
extension Label: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
public struct ChatProxy {
    public func rect(for messageID: AnyHashable) -> CGRect? {
        nil
    }
    
    public func scroll(to position: ChatPosition, animated: Bool) { }
    
    public var lastVisibleMessageID: AnyHashable? {
        nil
    }
    
    public func position(for messageID: AnyHashable) -> CGPoint? {
        nil
    }
    
    public func messageID(at position: CGPoint) -> AnyHashable? {
        nil
    }
    
    public var visibleMessageIDs: [AnyHashable] {
        []
    }
    
    public var contentSize: CGSize {
        .zero
    }
    
    public var chatFrame: Anchor<CGRect>? {
        nil
    }
    
    public var contentFrame: Anchor<CGRect>? {
        nil
    }
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct ChatReader<Content>: View where Content: View {
    nonisolated public init(@ViewBuilder _ content: @escaping (ChatProxy) -> Content) { }
    
    @MainActor @preconcurrency public var body: some View {
        EmptyView()
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension ChatReader: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor
public struct ScrollToBottomButton: View {
    nonisolated public init() { }
    
    @MainActor public var body: some View {
        EmptyView()
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension ScrollToBottomButton: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor
public struct TypingIndicatorDots: View {
    nonisolated public init(users: [String]) { }
    
    @MainActor public var body: some View {
        EmptyView()
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension TypingIndicatorDots: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
public struct Avatar: Hashable, Sendable {
    nonisolated public static func initials(_ text: String? = nil, background: Color? = nil) -> Avatar {
        Avatar()
    }
    
    nonisolated public static func image(_ image: Image) -> Avatar {
        Avatar()
    }
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor
public struct AvatarView: View {
    nonisolated public init(for role: ChatRole, size: CGFloat = 32) { }
    
    nonisolated public init(initials: String, background: Color? = nil, size: CGFloat = 32) { }
    
    nonisolated public init(image: Image, size: CGFloat = 32) { }
    
    @MainActor public var body: some View {
        EmptyView()
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension AvatarView: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
extension ForEach: ChatContent where Content: ChatContent {
    @MainActor @preconcurrency public var body: Never {
        fatalError()
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension ForEach where ID == Data.Element.ID, Content: ChatContent, Data.Element: Identifiable {
    nonisolated public init(_ data: Data, @ChatContentBuilder content: @escaping (Data.Element) -> Content) {
        fatalError()
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension ForEach where Content: ChatContent {
    nonisolated public init(_ data: Data, id: KeyPath<Data.Element, ID>, @ChatContentBuilder content: @escaping (Data.Element) -> Content) {
        fatalError()
    }
}

