import { useQuery } from "@tanstack/react-query";
import { getTotalClicks } from "~/apis/analytics/getTotalClicks";

export function useTotalClicks(shortenedUrlId: string) {
  const query = useQuery({
    queryKey: ["analytics/totalClicks", shortenedUrlId],
    queryFn: () => getTotalClicks(shortenedUrlId),
    staleTime: 5 * 60 * 1000,
  });

  return query;
}