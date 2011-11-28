Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAS8PvZ2225711 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 02:25:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 467E24FAA8B
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 00:25:57 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	pyO02m9h7lpxFDJC for <xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 00:25:57 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RUwXE-0000g3-Mk
	for xfs@oss.sgi.com; Mon, 28 Nov 2011 08:25:56 +0000
Message-Id: <20111128082522.224645690@bombadil.infradead.org>
Date: Mon, 28 Nov 2011 03:25:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] remove the deprecated nodelaylog options
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
To: xfs@oss.sgi.com

Let's start the Linux 3.3 window with the removal of the deprecated
nodelay option and call code required for it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
