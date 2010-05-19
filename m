Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JDolSW133153 for <xfs@oss.sgi.com>; Wed, 19 May 2010 08:50:48 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDB721DF395D
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 06:53:05 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id Y0n03tujAHiSsQnf for
	<xfs@oss.sgi.com>; Wed, 19 May 2010 06:53:05 -0700 (PDT)
Message-ID: <4BF3ED40.20609@sandeen.net>
Date: Wed, 19 May 2010 08:53:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mounting hixfs (Hitachi "tuned" XFS) on 2.6 kernel
References: <AANLkTikek9K8-BqNgee_tXz72beHpWEUl41YtDPrD-3P@mail.gmail.com>	<4BF1EC44.7070803@hardwarefreak.com>	<AANLkTin_WoxWP3JXHvflVVP_2fGzgbSVfpPW1KGiyd1z@mail.gmail.com>	<4BF219A6.4010900@hardwarefreak.com>	<AANLkTim93-4YueMBizXKLGRFka2vwqzJzDx5_P5gs0bl@mail.gmail.com>	<AANLkTim17eZcbW3gCOdziY3-Vsyd-XjBkmWV875yOWIC@mail.gmail.com>	<1274201857.17233.144.camel@montana.filmlight.ltd.uk>	<AANLkTimZnSIrjAsboL5AgZPRPl3qzCz0DyfE8cEp6KmO@mail.gmail.com>
	<4BF366C9.9050300@hardwarefreak.com>
In-Reply-To: <4BF366C9.9050300@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

Stan Hoeppner wrote:
> big beer put forth on 5/18/2010 5:43 PM:
> 
>> Strangely enough I was told by Hitachi that they licensed XFS from
>> SGI, so they don't have any GPL code to give back.
> 
> IIRC (and IANAL) any version of XFS, with the exception of CXFS, running on
> Linux is GPL'd code.  There is no such beast as non GPL XFS on Linux.
> 
> For that SGI licensing statement to be true, they've have to be running XFS
> on IRIX, which means they'd need an IRIX license as well.  Not to mention
> that IRIX only runs on MIPS hardware, and only SGI MIPS hardware.  This HDS
> storage blade is x86.
> 
> It seems whoever told you that is misinformed or is being disingenuous in
> order to avoid assisting you.

Anyone with clear copyright can license the code under any license(s) they wish.
So assuming SGI had clear copyright on all linux xfs code, it is certainly
possible to offer it under an alternate license.

http://www.gnu.org/licenses/gpl-faq.html#HeardOtherLicense :

> I heard that someone got a copy of a GPL'ed program under another license.
> Is this possible?
> 
> The GNU GPL does not give users permission to attach other licenses to the 
> program. But the copyright holder for a program can release it under several 
> different licenses in parallel. One of them may be the GNU GPL.
> 
> The license that comes in your copy, assuming it was put in by the copyright 
> holder and that you got the copy legitimately, is the license that applies 
> to your copy.

-Eric

(hoping the thread doesn't dissolve into a giant gpl speculation
thread, having just fueled it further...)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
