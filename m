Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p89MV3l6063716 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 17:31:03 -0500
Received: from kaylee.flamingspork.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C59AB14C465
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2011 15:31:02 -0700 (PDT)
Received: from kaylee.flamingspork.com (kaylee.flamingspork.com
	[74.207.245.61]) by cuda.sgi.com with ESMTP id OVqnzIcprE206Srb
	for <xfs@oss.sgi.com>; Fri, 09 Sep 2011 15:31:02 -0700 (PDT)
From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: XFS metadata flushing design - current and future
In-Reply-To: <20110827080321.GA16661@infradead.org>
References: <20110827080321.GA16661@infradead.org>
Date: Fri, 09 Sep 2011 15:31:01 -0700
Message-ID: <87litx73h6.fsf@flamingspork.com>
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, 27 Aug 2011 04:03:21 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> All metadata is XFS is read and written using buffers as the lowest
> layer.

s/is/in/

pretty minor :)

-- 
Stewart Smith

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
