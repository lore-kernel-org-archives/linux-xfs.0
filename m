Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o52A4KfF068036 for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 05:04:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3466B38DDC2
	for <xfs@oss.sgi.com>; Wed,  2 Jun 2010 03:06:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 75aYU0pDwRt3ItQO for
	<xfs@oss.sgi.com>; Wed, 02 Jun 2010 03:06:47 -0700 (PDT)
Date: Wed, 2 Jun 2010 06:06:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs/libhandle : How to get the handle for a symbolic link ?
Message-ID: <20100602100637.GA24014@infradead.org>
References: <4C04F386.908@cea.fr> <20100601232917.GG1395@dastard>
	<4C06063F.1000609@cea.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C06063F.1000609@cea.fr>
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
To: DENIEL Philippe <philippe.deniel@CEA.FR>
Cc: xfs@oss.sgi.com

On Wed, Jun 02, 2010 at 09:20:31AM +0200, DENIEL Philippe wrote:
> Hi Dave,
>
> In fact, path_to_handle does not do the work correctly. Its code is this  
> (extract from xfsprogs-3.0.3 sources) :

This is fixed as of xfsprogs 3.1.0.  I would recommend to update to the
latests xfsprogs (3.1.2) anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
