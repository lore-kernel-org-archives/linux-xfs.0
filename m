Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CD5A87F3F
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 13:27:36 -0600 (CST)
Received: from eagdhcp-232-156.americas.sgi.com
	(eagdhcp-232-156.americas.sgi.com [128.162.232.156])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AD1C7304066
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 11:27:33 -0800 (PST)
Message-ID: <5491D925.2040208@sgi.com>
Date: Wed, 17 Dec 2014 13:27:33 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_quota: fix typo in manpage
References: <5491BBC6.5090607@redhat.com>
In-Reply-To: <5491BBC6.5090607@redhat.com>
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
To: xfs@oss.sgi.com

On 12/17/14 11:22, Eric Sandeen wrote:
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> index 8cc8ab7..3ca2fa5 100644
> --- a/man/man8/xfs_quota.8
> +++ b/man/man8/xfs_quota.8
> @@ -324,7 +324,7 @@ path to the
>   list entry (the current path is used by many
>   of the commands described here, it identifies the filesystem toward
>   which a command is directed).
> -The patch list can come from several places \- the command line,
> +The path list can come from several places \- the command line,
>   the mount table, and the
>   .I /etc/projects
>   file.

Nod.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
