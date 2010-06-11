Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5BGkqLf147620
	for <linux-xfs@oss.sgi.com>; Fri, 11 Jun 2010 11:46:52 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D6CF3BFB11
	for <linux-xfs@oss.sgi.com>; Fri, 11 Jun 2010 09:49:25 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id Qs6MZCmt1IYwHW1y for <linux-xfs@oss.sgi.com>;
	Fri, 11 Jun 2010 09:49:25 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1ON7Q2-0001Fg-Lo
	for linux-xfs@oss.sgi.com; Fri, 11 Jun 2010 18:49:22 +0200
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 11 Jun 2010 18:49:22 +0200
Received: from niemayer by barriere.frankfurter-softwarefabrik.de with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 11 Jun 2010 18:49:22 +0200
From: Peter Niemayer <niemayer@isg.de>
Subject: Re: linux-2.6.34 xfs crash: xfs_inode_ag_iterator+0x6c - NULL pointer
	dereference
Date: Fri, 11 Jun 2010 18:49:10 +0200
Message-ID: <hutpe6$p9t$2@dough.gmane.org>
References: <hur8at$jua$1@dough.gmane.org>
	<20100611161922.GB7556@infradead.org>
Mime-Version: 1.0
In-Reply-To: <20100611161922.GB7556@infradead.org>
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

On 06/11/2010 06:19 PM, Christoph Hellwig wrote:
> Unfortunately the backtrace doesn't really tell what has happened as
> the origin of the backtrace scrolled away.

Oh, sorry. Now it's too late for this incident - but if it happens
again, I'll try to do screen-shots also from the "upper" part
of the scroll buffer.

Regards,

Peter Niemayer

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
