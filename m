Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7GI4MZt227411 for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 13:04:22 -0500
Received: from ogre.sisk.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 711C2DFFAD
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 11:04:20 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158]) by cuda.sgi.com
	with ESMTP id UVVNpFFmBy8qfq4P for <xfs@oss.sgi.com>;
	Tue, 16 Aug 2011 11:04:20 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: PM / hibernate xfs lock up / xfs_reclaim_inodes_ag
Date: Tue, 16 Aug 2011 20:05:59 +0200
References: <4E1C70AD.1010101@u-club.de>
	<20110810214327.GA9320@atrey.karlin.mff.cuni.cz>
	<4E4A64D4.4000005@u-club.de>
In-Reply-To: <4E4A64D4.4000005@u-club.de>
MIME-Version: 1.0
Message-Id: <201108162006.00200.rjw@sisk.pl>
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
To: Christoph <cr2005@u-club.de>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>, Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>, xfs@oss.sgi.com

On Tuesday, August 16, 2011, Christoph wrote:
> On 10.08.2011 23:43, Pavel Machek wrote:
> > Hi!
> > 
> >>>> Why don't you simply submit a patch to do that?
> >>>
> >>> a) I don't know how to test suspend/hibernate
> >>> b) I don't have any hardware I can test it on.
> 
> 
> Hi!
> 
> I do apologize fmy silence but I've been in a serious productions the last
> weeks.
> 
> If there any patches to test, let me know. I can run some decent stress tests.

Well, please try the one attached to
https://bugzilla.kernel.org/show_bug.cgi?id=33622#c10

Thanks,
Rafael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
