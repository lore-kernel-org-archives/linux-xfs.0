Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1CMBaaa088334 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 16:11:37 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71EEA119068
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 14:10:59 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id vdOuiTDUb2wMyXF9 for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2009 14:10:59 -0800 (PST)
Message-ID: <49949E64.8020904@sandeen.net>
Date: Thu, 12 Feb 2009 16:10:44 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: BUG: soft lockup detected on CPU#1!
References: <342331.71207.qm@web30204.mail.mud.yahoo.com>
In-Reply-To: <342331.71207.qm@web30204.mail.mud.yahoo.com>
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
To: raksac@yahoo.com
Cc: xfs@oss.sgi.com

raksac@yahoo.com wrote:
> Well the problem is the older kernel XFS driver is
> buggy to such a large extent that there is data loss
> even for data on rest should a power loss occur.
> 
> With a newer version back port I can preserve the
> kernel version change since it becomes far more
> reaching to the other kernel components and they have
> to move, to which ..... there is strong reservation.
> 
> Hope this gives you the perspective.

It's totally understandable why you might want to do it.

It's also totally understandable why upstream developers can't spend a
lot of time on your custom codebase.

What you need, of course, is a distribution with good support for xfs,
so you can make it Someone Else's Problem.  :)

-Eric

> Thanks,
> Rakesh 



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
