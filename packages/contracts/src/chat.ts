export const CONVERSATION_CONTEXTS = [
  "propuesta_protocolo_inquiry",
  "TT_team",
  "TT_direction",
  "TT_tracking",
] as const;
export type ConversationContext = (typeof CONVERSATION_CONTEXTS)[number];

export const CONVERSATION_STATES = [
  "requested",
  "open",
  "declined",
  "read_only",
  "archived",
] as const;
export type ConversationState = (typeof CONVERSATION_STATES)[number];

export const CHAT_SOCKET_EVENTS = {
  message: "chat:message",
  messageEdited: "chat:message_edited",
  messageDeleted: "chat:message_deleted",
  notification: "chat:notification",
} as const;
export type ChatSocketEvent = (typeof CHAT_SOCKET_EVENTS)[keyof typeof CHAT_SOCKET_EVENTS];

export const SOCKET_PATH = "/api/socket.io";
