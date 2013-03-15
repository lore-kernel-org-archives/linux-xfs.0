Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 8D5198044
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 14:36:39 -0500 (CDT)
Date: Fri, 15 Mar 2013 12:36:38 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 02/25] xfstests: remove bench infrastructure
Message-ID: <20130315193635.GA2025@caliban.engr.sgi.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363350489-22257-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 15, 2013 at 11:27:46PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The benchmark framework inside xfstests is basically unused,
> bitrotted and not very useful. If we need benchmarks, lets use a
> real benchmark framework, not xfstests. Kill it to remove
> dependencies on common and common.rc.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I've been straightforward and clear in why I reposted the patch set and why
I'm personally interested in the benchmark framework staying around.  I don't
see value in explaining it again.

I don't see how it serves anyone.  I don't see how it serves the community
to repost this rather than excluding this change, pushing this through, and
improving xfstests.  The resultant exchange of mail does nothing but to
litter everyone else's inbox.

-Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
