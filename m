Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB222gCV190697
	for <linux-xfs@oss.sgi.com>; Tue, 1 Dec 2009 20:02:43 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 12E8B1DA2BA4
	for <linux-xfs@oss.sgi.com>; Tue,  1 Dec 2009 18:03:12 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id 7livNCH1mHC4x0xS for <linux-xfs@oss.sgi.com>;
	Tue, 01 Dec 2009 18:03:12 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.50) id 1NFeYh-0003ZF-4U
	for linux-xfs@oss.sgi.com; Wed, 02 Dec 2009 03:03:11 +0100
Received: from 66-227-165-199.dhcp.klmz.mi.charter.com ([66.227.165.199])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 02 Dec 2009 03:03:11 +0100
Received: from mlueck by 66-227-165-199.dhcp.klmz.mi.charter.com with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 02 Dec 2009 03:03:11 +0100
From: Michael Lueck <mlueck@lueckdatasystems.com>
Subject: Does xfs automatically support acl without needing a mount/fstab
	option?
Date: Tue, 01 Dec 2009 21:02:46 -0500
Message-ID: <hf4hs7$1ks$1@ger.gmane.org>
Mime-Version: 1.0
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

Greetings-

I am seeing directories on xfs partitions with the + at the end of the perms list indicating there is an ACL associated with that particular directory.

With xfs, is it not necessary to specify in fstab that ACL support is desired? Is it automatically enabled?

I know on ReiserFS it must be specified in fstab. It is not specified in fstab on the xfs systems in question.

Sincerely,

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
