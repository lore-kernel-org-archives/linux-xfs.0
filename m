Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 224727F6A
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 15:43:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D1608F8074
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 13:43:29 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PuxGED1rsvEKlHCN for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 13:43:27 -0700 (PDT)
Date: Thu, 10 Oct 2013 07:43:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/32] xfs: fix some minor sparse warnings
Message-ID: <20131009204325.GI4446@dastard>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
	<1380510944-8571-4-git-send-email-david@fromorbit.com>
	<52548D80.8070807@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52548D80.8070807@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Oct 08, 2013 at 05:56:00PM -0500, Eric Sandeen wrote:
> On 9/29/13 10:15 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > A couple of simple locking annotations and 0 vs NULL warnings.
> > Nothing that changes any code behaviour, just removes build noise.
> 
> The patch is fine as it is, but it doesn't reflect the commit log.
> 
> Is part of it missing?

It's trimmed down from the kernel commit to just the bits that are
in libxfs. I haven't altered it in any other way, so it's entirely
possible the commit message has bits in it that the patch now
doesn't.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
