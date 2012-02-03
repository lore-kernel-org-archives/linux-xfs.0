Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13IoJdr153860
	for <linux-xfs@oss.sgi.com>; Fri, 3 Feb 2012 12:50:19 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id ljpMdCxAAsQ6i6qs for <linux-xfs@oss.sgi.com>;
	Fri, 03 Feb 2012 10:50:18 -0800 (PST)
Message-ID: <4F2C2C69.5020103@sandeen.net>
Date: Fri, 03 Feb 2012 12:50:17 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Placing the root partition on an XFS filesystem is not supported
References: <loom.20120129T133929-288@post.gmane.org>
	<4F2B02C4.8070903@sandeen.net>
	<loom.20120203T152753-631@post.gmane.org>
In-Reply-To: <loom.20120203T152753-631@post.gmane.org>
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
To: Marcos Mello <marcosfrm@gmail.com>
Cc: linux-xfs@oss.sgi.com

On 2/3/12 8:39 AM, Marcos Mello wrote:
> Eric Sandeen <sandeen <at> sandeen.net> writes:
> 
>>
>> In general there is no problem with xfs on a root partition.  However, the
> installer
>> may not make it easy or available for you.
>>
>> (I never use xfs for /boot though, I don't trust grub enough for that
> honestly).
>>
>> -Eric
> 
> Same thing on Fedora 16. Let's hope some day Anaconda will change that.

F16 prevents it?  I didn't see it in the upstream tree.  That should
not be so.  :/

> About GRUB with a XFS /boot the problem was with GRUB Lagacy, wasn't it?
> Or GRUB2 is still buggy?

I have no idea, actually.  I delved into grub a bit, it was disturbing
enough that I have not tried to look at grub2.  :)

-Eric

> Marcos
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
