Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3E6tAdL042824 for <xfs@oss.sgi.com>; Wed, 14 Apr 2010 01:55:11 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F4E42BFAC5
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 23:57:04 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id 0aLr5s1O3w0aRcl2 for
	<xfs@oss.sgi.com>; Tue, 13 Apr 2010 23:57:04 -0700 (PDT)
Subject: Re: [PATCH] enable inode64 by default when possible
From: Andi Kleen <andi@firstfloor.org>
References: <4B7309D7.5090800@sandeen.net> <1270850499.7840.25.camel@doink>
	<4BBFE478.3090901@hardwarefreak.com> <20100412062158.GF2493@dastard>
Date: Wed, 14 Apr 2010 08:57:01 +0200
In-Reply-To: <20100412062158.GF2493@dastard> (Dave Chinner's message of "Mon,
	12 Apr 2010 16:21:58 +1000")
Message-ID: <87k4saa5du.fsf@basil.nowhere.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

Dave Chinner <david@fromorbit.com> writes:
>> 
>> Intel Atom (32bit x86) CPUs
>
> No, I think Atom is 64 bit.

There are 32bit only versions of it around. The latest ones all
support 64bit. But there are still quite a lof of 32bit versions being
used.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
