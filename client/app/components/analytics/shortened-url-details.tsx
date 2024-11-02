import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "~/components/ui/card";
import { useParams } from "@remix-run/react";
import { useTotalClicks } from "~/hooks/analytics/useTotalClicks";
import { useShortenedUrl } from "~/hooks/useShortenedUrl";
import { Skeleton } from "../ui/skeleton";
import { ShortenedUrlDetailsLoading } from "./shortened-url-details-loading";
import { parseShortenedUrl } from "~/helpers/shortenedUrl.client";
import { ExternalLink } from "../external-link";
import { CopyLinkButton } from "../copy-link-button";

export function ShortenedUrlDetails() {
  const params = useParams();
  const shortenedUrlId = params.shortenedUrlId as string;

  const {
    data: shortenedUrl,
    isLoading: isLoadingShortenedUrl,
    error: shortenedUrlError,
  } = useShortenedUrl(shortenedUrlId);
  const {
    data: totalClicksData,
    isLoading: isLoadingTotalClicks,
    error: totalClicksError,
  } = useTotalClicks(shortenedUrlId);

  if (isLoadingShortenedUrl) {
    return <ShortenedUrlDetailsLoading />;
  }

  if (shortenedUrlError) {
    return (
      <Card>
        <CardHeader>
          <CardTitle>Error</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-sm text-red-500">
            Error fetching shortened URL details
          </p>
        </CardContent>
      </Card>
    );
  }

  if (!shortenedUrl) {
    return (
      <Card>
        <CardHeader>
          <CardTitle>Error 404: Not found</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-sm">Shortened URL not found</p>
        </CardContent>
      </Card>
    );
  }

  const { title, path, targetUrl, createdAt } = shortenedUrl;
  const { shortenedUrlWithHost, shortenedUrlWithOrigin } =
    parseShortenedUrl(path);
  const createdDate = new Date(createdAt).toLocaleString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  });
  const targetUrlDomain = new URL(targetUrl).hostname;

  function TotalClicks() {
    if (isLoadingTotalClicks) {
      return <Skeleton className="w-40 h-12 mt-2" />;
    }

    if (totalClicksError) {
      return (
        <p className="text-sm text-red-500">
          Error fetching total clicks
        </p>
      );
    }

    return <p className="text-3xl font-bold">{totalClicksData?.totalClicks || 0}</p>;
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-2xl font-semibold">
          {title || targetUrlDomain}
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div className="flex flex-col space-y-2 items-start">
          <ExternalLink to={shortenedUrlWithOrigin} className="hover:underline">
            {shortenedUrlWithHost}
          </ExternalLink>
          <ExternalLink
            to={targetUrl}
            className="text-muted-foreground text-sm hover:underline break-all"
          >
            {targetUrl}
          </ExternalLink>
          <p className="text-muted-foreground text-sm italic">
            Created on {createdDate}
          </p>
        </div>
        <div className="mt-6 flex items-end justify-between">
          <div className="flex-grow">
            <h3 className="text-lg font-semibold">Total Clicks</h3>
            <TotalClicks />
          </div>
          <CopyLinkButton link={shortenedUrlWithOrigin} size="sm" />
        </div>
      </CardContent>
    </Card>
  );
}
