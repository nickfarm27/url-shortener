import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from "./ui/dialog";
import { CopyLinkButton } from "./copy-link-button";
import { Link } from "@remix-run/react";
import { Dispatch, SetStateAction } from "react";

interface CreatedLinkModalProps {
  shortenedUrl?: {
    path: string;
    targetUrl: string;
    title?: string;
  };
  open: boolean;
  onOpenChange: Dispatch<SetStateAction<boolean>>;
}

export function CreatedLinkModal({
  shortenedUrl,
  open,
  onOpenChange,
}: CreatedLinkModalProps) {
  if (!shortenedUrl) return null;

  const { path, targetUrl, title } = shortenedUrl;

  const location = typeof window === "undefined" ? undefined : window.location;
  const domain = location?.origin;
  const host = location?.host;
  const shortenedUrlWithDomain = `${domain}/${path}`;
  const shortenedUrlWithHost = `${host}/${path}`;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Your link is ready! 🎉</DialogTitle>
        </DialogHeader>
        <DialogDescription>Copy the link below and share it!</DialogDescription>
        <div className="flex flex-col items-center bg-slate-200 p-4 rounded-lg">
          {title && <p className="text-xl font-bold mb-2">{title}</p>}
          <Link
            to={`/${path}`}
            rel="noopener noreferrer"
            target="_blank"
            className="text-lg font-bold text-blue-700 hover:underline"
          >
            {shortenedUrlWithHost}
          </Link>
          <p className="text-sm text-slate-500">
            Redirects to{" "}
            <Link
              to={targetUrl}
              rel="noopener noreferrer"
              target="_blank"
              className="underline"
            >
              {targetUrl}
            </Link>
          </p>
          <CopyLinkButton
            link={shortenedUrlWithDomain}
            className="w-full mt-4"
          />
        </div>
      </DialogContent>
    </Dialog>
  );
}
