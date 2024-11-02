import { useQuery } from "@tanstack/react-query";
import { getClicks } from "~/apis/analytics/getClicks";

export function useClicks(shortenedUrlId: string, page: number) {
  const query = useQuery({
    queryKey: ["analytics/clicks", shortenedUrlId, page],
    queryFn: () => getClicks(shortenedUrlId, page),
    staleTime: 5 * 60 * 1000,
  });

  return query;
}
