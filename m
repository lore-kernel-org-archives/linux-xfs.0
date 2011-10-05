Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p95LwKUs143467 for <xfs@oss.sgi.com>; Wed, 5 Oct 2011 16:58:22 -0500
Date: Wed, 5 Oct 2011 17:58:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] xfsprogs: libxcmd: avoid using strtok()
Message-ID: <20111005215816.GA16977@infradead.org>
References: <4a7a9e630aa7c62357a606f762abc19fc1d7073b.1317646036.git.aelder@sgi.com>
	<eba9155609154e80e0c529039ae98e1be8b3984c.1317646036.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <eba9155609154e80e0c529039ae98e1be8b3984c.1317646036.git.aelder@sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

Looks reasonable.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
