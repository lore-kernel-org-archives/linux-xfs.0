Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAO2DTK3045461
	for <linux-xfs@oss.sgi.com>; Tue, 23 Nov 2010 20:13:29 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CAC4D13E629A
	for <linux-xfs@oss.sgi.com>; Tue, 23 Nov 2010 18:15:05 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id iPapOg4vrJsa3YDw for <linux-xfs@oss.sgi.com>;
	Tue, 23 Nov 2010 18:15:05 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1PL4sy-0005qr-56
	for linux-xfs@oss.sgi.com; Wed, 24 Nov 2010 03:15:04 +0100
Received: from 162.105.205.253 ([162.105.205.253])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 24 Nov 2010 03:15:04 +0100
Received: from zhengmaoxie by 162.105.205.253 with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 24 Nov 2010 03:15:04 +0100
From: XIE Zhengmao <zhengmaoxie@gmail.com>
Subject: Re: ENOSPC at 90% with plenty of inodes
Date: Wed, 24 Nov 2010 01:04:35 +0000 (UTC)
Message-ID: <loom.20101124T015955-81@post.gmane.org>
References: <AANLkTinwnOm0V=9WwbXiUGFnyjCwT3GUHo0hiQahQNUV@mail.gmail.com>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

James Braid <jamesb <at> loreland.org> writes:

> 
> Hi,
> 

"no space left" when your still have space and inodes...
Please fsck the file system, too many fs errors cause this problem. 



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
