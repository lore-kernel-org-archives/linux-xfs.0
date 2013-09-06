Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9BD2B7F50
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 14:03:46 -0500 (CDT)
Message-ID: <522A270E.8010705@sgi.com>
Date: Fri, 06 Sep 2013 14:03:42 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 55/55] xfsprogs: cleanup miscellaneous merge faults
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-56-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-56-git-send-email-david@fromorbit.com>
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
> From: Ben Myers<bpm@sgi.com>
>
> * clean up a few extra tabs
> * xfs_buf_map->xfs_buf_ops in libxfs_readbuf and libxfs_readbuf_map args
> * don't call the write verifier twice
> * put the multithreaded scan_ags back
>
> Signed-off-by: Ben Myers<bpm@sgi.com>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
