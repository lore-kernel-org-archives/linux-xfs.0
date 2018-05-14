Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60462 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751219AbeENC2o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 May 2018 22:28:44 -0400
Subject: Re: [PATCH 1/4] design: rename disk structures book
References: <152623082465.10242.9458731018482450171.stgit@magnolia>
 <152623083064.10242.12457966241178588063.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <945f13a8-c37b-80de-7453-0b81c4350737@oracle.com>
Date: Sun, 13 May 2018 19:28:29 -0700
MIME-Version: 1.0
In-Reply-To: <152623083064.10242.12457966241178588063.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, azarus@posteo.net

Ok, you can add me as a reviewer

Reviewed by: Allison Henderson <allison.henderson@oracle.com>

On 05/13/2018 10:00 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Since the book already has chapters describing fundamental XFS
> algorithms, update the title to reflect this.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   .../xfs_filesystem_structure.asciidoc              |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
>
> diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
> index 5dba1c7..8d54935 100644
> --- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
> +++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
> @@ -6,8 +6,8 @@
>   // and we really need an area to set up various docbook sections like copyright
>   // and legal notice sections.
>   //
> -XFS Filesystem Disk Structures
> -==============================
> +XFS Algorithms & Data Structures
> +================================
>   :doctype: book
>   :docinfo1:
>   
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=JxScqp5vH7Jg1wyZcz9AeVNmSZ5-9zjBI0i7YcOQNxw&s=zLCCT--DFiCjYhfTc9uUCu07XLpTvt3VoB7pu6ts1AU&e=

