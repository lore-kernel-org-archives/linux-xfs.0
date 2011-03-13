Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2D2Fxgs253311 for <xfs@oss.sgi.com>; Sat, 12 Mar 2011 20:16:04 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9EAC1380455
	for <xfs@oss.sgi.com>; Sat, 12 Mar 2011 18:18:50 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	F1FzG2hh4J1bqNhv for <xfs@oss.sgi.com>;
	Sat, 12 Mar 2011 18:18:50 -0800 (PST)
Date: Sun, 13 Mar 2011 11:49:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't name variables "panic"
Message-ID: <20110313004859.GF15097@dastard>
References: <AANLkTi=Hg4s5kEMQZu_KGePf4W_7jAFm0_WifM9W3PR6@mail.gmail.com>
	<1299847191.3462.1.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299847191.3462.1.camel@doink>
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
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, XFS Mailing List <xfs@oss.sgi.com>

On Fri, Mar 11, 2011 at 06:39:51AM -0600, Alex Elder wrote:
> The new xfs_alert_tag() used a variable named "panic",
> and that is to be avoided.  Rename it.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

My fault. Fix looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
