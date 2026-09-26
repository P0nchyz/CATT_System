export const PROPUESTA_PROTOCOLO_STATUSES = ["draft", "published", "closed", "converted"] as const;
export type PropuestaProtocoloStatus = (typeof PROPUESTA_PROTOCOLO_STATUSES)[number];
