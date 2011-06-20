Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5K981BA136272 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 04:08:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97B5B4E2C22
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 02:07:59 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	upu5eRYUNksIqOWC for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2011 02:07:59 -0700 (PDT)
Date: Mon, 20 Jun 2011 05:07:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3 v5] XFS TESTS: Expand 252 punch hole test
Message-ID: <20110620090754.GA27583@infradead.org>
References: <4DED63DE.1070000@vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DED63DE.1070000@vnet.ibm.com>
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

This actually broke 242 due to the new output from the new tests for me.

Next time please do a full xfsqa run before submitting patches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
