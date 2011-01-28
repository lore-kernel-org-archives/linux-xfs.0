Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0S0eEW3061479 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 18:40:15 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F2B2126A922
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 16:42:38 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9XNOaX3fAwJj2zIg for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 16:42:38 -0800 (PST)
Date: Fri, 28 Jan 2011 11:42:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/8] xfs: candidate 2.6.38-rc fixes V3
Message-ID: <20110128004236.GP21311@dastard>
References: <1296100401-17135-1-git-send-email-david@fromorbit.com>
	<1296142265.1973.67.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1296142265.1973.67.camel@doink>
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

On Thu, Jan 27, 2011 at 09:31:05AM -0600, Alex Elder wrote:
> On Thu, 2011-01-27 at 14:53 +1100, Dave Chinner wrote:
> > Fixed the various issues found during review and added all the
> > reviewed-by tags to the fully reviewed commits.
> 
> I'll be testing with this today.  Barring any unforseen
> problems I'm just waiting for a pull request from you
> (or the go-ahead to just use the patches as posted).

Ok, still need a review on patch 2/8 (efi item leak) before I'll
send a pull request...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
