export const UNIDAD_ACADEMICA_KINDS = ["TT-I", "TT_II", "TT-R"] as const;
export type UnidadAcademicaKind = (typeof UNIDAD_ACADEMICA_KINDS)[number];
