Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1F2Vnbo142346 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 20:31:50 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	jChcmtAHlK05hGU2 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Feb 2012 18:31:48 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RxUeo-0004Na-Mp
	for xfs@oss.sgi.com; Wed, 15 Feb 2012 02:31:46 +0000
Message-Id: <20120215022926.577682146@bombadil.infradead.org>
Date: Tue, 14 Feb 2012 21:29:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/9] quota updates V2
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

Resend of the my previous two quota series.  The changes are:

 - drop the first patch is it's now included in mainline
 - rebase one patch on top of other changes in the tree
 - make various commit messages nicer
 - include a tested-by statement for arekm, who confirms the impressive
   speedups on his real life system

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
