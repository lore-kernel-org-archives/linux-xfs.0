Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 16:01:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8ON1tZS022719
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 16:01:56 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A815088E613
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 16:03:29 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id psZPEQH5BdSqeo30 for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 16:03:29 -0700 (PDT)
Date: Thu, 25 Sep 2008 09:03:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.27-rc7 no init found on the root partition?
Message-ID: <20080924230326.GM5448@disturbed>
References: <20080924192227.GC31582@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924192227.GC31582@ics.muni.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Sep 24, 2008 at 09:22:27PM +0200, Lukas Hejtmanek wrote:
> Hello,
> 
> I have a box that has XFS root partition, I have kernel 2.6.26.3 that boots
> pretty well on that box. Today, I've tried 2.6.27-rc7 (so that I can test
> NFSv4 over IPv6), but the kernel is unable to boot. It says that root
> partition is mounted, XFS file system but no init found.

Can you paste the error messages or send pointers to screen shots of
the error?

If you go back to 2.6.26.3, does the kernel boot ok?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
