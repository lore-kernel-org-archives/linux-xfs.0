Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p12J1IG2054909
	for <linux-xfs@oss.sgi.com>; Wed, 2 Feb 2011 13:01:19 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD0EF162CFB7
	for <linux-xfs@oss.sgi.com>; Wed,  2 Feb 2011 11:03:47 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id piZ94zlcZIMjUfc9 for <linux-xfs@oss.sgi.com>;
	Wed, 02 Feb 2011 11:03:47 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1PkhzW-0008NY-7h
	for linux-xfs@oss.sgi.com; Wed, 02 Feb 2011 20:03:46 +0100
Received: from 24-176-21-160.dhcp.klmz.mi.charter.com ([24.176.21.160])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 02 Feb 2011 20:03:46 +0100
Received: from mlueck by 24-176-21-160.dhcp.klmz.mi.charter.com with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 02 Feb 2011 20:03:46 +0100
From: Michael Lueck <mlueck@lueckdatasystems.com>
Subject: Re: xfsdump SGI_FS_BULKSTAT errno = 22, how could this IRIX bug get
	into Ubuntu 10.04 Lucid between kernels 2.6.32-27 and 2.6.32-26?
Date: Wed, 02 Feb 2011 14:03:35 -0500
Message-ID: <iic9q5$ueg$1@dough.gmane.org>
References: <iibmah$dlp$1@dough.gmane.org> <4D49A35B.6030009@sgi.com>
Mime-Version: 1.0
In-Reply-To: <4D49A35B.6030009@sgi.com>
Reply-To: mlueck@lueckdatasystems.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Bill Kendall wrote:
> I'm not aware of a similar problem upstream, so it would appear
> to be a problem with Ubuntu's backport of these commits.

Thank you SO much, Bill! :-) I will post your comments back to the Ubuntu bug report.

Sincerely,

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
