import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "../ui/sheet";
import { Button } from "../ui/button";
import { ShortenedUrlsList } from "./shortened-urls-list";

export function AllLinksSheet() {
  return (
    <Sheet>
      <SheetTrigger asChild className="absolute top-4 right-4">
        <Button variant="outline">My URLs</Button>
      </SheetTrigger>
      <SheetContent className="overflow-y-auto">
        <SheetHeader>
          <SheetTitle>My URLs</SheetTitle>
        </SheetHeader>
        <ShortenedUrlsList />
      </SheetContent>
    </Sheet>
  );
}
