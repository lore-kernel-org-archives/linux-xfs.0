Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3E5BE7F52
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 19:06:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C9B31AC002
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 17:06:39 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	8OVXKvtjYZ0ysSuh for <xfs@oss.sgi.com>;
	Sun, 28 Jul 2013 17:06:38 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id F168E1F003D6
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 20:06:37 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id ANQsBrcfeLV5 for <xfs@oss.sgi.com>;
	Sun, 28 Jul 2013 20:06:32 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 9AA7C1F003BB
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 20:06:32 -0400 (EDT)
Date: Sun, 28 Jul 2013 20:06:32 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <32553786.2492.1375056392388.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <20130729000247.GA13468@dastard>
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
> From: "Dave Chinner" <david@fromorbit.com>

> Sure, they have diverged signficant;y as we've backported various
> bits of XFs fetaures and bug fixes back into RHEL6. As have every
> other distro that doesn't track mainline directly. That's why you
> need to look at the kernel source package to know what code the
> distro is running.

And... all the way back to Jason's original question:

The way that you get the information out of a kernel/kernel RPM to 
determine which XFS version it's running... is?  Cause it's clearly
not obvious to either him or me.

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
