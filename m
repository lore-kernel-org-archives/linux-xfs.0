Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 867837F52
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 16:09:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 638E3304048
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 14:09:10 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9R0rNbEUCSea3olI for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 14:09:09 -0800 (PST)
Date: Fri, 15 Nov 2013 09:09:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: correct docs for "-t" units
Message-ID: <20131114220904.GR6188@dastard>
References: <528534B0.8070709@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528534B0.8070709@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Nov 14, 2013 at 02:38:08PM -0600, Eric Sandeen wrote:
> usage() says that the xfs_repair -t reporting interval is
> in minutes, and the manpage says nothing at all about units.
> 
> Actually, it's in seconds.
> 
> Clarify in both places that the interval is specified in
> seconds.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
