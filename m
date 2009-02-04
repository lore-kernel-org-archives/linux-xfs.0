Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n149Y9LY136471 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 03:34:09 -0600
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 576BAE4201
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 01:33:29 -0800 (PST)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de
	[85.214.69.204]) by cuda.sgi.com with ESMTP id 0iH2CYk05MWMVoWV
	for <xfs@oss.sgi.com>; Wed, 04 Feb 2009 01:33:29 -0800 (PST)
Date: Wed, 4 Feb 2009 10:33:28 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: A rescue tool: xfs_irecover
In-Reply-To: <20090204082816.GA9111@infradead.org>
Message-ID: <alpine.LSU.2.00.0902041032510.27900@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0812292059020.15355@fbirervta.pbzchgretzou.qr>
	<20090204082816.GA9111@infradead.org>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wednesday 2009-02-04 09:28, Christoph Hellwig wrote:

>I looked into importing this into xfsprogs, and from a quick look
>it could be simplified a lot by using code from libxfs or maybe even
>by merging it into xfs_db and using the infrastructure there.
>
>But xfsprogs is licensed under GPLv2 and will stay that way as it shares
>a lot of code with the kernel.  Are you willing to relicense the tool
>under GPLv2 or later?

Yes; I updated the repository to reflect this (and add a manpage).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
