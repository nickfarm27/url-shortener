import { useQuery } from "@tanstack/react-query";
import { getShortenedUrl } from "~/apis/getShortenedUrl";

export function useShortenedUrl(shortenedUrlId: string) {
  const query = useQuery({
    queryKey: ["shortenedUrl", shortenedUrlId],
    queryFn: () => getShortenedUrl(shortenedUrlId),
  });

  return query;
}