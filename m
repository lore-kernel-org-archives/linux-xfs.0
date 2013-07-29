Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6641F7F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 09:57:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4F60B8F804C
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 07:57:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 0GO1OLOQYoQwFSDR for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 07:57:21 -0700 (PDT)
Message-ID: <51F682CC.1080100@sandeen.net>
Date: Mon, 29 Jul 2013 09:57:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
References: <4422459.2522.1375107885083.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <4422459.2522.1375107885083.JavaMail.root@benjamin.baylink.com>
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
To: Jay Ashworth <jra@baylink.com>
Cc: xfs@oss.sgi.com

On 7/29/13 9:24 AM, Jay Ashworth wrote:
> ----- Original Message -----
>> From: "Dave Chinner" <david@fromorbit.com>
> 
>> The "version" of XFS that you are running is that of the
>> kernel you are running. i.e. 2.6.32-279.x.y or 2.6.32-358.x.y.
> 
> Those aren't kernel versions; those are kernel *package* versions.

Those are RHEL kernel version numbers, which 100% uniquely identify
the code contained in those kernels.

> Kernel versions are w.x.y or w.x.y.z.

^Upstream.

-Eric

> Cheers,
> -- jra
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
