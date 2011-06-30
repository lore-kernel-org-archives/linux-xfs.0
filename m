Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5UNUMww003523 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 18:30:22 -0500
Received: from a.mail.sonic.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 457C3442E0
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 16:30:20 -0700 (PDT)
Received: from a.mail.sonic.net (a.mail.sonic.net [64.142.16.245]) by
	cuda.sgi.com with ESMTP id KCsA5jjzcwrtxJcT for
	<xfs@oss.sgi.com>; Thu, 30 Jun 2011 16:30:20 -0700 (PDT)
Received: from webmail.sonic.net (d.webmail.sonic.net [69.12.208.81])
	by a.mail.sonic.net (8.13.8.Beta0-Sonic/8.13.7) with ESMTP id
	p5UNUKb1000554 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 16:30:20 -0700
MIME-Version: 1.0
Message-ID: <55283.1309476620@sonic.net>
Date: Thu, 30 Jun 2011 16:30:20 -0700
Subject: Re: xfs_growfs doesn't resize
From: kkeller@sonic.net
Reply-To: kkeller@sonic.net
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
To: xfs@oss.sgi.com

Hello again all,

I apologize for following up my own post, but I found some new information.

On Thu 30/06/11  2:42 PM , kkeller@sonic.net wrote:

> http://oss.sgi.com/archives/xfs/2008-01/msg00085.html

I found a newer thread in the archives which might be more relevant to my issue:

http://oss.sgi.com/archives/xfs/2009-09/msg00206.html

But I haven't yet done a umount, and don't really wish to.  So, my followup questions are:

==Is there a simple way to figure out what xfs_growfs did, and whether it caused any problems?
==Will I be able to fix these problems, if any, without needing a umount?
==Assuming my filesystem is healthy, will a simple kernel update (and reboot of course!) allow me to resize the filesystem in one step, instead of 2TB increments?

Again, many thanks!

--keith

-- 
kkeller@sonic.net

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
