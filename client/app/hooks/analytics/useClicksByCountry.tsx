import { useQuery } from "@tanstack/react-query";
import { getClicksByCountry } from "~/apis/analytics/getClicksByCountry";

export function useClicksByCountry(shortenedUrlId: string) {
  const query = useQuery({
    queryKey: ["analytics/clicksByCountry", shortenedUrlId],
    queryFn: () => getClicksByCountry(shortenedUrlId),
    staleTime: 5 * 60 * 1000,
  });

  return query;
}