Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8EDSLZW142355 for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 08:28:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D587E13E9AFD
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 06:33:03 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	hsIfdCkXgJ5vYhjI for <xfs@oss.sgi.com>;
	Wed, 14 Sep 2011 06:33:03 -0700 (PDT)
Date: Wed, 14 Sep 2011 09:28:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Code Changes [Review Request]: xfs_trans_ail_delete() gets
	invoked with corrupted values ? Causing Crash and Deadlock.
Message-ID: <20110914132816.GA18408@infradead.org>
References: <CADDb1s0HwQtno3qWJd5CDriGD+m1EJ3fKihrRXuGmqayzwb_Pw@mail.gmail.com>
	<20110913152706.GB21460@infradead.org>
	<CADDb1s2=jHyef=5S6WNV+eLZKD1C3yJX4LzcPJhUAA1ohpAfqQ@mail.gmail.com>
	<20110913160454.GA27569@infradead.org>
	<CADDb1s3tHU-KcU0HntiqgYObFpDHUKYnE3E5fnOj70QDyZw-PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADDb1s3tHU-KcU0HntiqgYObFpDHUKYnE3E5fnOj70QDyZw-PQ@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Sep 14, 2011 at 02:52:08PM +0530, Amit Sahrawat wrote:
> The patch is working fine.No issues observed.
> Thanks.

Ok, I'll send it in for Linux 3.2.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
