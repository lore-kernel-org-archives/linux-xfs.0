Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8EA4c0a041155 for <xfs@oss.sgi.com>; Mon, 14 Sep 2009 05:04:38 -0500
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 47E6344B9DF
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2009 03:05:50 -0700 (PDT)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id 7uMF8DKk22wgkFLB for <xfs@oss.sgi.com>;
	Mon, 14 Sep 2009 03:05:50 -0700 (PDT)
Date: Mon, 14 Sep 2009 12:05:48 +0200
From: "Steffen Knauf" <Steffen.Knauf@gmx.net>
Message-ID: <20090914100548.45440@gmx.net>
MIME-Version: 1.0
Subject: xfs_log_force: error 5 returend
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

hello,

sometimes, our server crashed with xfs_log_force: error 5.
It isn't reproducible and a xfs_check / xfs_repair don't find some errors.

Perhaps it's a bug?  

Version: Linux version 2.6.26-bpo.1-amd64 (Debian 2.6.26-9~bpo40+1) (nobse@debian.org) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21

greets

Steffen
-- 
Jetzt kostenlos herunterladen: Internet Explorer 8 und Mozilla Firefox 3 -
sicherer, schneller und einfacher! http://portal.gmx.net/de/go/chbrowser

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
