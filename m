Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DF7DC7F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 09:36:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CBA668F804C
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 07:36:45 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	foz1sK7E9glFFdA4 for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 07:36:44 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id EC16C1F00535
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 10:36:43 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id LkStE0NNoM3B for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 10:36:39 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id E3F2D1F0046E
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 10:36:39 -0400 (EDT)
Date: Mon, 29 Jul 2013 10:36:39 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <24152742.2528.1375108599905.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <4422459.2522.1375107885083.JavaMail.root@benjamin.baylink.com>
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
> From: "Jay Ashworth" <jra@baylink.com>

> > From: "Dave Chinner" <david@fromorbit.com>
> 
> > The "version" of XFS that you are running is that of the
> > kernel you are running. i.e. 2.6.32-279.x.y or 2.6.32-358.x.y.
> 
> Those aren't kernel versions; those are kernel *package* versions.
> 
> Kernel versions are w.x.y or w.x.y.z.

And as a further followup: it matters which kernel tree you're talking about
too.

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
