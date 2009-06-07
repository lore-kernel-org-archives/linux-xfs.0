Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n57LRTP0191192
	for <linux-xfs@oss.sgi.com>; Sun, 7 Jun 2009 16:27:30 -0500
Received: from foehn.mgras.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8EF6D1D3B104
	for <linux-xfs@oss.sgi.com>; Sun,  7 Jun 2009 14:27:48 -0700 (PDT)
Received: from foehn.mgras.de (quickstep.mgras.net [213.146.115.59]) by
	cuda.sgi.com with ESMTP id uTWsUQITn9RX1ceG for
	<linux-xfs@oss.sgi.com>; Sun, 07 Jun 2009 14:27:48 -0700 (PDT)
Received: from osprey.mgras.de (osprey.mgras.de [192.168.48.3])
	by foehn.mgras.de (8.13.1/8.13.0) with ESMTP id n57LQxrJ000221
	for <linux-xfs@oss.sgi.com>; Sun, 7 Jun 2009 23:27:00 +0200 (CEST)
Received: (from news@localhost) by osprey.mgras.de (AIX5.1/8.11.6p2/8.11.0) id
	n57LQxi35220 for linux-xfs@oss.sgi.com;
	Sun, 7 Jun 2009 23:26:59 +0200
From: Martin Spott <Martin.Spott@mgras.net>
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Sun, 7 Jun 2009 21:26:58 +0000 (UTC)
Message-ID: <h0hbb2$1358$1@osprey.mgras.de>
References: <20090520003745.GA27491@samad.com.au>
	<20090607204444.GA335@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Christoph Hellwig wrote:

> I recently started auditing the code and started to fix some locking
> issues in there, could you give the patch below a try?

  http://foxtrot.mgras.net/static/messages-20090607.2.bz2

I'm sorry but I'll have to boot the system using the previous kernel,
again, as people expect to have their system in a reliably working
state again tomorrow morning.

Cheers,
	Martin.
-- 
 Unix _IS_ user friendly - it's just selective about who its friends are !
--------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
