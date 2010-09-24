Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8OKl71B200775
	for <linux-xfs@oss.sgi.com>; Fri, 24 Sep 2010 15:47:07 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3A2CE6AFE3
	for <linux-xfs@oss.sgi.com>; Fri, 24 Sep 2010 14:00:42 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id fDZiy5S8zADXFlTE for <linux-xfs@oss.sgi.com>;
	Fri, 24 Sep 2010 14:00:42 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1OzFBW-0007OK-JP
	for linux-xfs@oss.sgi.com; Fri, 24 Sep 2010 22:47:58 +0200
Received: from p4fd4a8b5.dip0.t-ipconnect.de ([79.212.168.181])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 24 Sep 2010 22:47:58 +0200
Received: from Manuel.Spam by p4fd4a8b5.dip0.t-ipconnect.de with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 24 Sep 2010 22:47:58 +0200
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Re: System partially unusable after power loss...
Date: Fri, 24 Sep 2010 22:44:42 +0200
Message-ID: <i7j2pl$94a$1@dough.gmane.org>
References: <i6ttq6$41d$1@dough.gmane.org>
	<4C928424.1020409@sandeen.net>	<i7b8ao$erp$1@dough.gmane.org>
	<4C9982F0.6010902@sandeen.net>
Mime-Version: 1.0
In-Reply-To: <4C9982F0.6010902@sandeen.net>
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

Eric Sandeen wrote:
> I don't know what to make of that; if you mean the openssl files got replaced
> by older versions, it sounds very unlikely.

No. What I mean is, that xfs_repair seems to have restored an old 
version to "/lost+found" without restoring the file name for it.

Yours

Manuel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
