Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 87C5C7FA8
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 22:13:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 67CF230405F
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 20:13:51 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	TSeejl75L8czR2np for <xfs@oss.sgi.com>;
	Wed, 06 Mar 2013 20:13:49 -0800 (PST)
Date: Thu, 7 Mar 2013 15:13:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Fwd: xfs_reno
Message-ID: <20130307041348.GD6369@dastard>
References: <20351675.Zy117sIl8Z@xrated>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20351675.Zy117sIl8Z@xrated>
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

On Wed, Mar 06, 2013 at 03:55:19PM +0100, Hans-Peter Jansen wrote:
> Hi Dave,
> 
> I tried to gather Barrys SOB, but failed so far. His trace ends in 2009 google 
> wise.
> 
> How is this case usually handled?
> 
> Here's the current state of things.

He was working for SGI at the time, so you should be able to get
anyone from SGI provide a valid S-O-B if needed.

As it is, I can probably verify the patch origins sufficiently
to add a SOB to it as:

http://oss.sgi.com/archives/xfs/2007-11/msg00769.html

It's pretty clear that the code was released under the GPL and free
from any tainted code by SGI. The post I'm pointing to above is one
I made while an SGI employee, and it effectively verifies the origin
of the code in the same way a S-O-B does.

So, you probably don't even need to chase a S-O-B from SGI if you
just point at that email and attribute the code correctly. i.e.
retaining al the SGI copyright notices in the code and saying inteh
patch description that the code was originally authored by SGI and
released under the same license as the rest of the xfs userspace
code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
