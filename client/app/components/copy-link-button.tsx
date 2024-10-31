import { useState } from "react";
import { Button } from "./ui/button";
import { CheckIcon, ClipboardCopyIcon } from "@radix-ui/react-icons";

export function CopyLinkButton({ link, className }: { link: string; className?: string }) {
  const [hasCopied, setHasCopied] = useState(false);

  function copyLinkToClipboard() {
    navigator.clipboard.writeText(link);
    setHasCopied(true);
    setTimeout(() => setHasCopied(false), 2000);
  }

  return (
    <Button className={className} onClick={copyLinkToClipboard}>
      <span className="sr-only">Copy</span>
      Copy link
      {hasCopied ? (
        <CheckIcon className="h-4 w-4" />
      ) : (
        <ClipboardCopyIcon className="h-4 w-4" />
      )}
    </Button>
  );
}
