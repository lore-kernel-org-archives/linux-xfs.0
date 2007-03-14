Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Mar 2007 14:22:00 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2ELLt6p024680
	for <xfs@oss.sgi.com>; Wed, 14 Mar 2007 14:21:56 -0700
Message-ID: <45F86777.9030909@sandeen.net>
Date: Wed, 14 Mar 2007 16:21:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Strange XFS issue on tiny-NAS ARM NFS server
References: <EXNANE01iR9Odutox7n000000c6@exnane01.hq.netapp.com> <45F85BFA.1070505@sandeen.net> <EXNANE01yeKzGZuNY1S000000cb@exnane01.hq.netapp.com>
In-Reply-To: <EXNANE01yeKzGZuNY1S000000cb@exnane01.hq.netapp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Talpey, Thomas" <Thomas.Talpey@netapp.com>
Cc: xfs@oss.sgi.com

Talpey, Thomas wrote:
> Wow good memory, 3 years ago:
> <http://lists.arm.linux.org.uk/pipermail/linux-arm-kernel/2004-March/020287.html>
> 
> I'm compiling with gcc4.1.1 for arm5t big endian, patched for multiple
> arm ports (OpenEmbedded) and it still botches that code today.
> Works fine with the arithmetic decomposition in the message.
> And I never blame the compiler! ;-)
> 
> Thanks!
> 
> BTW, XFS gives this little machine a nice bump in NFS write
> bandwidth. Goes from ~6MB/sec to ~7MB/s. CPU limited, mainly.

Glad it worked!

So is netapp selling those now?  ;-)

-Eric
