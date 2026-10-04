export const ACCOUNT_ROLES = ["alumno", "profesor", "personal_CATT", "director_externo", "capital_humano"] as const;
export type AccountRole = (typeof ACCOUNT_ROLES)[number];

export const ACCESS_STATUSES = [
  "pending_review",
  "limited",
  "active",
  "denied",
  "disabled",
] as const;
export type AccessStatus = (typeof ACCESS_STATUSES)[number];

export const CREDENTIAL_STATES = ["pending-review", "limited", "active", "denied", "disabled"] as const;
export type CredentialState = (typeof CREDENTIAL_STATES)[number];

export const MFA_REQUIRED_ROLES = ["capital_humano", "personal_CATT"] as const satisfies readonly AccountRole[];

export const TT_ROLES = [
  "director",
  "sinodal",
  "profesor_seguimiento",
  "profesor_titular",
] as const;
export type TTRole = (typeof TT_ROLES)[number];
