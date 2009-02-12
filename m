Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1CMHUsq088983 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 16:17:30 -0600
Received: from web30203.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id F3A35119102
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 14:16:54 -0800 (PST)
Received: from web30203.mail.mud.yahoo.com (web30203.mail.mud.yahoo.com
	[209.191.69.50]) by cuda.sgi.com with SMTP id BuBHIJ8bW41aoBbX
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 14:16:54 -0800 (PST)
Message-ID: <3453.33822.qm@web30203.mail.mud.yahoo.com>
Date: Thu, 12 Feb 2009 14:16:53 -0800 (PST)
From: <raksac@yahoo.com>
Subject: Re: BUG: soft lockup detected on CPU#1!
In-Reply-To: <49949E64.8020904@sandeen.net>
MIME-Version: 1.0
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
Cc: xfs@oss.sgi.com


Guys,

Thank you for taking the time to write. Having said
where I stand and we are kind of on the same page. Is
there something I can expect which would put me on a
track of nailing down the problem. It maybe a wild
goose chase but something that I can start with would
be much appreciated.

Unfortunately there is no distro which gets closer to
where mainline lives today. Reading the changelog
there are several problems that I have already come
across and has convincingly driven me to take on this
task.

Thanks,
Rakesh

--- Eric Sandeen <sandeen@sandeen.net> wrote:

> raksac@yahoo.com wrote:
> > Well the problem is the older kernel XFS driver is
> > buggy to such a large extent that there is data
> loss
> > even for data on rest should a power loss occur.
> > 
> > With a newer version back port I can preserve the
> > kernel version change since it becomes far more
> > reaching to the other kernel components and they
> have
> > to move, to which ..... there is strong
> reservation.
> > 
> > Hope this gives you the perspective.
> 
> It's totally understandable why you might want to do
> it.
> 
> It's also totally understandable why upstream
> developers can't spend a
> lot of time on your custom codebase.
> 
> What you need, of course, is a distribution with
> good support for xfs,
> so you can make it Someone Else's Problem.  :)
> 
> -Eric
> 
> > Thanks,
> > Rakesh 
> 
> 
> 
> 



      

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
