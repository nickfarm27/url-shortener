import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from "../ui/dialog";
import { CopyLinkButton } from "../copy-link-button";
import { Dispatch, SetStateAction } from "react";
import { parseShortenedUrl } from "~/helpers/shortenedUrl.client";
import { ExternalLink } from "../external-link";

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
  const { shortenedUrlWithHost, shortenedUrlWithOrigin } = parseShortenedUrl(path);

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Your link is ready! 🎉</DialogTitle>
        </DialogHeader>
        <DialogDescription className="text-center sm:text-start">Copy the link below and share it!</DialogDescription>
        <div className="flex flex-col items-center bg-slate-200 p-4 rounded-lg">
          {title && <p className="text-xl font-bold mb-2">{title}</p>}
          <ExternalLink to={`/${path}`} className="text-lg font-bold text-blue-700 hover:underline">
            {shortenedUrlWithHost}
          </ExternalLink>
          <p className="text-sm text-slate-500 text-center mt-2">
            Redirects to{" "}
            <ExternalLink to={targetUrl} className="underline">
              {targetUrl}
            </ExternalLink>
          </p>
          <CopyLinkButton
            link={shortenedUrlWithOrigin}
            className="w-full mt-4"
          />
        </div>
      </DialogContent>
    </Dialog>
  );
}
