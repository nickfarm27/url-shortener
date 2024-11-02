import { Card, CardContent } from "./ui/card";
import { CopyLinkButton } from "./copy-link-button";
import { Calendar, ChartColumnBig } from "lucide-react";
import { Button } from "./ui/button";
import { ShortenedUrl } from "~/types/shortenedUrl";
import { ExternalLink } from "./external-link";
import { parseShortenedUrl } from "~/helpers/shortenedUrl.client";

export function ShortenedUrlCard({
  shortenedUrl,
}: {
  shortenedUrl: ShortenedUrl;
}) {
  const { id, path, targetUrl, title, createdAt } = shortenedUrl;
  const { shortenedUrlWithHost, shortenedUrlWithOrigin } =
    parseShortenedUrl(path);
  const createdDate = new Date(createdAt).toLocaleString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  });

  return (
    <Card>
      <CardContent className="py-4 flex flex-col gap-1">
        <p className="font-semibold">{title}</p>
        <ExternalLink
          to={`/${path}`}
          className="text-blue-700 text-sm font-medium hover:underline"
        >
          {shortenedUrlWithHost}
        </ExternalLink>
        <ExternalLink
          to={targetUrl}
          className="text-sm text-muted-foreground hover:underline"
        >
          {targetUrl}
        </ExternalLink>
        <div className="text-muted-foreground flex items-center gap-1">
          <Calendar className="h-3 w-3 mt-0.5" />
          <p className="text-xs pt-1">{createdDate}</p>
        </div>
        <div className="mt-2 flex gap-2">
          <CopyLinkButton link={shortenedUrlWithOrigin} size="sm" />
          <ExternalLink to={`/analytics/${id}`}>
            <Button variant="outline" size="sm">
              <ChartColumnBig className="h-4 w-4" />
            </Button>
          </ExternalLink>
        </div>
      </CardContent>
    </Card>
  );
}
