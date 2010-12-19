Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBJHQ5sT246787 for <xfs@oss.sgi.com>; Sun, 19 Dec 2010 11:26:06 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C9EC1468315
	for <xfs@oss.sgi.com>; Sun, 19 Dec 2010 09:28:00 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id IRDwyeZ13uM7I6nh for
	<xfs@oss.sgi.com>; Sun, 19 Dec 2010 09:28:00 -0800 (PST)
Message-ID: <4D0E409F.8060905@sandeen.net>
Date: Sun, 19 Dec 2010 11:27:59 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Fwd: xfs - fixing wrong xfs size
References: <dbd747120904130713t7388971axf75ee779b5b1e1f2@mail.gmail.com>	<49E353FD.5060207@sandeen.net>	<dbd747120904130933i6ae66aedt7912a47b7e561f76@mail.gmail.com>	<4BE1EF9D.2030901@sandeen.net>
	<30211747.post@talk.nabble.com>	<4CE15F39.2010904@sandeen.net>
	<30492876.post@talk.nabble.com>
In-Reply-To: <30492876.post@talk.nabble.com>
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
To: johahoff <jh@not-dark-yet.de>
Cc: xfs@oss.sgi.com

On 12/19/10 8:37 AM, johahoff wrote:
> 
> That worked perfectly, thanks a lot, Eric!
> 
> One minor issue: I had to use 'xfs_db -x', not '-w', but probably that's
> because of an old version of xfs-utils on the SystemRescueCD I was using.
> Just a hint if anybody is wondering.

Nah that was me misremembering debugfs vs. xfs_db arguments :)

-Eric

> Thanks again,
> Johannes

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
