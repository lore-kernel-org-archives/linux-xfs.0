Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13Ee7tR136366
	for <linux-xfs@oss.sgi.com>; Fri, 3 Feb 2012 08:40:08 -0600
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id g97GYmnBk0eswsAV (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Fri, 03 Feb 2012 06:40:05 -0800 (PST)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1RtKJ1-0001rM-Eb
	for linux-xfs@oss.sgi.com; Fri, 03 Feb 2012 15:40:04 +0100
Received: from bd206cc2.virtua.com.br ([bd206cc2.virtua.com.br])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 03 Feb 2012 15:40:03 +0100
Received: from marcosfrm by bd206cc2.virtua.com.br with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 03 Feb 2012 15:40:03 +0100
From: Marcos Mello <marcosfrm@gmail.com>
Subject: Re: Placing the root partition on an XFS filesystem is not supported
Date: Fri, 3 Feb 2012 14:39:55 +0000 (UTC)
Message-ID: <loom.20120203T152753-631@post.gmane.org>
References: <loom.20120129T133929-288@post.gmane.org>
	<4F2B02C4.8070903@sandeen.net>
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

Eric Sandeen <sandeen <at> sandeen.net> writes:

> 
> In general there is no problem with xfs on a root partition.  However, the
installer
> may not make it easy or available for you.
> 
> (I never use xfs for /boot though, I don't trust grub enough for that
honestly).
> 
> -Eric

Same thing on Fedora 16. Let's hope some day Anaconda will change that.

About GRUB with a XFS /boot the problem was with GRUB Lagacy, wasn't it?
Or GRUB2 is still buggy?

Marcos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
