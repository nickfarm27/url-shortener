import { Skeleton } from "../ui/skeleton";
import { Card, CardHeader, CardContent } from "~/components/ui/card";

export function ShortenedUrlDetailsLoading() {
  return (
    <Card>
      <CardHeader>
        <Skeleton className="h-12 w-48" />
      </CardHeader>
      <CardContent>
        <Skeleton className="h-20" />
        <Skeleton className="h-20 mt-4" />
      </CardContent>
    </Card>
  );
}