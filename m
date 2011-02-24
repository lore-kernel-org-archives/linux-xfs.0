Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1O1aAYT097330 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 19:36:10 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 192A6149B0D3
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 17:38:54 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IKv7BSUW77NdyBQE for <xfs@oss.sgi.com>;
	Wed, 23 Feb 2011 17:38:54 -0800 (PST)
Date: Thu, 24 Feb 2011 12:38:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3, 05/16] xfsprogs: metadump: eliminate a pointless
	loop in generate_obfuscated_name()
Message-ID: <20110224013852.GS3166@dastard>
References: <201102182121.p1ILL1lX029072@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201102182121.p1ILL1lX029072@stout.americas.sgi.com>
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

On Fri, Feb 18, 2011 at 03:21:01PM -0600, Alex Elder wrote:
> Eliminate a now pointless loop.  Done as a separate patch to make
> the effects of upcoming changes more clear.
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
