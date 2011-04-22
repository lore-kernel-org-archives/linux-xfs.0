Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3MCV5mX218292
	for <linux-xfs@oss.sgi.com>; Fri, 22 Apr 2011 07:31:08 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BDDF413301ED
	for <linux-xfs@oss.sgi.com>; Fri, 22 Apr 2011 05:34:33 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id DKczEE0blNUzapXM for <linux-xfs@oss.sgi.com>;
	Fri, 22 Apr 2011 05:34:33 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1QDFZA-000810-5O
	for linux-xfs@oss.sgi.com; Fri, 22 Apr 2011 14:34:32 +0200
Received: from 24-176-21-160.dhcp.klmz.mi.charter.com ([24.176.21.160])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 22 Apr 2011 14:34:32 +0200
Received: from mlueck by 24-176-21-160.dhcp.klmz.mi.charter.com with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 22 Apr 2011 14:34:32 +0200
From: Michael Lueck <mlueck@lueckdatasystems.com>
Subject: Re: xfsdump SGI_FS_BULKSTAT errno = 22, how could this IRIX bug get
	into Ubuntu 10.04 Lucid between kernels 2.6.32-27 and 2.6.32-26?
Date: Fri, 22 Apr 2011 08:34:18 -0400
Message-ID: <iorska$1po$1@dough.gmane.org>
References: <iibmah$dlp$1@dough.gmane.org>
Mime-Version: 1.0
In-Reply-To: <iibmah$dlp$1@dough.gmane.org>
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

Greetings,

Yesterday I received via production Ubuntu 10.04 Lucid updates the new kernel addressing this issue.

Thank you so much Bill, Dave, and Dann for your assistance in getting this diagnosed and resolved so quickly! I really appreciate it!

Sincerely,

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
