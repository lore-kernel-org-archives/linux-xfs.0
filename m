Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7KN54Jv011512 for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 18:05:04 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	FcPRF9UFhKQlcA1p for <xfs@oss.sgi.com>;
	Mon, 20 Aug 2012 16:05:03 -0700 (PDT)
Date: Tue, 21 Aug 2012 09:05:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V4] Make inode64 a remountable option
Message-ID: <20120820230501.GH19235@dastard>
References: <1345238378-10123-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1345238378-10123-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 17, 2012 at 06:19:38PM -0300, Carlos Maiolino wrote:
> Actually, there is no reason about why a user must umount and mount a XFS
> filesystem to enable 'inode64' option. So, this patch makes this a remountable
> option.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Next up - make inode64 the default mount option....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
