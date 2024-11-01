import { useInfiniteQuery } from "@tanstack/react-query";
import { getShortenedUrls } from "~/apis/getShortenedUrls";

export function useShortenedUrls() {
  const query = useInfiniteQuery({
    queryKey: ["shortenedUrls"],
    queryFn: getShortenedUrls,
    initialPageParam: 1,
    getNextPageParam: (lastPage) => lastPage.meta.next,
  });

  return query;
}