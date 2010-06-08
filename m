Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58MiMUv240211 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 17:44:23 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED3DD10D05BE
	for <xfs@oss.sgi.com>; Tue,  8 Jun 2010 15:49:50 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	4j4FVUDeI7ef4qyP for <xfs@oss.sgi.com>;
	Tue, 08 Jun 2010 15:49:50 -0700 (PDT)
Date: Wed, 9 Jun 2010 08:46:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6] writeback: tracing and fixes V4
Message-ID: <20100608224615.GE7869@dastard>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
	<alpine.LFD.2.00.1006081039370.4506@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006081039370.4506@i5.linux-foundation.org>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 08, 2010 at 10:41:28AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 8 Jun 2010, Dave Chinner wrote:
> >
> > Can you please consider this patch series for 2.6.35?
> 
> Yeah, no. See the several lkml discussions and the -rc2 announcement about 
> how I do _not_ intend to merge anything even remotely "new code" this time 
> around.
> 
> So purely regression fixes and serious bugfixes (oopses/security issues).

No worries,  I'll re-order the series and send you just the bug
fixes later this morning.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
