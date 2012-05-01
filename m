Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q41IB3Wh174556 for <xfs@oss.sgi.com>; Tue, 1 May 2012 13:11:03 -0500
Message-ID: <4FA02733.5080409@sgi.com>
Date: Tue, 01 May 2012 13:10:59 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/10] xfs: add discontiguous buffer map interface
References: <1335249220-22274-1-git-send-email-david@fromorbit.com>
	<1335249220-22274-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1335249220-22274-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/24/12 01:33, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> With the internal interfaces supporting discontiguous buffer maps,
> add external lookup, read and get interfaces so they can start to be
> used.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
