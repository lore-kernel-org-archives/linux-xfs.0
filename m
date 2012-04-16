Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3GLRT2X248207 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 16:27:29 -0500
Date: Mon, 16 Apr 2012 16:29:11 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/18] xfs: current patch queue
Message-ID: <20120416212911.GE2924@sgi.com>
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1334319061-12968-1-git-send-email-david@fromorbit.com>
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

Dave, 

On Fri, Apr 13, 2012 at 10:10:43PM +1000, Dave Chinner wrote:
> Here's a repost of my current patch queue. They are all based on Christoph's
> ilock and xfsbufd patch series and been tested on top of them. I've updated all
> the reviewed-by tags, so if the patch is missing such a tag then it hasn't been
> reviewed....

Looks like Christoph has some work to do on patch 4 of his xfsbufd series.  Do
you want to rebase to something without that patch?

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
