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
public protocol ChatMessageProtocol<ID>: Identifiable, Hashable, Sendable where ID: Hashable & Sendable {
    associatedtype ID
    var id: ID { get }
    var role: ChatRole { get }
    var timestamp: Date { get }
    var kind: MessageKind { get }
    var state: DeliveryState { get }
}

@available(iOS 17.0, macOS 14.0, *)
public struct ChatMessage<ID: Hashable & Sendable>: ChatMessageProtocol {
    public let id: ID
    public var role: ChatRole
    public var timestamp: Date
    public var kind: MessageKind
    public var state: DeliveryState
    public var text: String
    public var metadata: [String:String]
    
    nonisolated public init(
        id: ID,
        role: ChatRole,
        timestamp: Date = .now,
        kind: MessageKind = .text,
        state: DeliveryState = .sent,
        text: String,
        metadata: [String:String] = [:]
    ) {
        self.id = id
        self.role = role
        self.timestamp = timestamp
        self.kind = kind
        self.state = state
        self.text = text
        self.metadata = metadata
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension ChatMessage: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
@Observable
public final class ChatStore<M: ChatMessageProtocol>: @unchecked Sendable {
    public var messages: [M]
    public var typingUsers: [String]
    
    public init(_ messages: [M]) {
        self.messages = messages
        self.typingUsers = []
    }
    
    @MainActor public func append(_ m: M) { }
    @MainActor public func upsert(_ m: M) { }
    @MainActor public func updateState(id: M.ID, to state: DeliveryState) { }
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
public struct AlignScale: Hashable, Sendable {
    public var map: [ChatRole: HorizontalAlignment]
    
    nonisolated public init(_ map: [ChatRole: HorizontalAlignment]) {
        self.map = map
    }
    
    public static var automatic: AlignScale {
        AlignScale([:])
    }
}

@available(iOS 17.0, macOS 14.0, *)
public struct ForegroundStyleScale: Hashable, Sendable {
    nonisolated public init(_ map: [ChatRole: any ShapeStyle]) { }
}

@available(iOS 17.0, macOS 14.0, *)
public enum BubbleShapeToken: Hashable, Sendable {
    case capsule
    case rounded(CGFloat)
    case tail(TailPosition)
    case automatic
    
    public enum TailPosition: Hashable, Sendable {
        case bottomLeft
        case bottomRight
        case none
        case automatic
    }
}

@available(iOS 17.0, macOS 14.0, *)
public struct BubbleShapeScale: Hashable, Sendable {
    public var map: [MessageKind: BubbleShapeToken]
    
    nonisolated public init(_ map: [MessageKind: BubbleShapeToken]) {
        self.map = map
    }
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
public protocol ChatSelectable: Hashable {
    init(_ messageID: AnyHashable?)
    var messageID: AnyHashable? { get }
}

@available(iOS 17.0, macOS 14.0, *)
public struct ChatSelection<SelectionValue: Hashable>: ChatSelectable {
    public var value: SelectionValue? {
        fatalError()
    }
    
    public var messageID: AnyHashable? {
        fatalError()
    }
    
    nonisolated public init(_ value: SelectionValue) { }
    nonisolated public init(_ messageID: AnyHashable?) { }
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
public enum ChatAutoscroll: Sendable, Equatable {
    case always(anchor: UnitPoint = .bottom, animated: Bool = true)
    case never
    case whenAtBottom(anchor: UnitPoint = .bottom, animated: Bool = true)
}

@available(iOS 17.0, macOS 14.0, *)
public struct ChatInteractionModes: OptionSet, Sendable {
    public let rawValue: Int
    
    nonisolated public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let tap = ChatInteractionModes(rawValue: 1 << 0)
    public static let longPress = ChatInteractionModes(rawValue: 1 << 1)
    public static let dragToReply = ChatInteractionModes(rawValue: 1 << 2)
    public static let copy = ChatInteractionModes(rawValue: 1 << 3)
    public static let edit = ChatInteractionModes(rawValue: 1 << 4)
    public static let delete = ChatInteractionModes(rawValue: 1 << 5)
    public static let react = ChatInteractionModes(rawValue: 1 << 6)
    public static let forward = ChatInteractionModes(rawValue: 1 << 7)
    public static let select = ChatInteractionModes(rawValue: 1 << 8)
    
    public static let all: ChatInteractionModes = [.tap, .longPress, .dragToReply, .copy, .edit, .delete, .react, .forward, .select]
}

@available(iOS 17.0, macOS 14.0, *)
public enum ChatGrouping: Sendable, Equatable {
    case none
    case byDay
}

@available(iOS 17.0, macOS 14.0, *)
public struct ChatTheme: Hashable, Sendable {
    public var bubbleMaxWidthRatio: CGFloat
    public var insets: NSDirectionalEdgeInsets
    
    nonisolated public init(bubbleMaxWidthRatio: CGFloat, insets: NSDirectionalEdgeInsets) {
        self.bubbleMaxWidthRatio = bubbleMaxWidthRatio
        self.insets = insets
    }
    
    public static func glass(_ glass: UniversalGlass) -> ChatTheme {
        ChatTheme(bubbleMaxWidthRatio: 0.75, insets: .init(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

@available(iOS 17.0, macOS 14.0, *)
public enum UniversalGlass {
    case regular
    case clear
    case identity
}

@available(iOS 17.0, macOS 14.0, *)
extension EnvironmentValues {
    public var chatAlignScale: AlignScale {
        get { .automatic }
        set { }
    }
    
    public var chatForegroundStyleScale: ForegroundStyleScale {
        get { fatalError() }
        set { }
    }
    
    public var chatBubbleShapeScale: BubbleShapeScale {
        get { fatalError() }
        set { }
    }
    
    public var chatAutoscroll: ChatAutoscroll {
        get { fatalError() }
        set { }
    }
    
    public var chatInteractions: ChatInteractionModes {
        get { fatalError() }
        set { }
    }
    
    public var chatGrouping: ChatGrouping {
        get { fatalError() }
        set { }
    }
    
    public var chatMessageSpacing: CGFloat {
        get { fatalError() }
        set { }
    }
    
    public var chatReadReceipts: Bool {
        get { fatalError() }
        set { }
    }
    
    public var chatTheme: ChatTheme {
        get { fatalError() }
        set { }
    }
    
    public var messageStyle: AnyMessageStyle {
        get { AnyMessageStyle(BubbleMessageStyle()) }
        set { }
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension View {
    nonisolated public func alignScale(_ mapping: [ChatRole: HorizontalAlignment]) -> some View {
        self
    }
    
    nonisolated public func chatForegroundStyleScale<S>(_ mapping: [ChatRole: S]) -> some View where S: ShapeStyle {
        self
    }
    
    nonisolated public func bubbleShapeScale(_ mapping: [MessageKind: BubbleShapeToken]) -> some View {
        self
    }
    
    nonisolated public func autoscroll(_ behavior: ChatAutoscroll) -> some View {
        self
    }
    
    nonisolated public func chatInteractions(_ modes: ChatInteractionModes) -> some View {
        self
    }
    
    nonisolated public func grouping(_ strategy: ChatGrouping) -> some View {
        self
    }
    
    nonisolated public func messageSpacing(_ spacing: CGFloat) -> some View {
        self
    }
    
    nonisolated public func readReceipts(_ enabled: Bool) -> some View {
        self
    }
    
    nonisolated public func theme(_ theme: ChatTheme) -> some View {
        self
    }
    
    nonisolated public func header<Header: View>(@ViewBuilder _ header: () -> Header) -> some View {
        self
    }
    
    nonisolated public func composer<Composer: View>(@ViewBuilder _ composer: () -> Composer) -> some View {
        self
    }
    
    nonisolated public func keyboardAccessory<Accessory: View>(@ViewBuilder _ accessory: () -> Accessory) -> some View {
        self
    }
    
    nonisolated public func chatBackground<BG: View>(@ViewBuilder _ background: () -> BG) -> some View {
        self
    }
    
    nonisolated public func chatControls<Controls: View>(@ViewBuilder _ controls: () -> Controls) -> some View {
        self
    }
    
    nonisolated public func scrollPosition(_ position: Binding<ChatPosition>) -> some View {
        self
    }
    
    nonisolated public func chatSelection<V>(value: Binding<V?>) -> some View where V: Hashable {
        self
    }
    
    nonisolated public func chatSelection<V>(values: Binding<Set<V>>) -> some View where V: Hashable {
        self
    }
    
    nonisolated public func chatGesture(_ gesture: @escaping (ChatProxy) -> some Gesture) -> some View {
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
public struct Chat<Selection: ChatSelectable, Content: ChatContent>: View {
    nonisolated public init(@ChatContentBuilder _ content: () -> Content) where Selection == ChatSelection<Never> { }
    
    nonisolated public init(position: Binding<ChatPosition>, @ChatContentBuilder _ content: () -> Content) where Selection == ChatSelection<Never> { }
    
    nonisolated public init<S>(selection: Binding<S?>, @ChatContentBuilder _ content: () -> Content) where Selection == ChatSelection<S>, S: Hashable { }
    
    nonisolated public init<S>(position: Binding<ChatPosition>, selection: Binding<S?>, @ChatContentBuilder _ content: () -> Content) where Selection == ChatSelection<S>, S: Hashable { }
    
    @MainActor @preconcurrency public var body: some View {
        EmptyView()
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension Chat: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
extension Chat where Selection == ChatSelection<Never> {
    nonisolated public init<Data: RandomAccessCollection>(
        _ data: Data,
        @ChatContentBuilder content: @escaping (Data.Element) -> some ChatContent
    ) { }
    
    nonisolated public init<M: ChatMessageProtocol>(
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
    
    nonisolated public init<M: ChatMessageProtocol>(_ messages: [M]) { }
    
    nonisolated public init<M: ChatMessageProtocol>(_ messages: some RandomAccessCollection<M>) { }
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct MessageMark<Label, Content>: ChatContent where Label: View, Content: View {
    nonisolated public init(id: AnyHashable, role: ChatRole, time: Date, state: DeliveryState = .sent, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) { }
    
    nonisolated public init(id: AnyHashable, role: ChatRole, time: Date, state: DeliveryState = .sent, @ViewBuilder content: () -> Content) where Label == EmptyView { }
    
    public typealias Body = Never
}

@available(iOS 17.0, macOS 14.0, *)
extension MessageMark where Content == Text, Label == EmptyView {
    nonisolated public init(_ titleKey: LocalizedStringKey, id: AnyHashable, role: ChatRole, time: Date, state: DeliveryState = .sent) { }
    
    nonisolated public init<S>(_ title: S, id: AnyHashable, role: ChatRole, time: Date, state: DeliveryState = .sent) where S: StringProtocol { }
}

@available(iOS 17.0, macOS 14.0, *)
extension MessageMark where Label == EmptyView {
    nonisolated public init<M>(_ message: M, @ViewBuilder content: () -> Content) where M: ChatMessageProtocol { }
}

@available(iOS 17.0, macOS 14.0, *)
extension MessageMark where Content == Text, Label == EmptyView {
    nonisolated public init<M>(_ message: M) where M: ChatMessageProtocol { }
}

@available(iOS 17.0, macOS 14.0, *)
extension MessageMark {
    nonisolated public init<M>(_ message: M, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) where M: ChatMessageProtocol { }
}

@available(iOS 17.0, macOS 14.0, *)
extension MessageMark where Label == AvatarView {
    nonisolated public init<M>(_ message: M, avatar: Avatar?, @ViewBuilder content: () -> Content) where M: ChatMessageProtocol { }
}

@available(iOS 17.0, macOS 14.0, *)
extension MessageMark where Content == Text, Label == AvatarView {
    nonisolated public init<M>(_ message: M, avatar: Avatar?) where M: ChatMessageProtocol { }
}

@available(iOS 17.0, macOS 14.0, *)
extension MessageMark: Sendable {
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
public struct TypingMark: ChatContent {
    nonisolated public init(users: [String]) { }
    public typealias Body = Never
}

@available(iOS 17.0, macOS 14.0, *)
extension TypingMark: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct DividerMark: ChatContent {
    nonisolated public init(date: Date) { }
    public typealias Body = Never
}

@available(iOS 17.0, macOS 14.0, *)
extension DividerMark: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct EventMark<Content>: ChatContent where Content: View {
    nonisolated public init(time: Date, @ViewBuilder content: () -> Content) { }
    public typealias Body = Never
}

@available(iOS 17.0, macOS 14.0, *)
extension EventMark: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct ReceiptMark: ChatContent {
    public enum Position {
        case leading
        case trailing
        case overlay
    }
    
    nonisolated public init(for messageID: AnyHashable, position: Position = .trailing, state: DeliveryState) { }
    public typealias Body = Never
}

@available(iOS 17.0, macOS 14.0, *)
extension ReceiptMark: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct ReactionMark: ChatContent {
    nonisolated public init(for messageID: AnyHashable, reactions: [(emoji: String, users: [String])]) { }
    public typealias Body = Never
}

@available(iOS 17.0, macOS 14.0, *)
extension ReactionMark: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
public enum AttachmentType: Hashable, Sendable {
    case image
    case video
    case audio
    case document
    case location
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor @preconcurrency
public struct AttachmentMark<Content>: ChatContent where Content: View {
    nonisolated public init(
        id: AnyHashable,
        role: ChatRole,
        time: Date,
        attachmentType: AttachmentType,
        @ViewBuilder content: () -> Content
    ) { }
    public typealias Body = Never
}

@available(iOS 17.0, macOS 14.0, *)
extension AttachmentMark: Sendable {
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
@MainActor
public struct ChatHeader: View {
    public let title: String
    public let avatar: Image?
    public let avatarURL: URL?
    public let action: (() -> Void)?
    
    nonisolated public init(title: String, avatar: Image? = nil, avatarURL: URL? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.avatar = avatar
        self.avatarURL = avatarURL
        self.action = action
    }
    
    @MainActor public var body: some View {
        EmptyView()
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension ChatHeader: Sendable {
}

@available(iOS 17.0, macOS 14.0, *)
@MainActor
public struct InputBar: View {
    @Binding public var text: String
    public let placeholder: String
    public let onSend: () -> Void
    
    nonisolated public init(text: Binding<String>, placeholder: String = "Message", onSend: @escaping () -> Void) {
        self._text = text
        self.placeholder = placeholder
        self.onSend = onSend
    }
    
    @MainActor public var body: some View {
        EmptyView()
    }
}

@available(iOS 17.0, macOS 14.0, *)
extension InputBar: Sendable {
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

