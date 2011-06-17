Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5HC2ofV117215 for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 07:02:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34C481EDD560
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 05:02:47 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	YX4WZ1NFDBXIlEUD for <xfs@oss.sgi.com>;
	Fri, 17 Jun 2011 05:02:47 -0700 (PDT)
Date: Fri, 17 Jun 2011 08:02:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3 v5] XFS TESTS: Add Punch Hole to FSX
Message-ID: <20110617120241.GA20227@infradead.org>
References: <4DED63D1.5010600@vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DED63D1.5010600@vnet.ibm.com>
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
To: Allison Henderson <achender@vnet.ibm.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

I'm a bit worried about adding more and more local hacks to our FSX
version before resyncing with the official Apple variant that actual
has clear licensing.  But we didn't let other recent patches be affected
by that, so I guess I can't complain this time either and will put it
in.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
