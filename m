Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Sep 2008 19:03:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8C23KTG008206
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2008 19:03:21 -0700
Received: from blu0-omc4-s2.blu0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AAF38D170B
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2008 19:04:47 -0700 (PDT)
Received: from blu0-omc4-s2.blu0.hotmail.com (blu0-omc4-s2.blu0.hotmail.com [65.55.111.141]) by cuda.sgi.com with ESMTP id sJ1oI2rGXdnFpNQE for <xfs@oss.sgi.com>; Thu, 11 Sep 2008 19:04:47 -0700 (PDT)
Message-ID: <BLU141-W21A745812EB94C128504C680510@phx.gbl>
From: Andrew Lawry <a_lawry@hotmail.com>
Subject: 
Date: Fri, 12 Sep 2008 12:04:47 +1000
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com





Hi,

I am setting up a new Xen installation using XFS as the file system. On our test
machine we have been having some problems with a domU crashing and some
data loss on the domU (on recovery of the file system at the next boot
some files have become truncated.

Our setup:

Dom0 and
domUs are Ubuntu 8.04 64 bit  Server edition. The domUs use tap file
based backends. The file system holding the image files is XFS and the
filesystem in each domU is also XFS.

We are using xen 3.2 packaged with ubuntu.

I
have read on this mailing list and on google that xen and XFS do not
work well together and some patches have been produced. Has this issue been addressed? Would those patches be in the stable release and have found their way into Ubuntu packages?

Thanks for your help.

Andrew
_________________________________________________________________
Net yourself a bargain. Find great deals on eBay.
http://a.ninemsn.com.au/b.aspx?URL=http%3A%2F%2Frover%2Eebay%2Ecom%2Frover%2F1%2F705%2D10129%2D5668%2D323%2F4%3Fid%3D10&_t=763807330&_r=hotmailTAGLINES&_m=EXT

[[HTML alternate version deleted]]
