export const ACCOUNT_ROLES = ["alumno", "profesor", "admin_CATT", "director_externo"] as const;
export type AccountRole = (typeof ACCOUNT_ROLES)[number];

export const ACCOUNT_STATUSES = [
  "pending_review",
  "limited",
  "active",
  "denied",
  "disabled",
] as const;
export type AccountStatus = (typeof ACCOUNT_STATUSES)[number];

export const TT_ROLES = [
  "director",
  "sinodal",
  "profesor_seguimiento",
  "profesor_titular",
] as const;
export type TTRole = (typeof TT_ROLES)[number];
