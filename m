Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 72C1429DFB
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 13:25:52 -0500 (CDT)
Message-ID: <522A1E2F.8090206@sgi.com>
Date: Fri, 06 Sep 2013 13:25:51 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 49/55] xfsprogs: add dtype support to mkfs and db
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-50-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-50-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/04/13 17:05, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Now that we have an extra field in the dirent, add support into
> xfs_db to be able to view it when looking at directory structures.
>
> Add support to mkfs to create filesystems with filetype - we'll
> always set it on CRC enabled filesystems so all new v5 filesystems
> will have this functionality enabled.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
