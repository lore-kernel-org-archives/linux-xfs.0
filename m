Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ3evES004133 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 21:40:57 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C938A15A0AF6
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:40:56 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id DzQgT2mhPPEU6sRq for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 19:40:56 -0800 (PST)
Message-ID: <492CC547.6070401@sandeen.net>
Date: Tue, 25 Nov 2008 21:40:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: New XFS git tree on oss.sgi.com
References: <492BA7AD.5080007@sgi.com>
In-Reply-To: <492BA7AD.5080007@sgi.com>
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
To: lachlan@sgi.com
Cc: 'Russell Cattelan' <cattelan@thebarn.com>, xfs@oss.sgi.com

Lachlan McIlroy wrote:
> Hi all,
> 
> We've got a new xfs git tree on oss.sgi.com at:
> 
> git://oss.sgi.com/xfs/xfs
> 
> This tree is an automatic mirror of our internal tree so will always
> be up to date.
> 
> It supercedes the old xfs-2.6 tree which has a few problems with it's
> merge history.
> 
> There's a few branches there already:
> 
> 'master'      This will contain all the latest xfs changes not yet pushed
>                to mainline.
> 'mainline'    This is vanilla mainline and will updated regularly.
> 'for-linus'   Our staging branch for pull requests
> 'xfs-dev'     This branch will contain KDB and other supporting code for
>                development and should be identical to the old CVS tree.
> 
> Feel free to start using it and let us know if you have any issues.

First off, cool.  Glad to see this progressing.

TAKE messages currently have Russell-magic added to the body to link to
a cvs commit for that change.  (however, it always takes up to 24h to
sync...)

Will cvs still be around & updated?  If not, those messages should be
removed (or changed to point to git commits if possible (probably not
possible).

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
