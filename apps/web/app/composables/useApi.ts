export function useApi() {
  const config = useRuntimeConfig();
  const csrf = useState<string | null>("csrf-token", () => null);
  const baseURL= (import.meta.server ? `${config.apiInternalBase}/api` : config.public.apiBase) as string | undefined;
  const forwarded = import.meta.server ? useRequestHeaders(["cookie"]) : {};

  return $fetch.create({
    baseURL,
    credentials: "include",
    onRequest( { options } ) {
      const headers = new Headers(options.headers);
      for (const [k, v] of Object.entries(forwarded)) {
        if (v)
          headers.set(k, v);
      }
      const method = (options.method ?? "GET").toUpperCase();
      if (csrf.value && method !==  "GET" && method !== "HEAD")
          headers.set("X-CSRF-Token", csrf.value);
      options.headers = headers;
    },
  });
}
