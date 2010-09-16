Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8GNUxh8023518 for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 18:31:00 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 279B01D8AD66
	for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 16:31:48 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	PigtHnunjQYwiVCA for <xfs@oss.sgi.com>;
	Thu, 16 Sep 2010 16:31:48 -0700 (PDT)
Date: Fri, 17 Sep 2010 09:31:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add local.config example
Message-ID: <20100916233145.GI24409@dastard>
References: <4C925CF3.3060303@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C925CF3.3060303@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Sep 16, 2010 at 01:07:47PM -0500, Eric Sandeen wrote:
> I think it'd be useful to have a local.config template in the
> git repo, to avoid having to re-read the README each time
> to remember the required environment variable names.
> 
> Thoughts?  Am I just lazy?  :)

Lazy makes the world go round. ;)

A template is probably a good idea.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Btw, if you are going add a template, you might as well remove all
the old configs that are there. I don't think any of them exist
anymore, and they have no further use as templates.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
