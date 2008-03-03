Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 16:24:21 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m230ODQ0029452
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 16:24:14 -0800
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC8CC124BCC3
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2008 16:24:42 -0800 (PST)
Received: from postoffice.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id 7whER3PxB6Foh4ed for <xfs@oss.sgi.com>; Sun, 02 Mar 2008 16:24:42 -0800 (PST)
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <47CB43EE.3060405@sgi.com>
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com>
	 <1204166101.13569.102.camel@edge.scott.net.au>
	 <47C87775.2010007@thebarn.com> <47C89137.3070805@sandeen.net>
	 <47C89303.7070902@thebarn.com> <1204500895.10190.3.camel@edge.scott.net.au>
	  <47CB43EE.3060405@sgi.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 11:24:09 +1100
Message-Id: <1204503849.10190.26.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, Eric Sandeen <sandeen@sandeen.net>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, 2008-03-03 at 11:18 +1100, Donald Douwsma wrote:
> 
> 
> Could work but I dont like the idea of using -f for anything but
> mkfsing an
> existing filesystem. If that becomes habit for people it could lead to
> disasters. 

Its already used for more than just overwriting existing filesystems. :)
And it is already habit for some people.  Which leads to disasters, yes.

Its not a perfect system, but there's only so much you can do for people
before they shoot themselves in the foot.

-- 
Nathan
