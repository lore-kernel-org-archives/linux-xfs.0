Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1A76B7F37
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 22:13:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A9E43AC002
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 20:12:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id EBKZjpfYCHZ6b8Wv for <xfs@oss.sgi.com>;
	Sun, 28 Jul 2013 20:12:55 -0700 (PDT)
Message-ID: <51F5DDB3.7010109@sandeen.net>
Date: Sun, 28 Jul 2013 22:12:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
References: <20130729000247.GA13468@dastard>
	<32553786.2492.1375056392388.JavaMail.root@benjamin.baylink.com>
	<20130729024105.GC13468@dastard>
In-Reply-To: <20130729024105.GC13468@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jay Ashworth <jra@baylink.com>, xfs@oss.sgi.com

On 7/28/13 9:41 PM, Dave Chinner wrote:
> On Sun, Jul 28, 2013 at 08:06:32PM -0400, Jay Ashworth wrote:
>> ----- Original Message -----
>>> From: "Dave Chinner" <david@fromorbit.com>
>>
>>> Sure, they have diverged signficant;y as we've backported various
>>> bits of XFs fetaures and bug fixes back into RHEL6. As have every
>>> other distro that doesn't track mainline directly. That's why you
>>> need to look at the kernel source package to know what code the
>>> distro is running.
>>
>> And... all the way back to Jason's original question:
>>
>> The way that you get the information out of a kernel/kernel RPM to 
>> determine which XFS version it's running... is?  Cause it's clearly
>> not obvious to either him or me.
> 
> The "version" of XFS that you are running is that of the
> kernel you are running. i.e. 2.6.32-279.x.y or 2.6.32-358.x.y.

IOWS:  There is no spoon.  ;)

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
