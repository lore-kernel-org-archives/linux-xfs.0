Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OHrGlD059730 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 11:53:16 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	3XND0H2XXG4l0XUU (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 09:53:15 -0800 (PST)
Date: Tue, 24 Jan 2012 12:53:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 4/4] Define new macro XFS_ALL_QUOTA_ACTIVE and simply
	some usage
Message-ID: <20120124175314.GG9853@infradead.org>
References: <20120123173118.31546.3353.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173143.31546.29558.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120123173143.31546.29558.sendpatchset@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 23, 2012 at 11:31:43AM -0600, Chandra Seetharaman wrote:
> Define new macro XFS_ALL_QUOTA_ACTIVE and simply some usage
> of quota macros.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
