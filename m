Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 028707CBF
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 00:21:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7C414AC003
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 22:21:34 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Ej77fTsw3CkRAQyY for <xfs@oss.sgi.com>;
	Thu, 13 Jun 2013 22:21:32 -0700 (PDT)
Date: Fri, 14 Jun 2013 15:21:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Trivial PATCH 25/33] xfs: Convert use of typedef ctl_table to
	struct ctl_table
Message-ID: <20130614052104.GX29338@dastard>
References: <cover.1371177118.git.joe@perches.com>
	<1cd76f83a114f3bc5bf6450bc71098aa2c6baa33.1371177118.git.joe@perches.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1cd76f83a114f3bc5bf6450bc71098aa2c6baa33.1371177118.git.joe@perches.com>
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
To: Joe Perches <joe@perches.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jun 13, 2013 at 07:37:50PM -0700, Joe Perches wrote:
> This typedef is unnecessary and should just be removed.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Looks fine, Joe.

Acked-by: Dave Chinner <dchinner@redhat.com>

How do you want us to handle this? Push it through the XFS tree or
are you going to send it on up yourself?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
