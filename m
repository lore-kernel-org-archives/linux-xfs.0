Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53766 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751757AbdFPB4M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Jun 2017 21:56:12 -0400
Subject: Re: [PATCH] docs: fix mailing list
References: <20170615234854.GA5421@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dfc74ab6-c637-793b-c020-2f99fd5df1df@sandeen.net>
Date: Thu, 15 Jun 2017 20:56:10 -0500
MIME-Version: 1.0
In-Reply-To: <20170615234854.GA5421@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On 6/15/17 6:48 PM, Darrick J. Wong wrote:
> Fix the mailing list since it's way out of date.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I can handle this one! ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  .../xfs_filesystem_structure.asciidoc              |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
> index 5540fa0..4b0a054 100644
> --- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
> +++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
> @@ -34,7 +34,7 @@ design goals.
>  The information contained in this document derives from the XFS source code in
>  the Linux kernel as of v4.3.  This book's source code is available at
>  +git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git+.  Feedback should
> -be sent to the XFS mailing list, currently at +xfs@oss.sgi.com+.
> +be sent to the XFS mailing list, currently at +linux-xfs@vger.kernel.org+.
>  
>  [NOTE]
>  All fields in XFS metadata structures are in big-endian byte order except for
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
