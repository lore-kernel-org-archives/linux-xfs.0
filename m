Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MKsfSS083614 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 15:54:41 -0500
Subject: Re: [PATCH 0/16] xfs: metadata scalability V2
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1285137869-10310-1-git-send-email-david@fromorbit.com>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
Date: Wed, 22 Sep 2010 15:55:32 -0500
Message-ID: <1285188932.2211.44.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 2010-09-22 at 16:44 +1000, Dave Chinner wrote:
> This patchset started out as a "convert the buffer cache to rbtrees"
> patch, and just gew from there as I peeled the onion from one
> bottleneck to another. The second version of this patch does not go
> as far as the first version - it drops the more radical changes as
> they are not ready for integration yet.

I saw patches 01-14 and 16, but no 15.  Was that
intentionally excluded, or an oversight?

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
