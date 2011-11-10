Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAABBZgx075561 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 05:11:36 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35D0F126519F
	for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 03:11:34 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ZL7KlHBt04PMOci4 for <xfs@oss.sgi.com>;
	Thu, 10 Nov 2011 03:11:34 -0800 (PST)
Date: Thu, 10 Nov 2011 06:11:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] Set lost+found inode as used after its allocation
Message-ID: <20111110111133.GA6525@infradead.org>
References: <1320857647-25511-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320857647-25511-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

Thanks a lot, I've put the patches in.

I'd love to see followups to use the the get_inode_offset helper more
often, and to add a testcase for the bug if possible.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
