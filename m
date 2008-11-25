Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAP7MWZW019061 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 01:22:33 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay2.corp.sgi.com (Postfix) with SMTP id 2084B3040A3
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 23:22:28 -0800 (PST)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by
	larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF)
	via ESMTP id SAA08543 for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 18:22:27 +1100
Message-ID: <492BA7AD.5080007@sgi.com>
Date: Tue, 25 Nov 2008 18:22:21 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: New XFS git tree on oss.sgi.com
Reply-To: lachlan@sgi.com
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
To: xfs@oss.sgi.com

Hi all,

We've got a new xfs git tree on oss.sgi.com at:

git://oss.sgi.com/xfs/xfs

This tree is an automatic mirror of our internal tree so will always
be up to date.

It supercedes the old xfs-2.6 tree which has a few problems with it's
merge history.

There's a few branches there already:

'master'      This will contain all the latest xfs changes not yet pushed
               to mainline.
'mainline'    This is vanilla mainline and will updated regularly.
'for-linus'   Our staging branch for pull requests
'xfs-dev'     This branch will contain KDB and other supporting code for
               development and should be identical to the old CVS tree.

Feel free to start using it and let us know if you have any issues.

Thanks,
Lachlan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
