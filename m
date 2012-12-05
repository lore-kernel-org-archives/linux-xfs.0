Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB5LgjNZ060238 for <xfs@oss.sgi.com>; Wed, 5 Dec 2012 15:42:45 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UnmcxvMbPA0rD6I3 for <xfs@oss.sgi.com>;
	Wed, 05 Dec 2012 13:45:08 -0800 (PST)
Date: Thu, 6 Dec 2012 08:45:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [3.0-stable PATCH 00/36] Proposed 3.0-stable bug patches
Message-ID: <20121205214505.GG29399@dastard>
References: <20121203144208.143464631@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121203144208.143464631@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

On Mon, Dec 03, 2012 at 05:42:08PM -0600, Mark Tinguely wrote:
> Here a collection of bug fixes for 3.0-stable. Many of these patches
> were also selected by Dave Chinner as possible 3.0-stable patches:
> 	http://oss.sgi.com/archives/xfs/2012-08/msg00255.html
> 
> I chose only bug fixes and kept the changes to a minimum.
> 
> Patch 21/22 are required for the bug fix in patch 23 but they are
> important changes in their own right.

So I'll ask the same question that Christoph asked me: If nobody is
reporting problems on 3.0.x, why do this and risk regression and
fallout that requires fixing?

FWIW, what testing have you done?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
