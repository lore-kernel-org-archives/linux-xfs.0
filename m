Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1O1xgIv098758 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 19:59:43 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0ABE012E18FD
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 18:02:26 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	tE0TbPf94jRrfuso for <xfs@oss.sgi.com>;
	Wed, 23 Feb 2011 18:02:26 -0800 (PST)
Date: Thu, 24 Feb 2011 13:02:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3, 11/16] xfsprogs: metadump: move obfuscation
	algorithm into its own function
Message-ID: <20110224020225.GY3166@dastard>
References: <201102182121.p1ILL2XC029147@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201102182121.p1ILL2XC029147@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 18, 2011 at 03:21:02PM -0600, Alex Elder wrote:
> Pull the name obfuscation algorithm into a separate function.
> This separates it from the checking for duplicates and recording
> of names that are found to be acceptable.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
