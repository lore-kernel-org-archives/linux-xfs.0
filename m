Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p95MYn5n145155 for <xfs@oss.sgi.com>; Wed, 5 Oct 2011 17:34:49 -0500
Message-ID: <4E8CDB85.7080108@sgi.com>
Date: Wed, 05 Oct 2011 17:34:45 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: update summaries in preparation for release 3.0.6
References: <201110052210.p95MAXGI012463@stout.americas.sgi.com>
In-Reply-To: <201110052210.p95MAXGI012463@stout.americas.sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On 10/05/2011 05:10 PM, Alex Elder wrote:
> The following is a draft of summaries to be included in the next
> release of xfsdump.
>
> Signed-off-by: Alex Elder<alder@sgi.com>

Looks like this covers everything. Just one minor correction below.

Reviewed-by: Bill Kendall <wkendall@sgi.com>

> Index: b/doc/CHANGES
> ===================================================================
> --- a/doc/CHANGES
> +++ b/doc/CHANGES
> @@ -1,3 +1,29 @@

...

> +	- Some dialogs, which were previously restricted to at most
> +	  8 options, are now able to present up to 99.

Actually there's no realistic limit anymore (whatever fits in
a size_t).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
