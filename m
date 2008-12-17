Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBHNLOQ7019756 for <xfs@oss.sgi.com>; Wed, 17 Dec 2008 17:21:25 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BED7D2DEC8
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2008 15:21:23 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id Wj5GFcHo5tVdWqUA for
	<xfs@oss.sgi.com>; Wed, 17 Dec 2008 15:21:23 -0800 (PST)
Date: Wed, 17 Dec 2008 18:21:22 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Have the velociraptors in a test system now, checkout the errors.
In-Reply-To: <4949645F.4030407@tmr.com>
Message-ID: <alpine.DEB.1.10.0812171820200.26527@p34.internal.lan>
References: <alpine.DEB.1.10.0812060426280.3494@p34.internal.lan>
	<49405A94.8080601@tmr.com> <1229225303.16555.149.camel@localhost>
	<4949645F.4030407@tmr.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org, smartmontools-support@lists.sourceforge.net, Redeeman <redeeman@metanurb.dk>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Wed, 17 Dec 2008, Bill Davidsen wrote:

> Redeeman wrote:
>> On Wed, 2008-12-10 at 19:11 -0500, Bill Davidsen wrote:
>> 
>>> Justin Piszcz wrote:
>>> 
>
> Calls itself "WDC WD10EACS-00D" in /sys if that helps. I could dig out the 
> packing slip if it matters. Runs nicely so far, and if the SMART temperature 
> probe is correct, very cool:
>
> /dev/sda: ST3750640AS: 43 C
> /dev/sdb: WDC WD10EACS-00D6B1: 31 C
> /dev/sdc: ST3750640AS: 44 C
> /dev/sdd: ST3750640AS: 46 C
>
> I don't totally trust the temps, there is a LOT of 18C air going into that 
> box, because it has a lot coming out the back and side.

Hmm do you have a picture of those seagates? Seems like a lack of airflow there
or do they just run really hot?  Also, how many head unload/loads has the
1.0TB GP drive performed, that was one of my concerns when I was looking at
disks.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
