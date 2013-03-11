Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DB8267F4C
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 21:00:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C21958F8050
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 19:00:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ibuGVsZXNarVfx7g for <xfs@oss.sgi.com>;
	Sun, 10 Mar 2013 19:00:32 -0700 (PDT)
Date: Mon, 11 Mar 2013 13:00:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: ensure we capture IO errors correctly
Message-ID: <20130311020030.GB21651@dastard>
References: <1362708074-14987-1-git-send-email-david@fromorbit.com>
	<1407262.RNsTtTSyZy@xrated>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1407262.RNsTtTSyZy@xrated>
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
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: xfs@oss.sgi.com

On Fri, Mar 08, 2013 at 02:06:52PM +0100, Hans-Peter Jansen wrote:
> Hi, 
> 
> this sounds like stable material after a little simmering..

Yes, it probably is a candidate for 3.8.x

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
