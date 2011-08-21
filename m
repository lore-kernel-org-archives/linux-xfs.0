Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7LMxdQY006341 for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 17:59:40 -0500
Received: from eamp.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F00B1387B99
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 16:02:07 -0700 (PDT)
Received: from eamp.org (eamp.org [67.202.107.33]) by cuda.sgi.com with ESMTP
	id J6CEkwtDbLtUHOdW for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2011 16:02:07 -0700 (PDT)
Message-Id: <E1QvGzO-0001aI-4l@eamp.org>
From: Robert Jacobs <debbtsb06@eamp.org>
Subject: Re: Bug#638158: xfsprogs: Damaged filesystem causes xfs_repair to
	sometimes (but not always) segfault
In-reply-to: <201108171518.53374@zmi.at>
References: <E1QtbO1-0005u8-5N@eamp.org> <201108171518.53374@zmi.at>
Date: Sun, 21 Aug 2011 15:59:34 -0700
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

> On Mittwoch, 17. August 2011 Robert Jacobs wrote:
> > I've attached the outputs of xfs_check and three different runs of
> > xfs_repair (with backtrace, when available).
> 
> Can you provide a XFS metadump? That should help devs to reproduce the 
> error. 

I've uploaded it to <http://eamp.org/metadumpf.lzma>. It's 9MB but I
have somewhat limited upload quota. I noticed that some filenames
weren't obscured so I obscured them by hand -- if this is a problem,
please tell me. 

Thanks!

 - Robert Jacobs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
