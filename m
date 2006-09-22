Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Sep 2006 17:34:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8N0YVaG015840
	for <xfs@oss.sgi.com>; Fri, 22 Sep 2006 17:34:32 -0700
Received: from smtp.osdl.org (smtp.osdl.org [65.172.181.4])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2B4D45BB82
	for <xfs@oss.sgi.com>; Fri, 22 Sep 2006 16:34:22 -0700 (PDT)
Date: Fri, 22 Sep 2006 16:34:15 -0700
From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH -mm] rescue large xfs preferred iosize from the inode
 diet patch
Message-Id: <20060922163415.4e137374.akpm@osdl.org>
In-Reply-To: <45146F76.3010301@sandeen.net>
References: <45131334.6050803@sandeen.net>
	<45134472.7080002@sgi.com>
	<20060922161040.609286fa.akpm@osdl.org>
	<45146F76.3010301@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

On Fri, 22 Sep 2006 18:19:18 -0500
Eric Sandeen <sandeen@sandeen.net> wrote:

> Andrew Morton wrote:
> 
> >> So the fix for this is coming soon (and the fix is different from the
> >> one above).
> >>
> > 
> > eh?  Eric's patch is based on -mm, which includes the XFS git tree.  If I
> > go and merge the inode-diet patches from -mm, XFS gets broken until you
> > guys merge the above mystery patch.  (I prefer to merge the -mm patches
> > after all the git trees have gone, but sometimes maintainers dawdle and I
> > get bored of waiting).
> > 
> > Is git://oss.sgi.com:8090/nathans/xfs-2.6 obsolete, or are you hiding stuff
> > from me?  ;)
> > 
> > 
> well it's in cvs:

That's nearly four months old!

> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.254&r2=text&tr2=1.253&f=h

<checks to see if the changelog is in Aramaic too>
