import { Skeleton } from "./ui/skeleton";
import { useShortenedUrls } from "~/hooks/useShortenedUrls";
import { Button } from "./ui/button";
import { ShortenedUrlCard } from "./shortened-url-card";

export function ShortenedUrlsList() {
  const {
    data,
    isPending,
    isError,
    error,
    fetchNextPage,
    hasNextPage,
    isFetchingNextPage,
  } = useShortenedUrls();

  if (isPending) {
    return (
      <div className="flex flex-col gap-4 mt-4">
        {Array.from({ length: 3 }).map((_, i) => (
          <Skeleton key={i} className="w-full h-24" />
        ))}
      </div>
    );
  }

  if (isError) {
    return <p className="mt-4 text-sm">Error: {error.message}</p>;
  }

  if (!data || data.pages.length === 0) {
    return <p className="mt-4 text-sm">No shortened URLs found</p>;
  }

  return (
    <div className="flex flex-col gap-4 mt-4">
      {data.pages.map((page) =>
        page.shortenedUrls.map((shortenedUrl) => (
          <ShortenedUrlCard key={shortenedUrl.id} shortenedUrl={shortenedUrl} />
        ))
      )}
      {hasNextPage ? (
        <Button
          variant="secondary"
          onClick={() => {
            fetchNextPage();
          }}
          disabled={isFetchingNextPage}
        >
          {isFetchingNextPage ? "Loading..." : "Load more"}
        </Button>
      ): (
        <p className="mt-4 text-sm text-center text-muted-foreground">You&apos;ve seen it all! Have a 🍪</p>
      )}
    </div>
  );
}
