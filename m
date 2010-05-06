Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o46651Ss076163 for <xfs@oss.sgi.com>; Thu, 6 May 2010 01:05:01 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51A18314366
	for <xfs@oss.sgi.com>; Wed,  5 May 2010 23:07:08 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	HP0sWxFeVfENdQDF for <xfs@oss.sgi.com>;
	Wed, 05 May 2010 23:07:08 -0700 (PDT)
Date: Thu, 6 May 2010 16:07:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/11] xfs: Delayed logging design documentation
Message-ID: <20100506060706.GB19579@dastard>
References: <921460991.88921273119221574.JavaMail.root@mail-au>
	<827899224.88951273119424327.JavaMail.root@mail-au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <827899224.88951273119424327.JavaMail.root@mail-au>
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
To: nathans@aconex.com
Cc: xfs@oss.sgi.com

On Thu, May 06, 2010 at 02:17:04PM +1000, nathans@aconex.com wrote:
> Yo,
> 
> Looking good Dave!  Thanks for writing this up, it made for some
> interesting lunch time reading.  ;)
> 
> Here's a few typos I noticed, marked 'em up as I read along...

Thanks for the proof reading. ;)

I've fixed all the bits you pointed out, and a couple more I found
while fixing those....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
