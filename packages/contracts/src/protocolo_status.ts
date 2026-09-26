export const PROTOCOLO_STATUSES = [
  "enviado",
  "aprobado_requisitos",
  "sinodales_asignados",
  "ronda_1_aprovado",
  "ronda_1_rechazado",
  "dictamen_emitido",
  "ronda_2_enviado",
  "ronda_2_aprovado",
  "ronda_2_rechazado"
] as const;
export type ProtocoloStatus = (typeof PROTOCOLO_STATUSES)[number];

export type ProtocoloRonda = 1 | 2;
