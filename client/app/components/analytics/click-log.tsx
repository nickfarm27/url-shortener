import { useState } from "react";
import { ChevronLeftIcon, ChevronRightIcon } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "~/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "~/components/ui/table";
import { Button } from "~/components/ui/button";
import { useClicks } from "~/hooks/analytics/useClicks";
import { useParams } from "@remix-run/react";
import { Skeleton } from "../ui/skeleton";

export function ClickLog() {
  const params = useParams();
  const shortenedUrlId = params.shortenedUrlId as string;

  const [page, setPage] = useState(1);
  const { data, isLoading, error } = useClicks(shortenedUrlId, page);

  function ClickLogTable() {
    if (isLoading) {
      return (
        <>
          {Array.from({ length: 5 }).map((_, i) => (
            <Skeleton key={i} className="w-full h-8" />
          ))}
        </>
      );
    }

    if (error) {
      return <p className="text-sm text-red-500">Error fetching clicks</p>;
    }

    if (!data || data.clicks.length === 0) {
      return <p className="text-sm text-muted-foreground">No clicks found</p>;
    }

    const { clicks, meta } = data;
    const { last } = meta;

    return (
      <>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Timestamp</TableHead>
              <TableHead>Country</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {clicks.map((click) => {
              const { id, createdAt, country } = click;
              const date = new Date(createdAt).toLocaleString("en-UK", {
                day: "numeric",
                month: "numeric",
                year: "numeric",
                hour: "numeric",
                minute: "numeric",
                second: "numeric",
              });

              return (
                <TableRow key={id}>
                  <TableCell>{date}</TableCell>
                  <TableCell>{country || "-"}</TableCell>
                </TableRow>
              );
            })}
          </TableBody>
        </Table>
        <div className="flex items-center justify-between mt-4">
          <Button
            variant="outline"
            onClick={() => setPage((prev) => prev - 1)}
            disabled={page === 1}
          >
            <ChevronLeftIcon className="w-4 h-4" />
            Previous
          </Button>
          <span className="text-sm text-muted-foreground">
            Page {page} of {last}
          </span>
          <Button
            variant="outline"
            onClick={() => setPage((prev) => prev + 1)}
            disabled={page === last}
          >
            Next
            <ChevronRightIcon className="w-4 h-4" />
          </Button>
        </div>
      </>
    );
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Click Log</CardTitle>
      </CardHeader>
      <CardContent className="space-y-2">
        <ClickLogTable />
      </CardContent>
    </Card>
  );
}
