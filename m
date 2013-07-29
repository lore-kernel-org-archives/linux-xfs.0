Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 95B677F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 10:30:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3CBD3AC002
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 08:30:13 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	0BxqHsS4CjBCxpvN for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 08:30:11 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 684701F0019D
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 11:30:08 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id t7Zxnmsn-10B for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 11:30:02 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 354EC1F00532
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 11:30:02 -0400 (EDT)
Date: Mon, 29 Jul 2013 11:30:02 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <15781090.2540.1375111802121.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <51F682CC.1080100@sandeen.net>
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

----- Original Message -----
> From: "Eric Sandeen" <sandeen@sandeen.net>

> >> From: "Dave Chinner" <david@fromorbit.com>
> >
> >> The "version" of XFS that you are running is that of the
> >> kernel you are running. i.e. 2.6.32-279.x.y or 2.6.32-358.x.y.
> >
> > Those aren't kernel versions; those are kernel *package* versions.
> 
> Those are RHEL kernel version numbers, which 100% uniquely identify
> the code contained in those kernels.

So how, Eric, would that help, say, SuSE users -- which the XFS website makes 
special note to point out that there's a specific agreement in place to 
support.  Even SLES users vice openSUSE, though the XFS.org website doesn't 
make that distinction.

I'm sticking with "those are kernel package versions", and I was yelled
at the other day because I was interested in things that weren't "mainline
kernel versions".  RHEL kernels are the *best available example* of "not
a mainline kernel version", so I find these conflicting reports most
conflicting.

> > Kernel versions are w.x.y or w.x.y.z.
> 
> ^Upstream.

"Mainline".  Which was not my choice of term.

Cheers,
-- jra
-- 
Jay R. Ashworth                  Baylink                       jra@baylink.com
Designer                     The Things I Think                       RFC 2100
Ashworth & Associates     http://baylink.pitas.com         2000 Land Rover DII
St Petersburg FL USA               #natog                      +1 727 647 1274

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
